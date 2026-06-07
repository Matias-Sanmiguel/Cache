import Link from 'next/link'
import { Tag } from '@/components/ui/tag'
import { Dot } from '@/components/ui/dot'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { capacityPct, fmtTime, getNearby, type CacheEvent } from '@/lib/api'
import MapCanvas from '@/components/map/map-canvas'
import { FriendsStack } from '@/components/social/friends-stack'
import { EventCTALink } from '@/components/screens/event-cta-link'

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

export async function MapScreen() {
  // eventos reales con coordenadas, cerca del centro de Buenos Aires
  const { data: events, error, isFallback } = await getNearby()
  const liveCount = events.filter((event) => event.status === 'live').length
  const geoCount = events.filter((event) => event.lat != null && event.lon != null).length

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

      {/* mapa real (Leaflet + tiles dark de CARTO/OSM) — capa de fondo */}
      <MapCanvas events={events} />

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
          <Tag kind="acid">tus amigos</Tag>
          <Tag kind="ghost">cerca</Tag>
          <Tag kind="ghost">techno</Tag>
          <Tag kind="ghost">privadas</Tag>
        </div>
      </div>

      {error && (
        <div style={{ position: 'absolute', top: 120, left: 16, right: 16, zIndex: 600 }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--blood)', letterSpacing: '0.12em' }}>BACKEND OFFLINE</div>
          <div style={{ fontSize: 12, color: 'var(--mute)', marginTop: 4 }}>{error}</div>
        </div>
      )}

      {events.length === 0 ? (
        <div style={{ position: 'absolute', bottom: 120, left: 0, right: 0, padding: 24, textAlign: 'center', zIndex: 500 }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(no hay eventos cercanos.)</span>
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
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>{events.length} EVENTOS</span>
          </div>
          <FriendsStack size={20} max={3} />
          {events.map((event) => (
            <MapEventCard key={event.id} event={event} />
          ))}
        </div>
      )}
    </div>
  )
}
