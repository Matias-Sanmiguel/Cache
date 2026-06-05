'use client'

import type { CSSProperties, FormEvent, ReactNode } from 'react'
import { useEffect, useMemo, useState } from 'react'
import Link from 'next/link'
import { Avatar } from '@/components/ui/avatar'
import { Icon } from '@/components/ui/icon'
import { Tag } from '@/components/ui/tag'

type Session = {
  email: string
  displayName: string
  city: string
  handle: string
  createdAt: string
}

const STORAGE_KEY = 'cache:user-session'
const CITIES = ['Buenos Aires', 'Córdoba', 'Rosario', 'Mendoza']

function makeHandle(email: string, displayName: string) {
  const source = displayName.trim() || email.split('@')[0] || 'user'
  return source
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '')
    .slice(0, 18)
}

function isEmail(value: string) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)
}

function Field({
  label,
  children,
}: {
  label: string
  children: ReactNode
}) {
  return (
    <label className="font-mono" style={{ display: 'grid', gap: 7, fontSize: 10, color: 'var(--soft)', letterSpacing: '0.12em' }}>
      {label}
      {children}
    </label>
  )
}

export function LoginScreen() {
  const [session, setSession] = useState<Session | null>(null)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [displayName, setDisplayName] = useState('')
  const [city, setCity] = useState('Buenos Aires')
  const [remember, setRemember] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    const raw = window.localStorage.getItem(STORAGE_KEY)
    if (!raw) return
    try {
      setSession(JSON.parse(raw) as Session)
    } catch {
      window.localStorage.removeItem(STORAGE_KEY)
    }
  }, [])

  const handle = useMemo(() => makeHandle(email, displayName), [email, displayName])

  const submit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setError(null)

    if (!isEmail(email)) {
      setError('Ingresá un email válido.')
      return
    }

    if (password.length < 6) {
      setError('La contraseña tiene que tener al menos 6 caracteres.')
      return
    }

    if (!city.trim()) {
      setError('Elegí tu ciudad.')
      return
    }

    setLoading(true)
    window.setTimeout(() => {
      const nextSession: Session = {
        email: email.trim().toLowerCase(),
        displayName: displayName.trim() || email.split('@')[0],
        city: city.trim(),
        handle,
        createdAt: new Date().toISOString(),
      }

      if (remember) {
        window.localStorage.setItem(STORAGE_KEY, JSON.stringify(nextSession))
      }

      setSession(nextSession)
      setPassword('')
      setLoading(false)
    }, 420)
  }

  const logout = () => {
    window.localStorage.removeItem(STORAGE_KEY)
    setSession(null)
    setPassword('')
  }

  if (session) {
    return (
      <main className="no-scroll cache-screen" style={pageStyle}>
        <section style={heroStyle}>
          <div className="font-mono" style={eyebrowStyle}>PERFIL ACTIVO</div>
          <div style={{ display: 'flex', alignItems: 'flex-end', gap: 16, marginTop: 'auto' }}>
            <Avatar name={session.displayName} size={68} online />
            <div style={{ minWidth: 0 }}>
              <div className="font-display" style={{ fontSize: 44, color: 'var(--bone)', lineHeight: 0.9 }}>
                {session.displayName}<span style={{ color: 'var(--acid)' }}>.</span>
              </div>
              <div className="font-mono" style={{ fontSize: 11, color: 'var(--soft)', letterSpacing: '0.12em', marginTop: 8 }}>
                @{session.handle}
              </div>
            </div>
          </div>
        </section>

        <section style={{ padding: '18px 18px 96px', display: 'grid', gap: 14 }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            <div className="cache-card" style={metricStyle}>
              <span className="font-mono" style={metricLabelStyle}>CIUDAD</span>
              <strong style={metricValueStyle}>{session.city}</strong>
            </div>
            <div className="cache-card" style={metricStyle}>
              <span className="font-mono" style={metricLabelStyle}>ESTADO</span>
              <strong style={metricValueStyle}>online</strong>
            </div>
          </div>

          <div className="cache-card" style={panelStyle}>
            <div style={rowStyle}>
              <span className="font-mono" style={rowLabelStyle}>EMAIL</span>
              <span style={rowValueStyle}>{session.email}</span>
            </div>
            <div style={rowStyle}>
              <span className="font-mono" style={rowLabelStyle}>CUENTA</span>
              <Tag kind="acid">sesión local</Tag>
            </div>
            <div style={{ ...rowStyle, borderBottom: 'none', paddingBottom: 0 }}>
              <span className="font-mono" style={rowLabelStyle}>PREFERENCIAS</span>
              <span style={rowValueStyle}>pings · eventos · mapa</span>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr auto', gap: 8 }}>
            <Link className="font-mono cache-action" href="/" style={primaryActionStyle}>
              Ir al feed <Icon name="arrow" size={14} stroke={2.2} />
            </Link>
            <button className="font-mono cache-action" onClick={logout} style={secondaryActionStyle}>
              Salir
            </button>
          </div>
        </section>
      </main>
    )
  }

  return (
    <main className="no-scroll cache-screen" style={pageStyle}>
      <section style={heroStyle}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div className="font-mono" style={eyebrowStyle}>CACHE ID</div>
          <span style={{ width: 9, height: 9, borderRadius: '50%', background: 'var(--pulse)' }} className="cache-pulse" />
        </div>

        <div style={{ marginTop: 'auto' }}>
          <div className="font-display" style={{ fontSize: 54, color: 'var(--bone)', lineHeight: 0.86 }}>
            entrar<span style={{ color: 'var(--acid)' }}>.</span>
          </div>
          <p className="font-editorial-italic" style={{ fontSize: 20, color: 'var(--soft)', marginTop: 10, maxWidth: 360 }}>
            Guardá tu ciudad, pings y eventos favoritos para esta noche.
          </p>
        </div>
      </section>

      <section style={{ padding: '18px 18px 96px', background: 'var(--ink)' }}>
        <form onSubmit={submit} style={{ display: 'grid', gap: 14 }}>
          <Field label="EMAIL">
            <input
              className="cache-input"
              type="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              autoComplete="email"
              placeholder="tu@email.com"
              style={inputStyle}
            />
          </Field>

          <Field label="CONTRASEÑA">
            <input
              className="cache-input"
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              autoComplete="current-password"
              placeholder="mínimo 6 caracteres"
              style={inputStyle}
            />
          </Field>

          <Field label="NOMBRE VISIBLE">
            <input
              className="cache-input"
              value={displayName}
              onChange={(event) => setDisplayName(event.target.value)}
              autoComplete="name"
              placeholder="cómo querés aparecer"
              style={inputStyle}
            />
          </Field>

          <div style={{ display: 'grid', gap: 8 }}>
            <div className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.12em' }}>CIUDAD</div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
              {CITIES.map((option) => {
                const selected = city === option
                return (
                  <button
                    className="font-mono cache-action"
                    key={option}
                    type="button"
                    onClick={() => setCity(option)}
                    style={{
                      border: `1px solid ${selected ? 'var(--acid)' : 'var(--line-2)'}`,
                      background: selected ? 'var(--acid)' : 'var(--ink-2)',
                      color: selected ? 'var(--ink)' : 'var(--bone)',
                      padding: '12px 10px',
                      fontSize: 10,
                      letterSpacing: '0.1em',
                      textTransform: 'uppercase',
                    }}
                  >
                    {option}
                  </button>
                )
              })}
            </div>
            <input
              className="cache-input"
              value={city}
              onChange={(event) => setCity(event.target.value)}
              autoComplete="address-level2"
              placeholder="Otra ciudad"
              style={inputStyle}
            />
          </div>

          <label style={{ display: 'flex', alignItems: 'center', gap: 10, color: 'var(--soft)', fontSize: 12 }}>
            <input
              type="checkbox"
              checked={remember}
              onChange={(event) => setRemember(event.target.checked)}
              style={{ accentColor: 'var(--acid)' }}
            />
            Mantener sesión en este dispositivo
          </label>

          {error && (
            <div className="font-mono cache-card" style={{ color: 'var(--blood)', border: '1px solid var(--blood)', padding: 10, fontSize: 10, letterSpacing: '0.08em' }}>
              {error}
            </div>
          )}

          <button className="font-mono cache-action" disabled={loading} style={{ ...primaryActionStyle, width: '100%', border: 'none', opacity: loading ? 0.72 : 1 }}>
            {loading ? 'ENTRANDO...' : 'INICIAR SESIÓN'}
          </button>
        </form>
      </section>
    </main>
  )
}

const pageStyle: CSSProperties = {
  minHeight: '100dvh',
  background: 'var(--ink)',
}

const heroStyle: CSSProperties = {
  minHeight: '38dvh',
  padding: '54px 18px 22px',
  display: 'flex',
  flexDirection: 'column',
  borderBottom: '1px solid var(--line)',
  background:
    'linear-gradient(160deg, rgba(212,255,26,0.14), transparent 32%), repeating-linear-gradient(90deg, rgba(255,255,255,0.035) 0 1px, transparent 1px 46px), repeating-linear-gradient(0deg, rgba(255,255,255,0.03) 0 1px, transparent 1px 46px), var(--ink-2)',
}

const panelStyle: CSSProperties = {
  border: '1px solid var(--line)',
  background: 'var(--ink-2)',
  padding: 14,
}

const inputStyle: CSSProperties = {
  width: '100%',
  background: 'var(--ink-2)',
  color: 'var(--bone)',
  border: '1px solid var(--line-2)',
  padding: '14px 12px',
  font: 'inherit',
  fontSize: 14,
  letterSpacing: 0,
  outline: 'none',
}

const primaryActionStyle: CSSProperties = {
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  gap: 8,
  color: 'var(--ink)',
  background: 'var(--acid)',
  textDecoration: 'none',
  padding: '15px 14px',
  fontSize: 11,
  fontWeight: 700,
  letterSpacing: '0.15em',
  textTransform: 'uppercase',
}

const secondaryActionStyle: CSSProperties = {
  background: 'transparent',
  color: 'var(--soft)',
  border: '1px solid var(--line-2)',
  padding: '15px 14px',
  fontSize: 10,
  letterSpacing: '0.14em',
  textTransform: 'uppercase',
}

const eyebrowStyle: CSSProperties = {
  color: 'var(--acid)',
  fontSize: 10,
  letterSpacing: '0.18em',
}

const metricStyle: CSSProperties = {
  border: '1px solid var(--line)',
  background: 'var(--ink-2)',
  padding: 14,
  display: 'grid',
  gap: 8,
}

const metricLabelStyle: CSSProperties = {
  color: 'var(--mute)',
  fontSize: 9,
  letterSpacing: '0.14em',
}

const metricValueStyle: CSSProperties = {
  color: 'var(--bone)',
  fontSize: 18,
  fontWeight: 500,
}

const rowStyle: CSSProperties = {
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',
  gap: 12,
  borderBottom: '1px solid var(--line)',
  paddingBottom: 12,
  marginBottom: 12,
}

const rowLabelStyle: CSSProperties = {
  fontSize: 10,
  color: 'var(--mute)',
  letterSpacing: '0.12em',
}

const rowValueStyle: CSSProperties = {
  fontSize: 13,
  color: 'var(--bone)',
  textAlign: 'right',
  overflowWrap: 'anywhere',
}
