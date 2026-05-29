'use client'

export function Dot({
  color = 'var(--pulse)',
  size = 6,
  pulse = true,
}: {
  color?: string
  size?: number
  pulse?: boolean
}) {
  return (
    <span
      className={pulse ? 'cache-pulse' : undefined}
      style={{
        display: 'inline-block',
        width: size,
        height: size,
        borderRadius: '50%',
        background: color,
        color,
        flexShrink: 0,
      }}
    />
  )
}
