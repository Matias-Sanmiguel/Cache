'use client'

import { useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { Icon } from '@/components/ui/icon'

// acciones del header del feed: búsqueda (por género, pega al feed con ?genre=)
// y campana → pings. antes eran íconos muertos.
export function FeedActions() {
  const router = useRouter()
  const [open, setOpen] = useState(false)
  const [q, setQ] = useState('')

  const submit = () => {
    const v = q.trim().toLowerCase()
    setOpen(false)
    if (v) router.push(`/?genre=${encodeURIComponent(v)}`)
  }

  return (
    <div style={{ display: 'flex', gap: 14, alignItems: 'center', color: 'var(--bone)' }}>
      {open ? (
        <input
          autoFocus
          value={q}
          onChange={(e) => setQ(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') submit()
            if (e.key === 'Escape') setOpen(false)
          }}
          onBlur={submit}
          placeholder="buscar género…"
          className="font-mono cache-input"
          style={{
            background: 'var(--ink-2)', border: '1px solid var(--line-2)', color: 'var(--bone)',
            padding: '6px 10px', fontSize: 12, outline: 'none', width: 150,
          }}
        />
      ) : (
        <button
          type="button"
          aria-label="buscar"
          onClick={() => setOpen(true)}
          style={{ background: 'none', border: 'none', color: 'var(--bone)', display: 'flex', padding: 0 }}
        >
          <Icon name="search" size={20} />
        </button>
      )}
      <Link href="/pings" aria-label="pings" style={{ position: 'relative', color: 'var(--bone)', display: 'flex' }}>
        <Icon name="bell" size={20} />
        <span style={{ position: 'absolute', top: -2, right: -2, width: 7, height: 7, borderRadius: '50%', background: 'var(--acid)' }} />
      </Link>
    </div>
  )
}
