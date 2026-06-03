// cliente del backend spring (mongodb como catálogo de eventos)
const API = process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost:8080'
const API_TIMEOUT_MS = Number(process.env.NEXT_PUBLIC_API_TIMEOUT_MS ?? 2500)

export class ApiError extends Error {
  status: number

  constructor(status: number, message: string) {
    super(message)
    this.status = status
  }
}

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

export type ApiResult<T> = {
  data: T
  error?: string
  status?: number
  isFallback?: boolean
}

export type CheckInPayload = {
  userId: string
  eventId: string
  venueId: string
}

export type Notification = {
  id: string
  kind: 'friend-joined' | 'live' | 'urgent' | 'recommend' | 'system'
  tag: string
  time: string
  body: string
  sub?: string
  unread?: boolean
  avatar?: { name: string; color: string }
  icon?: 'fire' | 'spark' | 'pin'
  cta?: string
  cta2?: string
  group?: string
}

export type DashboardSummary = {
  activeEvents: number
  totalCheckins: number
  activeVenues: number
  topZone: string
}

export type DashboardAttendeesByEvent = {
  eventId: string
  eventName: string
  count: number
  capacity?: number
}

export type DashboardEventsByZone = {
  zone: string
  count: number
}

export type DashboardGenresByDate = {
  date: string
  genres: { name: string; count: number }[]
}

export type DashboardCheckinPeak = {
  time: string
  count: number
}

export type DashboardData = {
  summary: DashboardSummary
  attendeesByEvent: DashboardAttendeesByEvent[]
  eventsByZone: DashboardEventsByZone[]
  genresByDate: DashboardGenresByDate[]
  checkinPeaks: DashboardCheckinPeak[]
}

async function apiRequest<T>(path: string, init: RequestInit): Promise<T> {
  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), API_TIMEOUT_MS)

  try {
    const res = await fetch(`${API}${path}`, {
      cache: 'no-store',
      ...init,
      signal: init.signal ?? controller.signal,
      headers: {
        'Content-Type': 'application/json',
        ...(init.headers ?? {}),
      },
    })
    if (!res.ok) throw new ApiError(res.status, `${init.method ?? 'GET'} ${path} → ${res.status}`)
    if (res.status === 204) return undefined as T
    const contentType = res.headers.get('content-type') ?? ''
    if (contentType.includes('application/json')) {
      return res.json() as Promise<T>
    }
    const text = await res.text()
    return text as unknown as T
  } finally {
    clearTimeout(timeout)
  }
}

export function apiGet<T>(path: string): Promise<T> {
  return apiRequest<T>(path, { method: 'GET' })
}

export function apiPost<T>(path: string, body?: unknown): Promise<T> {
  return apiRequest<T>(path, { method: 'POST', body: body ? JSON.stringify(body) : undefined })
}

type ApiRecord = Record<string, unknown>

function isRecord(value: unknown): value is ApiRecord {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

function asString(value: unknown, fallback = ''): string {
  return typeof value === 'string' && value.trim() ? value : fallback
}

function asNullableString(value: unknown): string | null {
  return typeof value === 'string' && value.trim() ? value : null
}

function asNumber(value: unknown, fallback = 0): number {
  if (typeof value === 'number' && Number.isFinite(value)) return value
  if (typeof value === 'string' && value.trim()) {
    const parsed = Number(value)
    if (Number.isFinite(parsed)) return parsed
  }
  return fallback
}

function asNullableNumber(value: unknown): number | null {
  if (value === null || value === undefined) return null
  const parsed = asNumber(value, Number.NaN)
  return Number.isFinite(parsed) ? parsed : null
}

function asStringArray(value: unknown): string[] {
  if (!Array.isArray(value)) return []
  return value.filter((item): item is string => typeof item === 'string' && item.trim().length > 0)
}

function asArray(value: unknown): unknown[] {
  return Array.isArray(value) ? value : []
}

function apiErrorMessage(err: unknown): { message: string; status?: number } {
  if (err instanceof ApiError) return { message: err.message, status: err.status }
  if (err instanceof Error) return { message: err.message }
  return { message: 'error desconocido' }
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
export async function getFeed(
  city = 'buenos aires',
  genre?: string,
  page = 0,
  size = 4,
): Promise<PageResponse<CacheEvent>> {
  const params = new URLSearchParams({ city, page: String(page), size: String(size) })
  if (genre) params.set('genre', genre)
  return normalizeEventPage(await apiGet<unknown>(`/api/events?${params}`))
}

export const getLive = async () => normalizeEvents(await apiGet<unknown>('/api/events/live'))

export async function getEvents(
  city = 'buenos aires',
  genre?: string,
  size = 12,
): Promise<ApiResult<CacheEvent[]>> {
  try {
    const page = await getFeed(city, genre, 0, size)
    return { data: page.items }
  } catch (err) {
    const fallback = genre ? mockEvents().filter((event) => event.genres.includes(genre)) : mockEvents()
    const { message, status } = apiErrorMessage(err)
    return { data: fallback, error: message, status, isFallback: true }
  }
}

export async function getEventById(id: string): Promise<CacheEvent | null> {
  try {
    return normalizeEvent(await apiGet<unknown>(`/api/events/${id}`))
  } catch (err) {
    const fallbackEvent = mockEvents().find((event) => event.id === id)
    if (fallbackEvent) return fallbackEvent
    if (err instanceof ApiError && err.status === 404) return null
    throw err
  }
}

export const getEvent = getEventById

export function checkInToEvent(payload: CheckInPayload): Promise<void> {
  return apiPost<void>('/api/checkins', payload)
}

export async function getNotifications(userId: string): Promise<ApiResult<Notification[]>> {
  try {
    const data = await apiGet<unknown>(`/api/notifications/user/${userId}`)
    return { data: normalizeNotifications(data) }
  } catch (err) {
    const fallback = mockNotifications()
    const { message, status } = apiErrorMessage(err)
    return { data: fallback, error: message, status, isFallback: true }
  }
}

export async function getDashboardData(): Promise<ApiResult<DashboardData>> {
  const fallback = mockDashboard()
  const [summary, attendeesByEvent, eventsByZone, genresByDate, checkinPeaks] = await Promise.all([
    dashboardSection('/api/dashboard/summary', fallback.summary, normalizeSummary),
    dashboardSection('/api/dashboard/attendees-by-event', fallback.attendeesByEvent, normalizeAttendeesByEvent),
    dashboardSection('/api/dashboard/events-by-zone', fallback.eventsByZone, normalizeEventsByZone),
    dashboardSection('/api/dashboard/genres-by-date', fallback.genresByDate, normalizeGenresByDate),
    dashboardSection('/api/dashboard/checkin-peaks', fallback.checkinPeaks, normalizeCheckinPeaks),
  ])
  const fallbackResult = [summary, attendeesByEvent, eventsByZone, genresByDate, checkinPeaks].find((result) => result.isFallback)

  return {
    data: {
      summary: summary.data,
      attendeesByEvent: attendeesByEvent.data,
      eventsByZone: eventsByZone.data,
      genresByDate: genresByDate.data,
      checkinPeaks: checkinPeaks.data,
    },
    error: fallbackResult?.error,
    status: fallbackResult?.status,
    isFallback: Boolean(fallbackResult),
  }
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

function mockEvents(): CacheEvent[] {
  const now = Date.now()
  return [
    {
      id: 'mock-sub00',
      name: 'SUB00',
      venueId: 'venue-niceto',
      venueName: 'Niceto',
      venueAddress: 'Palermo · Niceto Vega 5510',
      lat: -34.5879,
      lon: -58.4361,
      startsAt: new Date(now + 45 * 60 * 1000).toISOString(),
      endsAt: new Date(now + 4 * 60 * 60 * 1000).toISOString(),
      genres: ['techno', 'house'],
      lineup: [],
      price: 8000,
      capacity: 600,
      attendeeCount: 412,
      description: 'noche techno con visuales y takeover local.',
      imageUrl: null,
      flyerVariant: 'red',
      accessType: 'public',
      hostUserId: null,
      status: 'live',
      city: 'buenos aires',
    },
    {
      id: 'mock-kernel',
      name: 'KERNEL',
      venueId: 'venue-crobar',
      venueName: 'Crobar',
      venueAddress: 'Palermo · Av. del Libertador 3883',
      lat: -34.5739,
      lon: -58.4125,
      startsAt: new Date(now + 2 * 60 * 60 * 1000).toISOString(),
      endsAt: new Date(now + 6 * 60 * 60 * 1000).toISOString(),
      genres: ['disco', 'house'],
      lineup: [],
      price: 9500,
      capacity: 720,
      attendeeCount: 180,
      description: 'groove disco con warmup melódico.',
      imageUrl: null,
      flyerVariant: 'amber',
      accessType: 'public',
      hostUserId: null,
      status: 'upcoming',
      city: 'buenos aires',
    },
    {
      id: 'mock-humedal',
      name: 'HUMEDAL',
      venueId: 'venue-gn',
      venueName: 'Galpón Norte',
      venueAddress: 'Chacarita · Forest 478',
      lat: -34.5872,
      lon: -58.4548,
      startsAt: new Date(now + 3 * 60 * 60 * 1000).toISOString(),
      endsAt: new Date(now + 7 * 60 * 60 * 1000).toISOString(),
      genres: ['bass', 'minimal'],
      lineup: [],
      price: 7000,
      capacity: 420,
      attendeeCount: 310,
      description: 'bass room + minimal stage con visuales.',
      imageUrl: null,
      flyerVariant: 'purple',
      accessType: 'invite-only',
      hostUserId: null,
      status: 'upcoming',
      city: 'buenos aires',
    },
    {
      id: 'mock-casa',
      name: 'CASA',
      venueId: 'venue-casa',
      venueName: 'Casa Pelícano',
      venueAddress: 'Villa Crespo · Loyola 710',
      lat: -34.5962,
      lon: -58.4386,
      startsAt: new Date(now + 90 * 60 * 1000).toISOString(),
      endsAt: new Date(now + 5 * 60 * 60 * 1000).toISOString(),
      genres: ['melodic'],
      lineup: [],
      price: 6000,
      capacity: 260,
      attendeeCount: 220,
      description: 'melodic night con cupo limitado.',
      imageUrl: null,
      flyerVariant: 'blue',
      accessType: 'private',
      hostUserId: null,
      status: 'live',
      city: 'buenos aires',
    },
  ]
}

function mockNotifications(): Notification[] {
  return [
    {
      id: 'ping-1',
      kind: 'friend-joined',
      tag: 'JULE SE ANOTÓ',
      time: 'AHORA',
      body: 'un amigo se anotó a un evento: SUB00.',
      sub: 'NICETO · 23:30 · 78% LLENO',
      unread: true,
      avatar: { name: 'Jule', color: '#D4FF1A' },
      cta: 'ANOTARME',
      cta2: 'VER',
      group: 'AHORA',
    },
    {
      id: 'ping-2',
      kind: 'urgent',
      tag: 'ZONA CALIENTE',
      time: '2 MIN',
      body: 'hay movimiento fuerte en villa crespo.',
      sub: '+3 eventos creciendo en 10 min',
      unread: true,
      icon: 'fire',
      cta: 'VER MAPA',
      group: 'AHORA',
    },
    {
      id: 'ping-3',
      kind: 'recommend',
      tag: 'EN TENDENCIA',
      time: '14 MIN',
      body: 'un venue está en tendencia: crobar.',
      sub: 'palermo · 84% de ocupación',
      icon: 'spark',
      group: 'HOY',
    },
    {
      id: 'ping-4',
      kind: 'live',
      tag: 'EN EL VENUE',
      time: '1 H',
      body: 'tomi llegó a SUB00. te está esperando.',
      avatar: { name: 'Tomi', color: '#00FF88' },
      group: 'HOY',
    },
    {
      id: 'ping-5',
      kind: 'system',
      tag: 'INVITACIÓN',
      time: '3 H',
      body: 'vico te invitó a su fiesta privada el sábado.',
      avatar: { name: 'Vico', color: '#FF2E2E' },
      cta: 'ACEPTAR',
      cta2: 'IGNORAR',
      group: 'HOY',
    },
  ]
}

function mockDashboard(): DashboardData {
  return {
    summary: {
      activeEvents: 12,
      totalCheckins: 482,
      activeVenues: 7,
      topZone: 'Palermo',
    },
    attendeesByEvent: [
      { eventId: 'mock-sub00', eventName: 'SUB00', count: 412, capacity: 600 },
      { eventId: 'mock-casa', eventName: 'CASA', count: 220, capacity: 260 },
      { eventId: 'mock-kernel', eventName: 'KERNEL', count: 180, capacity: 720 },
      { eventId: 'mock-humedal', eventName: 'HUMEDAL', count: 310, capacity: 420 },
    ],
    eventsByZone: [
      { zone: 'Palermo', count: 5 },
      { zone: 'Chacarita', count: 3 },
      { zone: 'Villa Crespo', count: 2 },
      { zone: 'Almagro', count: 2 },
    ],
    genresByDate: [
      { date: 'VIE 01/06', genres: [{ name: 'techno', count: 4 }, { name: 'house', count: 3 }, { name: 'disco', count: 2 }] },
      { date: 'SÁB 02/06', genres: [{ name: 'melodic', count: 2 }, { name: 'bass', count: 2 }, { name: 'minimal', count: 1 }] },
    ],
    checkinPeaks: [
      { time: '22:30', count: 38 },
      { time: '23:15', count: 72 },
      { time: '00:05', count: 94 },
      { time: '01:00', count: 61 },
    ],
  }
}
