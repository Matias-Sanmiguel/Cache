'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useAuth } from '@/lib/auth-context'
import { getVenueById, type Venue } from '@/lib/api'
import { Icon } from '@/components/ui/icon'

export function MyVenueScreen() {
  const { user } = useAuth()
  const venueId = user?.venueId ?? null
  const [venue, setVenue] = useState<Venue | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let alive = true
    if (!venueId) { setLoading(false); return }
    getVenueById(venueId)
      .then((v) => { if (alive) setVenue(v) })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [venueId])

  return (
    <div className="cache-screen" style={{ minHeight: '100dvh', paddingBottom: 88 }}>
      <div style={{ padding: '54px 18px 16px', borderBottom: '1px solid var(--line)' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>mi venue</div>
      </div>

      {loading ? (
        <div className="font-mono" style={{ padding: 18, color: 'var(--mute)', fontSize: 10 }}>cargando...</div>
      ) : !venueId ? (
        <div className="font-mono" style={{ padding: 18, color: 'var(--mute)', fontSize: 11 }}>
          no tenés un venue asignado a tu cuenta.
        </div>
      ) : !venue ? (
        <div className="font-mono" style={{ padding: 18, color: 'var(--mute)', fontSize: 11 }}>
          no encontramos el venue ({venueId}).
        </div>
      ) : (
        <div style={{ padding: 18, display: 'flex', flexDirection: 'column', gap: 14 }}>
          <Row label="nombre" value={venue.name} />
          <Row label="dirección" value={venue.address ?? '—'} />
          <Row label="ciudad" value={venue.city ?? '—'} />
          <Row label="capacidad" value={String(venue.capacity)} />
          <Row label="tags" value={venue.tags.length ? venue.tags.join(' · ') : '—'} />

          <Link href="/dashboard" className="cache-action" style={{
            marginTop: 8, background: 'var(--acid)', color: 'var(--ink)', textDecoration: 'none',
            padding: 14, fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.14em',
            textTransform: 'uppercase', fontWeight: 700, display: 'flex', alignItems: 'center',
            justifyContent: 'center', gap: 8,
          }}>
            VER ANALYTICS <Icon name="arrow" size={14} stroke={2.4} />
          </Link>
        </div>
      )}
    </div>
  )
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 4, borderBottom: '1px solid var(--line)', paddingBottom: 12 }}>
      <span className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.12em', textTransform: 'uppercase' }}>{label}</span>
      <span className="font-display" style={{ fontSize: 16, color: 'var(--bone)' }}>{value}</span>
    </div>
  )
}
