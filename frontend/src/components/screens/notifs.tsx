import type { ReactNode } from 'react'
import { Tag } from '@/components/ui/tag'
import { Avatar } from '@/components/ui/avatar'
import { Icon } from '@/components/ui/icon'

type NotifKind = 'friend-joined' | 'live' | 'urgent' | 'recommend' | 'system'

const KIND_STYLES: Record<NotifKind, { color: string; label: string }> = {
  'friend-joined': { color: 'var(--acid)',  label: '◉' },
  'live':          { color: 'var(--pulse)', label: '●' },
  'urgent':        { color: 'var(--blood)', label: '!' },
  'recommend':     { color: 'var(--bone)',  label: '~' },
  'system':        { color: 'var(--soft)',  label: '/' },
}

type NotifData = {
  kind: NotifKind
  tag: string
  time: string
  body: ReactNode
  sub?: string
  unread?: boolean
  avatar?: { name: string; color: string }
  icon?: 'fire' | 'spark' | 'pin'
  cta?: string
  cta2?: string
}

function NotifItem({ data }: { data: NotifData }) {
  const s = KIND_STYLES[data.kind]
  return (
    <div
      style={{
        padding: '14px 18px',
        borderBottom: '1px solid var(--line)',
        background: data.unread ? 'var(--ink-2)' : 'transparent',
        position: 'relative',
      }}
    >
      {data.unread && (
        <span style={{ position: 'absolute', left: 0, top: 0, bottom: 0, width: 2, background: 'var(--acid)' }} />
      )}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 8 }}>
        <span className="font-mono" style={{ fontSize: 9, color: s.color, letterSpacing: '0.16em' }}>
          {s.label} {data.tag}
        </span>
        <span className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.06em' }}>{data.time}</span>
      </div>
      <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
        {data.avatar && <Avatar name={data.avatar.name} color={data.avatar.color} size={32} />}
        {data.icon && (
          <div style={{ width: 32, height: 32, background: 'var(--ink-3)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: s.color, border: '1px solid var(--line)' }}>
            <Icon name={data.icon} size={16} />
          </div>
        )}
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 14, color: 'var(--bone)', lineHeight: 1.4 }}>{data.body}</div>
          {data.sub && (
            <div className="font-mono" style={{ fontSize: 10, color: 'var(--mute)', marginTop: 4, letterSpacing: '0.04em' }}>{data.sub}</div>
          )}
          {data.cta && (
            <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
              <button
                style={{
                  background: 'var(--acid)', color: 'var(--ink)', border: 'none',
                  padding: '7px 12px', fontFamily: 'var(--font-mono)',
                  fontSize: 10, letterSpacing: '0.12em', textTransform: 'uppercase', fontWeight: 700,
                }}
              >
                {data.cta}
              </button>
              {data.cta2 && (
                <button
                  style={{
                    background: 'transparent', color: 'var(--soft)', border: '1px solid var(--line-2)',
                    padding: '7px 12px', fontFamily: 'var(--font-mono)',
                    fontSize: 10, letterSpacing: '0.12em', textTransform: 'uppercase',
                  }}
                >
                  {data.cta2}
                </button>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

function GroupLabel({ label }: { label: string }) {
  return (
    <div style={{ padding: '12px 18px 6px', display: 'flex', alignItems: 'center', gap: 10 }}>
      <span className="font-mono" style={{ fontSize: 9, color: 'var(--acid)', letterSpacing: '0.18em' }}>— {label}</span>
      <div style={{ flex: 1, height: 1, background: 'var(--line)' }} />
    </div>
  )
}

export function NotifScreen() {
  return (
    <div className="no-scroll" style={{ height: '100dvh', overflowY: 'auto', paddingBottom: 72 }}>
      <div style={{ padding: '54px 18px 16px', borderBottom: '1px solid var(--line)', display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>pings</div>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.1em' }}>MARCAR LEÍDOS</span>
      </div>
      <div style={{ padding: '10px 18px', display: 'flex', gap: 8, borderBottom: '1px solid var(--line)' }}>
        <Tag kind="acid">todo</Tag>
        <Tag kind="ghost">amigos</Tag>
        <Tag kind="ghost">recomendados</Tag>
      </div>

      <GroupLabel label="AHORA" />
      <NotifItem data={{
        kind: 'friend-joined', tag: 'JULE SE ANOTÓ', time: 'AHORA', unread: true,
        avatar: { name: 'Jule', color: '#D4FF1A' },
        body: <>jule se anotó en <strong>SUB00</strong>. ya son 3 amigos tuyos en esa joda.</>,
        sub: 'NICETO · 23:30 · 78% LLENO',
        cta: 'ANOTARME', cta2: 'VER',
      }} />
      <NotifItem data={{
        kind: 'urgent', tag: 'CASI LLENO', time: '2 MIN', unread: true,
        icon: 'fire',
        body: <>la joda en <strong>casa pelícano</strong> tiene 12 lugares y 4 amigos tuyos van.</>,
        sub: 'CHACARITA · CIERRA EN 47 MIN',
        cta: 'SOLICITAR',
      }} />
      <NotifItem data={{
        kind: 'live', tag: 'EN EL VENUE', time: '4 MIN', unread: true,
        avatar: { name: 'Tomi', color: '#00FF88' },
        body: <>tomi llegó a SUB00. te está esperando.</>,
      }} />

      <GroupLabel label="HOY" />
      <NotifItem data={{
        kind: 'recommend', tag: 'PARA VOS', time: '1 H',
        icon: 'spark',
        body: <>fuiste a 4 jodas en niceto. <em style={{ fontFamily: 'var(--font-editorial)' }}>kernel</em> empieza ahí esta noche y matías va.</>,
        sub: 'BASADO EN TU HISTORIAL · 92% MATCH',
        cta: 'VER',
      }} />
      <NotifItem data={{
        kind: 'friend-joined', tag: 'CAMI + NACO ANOTADOS', time: '3 H',
        avatar: { name: 'Cami', color: '#7B61FF' },
        body: <>2 amigos tuyos se anotaron en <strong>humedal</strong>.</>,
        sub: 'GALPÓN SIN NOMBRE · SÁB 23:30',
      }} />
      <NotifItem data={{
        kind: 'system', tag: 'INVITACIÓN', time: '6 H',
        avatar: { name: 'Vico', color: '#FF2E2E' },
        body: <>vico te invitó a su fiesta privada el sábado.</>,
        cta: 'ACEPTAR', cta2: 'IGNORAR',
      }} />
      <NotifItem data={{
        kind: 'recommend', tag: 'NUEVA EN TU ZONA', time: '8 H',
        icon: 'pin',
        body: <>una sublabel nueva — <strong>kernel</strong> — abrió en crobar a 1.2 km de tu casa.</>,
      }} />

      <div style={{ padding: 24, textAlign: 'center' }}>
        <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(silencio.)</span>
      </div>
    </div>
  )
}
