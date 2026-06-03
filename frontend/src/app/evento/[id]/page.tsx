import Link from 'next/link'
import { DetailScreen } from '@/components/screens/detail'
import { getEvent, type CacheEvent } from '@/lib/api'

export default async function EventoPage({ params }: { params: { id: string } }) {
  let event: CacheEvent | null = null
  let error: string | null = null

  try {
    event = await getEvent(params.id)
  } catch (err) {
    error = err instanceof Error ? err.message : 'error desconocido'
  }

  if (error) {
    return (
      <div style={{ background: 'var(--ink)', minHeight: '100dvh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 16, padding: 24 }}>
        <div className="font-mono" style={{ fontSize: 10, color: 'var(--blood)', letterSpacing: '0.12em' }}>BACKEND OFFLINE</div>
        <div className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>{error}</div>
        <Link href="/" className="font-mono" style={{ fontSize: 11, color: 'var(--acid)', letterSpacing: '0.14em' }}>← VOLVER AL FEED</Link>
      </div>
    )
  }

  if (!event) {
    return (
      <div style={{ background: 'var(--ink)', minHeight: '100dvh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 16, padding: 24 }}>
        <div className="font-display" style={{ fontSize: 32, color: 'var(--bone)' }}>404</div>
        <div className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>ese evento no existe.</div>
        <Link href="/" className="font-mono" style={{ fontSize: 11, color: 'var(--acid)', letterSpacing: '0.14em' }}>← VOLVER AL FEED</Link>
      </div>
    )
  }

  return <DetailScreen event={event} />
}
