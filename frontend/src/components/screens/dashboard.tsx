'use client'

import { useEffect, useState } from 'react'
import {
  ResponsiveContainer,
  BarChart, Bar, XAxis, YAxis, Cell,
  PieChart, Pie,
  AreaChart, Area, CartesianGrid,
  Tooltip,
} from 'recharts'
import { Tag } from '@/components/ui/tag'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { getDashboardData, type ApiResult, type DashboardData } from '@/lib/api'

// refresco del lado del cliente — redis es tiempo real, lo repolleamos
const POLL_MS = 15000

// paleta para charts (alineada con las CSS vars del theme)
const ACID = '#D4FF1A'
const ACID_DEEP = '#B8E300'
const BLOOD = '#FF2E2E'
const BONE = '#E8E6DF'
const SOFT = '#9A9A9A'
const MUTE = '#6B6B6B'
const LINE = '#2A2A2A'
const INK2 = '#111111'
const ZONE_PALETTE = [ACID, ACID_DEEP, '#7FB800', SOFT, MUTE, '#4A5A00']

// recharts necesita DOM (ResponsiveContainer mide al montar) — evita el render SSR a 0px
function ClientOnly({ children }: { children: React.ReactNode }) {
  const [mounted, setMounted] = useState(false)
  useEffect(() => setMounted(true), [])
  return mounted ? <>{children}</> : null
}

function StatCard({ label, value, sub, accent = false, delay = 0 }: { label: string; value: string | number; sub?: string; accent?: boolean; delay?: number }) {
  return (
    <div className="cache-card" style={{ animationDelay: `${delay}ms`, background: 'var(--ink-2)', border: `1px solid ${accent ? 'var(--acid)' : 'var(--line)'}`, padding: 14 }}>
      <div className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.14em' }}>{label}</div>
      <div className="font-display cache-dashboard-value" style={{ animationDelay: `${delay + 120}ms`, fontSize: 26, color: accent ? 'var(--acid)' : 'var(--bone)', marginTop: 6 }}>{value}</div>
      {sub && <div className="font-mono" style={{ fontSize: 10, color: 'var(--mute)', marginTop: 6 }}>{sub}</div>}
    </div>
  )
}

function SectionHeader({ label, source }: { label: string; source?: string }) {
  return (
    <div style={{ padding: '14px 16px 8px', display: 'flex', alignItems: 'center', gap: 10 }}>
      <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.16em' }}>— {label}</span>
      {source && <span className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.1em' }}>{source}</span>}
      <div className="cache-section-rule" style={{ flex: 1, height: 1, background: 'var(--line)' }} />
    </div>
  )
}

function LiveDot() {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
      <span className="cache-live-pulse" style={{ width: 7, height: 7, borderRadius: '50%', background: BLOOD, display: 'inline-block' }} />
      <span className="font-mono" style={{ fontSize: 9, color: 'var(--blood)', letterSpacing: '0.14em' }}>LIVE</span>
    </span>
  )
}

// tooltip oscuro acorde al theme
function ChartTooltip({ active, payload, label, unit }: { active?: boolean; payload?: Array<{ value: number; payload: Record<string, unknown> }>; label?: string; unit?: string }) {
  if (!active || !payload || payload.length === 0) return null
  const row = payload[0]
  const name = (row.payload.label as string) ?? label ?? ''
  return (
    <div style={{ background: INK2, border: `1px solid ${LINE}`, padding: '6px 10px' }}>
      <div className="font-mono" style={{ fontSize: 10, color: SOFT, letterSpacing: '0.1em' }}>{name}</div>
      <div className="font-display" style={{ fontSize: 16, color: ACID }}>{row.value}{unit ?? ''}</div>
    </div>
  )
}

const empty = (
  <div style={{ padding: '0 16px 16px' }}>
    <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(sin datos.)</span>
  </div>
)

// barras horizontales — venues / eventos
function HBars({ data, unit }: { data: Array<{ label: string; value: number }>; unit?: string }) {
  const height = Math.max(80, data.length * 38)
  return (
    <div style={{ padding: '4px 8px 16px', height }}>
      <ClientOnly>
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data} layout="vertical" margin={{ top: 4, right: 16, left: 8, bottom: 4 }}>
          <XAxis type="number" hide />
          <YAxis type="category" dataKey="label" width={96} tick={{ fill: BONE, fontSize: 11 }} axisLine={false} tickLine={false} />
          <Tooltip cursor={{ fill: 'rgba(212,255,26,0.06)' }} content={<ChartTooltip unit={unit} />} />
          <Bar dataKey="value" radius={[0, 2, 2, 0]} isAnimationActive>
            {data.map((_, i) => <Cell key={i} fill={i === 0 ? ACID : ACID_DEEP} />)}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
      </ClientOnly>
    </div>
  )
}

// donut — eventos por zona
function ZonePie({ data }: { data: Array<{ label: string; value: number }> }) {
  return (
    <div style={{ padding: '4px 8px 16px', height: 240 }}>
      <ClientOnly>
      <ResponsiveContainer width="100%" height="100%">
        <PieChart>
          <Tooltip content={<ChartTooltip />} />
          <Pie data={data} dataKey="value" nameKey="label" cx="50%" cy="50%" innerRadius={52} outerRadius={84} paddingAngle={2} stroke={INK2} label={{ fill: SOFT, fontSize: 10 }}>
            {data.map((_, i) => <Cell key={i} fill={ZONE_PALETTE[i % ZONE_PALETTE.length]} />)}
          </Pie>
        </PieChart>
      </ResponsiveContainer>
      </ClientOnly>
    </div>
  )
}

// área temporal — pico de anotaciones (cassandra)
function PeakArea({ data }: { data: Array<{ label: string; value: number }> }) {
  return (
    <div style={{ padding: '4px 8px 16px', height: 200 }}>
      <ClientOnly>
      <ResponsiveContainer width="100%" height="100%">
        <AreaChart data={data} margin={{ top: 8, right: 16, left: -16, bottom: 4 }}>
          <defs>
            <linearGradient id="peakFill" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor={ACID} stopOpacity={0.5} />
              <stop offset="100%" stopColor={ACID} stopOpacity={0} />
            </linearGradient>
          </defs>
          <CartesianGrid stroke={LINE} vertical={false} />
          <XAxis dataKey="label" tick={{ fill: SOFT, fontSize: 10 }} axisLine={{ stroke: LINE }} tickLine={false} />
          <YAxis tick={{ fill: MUTE, fontSize: 10 }} axisLine={false} tickLine={false} width={36} />
          <Tooltip cursor={{ stroke: ACID, strokeWidth: 1 }} content={<ChartTooltip />} />
          <Area type="monotone" dataKey="value" stroke={ACID} strokeWidth={2} fill="url(#peakFill)" isAnimationActive />
        </AreaChart>
      </ResponsiveContainer>
      </ClientOnly>
    </div>
  )
}

export function DashboardScreen({ initial }: { initial: ApiResult<DashboardData> }) {
  const [result, setResult] = useState<ApiResult<DashboardData>>(initial)

  // polling client-side: redis/cassandra cambian en vivo
  useEffect(() => {
    let alive = true
    const tick = async () => {
      const next = await getDashboardData()
      if (alive) setResult(next)
    }
    const id = setInterval(tick, POLL_MS)
    return () => { alive = false; clearInterval(id) }
  }, [])

  const { data, error, isFallback } = result
  const { summary, attendeesByEvent, eventsByZone, genresByDate, checkinPeaks, livePresence } = data

  const presenceData = livePresence.map((r) => ({ label: r.venueName, value: r.count }))
  const attendeesData = attendeesByEvent.map((r) => ({ label: r.eventName, value: r.count }))
  const zoneData = eventsByZone.map((r) => ({ label: r.zone, value: r.count }))
  const peakData = checkinPeaks.map((r) => ({ label: r.time, value: r.count }))

  return (
    <div className="cache-screen" style={{ minHeight: '100dvh', paddingBottom: 88 }}>
      {isFallback && (
        <PlaceholderBadge mode="banner" label="DASHBOARD — DATA MOCK" note="ANALYTICS PENDIENTE" style={{ position: 'sticky', top: 0, zIndex: 60 }} />
      )}
      <div style={{ padding: '54px 18px 16px', borderBottom: '1px solid var(--line)' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>dashboard</div>
          <LiveDot />
        </div>
        <div className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', marginTop: 6, letterSpacing: '0.12em' }}>RESUMEN NOCHE · REDIS + CASSANDRA</div>
      </div>

      {error && (
        <div style={{ padding: '12px 18px', borderBottom: '1px solid var(--line)' }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--blood)', letterSpacing: '0.12em' }}>BACKEND OFFLINE</div>
          <div style={{ fontSize: 12, color: 'var(--mute)', marginTop: 4 }}>{error}</div>
        </div>
      )}

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, padding: '16px 16px 8px' }}>
        <StatCard label="PRESENTES AHORA" value={summary.totalPresentNow} sub="redis · en vivo" accent delay={40} />
        <StatCard label="EVENTOS ACTIVOS" value={summary.activeEvents} sub="en vivo" delay={100} />
        <StatCard label="CHECK-INS TOTALES" value={summary.totalCheckins} sub="hoy" delay={160} />
        <StatCard label="ZONA TOP" value={summary.topZone} sub={`${summary.activeVenues} venues activos`} delay={220} />
      </div>

      <SectionHeader label="EN VIVO POR VENUE" source="redis" />
      {presenceData.length === 0 ? empty : <HBars data={presenceData} unit=" pers" />}

      <SectionHeader label="ASISTENCIAS POR EVENTO" source="redis" />
      {attendeesData.length === 0 ? empty : <HBars data={attendeesData} />}

      <SectionHeader label="EVENTOS POR ZONA" source="mongo" />
      {zoneData.length === 0 ? empty : <ZonePie data={zoneData} />}

      <SectionHeader label="GÉNEROS POR FECHA" source="mongo" />
      {genresByDate.length === 0 ? empty : (
        <div style={{ padding: '0 16px 16px', display: 'grid', gap: 12 }}>
          {genresByDate.map((row, i) => (
            <div className="cache-card" key={row.date} style={{ animationDelay: `${100 + i * 100}ms`, border: '1px solid var(--line)', padding: 12, background: 'var(--ink-2)' }}>
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

      <SectionHeader label="PICO DE ANOTACIONES" source="cassandra" />
      {peakData.length === 0 ? empty : <PeakArea data={peakData} />}
    </div>
  )
}
