'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { useAuth } from '@/lib/auth-context'
import { ROLE_LABEL, type Role } from '@/lib/api'

const ROLES: Role[] = ['VISITOR', 'VENUE_OWNER', 'ADMIN']

const ROLE_DESC: Record<Role, string> = {
  VISITOR: 'me anoto a jodas y sigo amigos',
  VENUE_OWNER: 'administro un local y sus eventos',
  ADMIN: 'equipo caché — acceso total',
}

const labelStyle: React.CSSProperties = {
  fontFamily: 'var(--font-mono)',
  fontSize: 9,
  color: 'var(--soft)',
  letterSpacing: '0.16em',
  textTransform: 'uppercase',
  display: 'block',
  marginBottom: 6,
}

const inputStyle: React.CSSProperties = {
  width: '100%',
  background: 'var(--ink-2)',
  border: '1px solid var(--line)',
  color: 'var(--bone)',
  padding: '12px 14px',
  fontSize: 15,
  fontFamily: 'var(--font-body)',
  outline: 'none',
}

function Field({
  label,
  children,
}: {
  label: string
  children: React.ReactNode
}) {
  return (
    <div style={{ marginBottom: 16 }}>
      <label style={labelStyle}>{label}</label>
      {children}
    </div>
  )
}

export function AuthScreen({ mode }: { mode: 'login' | 'register' }) {
  const router = useRouter()
  const { login, register } = useAuth()
  const isLogin = mode === 'login'

  const [identifier, setIdentifier] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [displayName, setDisplayName] = useState('')
  const [handle, setHandle] = useState('')
  const [city, setCity] = useState('')
  const [role, setRole] = useState<Role>('VISITOR')
  const [venueId, setVenueId] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setBusy(true)
    try {
      const u = isLogin
        ? await login(identifier, password)
        : await register({
            email,
            password,
            displayName,
            handle,
            city: city || undefined,
            role,
            venueId: role === 'VENUE_OWNER' ? venueId || undefined : undefined,
          })
      // separar la experiencia desde el arranque: el merchant entra a su dashboard,
      // el visitante al feed. (en registro caemos al rol elegido si el backend no lo devuelve)
      const effectiveRole = u.role ?? (isLogin ? 'VISITOR' : role)
      const home = effectiveRole === 'VENUE_OWNER' || effectiveRole === 'ADMIN' ? '/dashboard' : '/'
      router.push(home)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'algo falló')
    } finally {
      setBusy(false)
    }
  }

  return (
    <div
      className="no-scroll"
      style={{ minHeight: '100dvh', overflowY: 'auto', padding: '0 0 40px' }}
    >
      {/* header editorial */}
      <div style={{ padding: '64px 24px 28px' }}>
        <div className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.2em', marginBottom: 14 }}>
          ◉ CACHÉ
        </div>
        <h1 className="font-display" style={{ fontSize: 40, color: 'var(--bone)', lineHeight: 0.9 }}>
          {isLogin ? 'entrar' : 'crear cuenta'}
        </h1>
        <p className="font-editorial-italic" style={{ fontSize: 17, color: 'var(--mute)', marginTop: 10 }}>
          {isLogin ? 'la noche te estaba esperando.' : 'sumate a la vida nocturna.'}
        </p>
      </div>

      <form onSubmit={onSubmit} style={{ padding: '0 24px' }}>
        {isLogin ? (
          <Field label="email o @handle">
            <input
              style={inputStyle}
              value={identifier}
              onChange={(e) => setIdentifier(e.target.value)}
              placeholder="vos@mail.com"
              autoCapitalize="none"
              required
            />
          </Field>
        ) : (
          <>
            <Field label="nombre">
              <input
                style={inputStyle}
                value={displayName}
                onChange={(e) => setDisplayName(e.target.value)}
                placeholder="cómo te ven tus amigos"
                required
              />
            </Field>
            <Field label="@handle">
              <input
                style={inputStyle}
                value={handle}
                onChange={(e) => setHandle(e.target.value.replace(/\s/g, ''))}
                placeholder="tunombre"
                autoCapitalize="none"
                required
              />
            </Field>
            <Field label="email">
              <input
                style={inputStyle}
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="vos@mail.com"
                autoCapitalize="none"
                required
              />
            </Field>
            <Field label="ciudad">
              <input
                style={inputStyle}
                value={city}
                onChange={(e) => setCity(e.target.value)}
                placeholder="buenos aires"
              />
            </Field>
          </>
        )}

        <Field label="contraseña">
          <input
            style={inputStyle}
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder={isLogin ? '••••••' : 'mínimo 6 caracteres'}
            required
          />
        </Field>

        {/* selección de rol — solo en registro */}
        {!isLogin && (
          <div style={{ marginBottom: 16 }}>
            <label style={labelStyle}>tipo de cuenta</label>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {ROLES.map((r) => {
                const active = role === r
                return (
                  <button
                    type="button"
                    key={r}
                    onClick={() => setRole(r)}
                    style={{
                      textAlign: 'left',
                      background: active ? 'var(--ink-4)' : 'var(--ink-2)',
                      border: `1px solid ${active ? 'var(--acid)' : 'var(--line)'}`,
                      padding: '12px 14px',
                      display: 'flex',
                      flexDirection: 'column',
                      gap: 3,
                    }}
                  >
                    <span style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      <span
                        style={{
                          width: 9,
                          height: 9,
                          borderRadius: '50%',
                          background: active ? 'var(--acid)' : 'transparent',
                          border: `1.5px solid ${active ? 'var(--acid)' : 'var(--line-2)'}`,
                        }}
                      />
                      <span style={{ fontSize: 14, color: 'var(--bone)', fontWeight: 600 }}>
                        {ROLE_LABEL[r]}
                      </span>
                    </span>
                    <span className="font-mono" style={{ fontSize: 10, color: 'var(--mute)', letterSpacing: '0.04em', paddingLeft: 17 }}>
                      {ROLE_DESC[r]}
                    </span>
                  </button>
                )
              })}
            </div>
          </div>
        )}

        {!isLogin && role === 'VENUE_OWNER' && (
          <Field label="venue id (opcional)">
            <input
              style={inputStyle}
              value={venueId}
              onChange={(e) => setVenueId(e.target.value)}
              placeholder="id del local que administrás"
              autoCapitalize="none"
            />
          </Field>
        )}

        {error && (
          <div
            className="font-mono"
            style={{
              fontSize: 11,
              color: 'var(--blood)',
              border: '1px solid var(--blood)',
              padding: '10px 12px',
              marginBottom: 16,
              letterSpacing: '0.04em',
            }}
          >
            ! {error}
          </div>
        )}

        <button
          type="submit"
          disabled={busy}
          style={{
            width: '100%',
            background: busy ? 'var(--acid-deep)' : 'var(--acid)',
            color: 'var(--ink)',
            border: 'none',
            padding: '15px',
            fontFamily: 'var(--font-mono)',
            fontSize: 12,
            fontWeight: 700,
            letterSpacing: '0.14em',
            textTransform: 'uppercase',
            opacity: busy ? 0.7 : 1,
          }}
        >
          {busy ? 'procesando…' : isLogin ? 'entrar' : 'crear cuenta'}
        </button>

        <div style={{ textAlign: 'center', marginTop: 22 }}>
          <span className="font-mono" style={{ fontSize: 11, color: 'var(--mute)', letterSpacing: '0.04em' }}>
            {isLogin ? 'no tenés cuenta? ' : 'ya tenés cuenta? '}
            <Link href={isLogin ? '/register' : '/login'} style={{ color: 'var(--acid)' }}>
              {isLogin ? 'registrate' : 'entrá'}
            </Link>
          </span>
        </div>
      </form>
    </div>
  )
}
