'use client'

import dynamic from 'next/dynamic'
import type { CacheEvent } from '@/lib/api'

// Leaflet toca `window` al importar → debe cargarse solo en cliente (ssr:false).
// ssr:false únicamente se permite dentro de un client component, por eso este wrapper.
const LeafletMap = dynamic(() => import('./leaflet-map'), {
  ssr: false,
  loading: () => (
    <div
      className="font-mono"
      style={{ position: 'absolute', inset: 0, display: 'grid', placeItems: 'center', color: 'var(--mute)', fontSize: 11, letterSpacing: '0.14em' }}
    >
      CARGANDO MAPA…
    </div>
  ),
})

export default function MapCanvas({ events }: { events: CacheEvent[] }) {
  return <LeafletMap events={events} />
}
