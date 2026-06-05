'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useAuth } from '@/lib/auth-context'
import { getFriends, type Friend } from '@/lib/api'
import { Avatar } from '@/components/ui/avatar'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'

// amigos de muestra cuando no hay sesión (deslogueado)
const MOCK_PEOPLE: Friend[] = [
  { userId: 'm1', displayName: 'Mati', handle: 'mati', avatarColor: '#FF2E2E' },
  { userId: 'm2', displayName: 'Jule', handle: 'jule', avatarColor: '#D4FF1A' },
  { userId: 'm3', displayName: 'Cami', handle: 'cami', avatarColor: '#7B61FF' },
  { userId: 'm4', displayName: 'Tomi', handle: 'tomi', avatarColor: '#00FF88' },
]

export function FriendStrip() {
  const { token } = useAuth()
  const [friends, setFriends] = useState<Friend[]>([])
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    if (!token) {
      setLoaded(false)
      return
    }
    let alive = true
    getFriends(token).then((f) => {
      if (alive) {
        setFriends(f)
        setLoaded(true)
      }
    })
    return () => {
      alive = false
    }
  }, [token])

  const real = loaded && token
  const people = real ? friends : MOCK_PEOPLE

  return (
    <div className="cache-card" style={{ position: 'relative', padding: '14px 16px', borderBottom: '1px solid var(--line)', background: 'var(--ink-2)' }}>
      {!real && <PlaceholderBadge note="LOGIN P/ VER REALES" />}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 12 }}>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.16em' }}>
          ◉ TU RED {real && `· ${friends.length}`}
        </span>
        <Link href="/perfil" className="font-mono cache-action" style={{ fontSize: 10, color: 'var(--soft)', textDecoration: 'none' }}>VER TODOS</Link>
      </div>

      {real && people.length === 0 ? (
        <span className="font-editorial-italic" style={{ fontSize: 14, color: 'var(--mute)' }}>(todavía no tenés amigos en tu red.)</span>
      ) : (
        <div className="no-scroll" style={{ display: 'flex', gap: 14, overflowX: 'auto' }}>
          {people.map((p) => (
            <div key={p.userId} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, minWidth: 56 }}>
              <Avatar name={p.displayName} size={44} color={p.avatarColor} online={!real} />
              <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>{p.displayName.toLowerCase()}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
