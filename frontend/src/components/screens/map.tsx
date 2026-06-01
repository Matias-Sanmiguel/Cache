import Link from 'next/link'
import { Tag } from '@/components/ui/tag'
import { Dot } from '@/components/ui/dot'
import { AvatarStack } from '@/components/ui/avatar'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { capacityPct, fmtTime, getEvents, type CacheEvent } from '@/lib/api'

const MOCK_PEOPLE = [
  { name: 'Mati', color: '#FF2E2E' },
  { name: 'Jule', color: '#D4FF1A' },
  { name: 'Cami', color: '#7B61FF' },
  { name: 'Tomi', color: '#00FF88' },
]

const PIN_SLOTS = [
  { x: 32, y: 38 },
  { x: 60, y: 28 },
  { x: 70, y: 55 },
  { x: 22, y: 62 },
  { x: 78, y: 78 },
  { x: 45, y: 70 },
]

type MapPin = {
  id: string
  label: string
  friends: number
  hot?: boolean
  urgent?: boolean
  big?: boolean
  x: number
  y: number
}

function pinLabel(name: string) {
  return name.replace(/[^a-z0-9]/gi, '').slice(0, 5).toUpperCase()
}

function makePins(events: CacheEvent[]) {
  return events.slice(0, PIN_SLOTS.length).map((event, i) => {
    const pct = capacityPct(event)
    return {
      id: event.id,
      label: pinLabel(event.name),
      friends: Math.min(9, Math.max(0, Math.round(event.attendeeCount / 50))),
      hot: event.status === 'live',
      urgent: pct >= 85,
      big: i === 0,
      ...PIN_SLOTS[i],
    }
  })
}

function FakeMap({ pins }: { pins: MapPin[] }) {
  return (
    <div style={{ position: 'absolute', inset: 0 }}>
      <svg viewBox="0 0 360 760" preserveAspectRatio="none" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
        <defs>
          <pattern id="map-dots" width="14" height="14" patternUnits="userSpaceOnUse">
            <circle cx="7" cy="7" r="0.7" fill="#1c1c1c" />
          </pattern>
          <pattern id="map-grid" width="60" height="60" patternUnits="userSpaceOnUse">
            <path d="M 60 0 L 0 0 0 60" fill="none" stroke="#141414" strokeWidth="1" />
          </pattern>
        </defs>
        <rect width="360" height="760" fill="#070707" />
        <rect width="360" height="760" fill="url(#map-dots)" />
        <rect width="360" height="760" fill="url(#map-grid)" />
        <path d="M -20 540 Q 80 510 200 580 T 400 620 L 400 820 L -20 820 Z" fill="#0c0f14" stroke="#1a1a1a" />
        <path d="M 0 200 L 360 220" stroke="#1a1a1a" strokeWidth="2" fill="none" />
        <path d="M 0 350 L 360 360" stroke="#1a1a1a" strokeWidth="2" fill="none" />
        <path d="M 0 460 L 360 480" stroke="#1a1a1a" strokeWidth="2" fill="none" />
        <path d="M 100 0 L 120 760" stroke="#1a1a1a" strokeWidth="2" fill="none" />
        <path d="M 240 0 L 220 760" stroke="#1a1a1a" strokeWidth="2" fill="none" />
        <text x="40"  y="180" fill="#2a2a2a" fontFamily="monospace" fontSize="9" letterSpacing="2">PALERMO</text>
        <text x="200" y="320" fill="#2a2a2a" fontFamily="monospace" fontSize="9" letterSpacing="2">CHACARITA</text>
        <text x="40"  y="490" fill="#2a2a2a" fontFamily="monospace" fontSize="9" letterSpacing="2">VILLA CRESPO</text>
        <text x="220" y="500" fill="#2a2a2a" fontFamily="monospace" fontSize="9" letterSpacing="2">ALMAGRO</text>
      </svg>

      {/* user location */}
      <div style={{ position: 'absolute', left: '48%', top: '50%', transform: 'translate(-50%, -50%)' }}>
        <div style={{ width: 60, height: 60, border: '1px solid rgba(0,255,136,0.2)', borderRadius: '50%', position: 'absolute', left: -22, top: -22 }} />
        <div style={{ width: 14, height: 14, borderRadius: '50%', background: 'var(--pulse)', border: '3px solid var(--ink)' }} />
      </div>

      {pins.map((p) => (
        <div
          key={p.id}
          style={{ position: 'absolute', left: `${p.x}%`, top: `${p.y}%`, transform: 'translate(-50%, -100%)' }}
        >
          <div
            className="font-mono"
            style={{
              background: p.hot ? 'var(--acid)' : p.urgent ? 'var(--blood)' : 'var(--bone)',
              color: 'var(--ink)',
              padding: p.big ? '6px 10px' : '4px 8px',
              display: 'flex', alignItems: 'center', gap: 6,
              border: '2px solid var(--ink)',
              fontSize: p.big ? 12 : 10, fontWeight: 700, letterSpacing: '0.06em',
            }}
          >
            {p.label}
            {p.friends > 0 && (
              <span style={{ background: 'var(--ink)', color: p.hot ? 'var(--acid)' : 'var(--bone)', padding: '1px 5px', fontSize: 9 }}>
                ·{p.friends}
              </span>
            )}
          </div>
          <div
            style={{
              width: 0, height: 0,
              borderLeft: '5px solid transparent',
              borderRight: '5px solid transparent',
              borderTop: `7px solid ${p.hot ? 'var(--acid)' : p.urgent ? 'var(--blood)' : 'var(--bone)'}`,
              margin: '0 auto',
            }}
          />
        </div>
      ))}
    </div>
  )
}

function MapEventCard({ event }: { event: CacheEvent }) {
  const pct = capacityPct(event)
  return (
    <div style={{ background: 'var(--ink-2)', border: '1px solid var(--line)', padding: 14 }}>
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
          className="font-mono"
          style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.12em', textDecoration: 'none', border: '1px solid var(--line-2)', padding: '7px 12px' }}
        >
          VER
        </Link>
        <Link
          href={`/evento/${event.id}`}
          className="font-mono"
          style={{ fontSize: 10, color: 'var(--ink)', letterSpacing: '0.12em', textDecoration: 'none', background: 'var(--acid)', padding: '7px 12px', fontWeight: 700 }}
        >
          ANOTARME
        </Link>
      </div>
    </div>
  )
}

export async function MapScreen() {
  const { data: events, error, isFallback } = await getEvents('buenos aires')
  const pins = makePins(events)
  const liveCount = events.filter((event) => event.status === 'live').length

  return (
    <div style={{ height: '100dvh', position: 'relative', background: '#070707', overflow: 'hidden' }}>
      {isFallback && (
        <PlaceholderBadge
          mode="banner"
          label="MAPA — DATA MOCK"
          note="MONGO GEO PENDIENTE"
          style={{ position: 'sticky', top: 0, zIndex: 60 }}
        />
      )}
      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, padding: '54px 16px 14px', zIndex: 40, background: 'linear-gradient(to bottom, rgba(7,7,7,0.95), transparent)' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div className="font-display" style={{ fontSize: 22, color: 'var(--bone)' }}>mapa</div>
          <span className="font-mono" style={{ fontSize: 10, color: 'var(--pulse)', letterSpacing: '0.14em', display: 'flex', alignItems: 'center', gap: 5 }}>
            <Dot color="var(--pulse)" size={5} /> {liveCount} ACTIVAS
          </span>
        </div>
        <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
          <Tag kind="acid">tus amigos</Tag>
          <Tag kind="ghost">cerca</Tag>
          <Tag kind="ghost">techno</Tag>
          <Tag kind="ghost">privadas</Tag>
        </div>
      </div>

      <FakeMap pins={pins} />

      {error && (
        <div style={{ position: 'absolute', top: 120, left: 16, right: 16, zIndex: 50 }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--blood)', letterSpacing: '0.12em' }}>BACKEND OFFLINE</div>
          <div style={{ fontSize: 12, color: 'var(--mute)', marginTop: 4 }}>{error}</div>
        </div>
      )}

      {events.length === 0 ? (
        <div style={{ position: 'absolute', bottom: 120, left: 0, right: 0, padding: 24, textAlign: 'center', zIndex: 40 }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(no hay eventos cercanos.)</span>
        </div>
      ) : (
        <div
          className="no-scroll"
          style={{
            position: 'absolute', bottom: 80, left: 12, right: 12,
            display: 'grid', gap: 10, zIndex: 40,
            maxHeight: '42vh', overflowY: 'auto', paddingBottom: 16,
          }}
        >
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em' }}>
              ● CERCA TUYO
            </span>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>{events.length} EVENTOS</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <AvatarStack people={MOCK_PEOPLE} size={20} max={3} />
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>+{MOCK_PEOPLE.length}</span>
          </div>
          {events.map((event) => (
            <MapEventCard key={event.id} event={event} />
          ))}
        </div>
      )}
    </div>
  )
}
