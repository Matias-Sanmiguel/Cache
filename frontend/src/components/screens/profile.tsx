'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import {
  ROLE_LABEL,
  apiUpdateProfile,
  getCheckinHistory,
  createEvent,
  type Role,
  type CheckinHistoryEntry,
} from '@/lib/api'
import { Avatar } from '@/components/ui/avatar'
import { FriendsPanel } from '@/components/social/friends-panel'

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

  // historial de check-ins
  const [history, setHistory] = useState<CheckinHistoryEntry[]>([])

  // formulario crear evento (VENUE_OWNER)
  const [showCreateEvent, setShowCreateEvent] = useState(false)
  const [evName, setEvName] = useState('')
  const [evVenueName, setEvVenueName] = useState('')
  const [evAddress, setEvAddress] = useState('')
  const [evCity, setEvCity] = useState('')
  const [evStartsAt, setEvStartsAt] = useState('')
  const [evEndsAt, setEvEndsAt] = useState('')
  const [evGenres, setEvGenres] = useState('')
  const [evPrice, setEvPrice] = useState('0')
  const [evCapacity, setEvCapacity] = useState('100')
  const [evDescription, setEvDescription] = useState('')
  const [evBusy, setEvBusy] = useState(false)
  const [evError, setEvError] = useState<string | null>(null)
  const [evSuccess, setEvSuccess] = useState<string | null>(null)

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

  useEffect(() => {
    if (!token) return
    getCheckinHistory(token, 10).then(setHistory)
  }, [token])

  async function onCreateEvent() {
    if (!token) return
    setEvBusy(true)
    setEvError(null)
    setEvSuccess(null)
    try {
      const ev = await createEvent({
        name: evName,
        venueName: evVenueName,
        venueAddress: evAddress,
        city: evCity,
        startsAt: new Date(evStartsAt).toISOString(),
        endsAt: new Date(evEndsAt).toISOString(),
        genres: evGenres.split(',').map((g) => g.trim()).filter(Boolean),
        price: parseFloat(evPrice) || 0,
        capacity: parseInt(evCapacity) || 100,
        description: evDescription,
        accessType: 'public',
      }, token)
      setEvSuccess(`evento "${ev.name}" creado.`)
      setEvName(''); setEvVenueName(''); setEvAddress(''); setEvCity('')
      setEvStartsAt(''); setEvEndsAt(''); setEvGenres(''); setEvDescription('')
      setEvPrice('0'); setEvCapacity('100')
      setShowCreateEvent(false)
    } catch (err) {
      setEvError(err instanceof Error ? err.message : 'no se pudo crear el evento')
    } finally {
      setEvBusy(false)
    }
  }

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

      {/* red social real (neo4j): amigos, solicitudes y sugerencias */}
      {!editing && <FriendsPanel />}

      {/* historial de check-ins */}
      {history.length > 0 && !editing && (
        <div style={{ padding: '0 24px 24px' }}>
          <div className="font-mono" style={{ fontSize: 9, color: 'var(--acid)', letterSpacing: '0.18em', marginBottom: 10 }}>— TU HISTORIAL</div>
          {history.map((h, i) => (
            <div key={i} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '10px 0', borderBottom: '1px solid var(--line)' }}>
              <div>
                <div style={{ fontSize: 13, color: 'var(--bone)' }}>{h.venueName}</div>
                {h.genre && <div className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', marginTop: 2, letterSpacing: '0.08em' }}>{h.genre.toUpperCase()}</div>}
              </div>
              <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>
                {new Date(h.checkedAt).toLocaleDateString('es-AR', { day: '2-digit', month: 'short' })}
              </span>
            </div>
          ))}
        </div>
      )}

      {/* panel merchant — crear eventos (VENUE_OWNER) */}
      {user.role === 'VENUE_OWNER' && !editing && (
        <div style={{ padding: '0 24px 24px' }}>
          <div className="font-mono" style={{ fontSize: 9, color: 'var(--acid)', letterSpacing: '0.18em', marginBottom: 10 }}>— TU LOCAL</div>

          {evSuccess && (
            <div className="font-mono" style={{ fontSize: 11, color: 'var(--acid)', marginBottom: 14, padding: '10px', border: '1px solid var(--acid)' }}>
              ✓ {evSuccess}
            </div>
          )}

          {!showCreateEvent ? (
            <button
              onClick={() => setShowCreateEvent(true)}
              style={{ width: '100%', background: 'var(--acid)', color: 'var(--ink)', border: 'none', padding: '13px', fontFamily: 'var(--font-mono)', fontSize: 11, fontWeight: 700, letterSpacing: '0.12em', textTransform: 'uppercase' }}
            >
              + crear evento
            </button>
          ) : (
            <div>
              {(
                [
                  { label: 'nombre del evento', value: evName, set: setEvName, type: 'text' },
                  { label: 'nombre del local', value: evVenueName, set: setEvVenueName, type: 'text' },
                  { label: 'dirección', value: evAddress, set: setEvAddress, type: 'text' },
                  { label: 'ciudad', value: evCity, set: setEvCity, type: 'text' },
                  { label: 'inicia (fecha y hora)', value: evStartsAt, set: setEvStartsAt, type: 'datetime-local' },
                  { label: 'termina (fecha y hora)', value: evEndsAt, set: setEvEndsAt, type: 'datetime-local' },
                  { label: 'géneros (separados por coma)', value: evGenres, set: setEvGenres, type: 'text' },
                  { label: 'precio ($)', value: evPrice, set: setEvPrice, type: 'number' },
                  { label: 'capacidad', value: evCapacity, set: setEvCapacity, type: 'number' },
                ] as const
              ).map(({ label, value, set, type }) => (
                <div key={label}>
                  <label className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.14em', textTransform: 'uppercase', display: 'block', marginBottom: 4, marginTop: 14 }}>{label}</label>
                  <input
                    type={type}
                    value={value}
                    onChange={(e) => (set as (v: string) => void)(e.target.value)}
                    style={{ width: '100%', background: 'var(--ink-2)', border: '1px solid var(--line)', color: 'var(--bone)', padding: '10px 12px', fontSize: 13, outline: 'none', boxSizing: 'border-box' }}
                  />
                </div>
              ))}

              <label className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.14em', textTransform: 'uppercase', display: 'block', marginBottom: 4, marginTop: 14 }}>descripción</label>
              <textarea
                value={evDescription}
                onChange={(e) => setEvDescription(e.target.value)}
                rows={3}
                style={{ width: '100%', background: 'var(--ink-2)', border: '1px solid var(--line)', color: 'var(--bone)', padding: '10px 12px', fontSize: 13, outline: 'none', resize: 'vertical', boxSizing: 'border-box' }}
              />

              {evError && <div className="font-mono" style={{ fontSize: 11, color: 'var(--blood)', marginTop: 10 }}>! {evError}</div>}

              <div style={{ display: 'flex', gap: 10, marginTop: 18 }}>
                <button onClick={onCreateEvent} disabled={evBusy}
                  style={{ flex: 1, background: 'var(--acid)', color: 'var(--ink)', border: 'none', padding: '13px', fontFamily: 'var(--font-mono)', fontSize: 11, fontWeight: 700, letterSpacing: '0.12em', textTransform: 'uppercase', opacity: evBusy ? 0.7 : 1 }}>
                  {evBusy ? 'creando…' : 'crear evento'}
                </button>
                <button onClick={() => { setShowCreateEvent(false); setEvError(null) }}
                  style={{ flex: 1, background: 'transparent', color: 'var(--soft)', border: '1px solid var(--line-2)', padding: '13px', fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.12em', textTransform: 'uppercase' }}>
                  cancelar
                </button>
              </div>
            </div>
          )}
        </div>
      )}

      {/* admin: link al dashboard */}
      {user.role === 'ADMIN' && !editing && (
        <div style={{ padding: '0 24px 24px' }}>
          <div className="font-mono" style={{ fontSize: 9, color: 'var(--acid)', letterSpacing: '0.18em', marginBottom: 10 }}>— ADMIN</div>
          <a href="/dashboard" style={{ display: 'block', padding: '13px', border: '1px solid var(--acid)', color: 'var(--acid)', fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.12em', textTransform: 'uppercase', textDecoration: 'none', textAlign: 'center' }}>
            ver dashboard de métricas →
          </a>
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
