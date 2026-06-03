import { Tag } from '@/components/ui/tag'
import { Avatar } from '@/components/ui/avatar'
import { Icon } from '@/components/ui/icon'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { getNotifications, type Notification } from '@/lib/api'

type NotifKind = 'friend-joined' | 'live' | 'urgent' | 'recommend' | 'system'

const KIND_STYLES: Record<NotifKind, { color: string; label: string }> = {
  'friend-joined': { color: 'var(--acid)',  label: '◉' },
  'live':          { color: 'var(--pulse)', label: '●' },
  'urgent':        { color: 'var(--blood)', label: '!' },
  'recommend':     { color: 'var(--bone)',  label: '~' },
  'system':        { color: 'var(--soft)',  label: '/' },
}

type NotifData = Notification

function NotifItem({ data }: { data: NotifData }) {
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

export async function NotifScreen() {
  const { data, error, isFallback } = await getNotifications('demo-user')
  const groups = groupNotifs(data)

  return (
    <div className="no-scroll cache-screen" style={{ height: '100dvh', overflowY: 'auto', paddingBottom: 72 }}>
      {isFallback && (
        <PlaceholderBadge mode="banner" label="PINGS — DATA MOCK" note="REDIS EN COLA" style={{ position: 'sticky', top: 0, zIndex: 60 }} />
      )}
      <div style={{ padding: '54px 18px 16px', borderBottom: '1px solid var(--line)', display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>pings</div>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.1em' }}>MARCAR LEÍDOS</span>
      </div>
      <div style={{ padding: '10px 18px', display: 'flex', gap: 8, borderBottom: '1px solid var(--line)' }}>
        <Tag kind="acid">todo</Tag>
        <Tag kind="ghost">amigos</Tag>
        <Tag kind="ghost">recomendados</Tag>
      </div>

      {error && (
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
              <NotifItem key={item.id} data={item} />
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
