import { getNearby } from '@/lib/api'
import MapView from '@/components/map/map-view'

export async function MapScreen() {
  // eventos reales con coordenadas, cerca del centro de Buenos Aires.
  // el fetch corre en el server; la capa interactiva (filtros) vive en MapView (client).
  const { data: events, error, isFallback } = await getNearby()
  return <MapView events={events} error={error} isFallback={isFallback} />
}
