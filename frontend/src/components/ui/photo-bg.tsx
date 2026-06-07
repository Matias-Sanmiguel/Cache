type Hue = 'red' | 'blue' | 'green' | 'purple' | 'amber'

const TINTS: Record<Hue, string> = {
  red:    'linear-gradient(135deg, #2A0808 0%, #FF2E2E 60%, #1a0202 100%)',
  blue:   'linear-gradient(135deg, #06121F 0%, #1E3A5F 50%, #0a0a0a 100%)',
  green:  'linear-gradient(135deg, #0a1a0a 0%, #2a4a18 60%, #060a06 100%)',
  purple: 'linear-gradient(135deg, #14081E 0%, #3A1A6B 50%, #08040E 100%)',
  amber:  'linear-gradient(135deg, #1a0a00 0%, #6B3A0A 60%, #0a0500 100%)',
}

export function PhotoBG({ height = 200, hue = 'red' }: { height?: number; hue?: Hue }) {
  return (
    <div
      style={{
        position: 'relative',
        width: '100%',
        height,
        background: TINTS[hue],
        overflow: 'hidden',
      }}
    >
      <svg
        className="cache-photo-layer"
        viewBox="0 0 400 200"
        preserveAspectRatio="xMidYMid slice"
        style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', opacity: 0.55 }}
      >
        <defs>
          <filter id={`blur-${hue}`}><feGaussianBlur stdDeviation="2.2" /></filter>
          <radialGradient id={`spot-${hue}`} cx="0.7" cy="0.2" r="0.6">
            <stop offset="0" stopColor="#fff" stopOpacity="0.35" />
            <stop offset="1" stopColor="#fff" stopOpacity="0" />
          </radialGradient>
        </defs>
        <rect width="400" height="200" fill={`url(#spot-${hue})`} />
        <g filter={`url(#blur-${hue})`} fill="#000" opacity="0.65">
          <ellipse cx="60" cy="180" rx="40" ry="55" />
          <ellipse cx="140" cy="170" rx="50" ry="65" />
          <ellipse cx="230" cy="180" rx="45" ry="60" />
          <ellipse cx="320" cy="175" rx="55" ry="70" />
          <circle cx="60" cy="125" r="14" />
          <circle cx="140" cy="110" r="16" />
          <circle cx="230" cy="120" r="15" />
          <circle cx="320" cy="110" r="17" />
        </g>
      </svg>
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: 'repeating-linear-gradient(0deg, rgba(0,0,0,0.18) 0 1px, transparent 1px 3px)',
          mixBlendMode: 'multiply',
        }}
      />
    </div>
  )
}
