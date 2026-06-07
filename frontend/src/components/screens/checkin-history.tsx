'use client'

import { useEffect, useState } from 'react'
import { useAuth } from '@/lib/auth-context'
import { getCheckinHistory, fmtDate, fmtTime, type CheckinHistoryItem } from '@/lib/api'
import { Tag } from '@/components/ui/tag'

// historial de check-ins del visitante (cassandra vía /api/checkin/history).
// sin sesión no renderiza nada; vacío muestra un placeholder honesto.
export function CheckinHistory({ limit = 20 }: { limit?: number }) {
  const { token } = useAuth()
  const [items, setItems] = useState<CheckinHistoryItem[]>([])
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    if (!token) {
      setItems([])
      setLoaded(true)
      return
    }
    let alive = true
    getCheckinHistory(token, limit).then((rows) => {
      if (alive) {
        setItems(rows)
        setLoaded(true)
      }
    })
    return () => {
      alive = false
    }
  }, [token, limit])

  if (!token) return null

  return (
    <div style={{ padding: '24px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 12 }}>
        <span className="font-mono" style={{ fontSize: 9, color: 'var(--acid)', letterSpacing: '0.18em' }}>— HISTORIAL DE CHECK-INS</span>
        {loaded && items.length > 0 && (
          <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>{items.length}</span>
        )}
      </div>

      {!loaded ? (
        <span className="font-mono" style={{ fontSize: 11, color: 'var(--mute)' }}>cargando…</span>
      ) : items.length === 0 ? (
        <span className="font-editorial-italic" style={{ fontSize: 14, color: 'var(--mute)' }}>
          (todavía no te anotaste a ningún evento.)
        </span>
      ) : (
        <div style={{ display: 'grid', gap: 8 }}>
          {items.map((it, i) => (
            <div
              key={`${it.checkedAt}-${it.eventId ?? i}`}
              style={{ border: '1px solid var(--line)', background: 'var(--ink-2)', padding: '12px 14px' }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 10 }}>
                <span className="font-display" style={{ fontSize: 17, color: 'var(--bone)' }}>
                  {it.venueName ?? 'venue'}
                </span>
                <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.1em', whiteSpace: 'nowrap' }}>
                  {fmtDate(it.checkedAt)} · {fmtTime(it.checkedAt)}
                </span>
              </div>
              <div style={{ display: 'flex', gap: 6, marginTop: 8, flexWrap: 'wrap', alignItems: 'center' }}>
                {it.genre && <Tag kind="ghost">{it.genre}</Tag>}
                {it.city && (
                  <span className="font-mono" style={{ fontSize: 10, color: 'var(--mute)', letterSpacing: '0.08em' }}>
                    {it.city.toUpperCase()}
                  </span>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
