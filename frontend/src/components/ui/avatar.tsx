const PALETTE = ['#FF2E2E', '#D4FF1A', '#E8E6DF', '#7B61FF', '#00FF88', '#FF8A00']

function resolveColor(name: string, override?: string): string {
  if (override) return override
  return PALETTE[(name.charCodeAt(0) + (name.charCodeAt(1) ?? 0)) % PALETTE.length]
}

export function Avatar({
  name,
  size = 28,
  color,
  online,
}: {
  name: string
  size?: number
  color?: string
  online?: boolean
}) {
  const bg = resolveColor(name, color)
  return (
    <span style={{ position: 'relative', display: 'inline-block', width: size, height: size, flexShrink: 0 }}>
      <span
        className="font-mono"
        style={{
          width: size,
          height: size,
          borderRadius: '50%',
          background: bg,
          color: 'var(--ink)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontWeight: 700,
          fontSize: size * 0.36,
          letterSpacing: '0.02em',
          border: '1.5px solid var(--ink)',
        }}
      >
        {name.slice(0, 2).toUpperCase()}
      </span>
      {online && (
        <span
          className="cache-pulse"
          style={{
            position: 'absolute',
            bottom: -1,
            right: -1,
            width: size * 0.32,
            height: size * 0.32,
            borderRadius: '50%',
            background: 'var(--pulse)',
            border: '2px solid var(--ink)',
          }}
        />
      )}
    </span>
  )
}

export function AvatarStack({
  people,
  max = 4,
  size = 26,
}: {
  people: { name: string; color?: string; online?: boolean }[]
  max?: number
  size?: number
}) {
  return (
    <span style={{ display: 'inline-flex' }}>
      {people.slice(0, max).map((p, i) => (
        <span key={i} style={{ marginLeft: i === 0 ? 0 : -10, zIndex: max - i }}>
          <Avatar name={p.name} size={size} color={p.color} online={p.online} />
        </span>
      ))}
      {people.length > max && (
        <span
          className="font-mono"
          style={{
            marginLeft: -10,
            width: size,
            height: size,
            borderRadius: '50%',
            background: 'var(--ink-4)',
            color: 'var(--soft)',
            display: 'inline-flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: size * 0.32,
            border: '1.5px solid var(--ink)',
          }}
        >
          +{people.length - max}
        </span>
      )}
    </span>
  )
}
