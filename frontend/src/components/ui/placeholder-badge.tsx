import type { CSSProperties } from 'react'

// marcador de dev: señala data/UI mock que todavía no viene del backend
type Mode = 'corner' | 'inline' | 'banner'

export function PlaceholderBadge({
  label = 'PLACEHOLDER',
  mode = 'corner',
  note,
  style,
}: {
  label?: string
  mode?: Mode
  note?: string
  style?: CSSProperties
}) {
  if (process.env.NEXT_PUBLIC_SHOW_PLACEHOLDERS !== 'true') return null

  const base: CSSProperties = {
    fontFamily: 'var(--font-mono)',
    fontSize: 8.5,
    fontWeight: 700,
    letterSpacing: '0.16em',
    textTransform: 'uppercase',
    background: '#FF2EC4',
    color: '#0A0A0A',
    padding: '3px 7px',
    border: '1px solid #0A0A0A',
    display: 'inline-flex',
    alignItems: 'center',
    gap: 5,
    whiteSpace: 'nowrap',
  }

  const content = (
    <>
      <span>⬡ {label}</span>
      {note && <span style={{ fontWeight: 400, opacity: 0.78 }}>· {note}</span>}
    </>
  )

  if (mode === 'banner') {
    return (
      <div style={{ ...base, width: '100%', justifyContent: 'center', padding: '5px 8px', ...style }}>
        {content}
      </div>
    )
  }

  if (mode === 'inline') {
    return <span style={{ ...base, fontSize: 7.5, padding: '2px 5px', letterSpacing: '0.1em', ...style }}>{content}</span>
  }

  // corner: requiere parent con position: relative
  return (
    <span style={{ position: 'absolute', top: 6, right: 6, zIndex: 50, ...base, ...style }}>
      {content}
    </span>
  )
}
