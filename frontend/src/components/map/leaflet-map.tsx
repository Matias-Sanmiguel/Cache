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
function makeIcon(event: GeoEvent): L.DivIcon {
  const live = event.status === 'live'
  const urgent = capacityPct(event) >= 85
  const bg = live ? 'var(--acid)' : urgent ? 'var(--blood)' : 'var(--bone)'
  const friends = Math.min(9, Math.max(0, Math.round(event.attendeeCount / 50)))
  const badge = friends > 0
    ? `<span style="background:var(--ink);color:${live ? 'var(--acid)' : 'var(--bone)'};padding:1px 4px;font-size:9px;margin-left:4px">·${friends}</span>`
    : ''

  const html = `
    <div style="display:flex;flex-direction:column;align-items:center;transform:translateY(-100%)">
      <div class="font-mono" style="background:${bg};color:var(--ink);padding:4px 8px;border:2px solid var(--ink);font-size:10px;font-weight:700;letter-spacing:0.06em;white-space:nowrap;display:flex;align-items:center">
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

export default function LeafletMap({ events }: { events: CacheEvent[] }) {
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
        url="https://{s}.basemap.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="https://carto.com/attributions">CARTO</a>'
        subdomains="abcd"
        maxZoom={20}
      />

      {/* ubicación real del usuario (geolocation del browser; cae a centro BA) */}
      <CircleMarker center={me} radius={7} pathOptions={{ color: '#00FF88', fillColor: '#00FF88', fillOpacity: 1, weight: 3 }}>
        <Popup>{userPos ? 'estás acá' : 'Buenos Aires (ubicación no disponible)'}</Popup>
      </CircleMarker>

      {geo.map((event) => (
        <Marker key={event.id} position={[event.lat, event.lon]} icon={makeIcon(event)}>
          <Popup>
            <div style={{ minWidth: 160 }}>
              <div className="font-display" style={{ fontSize: 18 }}>{event.name}</div>
              <div className="font-mono" style={{ fontSize: 10, color: '#555', marginTop: 2, letterSpacing: '0.06em' }}>
                {event.venueName.toUpperCase()} · {fmtTime(event.startsAt)}
              </div>
              <div className="font-mono" style={{ fontSize: 10, marginTop: 4 }}>
                {event.status === 'live' ? '● LIVE' : 'PRÓXIMO'} · {capacityPct(event)}% lleno
              </div>
              <Link href={`/evento/${event.id}`} className="font-mono" style={{ display: 'inline-block', marginTop: 8, fontSize: 11, fontWeight: 700, letterSpacing: '0.1em' }}>
                VER EVENTO →
              </Link>
            </div>
          </Popup>
        </Marker>
      ))}

      <FitBounds events={geo} userPos={userPos} />
    </MapContainer>
  )
}
