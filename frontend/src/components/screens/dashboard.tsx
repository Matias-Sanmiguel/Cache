import { Tag } from '@/components/ui/tag'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { getDashboardData } from '@/lib/api'

function StatCard({ label, value, sub }: { label: string; value: string | number; sub?: string }) {
  return (
    <div style={{ background: 'var(--ink-2)', border: '1px solid var(--line)', padding: 14 }}>
      <div className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.14em' }}>{label}</div>
      <div className="font-display" style={{ fontSize: 26, color: 'var(--bone)', marginTop: 6 }}>{value}</div>
      {sub && <div className="font-mono" style={{ fontSize: 10, color: 'var(--mute)', marginTop: 6 }}>{sub}</div>}
    </div>
  )
}

function SectionHeader({ label }: { label: string }) {
  return (
    <div style={{ padding: '14px 16px 8px', display: 'flex', alignItems: 'center', gap: 10 }}>
      <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.16em' }}>— {label}</span>
      <div style={{ flex: 1, height: 1, background: 'var(--line)' }} />
    </div>
  )
}

function BarRow({ label, value, max, hint }: { label: string; value: number; max: number; hint?: string }) {
  const pct = max > 0 ? Math.round((value / max) * 100) : 0
  return (
    <div style={{ padding: '10px 16px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <span style={{ fontSize: 13, color: 'var(--bone)' }}>{label}</span>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>{value}</span>
      </div>
      {hint && (
        <div className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', marginTop: 2 }}>{hint}</div>
      )}
      <div style={{ height: 4, background: 'var(--line)', marginTop: 8 }}>
        <div style={{ height: 4, width: `${pct}%`, background: 'var(--acid)' }} />
      </div>
    </div>
  )
}

function maxCount(items: Array<{ count: number }>) {
  return items.reduce((acc, item) => Math.max(acc, item.count), 0)
}

export async function DashboardScreen() {
  const { data, error, isFallback } = await getDashboardData()
  const { summary, attendeesByEvent, eventsByZone, genresByDate, checkinPeaks } = data

  const maxAttendees = maxCount(attendeesByEvent)
  const maxZones = maxCount(eventsByZone)
  const maxPeaks = maxCount(checkinPeaks)

  return (
    <div className="no-scroll" style={{ height: '100dvh', overflowY: 'auto', paddingBottom: 72 }}>
      {isFallback && (
        <PlaceholderBadge mode="banner" label="DASHBOARD — DATA MOCK" note="ANALYTICS PENDIENTE" style={{ position: 'sticky', top: 0, zIndex: 60 }} />
      )}
      <div style={{ padding: '54px 18px 16px', borderBottom: '1px solid var(--line)' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>dashboard</div>
        <div className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', marginTop: 6, letterSpacing: '0.12em' }}>RESUMEN NOCHE</div>
      </div>

      {error && (
        <div style={{ padding: '12px 18px', borderBottom: '1px solid var(--line)' }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--blood)', letterSpacing: '0.12em' }}>BACKEND OFFLINE</div>
          <div style={{ fontSize: 12, color: 'var(--mute)', marginTop: 4 }}>{error}</div>
        </div>
      )}

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, padding: '16px 16px 8px' }}>
        <StatCard label="EVENTOS ACTIVOS" value={summary.activeEvents} sub="últimas 2 horas" />
        <StatCard label="CHECK-INS TOTALES" value={summary.totalCheckins} sub="hoy" />
        <StatCard label="VENUES ACTIVOS" value={summary.activeVenues} sub="en vivo" />
        <StatCard label="ZONA TOP" value={summary.topZone} />
      </div>

      <SectionHeader label="ASISTENCIAS POR EVENTO" />
      {attendeesByEvent.length === 0 ? (
        <div style={{ padding: '0 16px 16px' }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(sin datos.)</span>
        </div>
      ) : (
        attendeesByEvent.map((row) => (
          <BarRow
            key={row.eventId}
            label={row.eventName}
            value={row.count}
            max={maxAttendees}
            hint={row.capacity ? `${row.count} / ${row.capacity}` : undefined}
          />
        ))
      )}

      <SectionHeader label="EVENTOS POR ZONA" />
      {eventsByZone.length === 0 ? (
        <div style={{ padding: '0 16px 16px' }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(sin datos.)</span>
        </div>
      ) : (
        eventsByZone.map((row) => (
          <BarRow key={row.zone} label={row.zone} value={row.count} max={maxZones} />
        ))
      )}

      <SectionHeader label="GÉNEROS POR FECHA" />
      {genresByDate.length === 0 ? (
        <div style={{ padding: '0 16px 16px' }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(sin datos.)</span>
        </div>
      ) : (
        <div style={{ padding: '0 16px 16px', display: 'grid', gap: 12 }}>
          {genresByDate.map((row) => (
            <div key={row.date} style={{ border: '1px solid var(--line)', padding: 12, background: 'var(--ink-2)' }}>
              <div className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.12em' }}>{row.date}</div>
              <div style={{ display: 'flex', gap: 6, marginTop: 8, flexWrap: 'wrap' }}>
                {row.genres.map((g) => (
                  <Tag key={g.name} kind="ghost">{g.name} · {g.count}</Tag>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}

      <SectionHeader label="PICO DE ANOTACIONES" />
      {checkinPeaks.length === 0 ? (
        <div style={{ padding: '0 16px 24px' }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(sin datos.)</span>
        </div>
      ) : (
        checkinPeaks.map((row) => (
          <BarRow key={row.time} label={row.time} value={row.count} max={maxPeaks} />
        ))
      )}
    </div>
  )
}
