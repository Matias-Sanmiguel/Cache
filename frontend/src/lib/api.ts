// cliente del backend spring (mongodb como catálogo de eventos)
const API = process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost:8080'

export type LineupSlot = { time: string; slot: string; artist: string }

export type CacheEvent = {
  id: string
  name: string
  venueId: string
  venueName: string
  venueAddress: string
  lat: number | null
  lon: number | null
  startsAt: string
  endsAt: string
  genres: string[]
  lineup: LineupSlot[]
  price: number
  capacity: number
  attendeeCount: number
  description: string
  imageUrl: string | null
  flyerVariant: string | null
  accessType: string | null // public | private | invite-only
  hostUserId: string | null
  status: string // upcoming | live | finished
  city: string
}

export type PageResponse<T> = {
  items: T[]
  page: number
  size: number
  totalItems: number
  totalPages: number
  hasNext: boolean
}

async function getJSON<T>(path: string): Promise<T> {
  const res = await fetch(`${API}${path}`, { cache: 'no-store' })
  if (!res.ok) throw new Error(`GET ${path} → ${res.status}`)
  return res.json() as Promise<T>
}

// feed paginado, con filtro opcional por género
export function getFeed(
  city = 'buenos aires',
  genre?: string,
  page = 0,
  size = 4,
): Promise<PageResponse<CacheEvent>> {
  const params = new URLSearchParams({ city, page: String(page), size: String(size) })
  if (genre) params.set('genre', genre)
  return getJSON<PageResponse<CacheEvent>>(`/api/events?${params}`)
}

export const getLive = () => getJSON<CacheEvent[]>('/api/events/live')

export async function getEvent(id: string): Promise<CacheEvent | null> {
  const res = await fetch(`${API}/api/events/${id}`, { cache: 'no-store' })
  if (res.status === 404) return null
  if (!res.ok) throw new Error(`GET /api/events/${id} → ${res.status}`)
  return res.json() as Promise<CacheEvent>
}

// ---- helpers de formato (UTC, deterministas en server) ----

const DAYS = ['DOM', 'LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB']
const MONTHS = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC']

export function fmtTime(iso: string): string {
  const d = new Date(iso)
  return `${String(d.getUTCHours()).padStart(2, '0')}:${String(d.getUTCMinutes()).padStart(2, '0')}`
}

export function fmtDate(iso: string): string {
  const d = new Date(iso)
  return `${DAYS[d.getUTCDay()]} ${String(d.getUTCDate()).padStart(2, '0')} ${MONTHS[d.getUTCMonth()]}`
}

export function capacityPct(e: CacheEvent): number {
  if (!e.capacity) return 0
  return Math.min(100, Math.round((e.attendeeCount / e.capacity) * 100))
}

export function fmtPrice(price: number): string {
  return `$${Math.round(price).toLocaleString('es-AR')}`
}
