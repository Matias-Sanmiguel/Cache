'use client'

import { useEffect, useState, type CSSProperties } from 'react'
import Link from 'next/link'
import { useAuth } from '@/lib/auth-context'
import { getVenueById, createVenue, apiMe, apiErrorMessage, type Venue } from '@/lib/api'
import { Icon } from '@/components/ui/icon'

export function MyVenueScreen() {
  const { user, token, setUser } = useAuth()
  const venueId = user?.venueId ?? null
  const [venue, setVenue] = useState<Venue | null>(null)
  const [loading, setLoading] = useState(true)

  // form de alta (cuando no hay venue asignado)
  const [form, setForm] = useState({ name: '', address: '', city: user?.city ?? 'buenos aires', capacity: '' })
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let alive = true
    if (!venueId) { setVenue(null); setLoading(false); return }
    setLoading(true)
    getVenueById(venueId)
      .then((v) => { if (alive) setVenue(v) })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [venueId])

  async function onCreate() {
    if (!token) return
    if (!form.name.trim() || !form.city.trim()) {
      setError('Completá al menos el nombre y la ciudad.')
      return
    }
    setSaving(true)
    setError(null)
    try {
      await createVenue({
        name: form.name.trim(),
        address: form.address.trim() || undefined,
        city: form.city.trim(),
        capacity: Number(form.capacity) || 0,
      }, token)
      // refrescamos el usuario para traer el venueId recién asignado → muestra el venue
      setUser(await apiMe(token))
    } catch (err) {
      setError(apiErrorMessage(err).message ?? 'no se pudo crear el venue.')
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="cache-screen" style={{ minHeight: '100dvh', paddingBottom: 88 }}>
      <div style={{ padding: '54px 18px 16px', borderBottom: '1px solid var(--line)' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>mi venue</div>
        <div className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', marginTop: 6, lineHeight: 1.5 }}>
          tu venue es el local que administrás. los eventos que crees quedan asociados a él
          y sus métricas (asistencia, presencia, tendencias) aparecen en tu dashboard.
        </div>
      </div>

      {error && <div className="font-mono" style={{ color: 'var(--blood)', fontSize: 10, padding: '10px 18px' }}>{error}</div>}

      {loading ? (
        <div className="font-mono" style={{ padding: 18, color: 'var(--mute)', fontSize: 10 }}>cargando...</div>
      ) : !venueId ? (
        // sin venue → form de alta (#7)
        <div style={{ padding: 18, display: 'flex', flexDirection: 'column', gap: 12 }}>
          <div className="font-mono" style={{ fontSize: 11, color: 'var(--mute)', letterSpacing: '0.08em' }}>
            todavía no tenés un venue. creá el tuyo para empezar a cargar eventos.
          </div>
          <Field label="nombre" value={form.name} onChange={(v) => setForm({ ...form, name: v })} />
          <Field label="dirección" value={form.address} onChange={(v) => setForm({ ...form, address: v })} />
          <Field label="ciudad" value={form.city} onChange={(v) => setForm({ ...form, city: v })} />
          <Field label="capacidad" type="number" value={form.capacity} onChange={(v) => setForm({ ...form, capacity: v })} />
          <button onClick={onCreate} disabled={saving} className="cache-action" style={{
            background: 'var(--acid)', color: 'var(--ink)', border: 'none', padding: 14,
            fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.14em', textTransform: 'uppercase',
            fontWeight: 700, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            opacity: saving ? 0.7 : 1,
          }}>
            {saving ? 'CREANDO...' : 'CREAR MI VENUE'} <Icon name="plus" size={14} stroke={2.4} />
          </button>
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

function Field({ label, value, onChange, type = 'text' }: {
  label: string; value: string; onChange: (v: string) => void; type?: string
}) {
  const style: CSSProperties = {
    background: 'var(--ink)', border: '1px solid var(--line)', color: 'var(--bone)',
    padding: '10px 12px', fontSize: 12, outline: 'none', width: '100%',
  }
  return (
    <label style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
      <span className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.1em', textTransform: 'uppercase' }}>{label}</span>
      <input type={type} value={value} onChange={(e) => onChange(e.target.value)} className="font-mono" style={style} />
    </label>
  )
}
