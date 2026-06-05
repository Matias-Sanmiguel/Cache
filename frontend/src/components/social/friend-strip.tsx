'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useAuth } from '@/lib/auth-context'
import { getFriends, type Friend } from '@/lib/api'
import { Avatar } from '@/components/ui/avatar'

// franja "tu red" del feed — amigos reales (neo4j) del user autenticado.
// sin sesión muestra un CTA al login; nunca datos hardcodeados.
export function FriendStrip() {
  const { token } = useAuth()
  const [friends, setFriends] = useState<Friend[]>([])
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    if (!token) {
      setFriends([])
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

  return (
    <div className="cache-card" style={{ position: 'relative', padding: '14px 16px', borderBottom: '1px solid var(--line)', background: 'var(--ink-2)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 12 }}>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.16em' }}>
          ◉ TU RED {token && loaded && `· ${friends.length}`}
        </span>
        <Link href="/perfil" className="font-mono cache-action" style={{ fontSize: 10, color: 'var(--soft)', textDecoration: 'none' }}>VER TODOS</Link>
      </div>

      {!token ? (
        <Link href="/login" className="font-editorial-italic cache-action" style={{ fontSize: 14, color: 'var(--soft)', textDecoration: 'none' }}>
          (iniciá sesión para ver tu red →)
        </Link>
      ) : !loaded ? (
        <span className="font-mono" style={{ fontSize: 11, color: 'var(--mute)' }}>cargando…</span>
      ) : friends.length === 0 ? (
        <span className="font-editorial-italic" style={{ fontSize: 14, color: 'var(--mute)' }}>(todavía no tenés amigos en tu red.)</span>
      ) : (
        <div className="no-scroll" style={{ display: 'flex', gap: 14, overflowX: 'auto' }}>
          {friends.map((p) => (
            <Link href="/perfil" key={p.userId} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, minWidth: 56, textDecoration: 'none' }}>
              <Avatar name={p.displayName} size={44} color={p.avatarColor} online />
              <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>{p.displayName.toLowerCase()}</span>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
