'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { Tag } from '@/components/ui/tag'
import { Avatar } from '@/components/ui/avatar'
import { Icon } from '@/components/ui/icon'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { useAuth } from '@/lib/auth-context'
import { useNotifications } from '@/lib/notification-context'
import {
  getNotifications,
  markNotificationsRead,
  markNotificationRead,
  acceptFriendRequest,
  rejectFriendRequest,
  type Notification,
} from '@/lib/api'

type NotifKind = 'friend-joined' | 'live' | 'urgent' | 'recommend' | 'system'

const KIND_STYLES: Record<NotifKind, { color: string; label: string }> = {
  'friend-joined': { color: 'var(--acid)',  label: '◉' },
  'live':          { color: 'var(--pulse)', label: '●' },
  'urgent':        { color: 'var(--blood)', label: '!' },
  'recommend':     { color: 'var(--bone)',  label: '~' },
  'system':        { color: 'var(--soft)',  label: '/' },
}

type NotifData = Notification

function NotifItem({
  data,
  onPrimary,
  onSecondary,
}: {
  data: NotifData
  onPrimary: (n: NotifData) => void
  onSecondary: (n: NotifData) => void
}) {
  const s = KIND_STYLES[data.kind]
  return (
    <div
      className="cache-card"
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
                className="cache-action"
                onClick={() => onPrimary(data)}
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
                  className="cache-action"
                  onClick={() => onSecondary(data)}
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

type Filter = 'todo' | 'amigos' | 'recomendados'

// qué kinds entran en cada tab
const FILTER_KINDS: Record<Filter, NotifKind[] | null> = {
  todo: null,
  amigos: ['friend-joined', 'live'],
  recomendados: ['recommend', 'urgent'],
}

// id del backend: "live-<eventId>" / "rec-<eventId>" → eventId para navegar al detalle
function eventIdOf(notifId: string): string | null {
  if (notifId.startsWith('live-')) return notifId.slice(5)
  if (notifId.startsWith('rec-')) return notifId.slice(4)
  return null
}

export function NotifScreen() {
  const router = useRouter()
  const { user, token, loading } = useAuth()
  const { resetUnread, subscribeToNewPings } = useNotifications()
  const [data, setData] = useState<Notification[]>([])
  const [filter, setFilter] = useState<Filter>('todo')
  const [error, setError] = useState<string | undefined>()
  const [isFallback, setIsFallback] = useState(false)

  // ping de solicitud de amistad: accionable (aceptar/rechazar) — trae el userId
  // del solicitante en refId y la cta "ACEPTAR"
  const isFriendRequest = (n: Notification) =>
    n.kind === 'friend-joined' && n.cta === 'ACEPTAR' && !!n.refId

  // marca leído optimista en UI; persiste en backend si es un ping persistido (id "{epoch}:{uuid}")
  const markRead = (id: string) => {
    setData((prev) => prev.map((n) => (n.id === id ? { ...n, unread: false } : n)))
    if (token && id.includes(':')) markNotificationRead(id, token).catch(() => {})
  }

  const removePing = (id: string) => setData((prev) => prev.filter((n) => n.id !== id))

  const markAllRead = () => {
    setData((prev) => prev.map((n) => ({ ...n, unread: false })))
    if (token) markNotificationsRead(token).catch(() => {})
  }

  // CTA primaria:
  //  - solicitud de amistad → ACEPTAR (neo4j) y saca el ping
  //  - ping de evento (refId/id) → abre el detalle
  //  - resto → marca leído
  const onPrimary = (n: Notification) => {
    if (isFriendRequest(n)) {
      if (token && n.refId) acceptFriendRequest(n.refId, token).catch(() => {})
      removePing(n.id)
      return
    }
    // CTA "VER MAPA" (pings de zona caliente) → mapa
    if (n.cta?.toUpperCase().includes('MAPA')) {
      router.push('/mapa')
      return
    }
    // ping que refiere a un evento (VER / ANOTARME) → detalle, donde se anota
    const eid = n.refId ?? eventIdOf(n.id)
    if (eid) {
      router.push(`/evento/${eid}`)
      return
    }
    // sin evento referido (ej. pings mock offline): llevamos al feed para anotarse
    if (n.cta?.toUpperCase().includes('ANOTAR') || n.cta?.toUpperCase() === 'VER') {
      router.push('/')
      return
    }
    markRead(n.id)
  }

  // CTA secundaria:
  //  - solicitud de amistad → RECHAZAR y saca el ping
  //  - resto → descarta marcándolo leído
  const onSecondary = (n: Notification) => {
    if (isFriendRequest(n)) {
      if (token && n.refId) rejectFriendRequest(n.refId, token).catch(() => {})
      removePing(n.id)
      return
    }
    markRead(n.id)
  }

  // al entrar a la pantalla, marcar todo como leído en el badge global
  useEffect(() => {
    resetUnread()
  }, [resetUnread])

  useEffect(() => {
    if (loading) return
    // sin sesión no hay a quién consultar → mostramos mock (fallback)
    if (!user || !token) {
      getNotifications().then((r) => {
        setData(r.data)
        setError(r.error)
        setIsFallback(true)
      })
      return
    }
    let alive = true
    getNotifications(token).then((r) => {
      if (!alive) return
      setData(r.data)
      setError(r.error)
      setIsFallback(Boolean(r.isFallback))
    })
    return () => {
      alive = false
    }
  }, [user, token, loading])

  // realtime: consume los pings del contexto global (SSE ya activo desde layout)
  useEffect(() => {
    if (!user) return
    return subscribeToNewPings((notif) => {
      setData((prev) => (prev.some((n) => n.id === notif.id) ? prev : [notif, ...prev]))
    })
  }, [user, subscribeToNewPings])

  const kinds = FILTER_KINDS[filter]
  const visible = kinds ? data.filter((n) => kinds.includes(n.kind)) : data
  const groups = groupNotifs(visible)
  const unreadCount = data.filter((n) => n.unread).length

  return (
    <div className="cache-screen" style={{ minHeight: '100dvh', paddingBottom: 88 }}>
      {isFallback && (
        <PlaceholderBadge mode="banner" label="PINGS — DATA MOCK" note={user ? 'BACKEND OFFLINE' : 'INICIÁ SESIÓN'} style={{ position: 'sticky', top: 0, zIndex: 60 }} />
      )}
      <div style={{ padding: '54px 18px 16px', borderBottom: '1px solid var(--line)', display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>pings</div>
        <button
          type="button"
          onClick={markAllRead}
          disabled={unreadCount === 0}
          className="font-mono cache-action"
          style={{
            background: 'none', border: 'none', padding: 0,
            fontSize: 10, color: unreadCount === 0 ? 'var(--mute)' : 'var(--soft)',
            letterSpacing: '0.1em', textTransform: 'uppercase',
          }}
        >
          MARCAR LEÍDOS{unreadCount > 0 ? ` (${unreadCount})` : ''}
        </button>
      </div>
      <div style={{ padding: '10px 18px', display: 'flex', gap: 8, borderBottom: '1px solid var(--line)' }}>
        {(['todo', 'amigos', 'recomendados'] as Filter[]).map((f) => (
          <button key={f} type="button" onClick={() => setFilter(f)} style={{ background: 'none', border: 'none', padding: 0 }}>
            <Tag kind={filter === f ? 'acid' : 'ghost'}>{f}</Tag>
          </button>
        ))}
      </div>

      {error && user && (
        <div style={{ padding: '12px 18px', borderBottom: '1px solid var(--line)' }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--blood)', letterSpacing: '0.12em' }}>BACKEND OFFLINE</div>
          <div style={{ fontSize: 12, color: 'var(--mute)', marginTop: 4 }}>{error}</div>
        </div>
      )}

      {groups.length === 0 ? (
        <div style={{ padding: 24, textAlign: 'center' }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(sin notificaciones.)</span>
        </div>
      ) : (
        groups.map((group) => (
          <div key={group.label}>
            <GroupLabel label={group.label} />
            {group.items.map((item) => (
              <NotifItem key={item.id} data={item} onPrimary={onPrimary} onSecondary={onSecondary} />
            ))}
          </div>
        ))
      )}

      {groups.length > 0 && (
        <div style={{ padding: 24, textAlign: 'center' }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(silencio.)</span>
        </div>
      )}
    </div>
  )
}

function groupNotifs(items: Notification[]) {
  const groups: { label: string; items: Notification[] }[] = []
  for (const notif of items) {
    const label = notif.group ?? 'HOY'
    const existing = groups.find((g) => g.label === label)
    if (existing) {
      existing.items.push(notif)
    } else {
      groups.push({ label, items: [notif] })
    }
  }
  return groups
}
