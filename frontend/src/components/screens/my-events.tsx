'use client'

import { useCallback, useEffect, useState, type CSSProperties } from 'react'
import { useAuth } from '@/lib/auth-context'
import {
  getMyEvents,
  createEvent,
  updateEvent,
  apiErrorMessage,
  type CacheEvent,
  type EventInput,
} from '@/lib/api'
import { Icon } from '@/components/ui/icon'

type FormState = {
  id: string | null // null = crear, set = editar
  name: string
  venueName: string
  city: string
  startsAt: string // datetime-local
  endsAt: string
  genres: string // coma-separado
  price: string
  capacity: string
  description: string
}

const EMPTY: FormState = {
  id: null, name: '', venueName: '', city: 'buenos aires',
  startsAt: '', endsAt: '', genres: '', price: '', capacity: '', description: '',
}

// "2026-06-14T23:00:00Z" → "2026-06-14T23:00" (para <input datetime-local>)
function toLocalInput(iso: string): string {
  if (!iso) return ''
  return iso.slice(0, 16)
}

export function MyEventsScreen() {
  const { token, user } = useAuth()
  const [events, setEvents] = useState<CacheEvent[]>([])
  const [loading, setLoading] = useState(true)
  const [form, setForm] = useState<FormState | null>(null)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const load = useCallback(async () => {
    if (!token) return
    setLoading(true)
    try {
      setEvents(await getMyEvents(token))
      setError(null)
    } catch (err) {
      setError(apiErrorMessage(err).message)
    } finally {
      setLoading(false)
    }
  }, [token])

  useEffect(() => { load() }, [load])

  const openCreate = () => { setForm({ ...EMPTY }); setError(null) }
  const openEdit = (e: CacheEvent) => {
    setError(null)
    setForm({
      id: e.id,
      name: e.name,
      venueName: e.venueName,
      city: e.city,
      startsAt: toLocalInput(e.startsAt),
      endsAt: toLocalInput(e.endsAt),
      genres: e.genres.join(', '),
      price: String(e.price ?? ''),
      capacity: String(e.capacity ?? ''),
      description: e.description ?? '',
    })
  }

  const submit = async () => {
    if (!token || !form) return
    setSaving(true)
    setError(null)
    const payload: EventInput = {
      name: form.name.trim(),
      venueId: user?.venueId ?? null,
      venueName: form.venueName.trim(),
      city: form.city.trim() || 'buenos aires',
      startsAt: form.startsAt ? new Date(form.startsAt).toISOString() : '',
      endsAt: form.endsAt ? new Date(form.endsAt).toISOString() : '',
      genres: form.genres.split(',').map((g) => g.trim()).filter(Boolean),
      price: Number(form.price) || 0,
      capacity: Number(form.capacity) || 0,
      description: form.description.trim(),
      status: 'upcoming',
    }
    try {
      if (form.id) await updateEvent(form.id, payload, token)
      else await createEvent(payload, token)
      setForm(null)
      await load()
    } catch (err) {
      setError(apiErrorMessage(err).message ?? 'no pudimos guardar el evento.')
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="cache-screen" style={{ minHeight: '100dvh', paddingBottom: 88 }}>
      <div style={{ padding: '54px 18px 16px', borderBottom: '1px solid var(--line)', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>mis eventos</div>
        <button onClick={openCreate} className="cache-action" style={{ ...btnStyle('var(--acid)'), flex: 'none', flexShrink: 0, padding: '10px 14px' }}>
          <Icon name="plus" size={14} stroke={2.4} /> NUEVO
        </button>
      </div>

      {error && <div className="font-mono" style={{ color: 'var(--blood)', fontSize: 10, padding: '10px 18px' }}>{error}</div>}

      {form && (
        <div style={{ padding: 18, borderBottom: '1px solid var(--line)', display: 'flex', flexDirection: 'column', gap: 10 }}>
          <div className="font-mono" style={{ fontSize: 10, letterSpacing: '0.14em', color: 'var(--mute)', textTransform: 'uppercase' }}>
            {form.id ? 'editar evento' : 'nuevo evento'}
          </div>
          <Field label="nombre" value={form.name} onChange={(v) => setForm({ ...form, name: v })} />
          <Field label="venue" value={form.venueName} onChange={(v) => setForm({ ...form, venueName: v })} />
          <Field label="ciudad" value={form.city} onChange={(v) => setForm({ ...form, city: v })} />
          <Field label="empieza" type="datetime-local" value={form.startsAt} onChange={(v) => setForm({ ...form, startsAt: v })} />
          <Field label="termina" type="datetime-local" value={form.endsAt} onChange={(v) => setForm({ ...form, endsAt: v })} />
          <Field label="géneros (coma)" value={form.genres} onChange={(v) => setForm({ ...form, genres: v })} />
          <div style={{ display: 'flex', gap: 10 }}>
            <Field label="precio" type="number" value={form.price} onChange={(v) => setForm({ ...form, price: v })} />
            <Field label="capacidad" type="number" value={form.capacity} onChange={(v) => setForm({ ...form, capacity: v })} />
          </div>
          <Field label="descripción" value={form.description} onChange={(v) => setForm({ ...form, description: v })} />
          <div style={{ display: 'flex', gap: 10, marginTop: 4 }}>
            <button onClick={submit} disabled={saving} className="cache-action" style={btnStyle('var(--acid)', saving)}>
              {saving ? 'GUARDANDO...' : 'GUARDAR'}
            </button>
            <button onClick={() => setForm(null)} className="cache-action" style={btnStyle('var(--line)')}>CANCELAR</button>
          </div>
        </div>
      )}

      {loading ? (
        <div className="font-mono" style={{ padding: 18, color: 'var(--mute)', fontSize: 10 }}>cargando...</div>
      ) : events.length === 0 ? (
        <div className="font-mono" style={{ padding: 18, color: 'var(--mute)', fontSize: 11 }}>todavía no creaste eventos.</div>
      ) : (
        <div>
          {events.map((e) => (
            <button
              key={e.id}
              onClick={() => openEdit(e)}
              style={{
                width: '100%', textAlign: 'left', background: 'transparent', border: 'none',
                borderBottom: '1px solid var(--line)', padding: '14px 18px', cursor: 'pointer',
                display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12,
              }}
            >
              <div>
                <div className="font-display" style={{ fontSize: 16, color: 'var(--bone)' }}>{e.name}</div>
                <div className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.08em', marginTop: 3 }}>
                  {e.venueName} · {e.status} · {e.attendeeCount} anotados
                </div>
              </div>
              <Icon name="arrow" size={14} stroke={2} />
            </button>
          ))}
        </div>
      )}
    </div>
  )
}

function btnStyle(bg: string, disabled = false): CSSProperties {
  return {
    background: bg, color: bg === 'var(--line)' ? 'var(--bone)' : 'var(--ink)', border: 'none',
    padding: '12px 16px', fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.14em',
    textTransform: 'uppercase', fontWeight: 700, display: 'flex', alignItems: 'center',
    justifyContent: 'center', gap: 8, opacity: disabled ? 0.7 : 1, flex: 1,
  }
}

function Field({ label, value, onChange, type = 'text' }: {
  label: string; value: string; onChange: (v: string) => void; type?: string
}) {
  return (
    <label style={{ display: 'flex', flexDirection: 'column', gap: 4, flex: 1 }}>
      <span className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.1em', textTransform: 'uppercase' }}>{label}</span>
      <input
        type={type}
        value={value}
        onChange={(ev) => onChange(ev.target.value)}
        className="font-mono"
        style={{
          background: 'var(--ink)', border: '1px solid var(--line)', color: 'var(--bone)',
          padding: '10px 12px', fontSize: 12, outline: 'none', width: '100%',
        }}
      />
    </label>
  )
}
