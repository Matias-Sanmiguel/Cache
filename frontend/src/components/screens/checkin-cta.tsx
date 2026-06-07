'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { ApiError, checkInToEvent, checkOutFromEvent, getCheckInStatus } from '@/lib/api'
import { useAuth } from '@/lib/auth-context'
import { Icon } from '@/components/ui/icon'

type Status = 'idle' | 'loading' | 'in' | 'error'
const ATTENDING_STORAGE_KEY = 'cache:attending-events'

export function CheckInCTA({ eventId, initialIsIn = false }: { eventId: string; initialIsIn?: boolean }) {
  const router = useRouter()
  const { token, user } = useAuth()
  const [status, setStatus] = useState<Status>(initialIsIn ? 'in' : 'idle')
  const [message, setMessage] = useState<string | null>(null)

  useEffect(() => {
    if (!token) return
    if (isStoredAsAttending(eventId)) {
      setStatus('in')
    }

    let cancelled = false
    getCheckInStatus(eventId, token)
      .then((isAttending) => {
        if (cancelled) return
        if (isAttending) {
          storeAttending(eventId)
          setStatus('in')
        }
      })
      .catch(() => {
        // Si falla el check remoto, conservamos el estado local del click.
      })

    return () => {
      cancelled = true
    }
  }, [eventId, token])

  // el check-in es una acción de CLIENTE. los merchants (VENUE_OWNER/ADMIN) no se anotan.
  if (user?.role === 'VENUE_OWNER' || user?.role === 'ADMIN') {
    return null
  }

  const onCheckIn = async () => {
    if (!token) return
    setStatus('loading')
    setMessage(null)
    try {
      await checkInToEvent(eventId, token)
      storeAttending(eventId)
      setStatus('in')
      setMessage('anotado. te esperamos.')
    } catch (err) {
      setStatus('error')
      setMessage(authError(err) ?? 'no pudimos registrar el check-in.')
    }
  }

  const onCheckOut = async () => {
    if (!token) return
    setStatus('loading')
    setMessage(null)
    try {
      await checkOutFromEvent(eventId, token)
      if (window.history.length > 1) {
        router.back()
      } else {
        router.push('/')
      }
    } catch (err) {
      setStatus('in')
      setMessage(authError(err) ?? 'no pudimos registrar la salida.')
    }
  }

  // sin sesión: el check-in necesita JWT, mandamos a login
  if (!token) {
    return (
      <div style={{ flex: 1 }}>
        <Link
          href="/login"
          className="cache-action"
          style={{
            width: '100%', background: 'var(--acid)', color: 'var(--ink)', border: 'none', padding: 16,
            fontFamily: 'var(--font-mono)', fontSize: 12, letterSpacing: '0.16em', textTransform: 'uppercase',
            fontWeight: 700, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
            textDecoration: 'none',
          }}
        >
          INICIÁ SESIÓN PARA ANOTARTE <Icon name="arrow" size={14} stroke={2.4} />
        </Link>
      </div>
    )
  }

  const isIn = status === 'in'
  const loading = status === 'loading'
  const label = loading ? 'PROCESANDO...' : isIn ? 'ANOTADO — TOCÁ PARA SALIR' : 'ANOTARME'

  return (
    <div style={{ flex: 1 }}>
      <button
        className="cache-action"
        onClick={isIn ? onCheckOut : onCheckIn}
        disabled={loading}
        style={{
          width: '100%',
          background: isIn ? 'var(--pulse)' : 'var(--acid)',
          color: 'var(--ink)',
          border: 'none',
          padding: 16,
          fontFamily: 'var(--font-mono)',
          fontSize: 12,
          letterSpacing: '0.16em',
          textTransform: 'uppercase',
          fontWeight: 700,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 10,
          opacity: loading ? 0.75 : 1,
        }}
      >
        {label} <Icon name={isIn ? 'check' : 'arrow'} size={14} stroke={2.4} />
      </button>
      {message && (
        <div
          className="font-mono"
          style={{
            fontSize: 9,
            color: status === 'error' ? 'var(--blood)' : 'var(--pulse)',
            letterSpacing: '0.08em',
            textAlign: 'center',
            marginTop: 6,
          }}
        >
          {message}
        </div>
      )}
    </div>
  )
}

function authError(err: unknown): string | null {
  if (err instanceof ApiError && (err.status === 401 || err.status === 403)) {
    return 'tu sesión expiró. volvé a iniciar sesión.'
  }
  return null
}

function isStoredAsAttending(eventId: string): boolean {
  try {
    const raw = window.localStorage.getItem(ATTENDING_STORAGE_KEY)
    return raw ? JSON.parse(raw).includes(eventId) : false
  } catch {
    return false
  }
}

function storeAttending(eventId: string) {
  try {
    const raw = window.localStorage.getItem(ATTENDING_STORAGE_KEY)
    const ids = new Set<string>(raw ? JSON.parse(raw) : [])
    ids.add(eventId)
    window.localStorage.setItem(ATTENDING_STORAGE_KEY, JSON.stringify(Array.from(ids)))
  } catch {
    // localStorage puede estar bloqueado; el estado del backend sigue mandando.
  }
}
