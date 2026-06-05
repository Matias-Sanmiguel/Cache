'use client'

import { useState } from 'react'
import { Icon } from '@/components/ui/icon'

// comparte el evento: usa Web Share API si existe, si no copia el link al portapapeles
async function shareEvent(name: string, note: string) {
  const url = typeof window !== 'undefined' ? window.location.href : ''
  const text = `${note}: ${name}`
  if (navigator.share) {
    try {
      await navigator.share({ title: name, text, url })
      return
    } catch {
      return // el user canceló el diálogo
    }
  }
  try {
    await navigator.clipboard.writeText(url)
    alert('link copiado al portapapeles')
  } catch {
    /* sin permisos de clipboard — no-op */
  }
}

const iconBtn = {
  width: 36, height: 36, background: 'rgba(10,10,10,0.6)', backdropFilter: 'blur(12px)',
  border: '1px solid var(--line)', color: 'var(--bone)',
  display: 'flex', alignItems: 'center', justifyContent: 'center',
} as const

// botones de compartir + guardar (corazón) del header del detalle
export function ShareHeart({ name }: { name: string }) {
  const [saved, setSaved] = useState(false)
  return (
    <div style={{ display: 'flex', gap: 8 }}>
      <button className="cache-action" aria-label="compartir" onClick={() => shareEvent(name, 'mirá esta fecha')} style={iconBtn}>
        <Icon name="share" size={16} />
      </button>
      <button
        className="cache-action"
        aria-label={saved ? 'quitar de guardados' : 'guardar'}
        aria-pressed={saved}
        onClick={() => setSaved((s) => !s)}
        style={{ ...iconBtn, color: saved ? 'var(--blood)' : 'var(--bone)', borderColor: saved ? 'var(--blood)' : 'var(--line)' }}
      >
        <Icon name="heart" size={16} />
      </button>
    </div>
  )
}

// botón "invitar" del CTA inferior — comparte una invitación al evento
export function InviteButton({ name }: { name: string }) {
  return (
    <button
      className="cache-action"
      onClick={() => shareEvent(name, 'te invito a')}
      style={{
        background: 'transparent', color: 'var(--bone)', border: '1px solid var(--line-2)',
        padding: 16, fontFamily: 'var(--font-mono)', fontSize: 11, letterSpacing: '0.14em',
        textTransform: 'uppercase', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      }}
    >
      <Icon name="people" size={14} /> INVITAR
    </button>
  )
}
