'use client'

import { useState } from 'react'
import { ApiError, checkInToEvent } from '@/lib/api'
import { Icon } from '@/components/ui/icon'

type Status = 'idle' | 'loading' | 'success' | 'error'

export function CheckInCTA({ eventId, venueId }: { eventId: string; venueId: string }) {
  const [status, setStatus] = useState<Status>('idle')
  const [message, setMessage] = useState<string | null>(null)

  const onCheckIn = async () => {
    if (status === 'loading' || status === 'success') return
    setStatus('loading')
    setMessage(null)
    try {
      await checkInToEvent({ userId: 'demo-user', eventId, venueId })
      setStatus('success')
      setMessage('anotado. te esperamos.')
    } catch (err) {
      if (err instanceof ApiError && err.status === 404) {
        setMessage('endpoint de check-in aún no disponible.')
      } else {
        setMessage('no pudimos registrar el check-in.')
      }
      setStatus('error')
    }
  }

  const label = status === 'loading' ? 'ANOTANDO...' : status === 'success' ? 'ANOTADO' : 'ANOTARME'

  return (
    <div style={{ flex: 1 }}>
      <button
        className="cache-action"
        onClick={onCheckIn}
        disabled={status === 'loading' || status === 'success'}
        style={{
          width: '100%',
          background: status === 'success' ? 'var(--pulse)' : 'var(--acid)',
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
          opacity: status === 'loading' ? 0.75 : 1,
        }}
      >
        {label} <Icon name="arrow" size={14} stroke={2.4} />
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
