'use client'

import { useEffect, useMemo, useState } from 'react'
import Link from 'next/link'
import { Tag } from '@/components/ui/tag'
import { Dot } from '@/components/ui/dot'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { useAuth } from '@/lib/auth-context'
import { capacityPct, fmtTime, getFriendsAttending, type CacheEvent } from '@/lib/api'
import MapCanvas from '@/components/map/map-canvas'
import { FriendsStack } from '@/components/social/friends-stack'
import { EventCTALink } from '@/components/screens/event-cta-link'

type FilterKey = 'amigos' | 'cerca' | 'techno' | 'privadas'

// radio (km) para el filtro "cerca" — eventos a esta distancia o menos del usuario
const NEAR_RADIUS_KM = 5

// distancia en km entre dos coords (haversine)
function distanceKm(aLat: number, aLon: number, bLat: number, bLon: number): number {
  const R = 6371
  const dLat = ((bLat - aLat) * Math.PI) / 180
  const dLon = ((bLon - aLon) * Math.PI) / 180
  const lat1 = (aLat * Math.PI) / 180
  const lat2 = (bLat * Math.PI) / 180
  const h = Math.sin(dLat / 2) ** 2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) ** 2
  return 2 * R * Math.asin(Math.sqrt(h))
}

function MapEventCard({ event }: { event: CacheEvent }) {
  const pct = capacityPct(event)
  return (
    <div className="cache-card cache-event-card" style={{ background: 'var(--ink-2)', border: '1px solid var(--line)', padding: 14 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 12 }}>
        <div>
          <div className="font-display" style={{ fontSize: 22, color: 'var(--bone)' }}>
            {event.name}<span style={{ color: 'var(--acid)' }}>.</span>
          </div>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', marginTop: 4, letterSpacing: '0.08em' }}>
            {event.venueName.toUpperCase()} · {fmtTime(event.startsAt)}
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <span className="font-mono" style={{ fontSize: 10, color: event.status === 'live' ? 'var(--pulse)' : 'var(--soft)', letterSpacing: '0.14em' }}>
            {event.status === 'live' ? 'LIVE' : 'PRÓX'}
          </span>
          <div className="font-mono" style={{ fontSize: 10, color: pct >= 85 ? 'var(--blood)' : 'var(--soft)', marginTop: 6 }}>
            {pct}% LLENO
          </div>
        </div>
      </div>
      <div style={{ fontSize: 12, color: 'var(--soft)', marginTop: 6 }}>{event.venueAddress}</div>
      <div style={{ display: 'flex', gap: 6, marginTop: 12, flexWrap: 'wrap' }}>
        {event.genres.slice(0, 3).map((g) => (
          <Tag key={g} kind="ghost">{g}</Tag>
        ))}
      </div>
      <div style={{ display: 'flex', gap: 6, marginTop: 12 }}>
        <Link
          href={`/evento/${event.id}`}
          className="font-mono cache-action"
          style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.12em', textDecoration: 'none', border: '1px solid var(--line-2)', padding: '7px 12px' }}
        >
          VER
        </Link>
        <EventCTALink eventId={event.id} compact />
      </div>
    </div>
  )
}

export default function MapView({
  events,
  error,
  isFallback,
}: {
  events: CacheEvent[]
  error?: string
  isFallback?: boolean
}) {
  const { token } = useAuth()
  // filtros activos (combinados con AND). vacío = todos los eventos.
  const [active, setActive] = useState<Set<FilterKey>>(new Set())
  const [friendsByEvent, setFriendsByEvent] = useState<Record<string, number>>({})
  const [userPos, setUserPos] = useState<{ lat: number; lon: number } | null>(null)

  // amigos reales (neo4j) anotados a cada evento — alimenta pines, badge y filtro "amigos".
  // sin sesión no hay grafo: queda vacío y el filtro "amigos" no matchea nada.
  useEffect(() => {
    if (!token) {
      setFriendsByEvent({})
      return
    }
    let alive = true
    const geo = events.filter((e) => e.lat != null && e.lon != null)
    Promise.all(
      geo.map(async (e) => [e.id, (await getFriendsAttending(e.id, token)).length] as const),
    ).then((entries) => {
      if (alive) setFriendsByEvent(Object.fromEntries(entries))
    })
    return () => {
      alive = false
    }
  }, [events, token])

  // ubicación del usuario para el filtro "cerca" — best-effort, sin bloquear si la niega
  useEffect(() => {
    if (!('geolocation' in navigator)) return
    navigator.geolocation.getCurrentPosition(
      (pos) => setUserPos({ lat: pos.coords.latitude, lon: pos.coords.longitude }),
      () => setUserPos(null),
      { enableHighAccuracy: false, timeout: 8000, maximumAge: 300000 },
    )
  }, [])

  const toggle = (key: FilterKey) =>
    setActive((prev) => {
      const next = new Set(prev)
      if (next.has(key)) next.delete(key)
      else next.add(key)
      return next
    })

  const filtered = useMemo(() => {
    return events.filter((e) => {
      if (active.has('amigos') && !(friendsByEvent[e.id] > 0)) return false
      if (active.has('techno') && !e.genres.some((g) => g.toLowerCase().includes('techno'))) return false
      if (active.has('privadas') && e.accessType !== 'private' && e.accessType !== 'invite-only') return false
      if (active.has('cerca')) {
        if (!userPos || e.lat == null || e.lon == null) return false
        if (distanceKm(userPos.lat, userPos.lon, e.lat, e.lon) > NEAR_RADIUS_KM) return false
      }
      return true
    })
  }, [events, active, friendsByEvent, userPos])

  const liveCount = filtered.filter((e) => e.status === 'live').length
  const geoCount = filtered.filter((e) => e.lat != null && e.lon != null).length

  const chips: { key: FilterKey; label: string }[] = [
    { key: 'amigos', label: 'tus amigos' },
    { key: 'cerca', label: 'cerca' },
    { key: 'techno', label: 'techno' },
    { key: 'privadas', label: 'privadas' },
  ]

  return (
    <div className="cache-screen" style={{ height: '100dvh', position: 'relative', background: '#070707', overflow: 'hidden' }}>
      {isFallback && (
        <PlaceholderBadge
          mode="banner"
          label="MAPA — DATA MOCK"
          note="BACKEND OFFLINE"
          style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 600 }}
        />
      )}

      {/* mapa real (Leaflet + tiles dark de CARTO/OSM) — capa de fondo. pines ya filtrados */}
      <MapCanvas events={filtered} friendsByEvent={friendsByEvent} />

      {/* header overlay — encima del mapa. pointerEvents none salvo los chips,
          así el resto del header no bloquea el drag del mapa */}
      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, padding: '54px 16px 14px', zIndex: 500, background: 'linear-gradient(to bottom, rgba(7,7,7,0.95), transparent)', pointerEvents: 'none' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div className="font-display" style={{ fontSize: 22, color: 'var(--bone)' }}>mapa</div>
          <span className="font-mono" style={{ fontSize: 10, color: 'var(--pulse)', letterSpacing: '0.14em', display: 'flex', alignItems: 'center', gap: 5 }}>
            <Dot color="var(--pulse)" size={5} /> {liveCount} ACTIVAS · {geoCount} EN MAPA
          </span>
        </div>
        <div style={{ display: 'flex', gap: 8, marginTop: 12, pointerEvents: 'auto' }}>
          {chips.map((c) => {
            const on = active.has(c.key)
            const disabled = c.key === 'cerca' && !userPos
            return (
              <button
                key={c.key}
                type="button"
                onClick={() => toggle(c.key)}
                disabled={disabled}
                title={disabled ? 'activá la ubicación para filtrar por cercanía' : undefined}
                style={{ background: 'none', border: 'none', padding: 0, cursor: disabled ? 'not-allowed' : 'pointer', opacity: disabled ? 0.4 : 1 }}
              >
                <Tag kind={on ? 'acid' : 'ghost'}>{c.label}</Tag>
              </button>
            )
          })}
        </div>
      </div>

      {error && (
        <div style={{ position: 'absolute', top: 120, left: 16, right: 16, zIndex: 600 }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--blood)', letterSpacing: '0.12em' }}>BACKEND OFFLINE</div>
          <div style={{ fontSize: 12, color: 'var(--mute)', marginTop: 4 }}>{error}</div>
        </div>
      )}

      {filtered.length === 0 ? (
        <div style={{ position: 'absolute', bottom: 120, left: 0, right: 0, padding: 24, textAlign: 'center', zIndex: 500 }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>
            {active.size > 0 ? '(ningún evento con esos filtros.)' : '(no hay eventos cercanos.)'}
          </span>
        </div>
      ) : (
        <div
          className="no-scroll cache-screen"
          style={{
            position: 'absolute', bottom: 80, left: 12, right: 12,
            display: 'grid', gap: 10, zIndex: 500,
            maxHeight: '42vh', overflowY: 'auto', paddingBottom: 16,
          }}
        >
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em' }}>
              ● CERCA TUYO
            </span>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>{filtered.length} EVENTOS</span>
          </div>
          <FriendsStack size={20} max={3} />
          {filtered.map((event) => (
            <MapEventCard key={event.id} event={event} />
          ))}
        </div>
      )}
    </div>
  )
}
