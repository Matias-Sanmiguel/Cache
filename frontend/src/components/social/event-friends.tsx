'use client'

import { useEffect, useState } from 'react'
import { useAuth } from '@/lib/auth-context'
import { getFriendsAttending, type Friend } from '@/lib/api'
import { Avatar, AvatarStack } from '@/components/ui/avatar'
import { Tag } from '@/components/ui/tag'
import { Dot } from '@/components/ui/dot'

// amigos reales (neo4j) anotados a un evento. reemplaza las listas mock en
// el feed y el detalle del evento. sin sesión / sin amigos no rompe el layout.

function useFriendsAttending(eventId: string): { friends: Friend[]; loaded: boolean } {
  const { token } = useAuth()
  const [friends, setFriends] = useState<Friend[]>([])
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    if (!token) {
      setFriends([])
      setLoaded(true)
      return
    }
    let alive = true
    getFriendsAttending(eventId, token).then((f) => {
      if (alive) {
        setFriends(f)
        setLoaded(true)
      }
    })
    return () => {
      alive = false
    }
  }, [eventId, token])

  return { friends, loaded }
}

// stack compacto para las cards del feed. devuelve null si no hay amigos anotados,
// así la card cae a mostrar solo el conteo de anotados.
export function EventFriendsStack({
  eventId,
  size = 26,
  max = 5,
}: {
  eventId: string
  size?: number
  max?: number
}) {
  const { friends } = useFriendsAttending(eventId)
  if (friends.length === 0) return null
  return (
    <AvatarStack
      people={friends.map((f) => ({ name: f.displayName, color: f.avatarColor, online: true }))}
      size={size}
      max={max}
    />
  )
}

// lista detallada para la pantalla de evento. muestra amigos anotados con su estado.
export function EventFriendsList({ eventId }: { eventId: string }) {
  const { friends, loaded } = useFriendsAttending(eventId)

  return (
    <div style={{ padding: '20px 18px', borderBottom: '1px solid var(--line)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 14 }}>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em' }}>— TUS AMIGOS</span>
        {friends.length > 0 && (
          <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', display: 'flex', alignItems: 'center', gap: 5 }}>
            <Dot color="var(--pulse)" size={5} /> {friends.length} ANOTADOS
          </span>
        )}
      </div>

      {!loaded ? (
        <span className="font-mono" style={{ fontSize: 11, color: 'var(--mute)' }}>cargando…</span>
      ) : friends.length === 0 ? (
        <span className="font-editorial-italic" style={{ fontSize: 14, color: 'var(--mute)' }}>
          (ninguno de tus amigos se anotó todavía.)
        </span>
      ) : (
        friends.map((p, i) => (
          <div className="cache-card" key={p.userId} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '10px 0', borderBottom: i < friends.length - 1 ? '1px dashed var(--line)' : 'none' }}>
            <Avatar name={p.displayName} size={36} color={p.avatarColor} online />
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 14, color: 'var(--bone)' }}>{p.displayName.toLowerCase()}</div>
              <div className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.04em' }}>@{p.handle}</div>
            </div>
            <Tag kind="acid">ANOTADO</Tag>
          </div>
        ))
      )}
    </div>
  )
}
