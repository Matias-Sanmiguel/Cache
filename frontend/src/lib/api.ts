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

// ---- auth ----

export type Role = 'VISITOR' | 'VENUE_OWNER' | 'ADMIN'

export const ROLE_LABEL: Record<Role, string> = {
  VISITOR: 'visitante',
  VENUE_OWNER: 'dueño de local',
  ADMIN: 'admin',
}

export type AuthUser = {
  userId: string
  email: string
  displayName: string
  handle: string
  avatarColor: string
  city: string | null
  role: Role
  venueId: string | null
  createdAt: string
  lastActiveAt: string
}

export type AuthResponse = { token: string; user: AuthUser }

export type RegisterPayload = {
  email: string
  password: string
  displayName: string
  handle: string
  city?: string
  avatarColor?: string
  role?: Role
  venueId?: string
}

// extrae el mensaje de error del backend (ResponseStatusException → { message })
async function readError(res: Response): Promise<string> {
  try {
    const body = await res.json()
    return body.message ?? body.error ?? `error ${res.status}`
  } catch {
    return `error ${res.status}`
  }
}

export async function apiRegister(payload: RegisterPayload): Promise<AuthResponse> {
  const res = await fetch(`${API}/api/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })
  if (!res.ok) throw new Error(await readError(res))
  return res.json() as Promise<AuthResponse>
}

export async function apiLogin(identifier: string, password: string): Promise<AuthResponse> {
  const res = await fetch(`${API}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ identifier, password }),
  })
  if (!res.ok) throw new Error(await readError(res))
  return res.json() as Promise<AuthResponse>
}

export async function apiMe(token: string): Promise<AuthUser> {
  const res = await fetch(`${API}/api/auth/me`, {
    headers: { Authorization: `Bearer ${token}` },
    cache: 'no-store',
  })
  if (!res.ok) throw new Error(await readError(res))
  return res.json() as Promise<AuthUser>
}

export async function apiLogout(token: string): Promise<void> {
  await fetch(`${API}/api/auth/logout`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
  })
}

export async function apiUpdateProfile(
  userId: string,
  patch: { displayName?: string; avatarColor?: string; city?: string },
): Promise<AuthUser> {
  const res = await fetch(`${API}/api/users/${userId}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(patch),
  })
  if (!res.ok) throw new Error(await readError(res))
  return res.json() as Promise<AuthUser>
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
