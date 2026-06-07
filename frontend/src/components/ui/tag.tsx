import type { CSSProperties, ReactNode } from 'react'

type TagKind = 'default' | 'acid' | 'ghost' | 'blood' | 'bone'
type TagSize = 'sm' | 'md'

const STYLES: Record<TagKind, { bg: string; fg: string; bd: string }> = {
  default: { bg: 'transparent',    fg: 'var(--bone)', bd: 'var(--line-2)' },
  acid:    { bg: 'var(--acid)',     fg: 'var(--ink)',  bd: 'var(--acid)'   },
  ghost:   { bg: 'var(--ink-3)',    fg: 'var(--soft)', bd: 'var(--line)'   },
  blood:   { bg: 'transparent',    fg: 'var(--blood)',bd: 'var(--blood)'  },
  bone:    { bg: 'var(--bone)',     fg: 'var(--ink)',  bd: 'var(--bone)'   },
}

export function Tag({
  children,
  kind = 'default',
  size = 'sm',
  style,
}: {
  children: ReactNode
  kind?: TagKind
  size?: TagSize
  style?: CSSProperties
}) {
  const s = STYLES[kind]
  return (
    <span
      className="font-mono cache-tag"
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 6,
        padding: size === 'sm' ? '3px 8px' : '5px 10px',
        background: s.bg,
        color: s.fg,
        border: `1px solid ${s.bd}`,
        fontSize: size === 'sm' ? 10 : 11,
        letterSpacing: '0.08em',
        textTransform: 'uppercase',
        borderRadius: 0,
        whiteSpace: 'nowrap',
        ...style,
      }}
    >
      {children}
    </span>
  )
}
