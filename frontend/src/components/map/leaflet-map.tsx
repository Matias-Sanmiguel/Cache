'use client'

import { MapContainer, TileLayer, Marker, Popup, CircleMarker, useMap } from 'react-leaflet'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import { useEffect, useState } from 'react'
import Link from 'next/link'
import { capacityPct, fmtTime, type CacheEvent } from '@/lib/api'

const BA_CENTER: [number, number] = [-34.605, -58.42]

// solo eventos con coordenadas reales van al mapa
type GeoEvent = CacheEvent & { lat: number; lon: number }
function withCoords(events: CacheEvent[]): GeoEvent[] {
  return events.filter((e): e is GeoEvent => e.lat != null && e.lon != null)
}

function pinLabel(name: string) {
  return name.replace(/[^a-z0-9]/gi, '').slice(0, 6).toUpperCase()
}

// pin HTML estilado (matchea la estética del feed). las CSS vars resuelven porque
// el icono se inyecta en el document y hereda de :root.
// friendCount = amigos reales (neo4j) anotados a este evento; 0 → sin badge.
function makeIcon(event: GeoEvent, friendCount: number): L.DivIcon {
  const live = event.status === 'live'
  const urgent = capacityPct(event) >= 85
  const bg = live ? 'var(--acid)' : urgent ? 'var(--blood)' : '#00FF88'
  const fg = urgent ? 'var(--bone)' : 'var(--ink)'
  const friends = Math.min(9, Math.max(0, friendCount))
  const badge = friends > 0
    ? `<span style="background:var(--ink);color:${urgent ? 'var(--bone)' : 'var(--acid)'};padding:1px 4px;font-size:9px;margin-left:4px">·${friends}</span>`
    : ''

  const html = `
    <div style="display:flex;flex-direction:column;align-items:center;transform:translateY(-100%)">
      <div class="font-mono" style="background:${bg};color:${fg};padding:4px 8px;border:1px solid rgba(255,255,255,0.18);box-shadow:0 0 0 2px rgba(7,7,7,0.9),0 0 18px ${urgent ? 'rgba(255,46,46,0.4)' : 'rgba(0,255,136,0.36)'};font-size:10px;font-weight:700;letter-spacing:0.06em;white-space:nowrap;display:flex;align-items:center">
        ${pinLabel(event.name)}${badge}
      </div>
      <div style="width:0;height:0;border-left:5px solid transparent;border-right:5px solid transparent;border-top:7px solid ${bg}"></div>
    </div>`

  return L.divIcon({ html, className: 'cache-leaflet-pin', iconSize: [0, 0], iconAnchor: [0, 0] })
}

// ajusta el viewport para que entren todos los pines (+ el usuario si lo tenemos)
function FitBounds({ events, userPos }: { events: GeoEvent[]; userPos: [number, number] | null }) {
  const map = useMap()
  useEffect(() => {
    const pts: [number, number][] = events.map((e) => [e.lat, e.lon])
    if (userPos) pts.push(userPos)
    if (pts.length === 0) return
    map.fitBounds(L.latLngBounds(pts).pad(0.25), { maxZoom: 15 })
  }, [events, userPos, map])
  return null
}

// pide la ubicación real del browser una vez y recentra el mapa ahí
function useGeolocation(): [number, number] | null {
  const [pos, setPos] = useState<[number, number] | null>(null)
  useEffect(() => {
    if (!('geolocation' in navigator)) return
    navigator.geolocation.getCurrentPosition(
      (p) => setPos([p.coords.latitude, p.coords.longitude]),
      () => setPos(null),
      { enableHighAccuracy: true, timeout: 8000 },
    )
  }, [])
  return pos
}

// friendsByEvent: eventId → cantidad de amigos del user anotados a ese evento (real)
export default function LeafletMap({
  events,
  friendsByEvent = {},
}: {
  events: CacheEvent[]
  friendsByEvent?: Record<string, number>
}) {
  const geo = withCoords(events)
  const userPos = useGeolocation()
  const me = userPos ?? BA_CENTER

  return (
    <MapContainer
      center={BA_CENTER}
      zoom={13}
      zoomControl={false}
      scrollWheelZoom
      style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', background: '#070707' }}
    >
      {/* tiles dark gratuitos de CARTO (OpenStreetMap data), sin API key */}
      <TileLayer
        url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
        attribution='&copy; OpenStreetMap contributors &copy; CARTO'
        subdomains="abcd"
        maxZoom={20}
        detectRetina
      />

      {/* ubicación real del usuario (geolocation del browser; cae a centro BA) */}
      <CircleMarker center={me} radius={7} pathOptions={{ color: '#00FF88', fillColor: '#00FF88', fillOpacity: 1, weight: 3 }}>
        <Popup>{userPos ? 'estás acá' : 'Buenos Aires (ubicación no disponible)'}</Popup>
      </CircleMarker>

      {geo.map((event) => {
        const friendCount = friendsByEvent[event.id] ?? 0
        return (
        <Marker key={event.id} position={[event.lat, event.lon]} icon={makeIcon(event, friendCount)}>
          <Popup>
            <div style={{ minWidth: 160 }}>
              <div className="font-display" style={{ fontSize: 18 }}>{event.name}</div>
              <div className="font-mono" style={{ fontSize: 10, color: '#8A8A99', marginTop: 2, letterSpacing: '0.06em' }}>
                {event.venueName.toUpperCase()} · {fmtTime(event.startsAt)}
              </div>
              <div className="font-mono" style={{ fontSize: 10, marginTop: 4 }}>
                {event.status === 'live' ? '● LIVE' : 'PRÓXIMO'} · {capacityPct(event)}% lleno
              </div>
              {friendCount > 0 && (
                <div className="font-mono" style={{ fontSize: 10, marginTop: 4, color: '#00FF88' }}>
                  {friendCount} {friendCount === 1 ? 'amigo va' : 'amigos van'}
                </div>
              )}
              <Link href={`/evento/${event.id}`} className="font-mono" style={{ display: 'inline-block', marginTop: 8, fontSize: 11, fontWeight: 700, letterSpacing: '0.1em' }}>
                VER EVENTO →
              </Link>
            </div>
          </Popup>
        </Marker>
        )
      })}

      <FitBounds events={geo} userPos={userPos} />
    </MapContainer>
  )
}
