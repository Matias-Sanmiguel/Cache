'use client'

import { useCallback, useEffect, useState } from 'react'
import { useAuth } from '@/lib/auth-context'
import {
  getFriends,
  getPendingRequests,
  getSentRequests,
  getPeopleYouMayKnow,
  searchUsers,
  sendFriendRequest,
  acceptFriendRequest,
  rejectFriendRequest,
  cancelFriendRequest,
  removeFriend,
  type Friend,
  type FriendSuggestion,
} from '@/lib/api'
import { Avatar } from '@/components/ui/avatar'

// panel real de red social (neo4j). reemplaza la lista hardcodeada de amigos:
// amigos confirmados (deshacer), solicitudes pendientes (aceptar/rechazar) y
// sugerencias "quizás conozcas" (enviar solicitud). todo contra el backend.

const SECTION_LABEL: React.CSSProperties = {
  fontSize: 9,
  color: 'var(--acid)',
  letterSpacing: '0.18em',
  textTransform: 'uppercase',
}

function PersonRow({
  friend,
  sub,
  children,
}: {
  friend: Friend
  sub?: string
  children?: React.ReactNode
}) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '11px 0', borderBottom: '1px solid var(--line)' }}>
      <Avatar name={friend.displayName} color={friend.avatarColor} size={38} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14, color: 'var(--bone)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
          {friend.displayName}
        </div>
        <div className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', marginTop: 2 }}>
          @{friend.handle}{sub ? ` · ${sub}` : ''}
        </div>
      </div>
      <div style={{ display: 'flex', gap: 6, flexShrink: 0 }}>{children}</div>
    </div>
  )
}

const BTN_BASE: React.CSSProperties = {
  fontFamily: 'var(--font-mono)',
  fontSize: 9,
  letterSpacing: '0.1em',
  textTransform: 'uppercase',
  padding: '7px 10px',
  border: '1px solid var(--line-2)',
  background: 'transparent',
  color: 'var(--soft)',
  cursor: 'pointer',
}

function ActionButton({
  label,
  onClick,
  variant = 'ghost',
  busy,
}: {
  label: string
  onClick: () => void
  variant?: 'ghost' | 'acid' | 'blood'
  busy?: boolean
}) {
  const style: React.CSSProperties = { ...BTN_BASE, opacity: busy ? 0.5 : 1 }
  if (variant === 'acid') {
    style.background = 'var(--acid)'
    style.color = 'var(--ink)'
    style.border = 'none'
    style.fontWeight = 700
  } else if (variant === 'blood') {
    style.color = 'var(--blood)'
    style.borderColor = 'var(--blood)'
  }
  return (
    <button type="button" onClick={onClick} disabled={busy} style={style}>
      {label}
    </button>
  )
}

export function FriendsPanel() {
  const { token } = useAuth()
  const [friends, setFriends] = useState<Friend[]>([])
  const [requests, setRequests] = useState<Friend[]>([])
  const [sent, setSent] = useState<Friend[]>([])
  const [suggestions, setSuggestions] = useState<FriendSuggestion[]>([])
  const [loaded, setLoaded] = useState(false)
  const [pending, setPending] = useState<Set<string>>(new Set())
  const [query, setQuery] = useState('')
  const [results, setResults] = useState<Friend[]>([])
  const [searching, setSearching] = useState(false)

  const load = useCallback(async () => {
    if (!token) return
    const [f, r, sent, s] = await Promise.all([
      getFriends(token),
      getPendingRequests(token),
      getSentRequests(token),
      getPeopleYouMayKnow(token),
    ])
    setFriends(f)
    setRequests(r)
    setSent(sent)
    setSuggestions(s)
    setLoaded(true)
  }, [token])

  useEffect(() => {
    load()
  }, [load])

  // búsqueda con debounce (mín. 2 caracteres)
  useEffect(() => {
    if (!token) return
    const q = query.trim()
    if (q.length < 2) {
      setResults([])
      setSearching(false)
      return
    }
    setSearching(true)
    const t = setTimeout(() => {
      searchUsers(q, token).then((r) => {
        setResults(r)
        setSearching(false)
      })
    }, 300)
    return () => clearTimeout(t)
  }, [query, token])

  // marca un userId como "en proceso" para deshabilitar sus botones durante el fetch
  const withPending = useCallback(
    async (id: string, action: () => Promise<void>) => {
      setPending((prev) => new Set(prev).add(id))
      try {
        await action()
        await load()
      } catch {
        // el backend ya valida (ya-amigos, etc.); en error solo refrescamos
        await load()
      } finally {
        setPending((prev) => {
          const next = new Set(prev)
          next.delete(id)
          return next
        })
      }
    },
    [load],
  )

  if (!token) return null

  const isBusy = (id: string) => pending.has(id)

  // no mostrar en resultados a quienes ya son amigos / con solicitud pendiente
  const known = new Set([...friends, ...sent, ...requests].map((u) => u.userId))
  const visibleResults = results.filter((u) => !known.has(u.userId))

  return (
    <div style={{ padding: '24px' }}>
      {/* buscador para agregar amigos por @handle o nombre */}
      <section style={{ marginBottom: 28 }}>
        <div className="font-mono" style={{ ...SECTION_LABEL, marginBottom: 8 }}>— AGREGAR AMIGOS</div>
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="buscar por @handle o nombre…"
          className="font-mono"
          style={{ width: '100%', background: 'var(--ink-2)', border: '1px solid var(--line-2)', color: 'var(--bone)', padding: '10px 12px', fontSize: 13, outline: 'none' }}
        />
        {query.trim().length >= 2 && (
          searching ? (
            <div className="font-mono" style={{ fontSize: 11, color: 'var(--mute)', padding: '11px 0' }}>buscando…</div>
          ) : visibleResults.length === 0 ? (
            <div className="font-editorial-italic" style={{ fontSize: 14, color: 'var(--mute)', padding: '11px 0' }}>(sin resultados.)</div>
          ) : (
            visibleResults.map((u) => (
              <PersonRow key={u.userId} friend={u}>
                <ActionButton label="+ agregar" busy={isBusy(u.userId)}
                  onClick={() => withPending(u.userId, () => sendFriendRequest(u.userId, token))} />
              </PersonRow>
            ))
          )
        )}
      </section>

      {/* solicitudes pendientes — primero, son accionables */}
      {requests.length > 0 && (
        <section style={{ marginBottom: 28 }}>
          <div className="font-mono" style={{ ...SECTION_LABEL, marginBottom: 6 }}>
            — SOLICITUDES · {requests.length}
          </div>
          {requests.map((r) => (
            <PersonRow key={r.userId} friend={r} sub="te quiere agregar">
              <ActionButton label="aceptar" variant="acid" busy={isBusy(r.userId)}
                onClick={() => withPending(r.userId, () => acceptFriendRequest(r.userId, token))} />
              <ActionButton label="✕" busy={isBusy(r.userId)}
                onClick={() => withPending(r.userId, () => rejectFriendRequest(r.userId, token))} />
            </PersonRow>
          ))}
        </section>
      )}

      {/* solicitudes enviadas pendientes */}
      {sent.length > 0 && (
        <section style={{ marginBottom: 28 }}>
          <div className="font-mono" style={{ ...SECTION_LABEL, marginBottom: 6 }}>
            — ENVIADAS · {sent.length}
          </div>
          {sent.map((s) => (
            <PersonRow key={s.userId} friend={s} sub="pendiente">
              <ActionButton label="cancelar" variant="blood" busy={isBusy(s.userId)}
                onClick={() => withPending(s.userId, () => cancelFriendRequest(s.userId, token!))} />
            </PersonRow>
          ))}
        </section>
      )}

      {/* amigos confirmados */}
      <section style={{ marginBottom: 28 }}>
        <div className="font-mono" style={{ ...SECTION_LABEL, marginBottom: 6 }}>
          — TU RED · {friends.length}
        </div>
        {!loaded ? (
          <div className="font-mono" style={{ fontSize: 11, color: 'var(--mute)', padding: '11px 0' }}>cargando…</div>
        ) : friends.length === 0 ? (
          <div className="font-editorial-italic" style={{ fontSize: 14, color: 'var(--mute)', padding: '11px 0' }}>
            (todavía no tenés amigos en tu red.)
          </div>
        ) : (
          friends.map((f) => (
            <PersonRow key={f.userId} friend={f}>
              <ActionButton label="quitar" variant="blood" busy={isBusy(f.userId)}
                onClick={() => withPending(f.userId, () => removeFriend(f.userId, token))} />
            </PersonRow>
          ))
        )}
      </section>

      {/* sugerencias (amigos de amigos) */}
      {suggestions.length > 0 && (
        <section>
          <div className="font-mono" style={{ ...SECTION_LABEL, marginBottom: 6 }}>
            — QUIZÁS CONOZCAS
          </div>
          {suggestions.map(({ user, mutualFriends }) => (
            <PersonRow
              key={user.userId}
              friend={user}
              sub={mutualFriends > 0 ? `${mutualFriends} en común` : undefined}
            >
              <ActionButton label="+ agregar" busy={isBusy(user.userId)}
                onClick={() => withPending(user.userId, () => sendFriendRequest(user.userId, token))} />
            </PersonRow>
          ))}
        </section>
      )}
    </div>
  )
}
