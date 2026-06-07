'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { cancelEventAttendance, getCheckInStatus } from '@/lib/api'
import { useAuth } from '@/lib/auth-context'
import { Icon } from '@/components/ui/icon'

const ATTENDING_STORAGE_KEY = 'cache:attending-events'

type Props = {
  eventId: string
  compact?: boolean
  asLink?: boolean
}

export function EventCTALink({ eventId, compact = false, asLink = true }: Props) {
  const { token } = useAuth()
  const [isAttending, setIsAttending] = useState(false)
  const [busy, setBusy] = useState(false)

  useEffect(() => {
    if (isStoredAsAttending(eventId)) {
      setIsAttending(true)
    }

    if (!token) return
    let cancelled = false
    getCheckInStatus(eventId, token)
      .then((value) => {
        if (cancelled) return
        if (value) {
          storeAttending(eventId)
          setIsAttending(true)
        }
      })
      .catch(() => {})

    return () => {
      cancelled = true
    }
  }, [eventId, token])

  const label = isAttending ? 'ANOTADO' : 'ANOTARME'

  const style = {
    fontSize: compact ? 10 : 11,
    color: 'var(--ink)',
    letterSpacing: compact ? '0.12em' : '0.14em',
    textDecoration: 'none',
    background: isAttending ? 'var(--pulse)' : 'var(--acid)',
    padding: compact ? '7px 12px' : '12px 16px',
    fontWeight: 700,
    display: 'inline-flex',
    alignItems: 'center',
    gap: 8,
    textTransform: 'uppercase' as const,
  }

  const content = (
    <>
      {label} {!compact && <Icon name={isAttending ? 'check' : 'arrow'} size={14} stroke={2} />}
    </>
  )

  const cancelButton = isAttending && token ? (
    <button
      type="button"
      className="font-mono cache-action"
      disabled={busy}
      onClick={(event) => {
        event.preventDefault()
        event.stopPropagation()
        setBusy(true)
        cancelEventAttendance(eventId, token)
          .then(() => {
            removeStoredAttending(eventId)
            setIsAttending(false)
          })
          .finally(() => setBusy(false))
      }}
      style={{
        fontSize: compact ? 10 : 11,
        color: 'var(--bone)',
        letterSpacing: compact ? '0.12em' : '0.14em',
        background: 'transparent',
        border: '1px solid var(--line-2)',
        padding: compact ? '7px 12px' : '12px 16px',
        fontWeight: 700,
        textTransform: 'uppercase',
        opacity: busy ? 0.65 : 1,
      }}
    >
      {busy ? '...' : 'ME BAJO'}
    </button>
  ) : null

  if (!asLink) {
    return (
      <span style={{ display: 'inline-flex', gap: 8, alignItems: 'center' }}>
        <span className="font-mono cache-action" style={style}>
          {content}
        </span>
        {cancelButton}
      </span>
    )
  }

  return (
    <span style={{ display: 'inline-flex', gap: 8, alignItems: 'center' }}>
      <Link href={`/evento/${eventId}`} className="font-mono cache-action" style={style}>
        {content}
      </Link>
      {cancelButton}
    </span>
  )
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
  } catch {}
}

function removeStoredAttending(eventId: string) {
  try {
    const raw = window.localStorage.getItem(ATTENDING_STORAGE_KEY)
    const ids = new Set<string>(raw ? JSON.parse(raw) : [])
    ids.delete(eventId)
    window.localStorage.setItem(ATTENDING_STORAGE_KEY, JSON.stringify(Array.from(ids)))
  } catch {}
}
