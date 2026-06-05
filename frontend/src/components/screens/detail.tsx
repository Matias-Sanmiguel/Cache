import Link from 'next/link'
import { Tag } from '@/components/ui/tag'
import { Dot } from '@/components/ui/dot'
import { Avatar } from '@/components/ui/avatar'
import { Icon } from '@/components/ui/icon'
import { PhotoBG } from '@/components/ui/photo-bg'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { fmtTime, fmtDate, capacityPct, fmtPrice, type CacheEvent } from '@/lib/api'
import { CheckInCTA } from '@/components/screens/checkin-cta'
import { ShareHeart, InviteButton } from '@/components/screens/detail-actions'

// amigos: neo4j/redis (fuera de alcance) — placeholder visual
const FRIENDS = [
  { name: 'Jule', color: '#D4FF1A', state: 'in', sub: 'llegó hace 12 min' },
  { name: 'Mati', color: '#FF2E2E', state: 'on-way', sub: 'en camino — eta 23:50' },
  { name: 'Tomi', color: '#00FF88', state: 'in', sub: 'llegó hace 4 min' },
  { name: 'Cami', color: '#7B61FF', state: 'pending', sub: 'anotada — sin confirmar' },
]

export function DetailScreen({ event }: { event: CacheEvent }) {
  const pct = capacityPct(event)
  const live = event.status === 'live'

  return (
    <div className="cache-screen" style={{ background: 'var(--ink)', position: 'relative', minHeight: '100dvh' }}>
      <div className="no-scroll" style={{ overflowY: 'auto', paddingBottom: 110 }}>

        {/* hero */}
        <div style={{ position: 'relative' }}>
          <PhotoBG height={340} hue="red" />
          <div style={{ position: 'absolute', top: 58, left: 14, right: 14, display: 'flex', justifyContent: 'space-between' }}>
            <Link
              className="cache-action"
              href="/"
              style={{
                width: 36, height: 36, background: 'rgba(10,10,10,0.6)', backdropFilter: 'blur(12px)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                border: '1px solid var(--line)', color: 'var(--bone)',
              }}
            >
              <Icon name="back" size={18} />
            </Link>
            <ShareHeart name={event.name} />
          </div>
          <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, background: 'linear-gradient(to top, var(--ink) 0%, transparent 100%)', padding: '60px 18px 16px' }}>
            <div className="font-mono" style={{ fontSize: 10, letterSpacing: '0.18em', color: 'var(--acid)' }}>
              {live ? '● LIVE NOW' : '○ PRÓXIMO'} · {event.genres.map((g) => g.toUpperCase()).join(' / ')}
            </div>
            <div className="font-display" style={{ fontSize: 48, lineHeight: 0.92, marginTop: 6 }}>
              {event.name}<span style={{ color: 'var(--acid)' }}>.</span>
            </div>
            <div className="font-editorial-italic" style={{ fontSize: 17, color: 'var(--soft)', marginTop: 4 }}>{event.venueName}</div>
          </div>
        </div>

        {/* meta */}
        <div style={{ padding: '16px 18px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14, borderBottom: '1px solid var(--line)' }}>
          {[
            { icon: 'clock' as const, label: 'CUÁNDO', value: fmtDate(event.startsAt), sub: `${fmtTime(event.startsAt)} → ${fmtTime(event.endsAt)}` },
            { icon: 'pin' as const, label: 'DÓNDE', value: event.venueName, sub: event.venueAddress },
            { icon: 'people' as const, label: 'CAPACIDAD', value: `${event.attendeeCount} / ${event.capacity}`, sub: `${pct}% lleno`, urgent: pct >= 75 },
            { icon: 'fire' as const, label: 'ENTRADA', value: fmtPrice(event.price), sub: 'puerta + cupos online' },
          ].map((m) => (
            <div className="cache-card" key={m.label} style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <span className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.14em', display: 'flex', alignItems: 'center', gap: 6 }}>
                <Icon name={m.icon} size={11} stroke={1.6} /> {m.label}
              </span>
              <span className="font-display" style={{ fontSize: 18, color: m.urgent ? 'var(--blood)' : 'var(--bone)' }}>{m.value}</span>
              <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.04em' }}>{m.sub}</span>
            </div>
          ))}
        </div>

        {/* blurb */}
        <div style={{ padding: '20px 18px', borderBottom: '1px solid var(--line)' }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em', marginBottom: 10 }}>— SOBRE LA NOCHE</div>
          <p className="font-editorial" style={{ fontSize: 22, color: 'var(--bone)', lineHeight: 1.3 }}>
            {event.description}
          </p>
          <div style={{ display: 'flex', gap: 6, marginTop: 14, flexWrap: 'wrap' }}>
            {event.genres.map((g) => (
              <Tag key={g}>{g}</Tag>
            ))}
          </div>
        </div>

        {/* friends live (placeholder neo4j/redis) */}
        <div style={{ position: 'relative', padding: '20px 18px', borderBottom: '1px solid var(--line)' }}>
          <PlaceholderBadge note="NEO4J/REDIS" />
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 14 }}>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em' }}>— TUS AMIGOS</span>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', display: 'flex', alignItems: 'center', gap: 5 }}>
              <Dot color="var(--pulse)" size={5} /> 2 EN VENUE
            </span>
          </div>
          {FRIENDS.map((p, i) => (
            <div className="cache-card" key={p.name} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '10px 0', borderBottom: i < FRIENDS.length - 1 ? '1px dashed var(--line)' : 'none' }}>
              <Avatar name={p.name} size={36} color={p.color} online={p.state === 'in' || p.state === 'on-way'} />
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, color: 'var(--bone)' }}>{p.name.toLowerCase()}</div>
                <div className="font-mono" style={{ fontSize: 10, color: p.state === 'in' ? 'var(--pulse)' : p.state === 'on-way' ? 'var(--bone)' : 'var(--mute)', letterSpacing: '0.04em' }}>
                  {p.sub}
                </div>
              </div>
              {p.state === 'in' && <Tag kind="acid">EN VENUE</Tag>}
              {p.state === 'on-way' && <Tag>EN CAMINO</Tag>}
              {p.state === 'pending' && <Tag kind="ghost">PENDIENTE</Tag>}
            </div>
          ))}
        </div>

        {/* lineup */}
        {event.lineup?.length > 0 && (
          <div style={{ padding: '20px 18px', borderBottom: '1px solid var(--line)' }}>
            <div className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em', marginBottom: 14 }}>— LINE UP</div>
            {event.lineup.map((slot, i) => (
              <div className="cache-card" key={i} style={{ display: 'grid', gridTemplateColumns: '60px 70px 1fr', gap: 12, alignItems: 'baseline', padding: '10px 0', borderBottom: i < event.lineup.length - 1 ? '1px dashed var(--line)' : 'none' }}>
                <span className="font-mono" style={{ fontSize: 13, color: 'var(--bone)' }}>{slot.time}</span>
                <span className="font-mono" style={{ fontSize: 9, color: 'var(--acid)', letterSpacing: '0.14em' }}>{slot.slot}</span>
                <span className="font-display" style={{ fontSize: 16, color: 'var(--bone)' }}>{slot.artist}</span>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* sticky CTA */}
      <div style={{ position: 'fixed', bottom: 0, left: 0, right: 0, padding: '14px 16px 32px', background: 'linear-gradient(to top, var(--ink) 70%, transparent)' }}>
        <div style={{ display: 'flex', gap: 8 }}>
          <CheckInCTA eventId={event.id} venueId={event.venueId} />
          <InviteButton name={event.name} />
        </div>
        <div className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.1em', textAlign: 'center', marginTop: 8 }}>
          {event.attendeeCount} / {event.capacity} · {pct}% LLENO · {event.venueName.toUpperCase()}
        </div>
      </div>
    </div>
  )
}
