'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { ROLE_LABEL, apiUpdateProfile, type Role } from '@/lib/api'
import { Avatar } from '@/components/ui/avatar'
import { FriendsPanel } from '@/components/social/friends-panel'
import { CheckinHistory } from '@/components/screens/checkin-history'

const ROLE_COLOR: Record<Role, string> = {
  VISITOR: 'var(--bone)',
  VENUE_OWNER: 'var(--acid)',
  ADMIN: 'var(--blood)',
}

const PALETTE = ['#FF2E2E', '#D4FF1A', '#E8E6DF', '#7B61FF', '#00FF88', '#FF8A00']

function fmtSince(iso: string): string {
  const d = new Date(iso)
  const M = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic']
  return `${M[d.getUTCMonth()]} ${d.getUTCFullYear()}`
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '13px 0', borderBottom: '1px solid var(--line)' }}>
      <span className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.14em', textTransform: 'uppercase' }}>{label}</span>
      <span style={{ fontSize: 14, color: 'var(--bone)' }}>{value}</span>
    </div>
  )
}

export function ProfileScreen() {
  const router = useRouter()
  const { user, token, loading, logout, setUser } = useAuth()

  const [editing, setEditing] = useState(false)
  const [displayName, setDisplayName] = useState('')
  const [city, setCity] = useState('')
  const [avatarColor, setAvatarColor] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)

  // sin sesión → al login
  useEffect(() => {
    if (!loading && !user) router.replace('/login')
  }, [loading, user, router])

  useEffect(() => {
    if (user) {
      setDisplayName(user.displayName)
      setCity(user.city ?? '')
      setAvatarColor(user.avatarColor)
    }
  }, [user])

  if (loading || !user) {
    return (
      <div style={{ minHeight: '100dvh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <span className="font-editorial-italic" style={{ color: 'var(--mute)', fontSize: 18 }}>cargando…</span>
      </div>
    )
  }

  async function onSave() {
    if (!token) {
      setError('tu sesión expiró. volvé a iniciar sesión.')
      return
    }
    setBusy(true)
    setError(null)
    try {
      const updated = await apiUpdateProfile(token, { displayName, city, avatarColor })
      setUser(updated)
      setEditing(false)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'no se pudo guardar')
    } finally {
      setBusy(false)
    }
  }

  return (
    <div className="no-scroll" style={{ minHeight: '100dvh', overflowY: 'auto', paddingBottom: 96 }}>
      {/* header */}
      <div style={{ padding: '56px 24px 24px', borderBottom: '1px solid var(--line)' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
          <Avatar name={user.displayName} color={avatarColor} size={64} />
          <div style={{ flex: 1 }}>
            <h1 className="font-display" style={{ fontSize: 26, color: 'var(--bone)', lineHeight: 1 }}>
              {user.displayName}
            </h1>
            <div className="font-mono" style={{ fontSize: 12, color: 'var(--soft)', marginTop: 4 }}>
              @{user.handle}
            </div>
          </div>
        </div>

        {/* badge de rol — el backend puede no devolver role; default VISITOR */}
        {(() => {
          const role: Role = user.role ?? 'VISITOR'
          return (
            <div style={{ marginTop: 18, display: 'inline-flex', alignItems: 'center', gap: 7, border: `1px solid ${ROLE_COLOR[role]}`, padding: '5px 11px' }}>
              <span style={{ width: 7, height: 7, borderRadius: '50%', background: ROLE_COLOR[role] }} />
              <span className="font-mono" style={{ fontSize: 10, color: ROLE_COLOR[role], letterSpacing: '0.14em', textTransform: 'uppercase' }}>
                {ROLE_LABEL[role]}
              </span>
            </div>
          )
        })()}
      </div>

      {/* editor inline */}
      {editing ? (
        <div style={{ padding: '20px 24px' }}>
          <label className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.16em', textTransform: 'uppercase', display: 'block', marginBottom: 6 }}>nombre</label>
          <input value={displayName} onChange={(e) => setDisplayName(e.target.value)}
            style={{ width: '100%', background: 'var(--ink-2)', border: '1px solid var(--line)', color: 'var(--bone)', padding: '12px 14px', fontSize: 15, outline: 'none', marginBottom: 16 }} />

          <label className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.16em', textTransform: 'uppercase', display: 'block', marginBottom: 6 }}>ciudad</label>
          <input value={city} onChange={(e) => setCity(e.target.value)}
            style={{ width: '100%', background: 'var(--ink-2)', border: '1px solid var(--line)', color: 'var(--bone)', padding: '12px 14px', fontSize: 15, outline: 'none', marginBottom: 16 }} />

          <label className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.16em', textTransform: 'uppercase', display: 'block', marginBottom: 8 }}>color de avatar</label>
          <div style={{ display: 'flex', gap: 10, marginBottom: 22 }}>
            {PALETTE.map((c) => (
              <button key={c} type="button" onClick={() => setAvatarColor(c)}
                style={{ width: 30, height: 30, borderRadius: '50%', background: c, border: avatarColor === c ? '2px solid var(--bone)' : '2px solid transparent' }} />
            ))}
          </div>

          {error && <div className="font-mono" style={{ fontSize: 11, color: 'var(--blood)', marginBottom: 14 }}>! {error}</div>}

          <div style={{ display: 'flex', gap: 10 }}>
            <button onClick={onSave} disabled={busy}
              style={{ flex: 1, background: 'var(--acid)', color: 'var(--ink)', border: 'none', padding: '13px', fontFamily: 'var(--font-mono)', fontSize: 11, fontWeight: 700, letterSpacing: '0.12em', textTransform: 'uppercase', opacity: busy ? 0.7 : 1 }}>
              {busy ? 'guardando…' : 'guardar'}
            </button>
            <button onClick={() => { setEditing(false); setError(null) }}
              style={{ flex: 1, background: 'transparent', color: 'var(--soft)', border: '1px solid var(--line-2)', padding: '13px', fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.12em', textTransform: 'uppercase' }}>
              cancelar
            </button>
          </div>
        </div>
      ) : (
        <div style={{ padding: '8px 24px' }}>
          <Row label="email" value={user.email ?? '—'} />
          <Row label="ciudad" value={user.city || '—'} />
          {user.role === 'VENUE_OWNER' && <Row label="venue" value={user.venueId || 'sin asignar'} />}
          <Row label="miembro desde" value={user.createdAt ? fmtSince(user.createdAt) : '—'} />

          <button onClick={() => setEditing(true)}
            style={{ width: '100%', marginTop: 20, background: 'var(--ink-3)', color: 'var(--bone)', border: '1px solid var(--line-2)', padding: '13px', fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.12em', textTransform: 'uppercase' }}>
            editar perfil
          </button>
        </div>
      )}

      {/* red social real (neo4j): amigos, solicitudes y sugerencias — solo VISITOR.
          los merchants (VENUE_OWNER/ADMIN) no tienen funcionalidades sociales */}
      {!editing && (user.role ?? 'VISITOR') === 'VISITOR' && <FriendsPanel />}

      {/* historial de check-ins (cassandra) — solo el visitante se anota a eventos */}
      {!editing && (user.role ?? 'VISITOR') === 'VISITOR' && <CheckinHistory />}

      {/* sección segun rol — accesos directos a la administración del merchant */}
      {(user.role === 'ADMIN' || user.role === 'VENUE_OWNER') && (
        <div style={{ padding: '24px' }}>
          <div className="font-mono" style={{ fontSize: 9, color: 'var(--acid)', letterSpacing: '0.18em', marginBottom: 12 }}>— GESTIÓN</div>
          <div style={{ display: 'grid', gap: 8 }}>
            {[
              { href: '/dashboard', label: 'dashboard · métricas y analytics' },
              { href: '/mis-eventos', label: 'mis eventos · crear y editar' },
              { href: '/mi-venue', label: 'mi venue' },
            ].map((item) => (
              <Link key={item.href} href={item.href} className="cache-action" style={{
                padding: '14px', border: '1px solid var(--line)', background: 'var(--ink-2)',
                fontSize: 13, color: 'var(--soft)', textDecoration: 'none', display: 'flex',
                alignItems: 'center', justifyContent: 'space-between', gap: 8,
              }}>
                {item.label} <span style={{ color: 'var(--acid)' }}>→</span>
              </Link>
            ))}
          </div>
        </div>
      )}

      {/* logout */}
      <div style={{ padding: '8px 24px 24px' }}>
        <button onClick={async () => { await logout(); router.replace('/login') }}
          style={{ width: '100%', background: 'transparent', color: 'var(--blood)', border: '1px solid var(--blood)', padding: '13px', fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.12em', textTransform: 'uppercase' }}>
          cerrar sesión
        </button>
      </div>
    </div>
  )
}
