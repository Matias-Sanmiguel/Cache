'use client'

import { FormEvent, useMemo, useState } from 'react'
import Link from 'next/link'
import { Icon } from '@/components/ui/icon'
import { Tag } from '@/components/ui/tag'
import {
  capacityPct,
  fmtDate,
  fmtPrice,
  fmtTime,
  getAdminMongoData,
  type AdminMongoData,
  type ApiResult,
  type CacheEvent,
  type CacheVenue,
} from '@/lib/api'

const panel: React.CSSProperties = {
  border: '1px solid var(--line)',
  background: 'var(--ink-2)',
}

const headerCell: React.CSSProperties = {
  padding: '10px 12px',
  color: 'var(--soft)',
  fontSize: 10,
  letterSpacing: '0.12em',
  textTransform: 'uppercase',
  borderBottom: '1px solid var(--line)',
}

const cell: React.CSSProperties = {
  padding: '12px',
  borderBottom: '1px solid var(--line)',
  verticalAlign: 'top',
}

function SourcePill({ ok, label }: { ok: boolean; label: string }) {
  return (
    <span
      className="font-mono"
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 7,
        padding: '5px 8px',
        border: `1px solid ${ok ? 'var(--acid)' : 'var(--blood)'}`,
        color: ok ? 'var(--acid)' : 'var(--blood)',
        fontSize: 10,
        letterSpacing: '0.12em',
        textTransform: 'uppercase',
        whiteSpace: 'nowrap',
      }}
    >
      <span
        style={{
          width: 7,
          height: 7,
          borderRadius: '50%',
          background: ok ? 'var(--acid)' : 'var(--blood)',
          boxShadow: ok ? '0 0 12px rgba(212,255,26,0.5)' : '0 0 12px rgba(255,46,46,0.5)',
        }}
      />
      {label}
    </span>
  )
}

function Metric({ label, value, tone = 'normal' }: { label: string; value: string | number; tone?: 'normal' | 'accent' | 'warn' }) {
  const color = tone === 'accent' ? 'var(--acid)' : tone === 'warn' ? 'var(--blood)' : 'var(--bone)'
  return (
    <div className="cache-card" style={{ ...panel, padding: 14 }}>
      <div className="font-mono" style={{ color: 'var(--soft)', fontSize: 10, letterSpacing: '0.12em', textTransform: 'uppercase' }}>{label}</div>
      <div className="font-display" style={{ color, fontSize: 30, marginTop: 8 }}>{value}</div>
    </div>
  )
}

function ErrorStrip({ result, emptyLabel }: { result: ApiResult<unknown>; emptyLabel: string }) {
  if (result.error) {
    return (
      <div style={{ borderTop: '1px solid var(--line)', padding: '10px 12px', color: 'var(--blood)', background: 'rgba(255,46,46,0.06)' }}>
        <div className="font-mono" style={{ fontSize: 10, letterSpacing: '0.12em' }}>BACKEND OFFLINE O ENDPOINT SIN RESPUESTA</div>
        <div style={{ color: 'var(--soft)', fontSize: 12, marginTop: 4 }}>{result.error}</div>
      </div>
    )
  }
  if (Array.isArray(result.data) && result.data.length === 0) {
    return (
      <div style={{ borderTop: '1px solid var(--line)', padding: '12px', color: 'var(--mute)', fontSize: 13 }}>
        {emptyLabel}
      </div>
    )
  }
  return null
}

function Section({
  title,
  endpoint,
  result,
  children,
}: {
  title: string
  endpoint: string
  result: ApiResult<unknown>
  children: React.ReactNode
}) {
  const ok = !result.error
  return (
    <section style={panel}>
      <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, padding: 14, borderBottom: '1px solid var(--line)', alignItems: 'center', flexWrap: 'wrap' }}>
        <div>
          <h2 className="font-display" style={{ fontSize: 24, color: 'var(--bone)' }}>{title}</h2>
          <div className="font-mono" style={{ color: 'var(--mute)', fontSize: 10, letterSpacing: '0.08em', marginTop: 5 }}>{endpoint}</div>
        </div>
        <SourcePill ok={ok} label={ok ? 'real' : 'fallback'} />
      </div>
      {children}
    </section>
  )
}

function EventsTable({ events }: { events: CacheEvent[] }) {
  if (events.length === 0) return null
  return (
    <div style={{ overflowX: 'auto' }}>
      <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: 760 }}>
        <thead>
          <tr>
            <th className="font-mono" style={headerCell}>evento</th>
            <th className="font-mono" style={headerCell}>venue</th>
            <th className="font-mono" style={headerCell}>fecha</th>
            <th className="font-mono" style={headerCell}>estado</th>
            <th className="font-mono" style={headerCell}>capacidad</th>
            <th className="font-mono" style={headerCell}>precio</th>
          </tr>
        </thead>
        <tbody>
          {events.map((event) => (
            <tr key={event.id}>
              <td style={cell}>
                <Link href={`/evento/${event.id}`} style={{ color: 'var(--bone)', textDecoration: 'none' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <span className="font-display" style={{ fontSize: 18 }}>{event.name}</span>
                    <Icon name="arrow" size={15} stroke={1.8} />
                  </div>
                </Link>
                <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginTop: 8 }}>
                  {event.genres.slice(0, 3).map((genre) => <Tag key={genre} kind="ghost">{genre}</Tag>)}
                </div>
              </td>
              <td style={{ ...cell, color: 'var(--soft)', fontSize: 13 }}>
                <div style={{ color: 'var(--bone)' }}>{event.venueName}</div>
                <div style={{ marginTop: 4 }}>{event.venueId}</div>
              </td>
              <td className="font-mono" style={{ ...cell, color: 'var(--soft)', fontSize: 11 }}>
                {fmtDate(event.startsAt)} · {fmtTime(event.startsAt)}
              </td>
              <td style={cell}><Tag kind={event.status === 'live' ? 'blood' : 'default'}>{event.status}</Tag></td>
              <td style={{ ...cell, color: 'var(--soft)', fontSize: 13 }}>
                <div>{event.attendeeCount}/{event.capacity || '-'}</div>
                <div style={{ width: 92, height: 5, background: 'var(--ink-5)', marginTop: 8 }}>
                  <div style={{ width: `${capacityPct(event)}%`, height: '100%', background: 'var(--acid)' }} />
                </div>
              </td>
              <td className="font-mono" style={{ ...cell, color: 'var(--bone)', fontSize: 12 }}>{fmtPrice(event.price)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

function VenuesTable({ venues }: { venues: CacheVenue[] }) {
  if (venues.length === 0) return null
  return (
    <div style={{ overflowX: 'auto' }}>
      <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: 680 }}>
        <thead>
          <tr>
            <th className="font-mono" style={headerCell}>venue</th>
            <th className="font-mono" style={headerCell}>dirección</th>
            <th className="font-mono" style={headerCell}>coords</th>
            <th className="font-mono" style={headerCell}>capacidad</th>
            <th className="font-mono" style={headerCell}>tags</th>
          </tr>
        </thead>
        <tbody>
          {venues.map((venue) => (
            <tr key={venue.venueId}>
              <td style={cell}>
                <div className="font-display" style={{ color: 'var(--bone)', fontSize: 18 }}>{venue.name}</div>
                <div className="font-mono" style={{ color: 'var(--mute)', fontSize: 10, marginTop: 5 }}>{venue.venueId}</div>
              </td>
              <td style={{ ...cell, color: 'var(--soft)', fontSize: 13 }}>{venue.address}</td>
              <td className="font-mono" style={{ ...cell, color: 'var(--soft)', fontSize: 11 }}>
                {venue.lat === null || venue.lon === null ? '-' : `${venue.lat.toFixed(4)}, ${venue.lon.toFixed(4)}`}
              </td>
              <td className="font-mono" style={{ ...cell, color: 'var(--bone)', fontSize: 12 }}>{venue.capacity || '-'}</td>
              <td style={cell}>
                <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                  {venue.tags.length ? venue.tags.map((tag) => <Tag key={tag} kind="ghost">{tag}</Tag>) : <span style={{ color: 'var(--mute)' }}>-</span>}
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export function AdminScreen({ initial, initialCity }: { initial: AdminMongoData; initialCity: string }) {
  const [city, setCity] = useState(initialCity)
  const [data, setData] = useState(initial)
  const [loading, setLoading] = useState(false)

  const totals = useMemo(() => {
    const events = data.events.data
    const venues = data.venues.data
    return {
      events: events.length,
      venues: venues.length,
      users: data.users.data.canList ? 'ok' : 'sin lista',
      live: events.filter((event) => event.status === 'live').length,
    }
  }, [data])

  async function refresh(nextCity = city) {
    setLoading(true)
    try {
      const fresh = await getAdminMongoData(nextCity.trim() || 'buenos aires')
      setData(fresh)
    } finally {
      setLoading(false)
    }
  }

  async function onSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    await refresh()
  }

  return (
    <div className="cache-screen" style={{ minHeight: '100dvh', padding: '38px 18px 34px', background: 'var(--ink)' }}>
      <div style={{ maxWidth: 1180, margin: '0 auto', display: 'grid', gap: 18 }}>
        <header style={{ display: 'grid', gap: 16, borderBottom: '1px solid var(--line)', paddingBottom: 18 }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
            <div>
              <div className="font-mono" style={{ color: 'var(--acid)', fontSize: 10, letterSpacing: '0.16em', textTransform: 'uppercase' }}>admin · mongo check</div>
              <h1 className="font-display" style={{ color: 'var(--bone)', fontSize: 44, marginTop: 8 }}>Caché Admin</h1>
            </div>
            <Link href="/" aria-label="Volver al feed" style={{ color: 'var(--bone)', border: '1px solid var(--line)', padding: 10, display: 'inline-flex', textDecoration: 'none' }}>
              <Icon name="back" size={20} stroke={1.8} />
            </Link>
          </div>

          <form onSubmit={onSubmit} style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
            <label className="font-mono" style={{ display: 'grid', gap: 6, color: 'var(--soft)', fontSize: 10, letterSpacing: '0.1em', textTransform: 'uppercase' }}>
              ciudad
              <input
                value={city}
                onChange={(event) => setCity(event.target.value)}
                style={{
                  width: 220,
                  height: 42,
                  background: 'var(--ink-2)',
                  border: '1px solid var(--line-2)',
                  color: 'var(--bone)',
                  padding: '0 12px',
                  font: 'inherit',
                  fontSize: 12,
                  letterSpacing: 0,
                  outline: 'none',
                }}
              />
            </label>
            <button
              type="submit"
              disabled={loading}
              style={{
                height: 42,
                alignSelf: 'end',
                display: 'inline-flex',
                alignItems: 'center',
                gap: 8,
                background: loading ? 'var(--ink-4)' : 'var(--acid)',
                color: loading ? 'var(--soft)' : 'var(--ink)',
                border: '1px solid var(--acid)',
                padding: '0 14px',
                cursor: loading ? 'wait' : 'pointer',
              }}
            >
              <Icon name="spark" size={16} stroke={2} />
              <span className="font-mono" style={{ fontSize: 10, letterSpacing: '0.12em', textTransform: 'uppercase' }}>
                {loading ? 'leyendo' : 'refrescar'}
              </span>
            </button>
          </form>
        </header>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(170px, 1fr))', gap: 12 }}>
          <Metric label="events" value={totals.events} tone={data.events.error ? 'warn' : 'accent'} />
          <Metric label="venues" value={totals.venues} tone={data.venues.error ? 'warn' : 'accent'} />
          <Metric label="live" value={totals.live} />
          <Metric label="users" value={totals.users} tone="warn" />
        </div>

        <Section title="Events" endpoint="GET /api/events/feed" result={data.events}>
          <EventsTable events={data.events.data} />
          <ErrorStrip result={data.events} emptyLabel="No llegaron eventos para esa ciudad desde Mongo." />
        </Section>

        <Section title="Venues" endpoint="GET /api/venues" result={data.venues}>
          <VenuesTable venues={data.venues.data} />
          <ErrorStrip result={data.venues} emptyLabel="No llegaron venues para esa ciudad desde Mongo." />
        </Section>

        <section style={panel}>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, padding: 14, borderBottom: '1px solid var(--line)', alignItems: 'center', flexWrap: 'wrap' }}>
            <div>
              <h2 className="font-display" style={{ fontSize: 24, color: 'var(--bone)' }}>Users</h2>
              <div className="font-mono" style={{ color: 'var(--mute)', fontSize: 10, letterSpacing: '0.08em', marginTop: 5 }}>
                {data.users.data.availableEndpoints.join(' · ')}
              </div>
            </div>
            <SourcePill ok={false} label="sin listado" />
          </div>
          <div style={{ padding: 14, color: 'var(--soft)', fontSize: 13, lineHeight: 1.5 }}>
            {data.users.data.note}
          </div>
        </section>
      </div>
    </div>
  )
}
