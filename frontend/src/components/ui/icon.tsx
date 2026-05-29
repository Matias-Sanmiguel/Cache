type IconName =
  | 'home' | 'map' | 'bell' | 'user' | 'plus' | 'arrow' | 'back'
  | 'pin' | 'clock' | 'people' | 'check' | 'fire' | 'search'
  | 'close' | 'share' | 'heart' | 'spark'

export function Icon({
  name,
  size = 20,
  stroke = 1.5,
}: {
  name: IconName
  size?: number
  stroke?: number
}) {
  const p = {
    width: size,
    height: size,
    viewBox: '0 0 24 24',
    fill: 'none' as const,
    stroke: 'currentColor',
    strokeWidth: stroke,
    strokeLinecap: 'round' as const,
    strokeLinejoin: 'round' as const,
  }
  switch (name) {
    case 'home':   return <svg {...p}><path d="M3 12 12 3l9 9"/><path d="M5 10v10h14V10"/></svg>
    case 'map':    return <svg {...p}><path d="M9 4 3 6v14l6-2 6 2 6-2V4l-6 2-6-2Z"/><path d="M9 4v14"/><path d="M15 6v14"/></svg>
    case 'bell':   return <svg {...p}><path d="M6 8a6 6 0 1 1 12 0c0 7 3 7 3 9H3c0-2 3-2 3-9Z"/><path d="M10 21a2 2 0 0 0 4 0"/></svg>
    case 'user':   return <svg {...p}><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-7 8-7s8 3 8 7"/></svg>
    case 'plus':   return <svg {...p}><path d="M12 5v14M5 12h14"/></svg>
    case 'arrow':  return <svg {...p}><path d="M5 12h14M13 6l6 6-6 6"/></svg>
    case 'back':   return <svg {...p}><path d="M19 12H5M11 18l-6-6 6-6"/></svg>
    case 'pin':    return <svg {...p}><path d="M12 22s8-7.5 8-13a8 8 0 1 0-16 0c0 5.5 8 13 8 13Z"/><circle cx="12" cy="9" r="3"/></svg>
    case 'clock':  return <svg {...p}><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg>
    case 'people': return <svg {...p}><circle cx="9" cy="8" r="3.5"/><circle cx="17" cy="9" r="2.5"/><path d="M3 20c0-3 3-5 6-5s6 2 6 5"/><path d="M17 14c2.5 0 4 1.5 4 4"/></svg>
    case 'check':  return <svg {...p}><path d="M5 12l5 5L20 7"/></svg>
    case 'fire':   return <svg {...p}><path d="M12 3s4 4 4 8a4 4 0 0 1-8 0c0-2 1-3 1-3s-3 2-3 6a6 6 0 0 0 12 0c0-6-6-11-6-11Z"/></svg>
    case 'search': return <svg {...p}><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
    case 'close':  return <svg {...p}><path d="M6 6l12 12M18 6 6 18"/></svg>
    case 'share':  return <svg {...p}><path d="M12 4v12"/><path d="m7 9 5-5 5 5"/><path d="M5 14v5h14v-5"/></svg>
    case 'heart':  return <svg {...p}><path d="M12 20s-7-4.5-7-10a4 4 0 0 1 7-2.5A4 4 0 0 1 19 10c0 5.5-7 10-7 10Z"/></svg>
    case 'spark':  return <svg {...p}><path d="M12 3v6M12 15v6M3 12h6M15 12h6M5.6 5.6l4.2 4.2M14.2 14.2l4.2 4.2M5.6 18.4l4.2-4.2M14.2 9.8l4.2-4.2"/></svg>
    default:       return null
  }
}
