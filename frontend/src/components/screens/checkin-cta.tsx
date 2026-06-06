'use client'

import { useState } from 'react'
import Link from 'next/link'
import { ApiError, checkInToEvent, checkOutFromVenue } from '@/lib/api'
import { useAuth } from '@/lib/auth-context'
import { Icon } from '@/components/ui/icon'

type Status = 'idle' | 'loading' | 'in' | 'error'

export function CheckInCTA({ eventId, venueId }: { eventId: string; venueId: string }) {
  const { token, user } = useAuth()
  const [status, setStatus] = useState<Status>('idle')
  const [message, setMessage] = useState<string | null>(null)

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
      await checkOutFromVenue(venueId, token)
      setStatus('idle')
      setMessage('saliste del venue.')
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
