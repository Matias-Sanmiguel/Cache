'use client'

import dynamic from 'next/dynamic'
import { useEffect, useState } from 'react'
import { useAuth } from '@/lib/auth-context'
import { getFriendsAttending, type CacheEvent } from '@/lib/api'

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
  const { token } = useAuth()
  const [friendsByEvent, setFriendsByEvent] = useState<Record<string, number>>({})

  // amigos reales (neo4j) anotados a cada evento → alimenta el badge de los pines.
  // sin sesión no hay grafo: el mapa cae a pines sin badge (no más conteo fake).
  useEffect(() => {
    if (!token) {
      setFriendsByEvent({})
      return
    }
    let alive = true
    const geo = events.filter((e) => e.lat != null && e.lon != null)
    Promise.all(
      geo.map(async (e) => [e.id, (await getFriendsAttending(e.id, token)).length] as const),
    ).then((entries) => {
      if (alive) setFriendsByEvent(Object.fromEntries(entries))
    })
    return () => {
      alive = false
    }
  }, [events, token])

  return <LeafletMap events={events} friendsByEvent={friendsByEvent} />
}
