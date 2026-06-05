'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useAuth } from '@/lib/auth-context'
import { getFriends, type Friend } from '@/lib/api'
import { AvatarStack } from '@/components/ui/avatar'

// franja "tu red" del mapa — amigos reales (neo4j) del user autenticado.
// reemplaza la lista MOCK_PEOPLE hardcodeada. sin amigos/sesión no renderiza nada.
export function FriendsStack({ size = 20, max = 3 }: { size?: number; max?: number }) {
  const { token } = useAuth()
  const [friends, setFriends] = useState<Friend[]>([])

  useEffect(() => {
    if (!token) {
      setFriends([])
      return
    }
    let alive = true
    getFriends(token).then((f) => {
      if (alive) setFriends(f)
    })
    return () => {
      alive = false
    }
  }, [token])

  if (friends.length === 0) return null

  return (
    <Link href="/perfil" style={{ display: 'flex', alignItems: 'center', gap: 8, textDecoration: 'none' }}>
      <AvatarStack people={friends.map((f) => ({ name: f.displayName, color: f.avatarColor }))} size={size} max={max} />
      <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>tu red · {friends.length}</span>
    </Link>
  )
}
