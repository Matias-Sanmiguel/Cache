import type { ReactNode, CSSProperties } from 'react'

const VARIANTS = [
  { bg: 'var(--blood)', color: 'var(--bone)' },
  { bg: 'var(--bone)',  color: 'var(--ink)'  },
  { bg: 'var(--acid)',  color: 'var(--ink)'  },
  { bg: 'var(--ink-3)', color: 'var(--bone)' },
]

export function FlyerBG({
  variant = 0,
  height = 200,
  children,
  style,
}: {
  variant?: number
  height?: number
  children?: ReactNode
  style?: CSSProperties
}) {
  const v = VARIANTS[variant % VARIANTS.length]
  return (
    <div
      style={{
        position: 'relative',
        width: '100%',
        height,
        background: v.bg,
        color: v.color,
        overflow: 'hidden',
        ...style,
      }}
    >
      <div style={{ position: 'relative', height: '100%', padding: 16, display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
        {children}
      </div>
    </div>
  )
}
