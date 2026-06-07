// cliente del backend spring (mongodb como catálogo de eventos)
// server components (feed/map) corren DENTRO del contenedor: localhost:8080 = el propio
// contenedor → ECONNREFUSED. Usan INTERNAL_API_URL (nombre de red docker `backend:8080`).
// el browser (componentes 'use client') usa NEXT_PUBLIC_API_URL (origen host = localhost:8080).
const API =
  (typeof window === 'undefined'
    ? process.env.INTERNAL_API_URL ?? process.env.NEXT_PUBLIC_API_URL
    : process.env.NEXT_PUBLIC_API_URL) ?? 'http://localhost:8080'
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
  isAttending: boolean
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
  // entidad referida: eventId (ping de evento) o userId del solicitante (ping de amistad)
  refId?: string
}

export type DashboardSummary = {
  activeEvents: number
  totalCheckins: number
  activeVenues: number
  topZone: string
  totalPresentNow: number
}

export type DashboardLivePresence = {
  venueId: string
  venueName: string
  count: number
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
  livePresence: DashboardLivePresence[]
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

// GET autenticado: agrega el Bearer token (endpoints user-specific: friends, notifs, me)
export function apiGetAuth<T>(path: string, token: string): Promise<T> {
  return apiRequest<T>(path, { method: 'GET', headers: { Authorization: `Bearer ${token}` } })
}

export function apiPost<T>(path: string, body?: unknown): Promise<T> {
  return apiRequest<T>(path, { method: 'POST', body: body ? JSON.stringify(body) : undefined })
}

// POST autenticado: Bearer token (check-in, anotaciones user-specific)
export function apiPostAuth<T>(path: string, body: unknown, token: string): Promise<T> {
  return apiRequest<T>(path, {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
    body: body ? JSON.stringify(body) : undefined,
  })
}

// PUT autenticado: Bearer token (aceptar solicitud de amistad, etc.)
export function apiPutAuth<T>(path: string, token: string, body?: unknown): Promise<T> {
  return apiRequest<T>(path, {
    method: 'PUT',
    headers: { Authorization: `Bearer ${token}` },
    body: body ? JSON.stringify(body) : undefined,
  })
}

// DELETE autenticado
export function apiDeleteAuth<T>(path: string, token: string): Promise<T> {
  return apiRequest<T>(path, { method: 'DELETE', headers: { Authorization: `Bearer ${token}` } })
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

export function apiErrorMessage(err: unknown): { message: string; status?: number } {
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
  displayName: string
  handle: string
  avatarColor: string
  city: string | null
  // el backend (UserProfileDTO) no devuelve estos campos en login/me; opcionales
  email?: string
  role?: Role
  venueId?: string | null
  createdAt?: string
  lastActiveAt?: string
}

export type AuthResponse = { token: string; refreshToken: string; user: AuthUser }

// el backend manda UserProfileDTO {userId, displayName, handle, avatarColor, city}
function normalizeAuthUser(raw: unknown): AuthUser {
  const u = isRecord(raw) ? raw : {}
  return {
    userId: asString(u.userId),
    displayName: asString(u.displayName, 'vos'),
    handle: asString(u.handle),
    avatarColor: asString(u.avatarColor, '#E8E6DF'),
    city: asNullableString(u.city),
    email: typeof u.email === 'string' ? u.email : undefined,
    role: typeof u.role === 'string' ? (u.role as Role) : undefined,
    venueId: asNullableString(u.venueId),
    createdAt: typeof u.createdAt === 'string' ? u.createdAt : undefined,
    lastActiveAt: typeof u.lastActiveAt === 'string' ? u.lastActiveAt : undefined,
  }
}

// el backend responde { accessToken, refreshToken, user } → lo adaptamos a { token, refreshToken, user }
function normalizeAuthResponse(raw: unknown): AuthResponse {
  const r = isRecord(raw) ? raw : {}
  return {
    token: asString(r.accessToken ?? r.token),
    refreshToken: asString(r.refreshToken),
    user: normalizeAuthUser(r.user),
  }
}

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
  return normalizeAuthResponse(await res.json())
}

export async function apiLogin(identifier: string, password: string): Promise<AuthResponse> {
  const res = await fetch(`${API}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    // el backend (LoginRequest) espera el campo `email`
    body: JSON.stringify({ email: identifier, password }),
  })
  if (!res.ok) throw new Error(await readError(res))
  return normalizeAuthResponse(await res.json())
}

export async function apiMe(token: string): Promise<AuthUser> {
  // el endpoint /me vive en UserController (/api/users/me), no en /api/auth
  const res = await fetch(`${API}/api/users/me`, {
    headers: { Authorization: `Bearer ${token}` },
    cache: 'no-store',
  })
  if (!res.ok) throw new Error(await readError(res))
  return normalizeAuthUser(await res.json())
}

// logout: el backend invalida el refresh token (TokenRequest{refreshToken}) en redis.
// el access token es stateless, no se revoca; vence solo.
export async function apiLogout(refreshToken: string): Promise<void> {
  if (!refreshToken) return
  await fetch(`${API}/api/auth/logout`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ refreshToken }),
  })
}

// rota el refresh token y emite un access nuevo — usado al rehidratar si el access venció
export async function apiRefresh(refreshToken: string): Promise<AuthResponse> {
  const res = await fetch(`${API}/api/auth/refresh`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ refreshToken }),
  })
  if (!res.ok) throw new Error(await readError(res))
  return normalizeAuthResponse(await res.json())
}

// actualiza el propio perfil — PUT /api/users/me con Bearer (UpdateProfileRequest)
export async function apiUpdateProfile(
  token: string,
  patch: { displayName?: string; avatarColor?: string; city?: string },
): Promise<AuthUser> {
  const res = await fetch(`${API}/api/users/me`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: JSON.stringify(patch),
  })
  if (!res.ok) throw new Error(await readError(res))
  return normalizeAuthUser(await res.json())
}

// ---- normalizers (api crudo → tipos del front) + mocks de fallback ----

function normalizeLineup(value: unknown): LineupSlot[] {
  return asArray(value)
    .filter(isRecord)
    .map((slot) => ({
      time: asString(slot.time),
      slot: asString(slot.slot),
      artist: asString(slot.artist),
    }))
}

function normalizeEvent(value: unknown): CacheEvent {
  const event = isRecord(value) ? value : {}
  const now = new Date().toISOString()
  // el backend manda las coords anidadas en `location: { lat, lon }` (GeoPointDTO);
  // los mocks las traen planas. soportamos ambas.
  const loc = isRecord(event.location) ? event.location : {}
  return {
    id: asString(event.id, asString(event.eventId, 'event')),
    name: asString(event.name, 'Evento'),
    venueId: asString(event.venueId, asString(event.venue?.valueOf(), 'venue')),
    venueName: asString(event.venueName, asString(event.venue, 'Venue')),
    venueAddress: asString(event.venueAddress, asString(event.address, 'Buenos Aires')),
    lat: asNullableNumber(event.lat ?? loc.lat),
    lon: asNullableNumber(event.lon ?? event.lng ?? loc.lon ?? loc.lng),
    startsAt: asString(event.startsAt, now),
    endsAt: asString(event.endsAt, asString(event.startsAt, now)),
    genres: asStringArray(event.genres),
    lineup: normalizeLineup(event.lineup),
    price: asNumber(event.price),
    capacity: asNumber(event.capacity),
    attendeeCount: asNumber(event.attendeeCount ?? event.attendees ?? event.checkins),
    description: asString(event.description, 'noche en movimiento.'),
    imageUrl: asNullableString(event.imageUrl),
    flyerVariant: asNullableString(event.flyerVariant),
    accessType: asNullableString(event.accessType),
    hostUserId: asNullableString(event.hostUserId),
    status: asString(event.status, 'upcoming'),
    city: asString(event.city, 'buenos aires'),
    isAttending: event.isAttending === true,
  }
}

function normalizeEventPage(value: unknown): PageResponse<CacheEvent> {
  const page = isRecord(value) ? value : {}
  const items = asArray(page.items ?? page.content ?? page.events).map(normalizeEvent)
  return {
    items,
    page: asNumber(page.page ?? page.number),
    size: asNumber(page.size, items.length),
    totalItems: asNumber(page.totalItems ?? page.totalElements, items.length),
    totalPages: asNumber(page.totalPages, 1),
    hasNext: Boolean(page.hasNext),
  }
}

function normalizeEvents(value: unknown): CacheEvent[] {
  return asArray(value).map(normalizeEvent)
}

const NOTIFICATION_KINDS = ['friend-joined', 'live', 'urgent', 'recommend', 'system'] as const
const NOTIFICATION_ICONS = ['fire', 'spark', 'pin'] as const
type NotificationIcon = NonNullable<Notification['icon']>

function normalizeNotification(value: unknown): Notification {
  const notif = isRecord(value) ? value : {}
  const kind = asString(notif.kind, 'system')
  const icon = asString(notif.icon)
  const avatar = isRecord(notif.avatar)
    ? { name: asString(notif.avatar.name, 'User'), color: asString(notif.avatar.color, '#E8E6DF') }
    : undefined

  return {
    id: asString(notif.id, crypto.randomUUID()),
    kind: NOTIFICATION_KINDS.includes(kind as Notification['kind']) ? (kind as Notification['kind']) : 'system',
    tag: asString(notif.tag, asString(notif.title, 'PING')),
    time: asString(notif.time, 'AHORA'),
    body: asString(notif.body, asString(notif.message, 'Tenés una novedad en Caché.')),
    sub: asNullableString(notif.sub ?? notif.subtitle ?? notif.detail) ?? undefined,
    unread: typeof notif.unread === 'boolean' ? notif.unread : undefined,
    avatar,
    icon: NOTIFICATION_ICONS.includes(icon as NotificationIcon) ? (icon as NotificationIcon) : undefined,
    cta: asNullableString(notif.cta) ?? undefined,
    cta2: asNullableString(notif.cta2) ?? undefined,
    group: asNullableString(notif.group) ?? undefined,
    refId: asNullableString(notif.refId) ?? undefined,
  }
}

function normalizeNotifications(value: unknown): Notification[] {
  const source = isRecord(value) ? value.items ?? value.notifications ?? value.content : value
  return asArray(source).map(normalizeNotification)
}

function normalizeSummary(value: unknown): DashboardSummary {
  const summary = isRecord(value) ? value : {}
  return {
    activeEvents: asNumber(summary.activeEvents ?? summary.eventsActive),
    totalCheckins: asNumber(summary.totalCheckins ?? summary.checkins),
    activeVenues: asNumber(summary.activeVenues ?? summary.venuesActive),
    topZone: asString(summary.topZone ?? summary.zone, '-'),
    totalPresentNow: asNumber(summary.totalPresentNow ?? summary.presentNow),
  }
}

function normalizeLivePresence(value: unknown): DashboardLivePresence[] {
  return asArray(value).filter(isRecord).map((row) => ({
    venueId: asString(row.venueId ?? row.id, asString(row.venueName ?? row.name, 'venue')),
    venueName: asString(row.venueName ?? row.name, 'Venue'),
    count: asNumber(row.count ?? row.present ?? row.headcount),
  }))
}

function normalizeAttendeesByEvent(value: unknown): DashboardAttendeesByEvent[] {
  return asArray(value).filter(isRecord).map((row) => ({
    eventId: asString(row.eventId ?? row.id, asString(row.eventName ?? row.name, 'event')),
    eventName: asString(row.eventName ?? row.name, 'Evento'),
    count: asNumber(row.count ?? row.attendees ?? row.checkins),
    capacity: row.capacity === undefined ? undefined : asNumber(row.capacity),
  }))
}

function normalizeEventsByZone(value: unknown): DashboardEventsByZone[] {
  return asArray(value).filter(isRecord).map((row) => ({
    zone: asString(row.zone ?? row.name, 'Zona'),
    count: asNumber(row.count ?? row.events),
  }))
}

function normalizeGenresByDate(value: unknown): DashboardGenresByDate[] {
  return asArray(value).filter(isRecord).map((row) => ({
    date: asString(row.date, 'HOY'),
    genres: asArray(row.genres).filter(isRecord).map((genre) => ({
      name: asString(genre.name ?? genre.genre, 'genre'),
      count: asNumber(genre.count),
    })),
  }))
}

function normalizeCheckinPeaks(value: unknown): DashboardCheckinPeak[] {
  return asArray(value).filter(isRecord).map((row) => ({
    time: asString(row.time ?? row.hour, '--:--'),
    count: asNumber(row.count ?? row.checkins),
  }))
}

async function dashboardSection<T>(
  path: string,
  fallback: T,
  normalize: (value: unknown) => T,
  token?: string,
): Promise<ApiResult<T>> {
  try {
    // /api/dashboard/** ahora exige rol VENUE_OWNER/ADMIN → mandamos el Bearer si lo tenemos
    const raw = token ? await apiGetAuth<unknown>(path, token) : await apiGet<unknown>(path)
    return { data: normalize(raw) }
  } catch (err) {
    const { message, status } = apiErrorMessage(err)
    return { data: fallback, error: message, status, isFallback: true }
  }
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
  return normalizeEventPage(await apiGet<unknown>(`/api/events/feed?${params}`))
}

export const getLive = async () => normalizeEvents(await apiGet<unknown>('/api/events/live'))

// eventos cerca de una coordenada (default: centro de Buenos Aires) — usado por el mapa.
// pega a /api/events/nearby, que devuelve cada evento con su location {lat, lon} real.
export async function getNearby(
  lat = -34.605,
  lon = -58.42,
  radiusKm = 8,
): Promise<ApiResult<CacheEvent[]>> {
  try {
    const params = new URLSearchParams({ lat: String(lat), lon: String(lon), radiusKm: String(radiusKm) })
    return { data: normalizeEvents(await apiGet<unknown>(`/api/events/nearby?${params}`)) }
  } catch (err) {
    const { message, status } = apiErrorMessage(err)
    return { data: mockEvents(), error: message, status, isFallback: true }
  }
}

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

// anotarse a un evento — POST /api/checkin (CheckinService orquesta redis/neo4j/cassandra).
// el userId sale del JWT (@AuthenticationPrincipal), el body sólo lleva el eventId
export function checkInToEvent(eventId: string, token: string): Promise<void> {
  return apiPostAuth<void>('/api/checkin', { eventId }, token)
}

// salir del venue — DELETE /api/checkin/{eventId} (saca presencia, conserva la anotación)
export function checkOutFromEvent(eventId: string, token: string): Promise<void> {
  return apiDeleteAuth<void>(`/api/checkin/${eventId}`, token)
}

export async function getCheckInStatus(eventId: string, token: string): Promise<boolean> {
  const data = await apiGetAuth<{ isAttending?: boolean }>(`/api/checkin/${eventId}/status`, token)
  return data.isAttending === true
}

export function cancelEventAttendance(eventId: string, token: string): Promise<void> {
  return apiDeleteAuth<void>(`/api/checkin/${eventId}/attendance`, token)
}

// una entrada del historial de check-ins del user (cassandra, más recientes primero)
export type CheckinHistoryItem = {
  checkedAt: string
  eventId: string | null
  venueId: string | null
  venueName: string | null
  genre: string | null
  city: string | null
}

// historial de check-ins del user autenticado — GET /api/checkin/history
export async function getCheckinHistory(token: string, limit = 20): Promise<CheckinHistoryItem[]> {
  try {
    const rows = await apiGetAuth<CheckinHistoryItem[]>(`/api/checkin/history?limit=${limit}`, token)
    return Array.isArray(rows) ? rows : []
  } catch {
    return []
  }
}

// ───────────────────────── merchant (VENUE_OWNER) ─────────────────────────

// campos editables de un evento por el merchant (el backend setea hostUserId)
export type EventInput = {
  name: string
  venueId?: string | null
  venueName: string
  city: string
  startsAt: string // ISO
  endsAt: string // ISO
  genres: string[]
  price: number
  capacity: number
  description?: string
  status?: string // upcoming | live | finished
}

// eventos creados por el merchant autenticado — GET /api/events/mine (rol VENUE_OWNER/ADMIN)
export async function getMyEvents(token: string): Promise<CacheEvent[]> {
  return normalizeEvents(await apiGetAuth<unknown>('/api/events/mine', token))
}

// crear evento — POST /api/events
export async function createEvent(input: EventInput, token: string): Promise<CacheEvent> {
  return normalizeEvent(await apiPostAuth<unknown>('/api/events', input, token))
}

// editar evento propio — PUT /api/events/{id} (403 si es ajeno)
export async function updateEvent(id: string, input: EventInput, token: string): Promise<CacheEvent> {
  return normalizeEvent(await apiPutAuth<unknown>(`/api/events/${id}`, token, input))
}

export type Venue = {
  venueId: string
  name: string
  address: string | null
  city: string | null
  lat: number | null
  lon: number | null
  capacity: number
  tags: string[]
}

function normalizeVenue(raw: unknown): Venue {
  const v = isRecord(raw) ? raw : {}
  return {
    venueId: asString(v.venueId),
    name: asString(v.name, 'mi venue'),
    address: asNullableString(v.address),
    city: asNullableString(v.city),
    lat: typeof v.lat === 'number' ? v.lat : null,
    lon: typeof v.lon === 'number' ? v.lon : null,
    capacity: asNumber(v.capacity),
    tags: Array.isArray(v.tags) ? v.tags.filter((t): t is string => typeof t === 'string') : [],
  }
}

export type VenueTrend = { date: string; hour: number; checkinCount: number; uniqueUsers: number }

// tendencias horarias de un venue (cassandra) — solo VENUE_OWNER/ADMIN
export async function getVenueTrends(venueId: string, token: string, limit = 168): Promise<VenueTrend[]> {
  try {
    const params = new URLSearchParams({ limit: String(limit) })
    const data = await apiGetAuth<unknown>(`/api/venues/${venueId}/trends?${params}`, token)
    return asArray(data).map((row) => {
      const r = isRecord(row) ? row : {}
      return {
        date: asString(r.date),
        hour: asNumber(r.hour),
        checkinCount: asNumber(r.checkinCount),
        uniqueUsers: asNumber(r.uniqueUsers),
      }
    })
  } catch {
    return []
  }
}

// venue por id — GET /api/venues/{id}
export async function getVenueById(venueId: string): Promise<Venue | null> {
  try {
    return normalizeVenue(await apiGet<unknown>(`/api/venues/${venueId}`))
  } catch (err) {
    if (err instanceof ApiError && err.status === 404) return null
    throw err
  }
}

// datos para crear/asignar el venue del merchant
export type VenueInput = {
  name: string
  address?: string
  city: string
  capacity: number
  tags?: string[]
}

// crea el venue y lo vincula a la cuenta del merchant — POST /api/venues
export async function createVenue(input: VenueInput, token: string): Promise<Venue> {
  return normalizeVenue(await apiPostAuth<unknown>('/api/venues', input, token))
}

// venues de una ciudad — GET /api/venues?city= (con fallback para no romper el panel admin)
export async function getVenuesByCity(city = 'buenos aires'): Promise<ApiResult<Venue[]>> {
  try {
    const raw = await apiGet<unknown>(`/api/venues?city=${encodeURIComponent(city)}`)
    return { data: asArray(raw).map(normalizeVenue) }
  } catch (err) {
    const { message, status } = apiErrorMessage(err)
    return { data: [], error: message, status, isFallback: true }
  }
}

// alias para que admin.tsx pueda importar `CacheVenue`
export type CacheVenue = Venue

export type AdminMongoData = {
  events: ApiResult<CacheEvent[]>
  venues: ApiResult<CacheVenue[]>
  users: ApiResult<{ canList: boolean; note: string; availableEndpoints: string[] }>
}

export async function getAdminMongoData(city = 'buenos aires'): Promise<AdminMongoData> {
  const [eventsResult, venuesResult] = await Promise.all([
    getEvents(city, undefined, 50),
    getVenuesByCity(city),
  ])
  return {
    events: eventsResult,
    venues: venuesResult,
    users: {
      data: {
        canList: false,
        note: 'El endpoint de usuarios no expone listado (privacidad). Solo existe /api/users/me y /api/users/{handle}.',
        availableEndpoints: ['GET /api/users/me', 'GET /api/users/{handle}'],
      },
    },
  }
}

// clima actual — pipeline Open-Meteo → kafka → redis, expuesto en /api/weather
export type Weather = {
  city: string
  time: string
  temperature: number
  humidity: number
  precipitation: number
  weatherCode: number
  windSpeed: number
}

// código WMO → emoji + etiqueta corta (https://open-meteo.com/en/docs)
export function weatherGlyph(code: number): { icon: string; label: string } {
  if (code === 0) return { icon: '☀️', label: 'despejado' }
  if (code <= 2) return { icon: '🌤️', label: 'algo nublado' }
  if (code === 3) return { icon: '☁️', label: 'nublado' }
  if (code <= 48) return { icon: '🌫️', label: 'niebla' }
  if (code <= 67) return { icon: '🌧️', label: 'lluvia' }
  if (code <= 77) return { icon: '🌨️', label: 'nieve' }
  if (code <= 82) return { icon: '🌦️', label: 'chaparrones' }
  if (code <= 99) return { icon: '⛈️', label: 'tormenta' }
  return { icon: '🌡️', label: 'clima' }
}

// null si el backend aún no publicó (204) o está offline — el header lo omite
export async function getWeather(city?: string): Promise<Weather | null> {
  try {
    const path = city ? `/api/weather?city=${encodeURIComponent(city)}` : '/api/weather'
    const data = await apiGet<Weather | undefined>(path)
    return data ?? null
  } catch {
    return null
  }
}

// pings del usuario autenticado — GET /api/notifications (cualquier rol autenticado).
// sin token no hay a quién consultar → caemos directo al mock.
export async function getNotifications(token?: string): Promise<ApiResult<Notification[]>> {
  if (!token) {
    return { data: mockNotifications(), isFallback: true }
  }
  try {
    const data = await apiGetAuth<unknown>('/api/notifications', token)
    return { data: normalizeNotifications(data) }
  } catch (err) {
    const fallback = mockNotifications()
    const { message, status } = apiErrorMessage(err)
    return { data: fallback, error: message, status, isFallback: true }
  }
}

// stream SSE de pings en vivo. EventSource no manda headers → el token va por query param.
// el backend emite eventos nombrados "ping" con el payload de la notificación.
export function subscribeNotifications(token: string, onPing: (n: Notification) => void): EventSource {
  const es = new EventSource(`${API}/api/notifications/stream?token=${encodeURIComponent(token)}`)
  es.addEventListener('ping', (e) => {
    try {
      onPing(normalizeNotification(JSON.parse((e as MessageEvent).data)))
    } catch {
      /* payload inválido — lo ignoramos */
    }
  })
  return es
}

// marcar todas las notifs del user como leídas — PUT /api/notifications/read
export function markNotificationsRead(token: string): Promise<void> {
  return apiPutAuth<void>('/api/notifications/read', token)
}

// marcar una notif puntual como leída — PUT /api/notifications/{id}/read
export function markNotificationRead(id: string, token: string): Promise<void> {
  return apiPutAuth<void>(`/api/notifications/${encodeURIComponent(id)}/read`, token)
}

// amigos del usuario autenticado (grafo neo4j) — para la franja "tus amigos"
export type Friend = {
  userId: string
  displayName: string
  handle: string
  avatarColor: string
}

// "personas que quizás conozcas": perfil + amigos en común (amigos de amigos)
export type FriendSuggestion = {
  user: Friend
  mutualFriends: number
}

// UserProfileDTO crudo → Friend
function normalizeFriend(value: unknown): Friend {
  const u = isRecord(value) ? value : {}
  return {
    userId: asString(u.userId),
    displayName: asString(u.displayName, 'amigo'),
    handle: asString(u.handle),
    avatarColor: asString(u.avatarColor, '#E8E6DF'),
  }
}

function normalizeFriends(value: unknown): Friend[] {
  return asArray(value).map(normalizeFriend).filter((f) => f.userId)
}

// amigos confirmados — GET /api/friends
export async function getFriends(token: string): Promise<Friend[]> {
  try {
    return normalizeFriends(await apiGetAuth<unknown>('/api/friends', token))
  } catch {
    return []
  }
}

// solicitudes de amistad recibidas, pendientes — GET /api/friends/requests
export async function getPendingRequests(token: string): Promise<Friend[]> {
  try {
    return normalizeFriends(await apiGetAuth<unknown>('/api/friends/requests', token))
  } catch {
    return []
  }
}

// solicitudes enviadas por el user (pendientes) — GET /api/friends/requests/sent
export async function getSentRequests(token: string): Promise<Friend[]> {
  try {
    return normalizeFriends(await apiGetAuth<unknown>('/api/friends/requests/sent', token))
  } catch {
    return []
  }
}

// cancelar una solicitud que mandé a targetUserId — DELETE /api/friends/request/{id}/cancel
export function cancelFriendRequest(targetUserId: string, token: string): Promise<void> {
  return apiDeleteAuth<void>(`/api/friends/request/${targetUserId}/cancel`, token)
}

// personas que quizás conozcas (amigos de amigos) — GET /api/recommendations/people
export async function getPeopleYouMayKnow(token: string, limit = 10): Promise<FriendSuggestion[]> {
  try {
    const raw = await apiGetAuth<unknown>(`/api/recommendations/people?limit=${limit}`, token)
    return asArray(raw).filter(isRecord).map((s) => ({
      user: normalizeFriend(s.user),
      mutualFriends: asNumber(s.mutualFriends),
    })).filter((s) => s.user.userId)
  } catch {
    return []
  }
}

// buscar usuarios por @handle o nombre — GET /api/users/search?q= (para agregar amigos)
export async function searchUsers(q: string, token: string): Promise<Friend[]> {
  try {
    return normalizeFriends(await apiGetAuth<unknown>(`/api/users/search?q=${encodeURIComponent(q)}`, token))
  } catch {
    return []
  }
}

// enviar solicitud de amistad — POST /api/friends/request { targetUserId }
export function sendFriendRequest(targetUserId: string, token: string): Promise<void> {
  return apiPostAuth<void>('/api/friends/request', { targetUserId }, token)
}

// aceptar la solicitud que mandó requesterId — PUT /api/friends/request/{id}/accept
export function acceptFriendRequest(requesterId: string, token: string): Promise<void> {
  return apiPutAuth<void>(`/api/friends/request/${requesterId}/accept`, token)
}

// rechazar la solicitud que mandó requesterId — DELETE /api/friends/request/{id}
export function rejectFriendRequest(requesterId: string, token: string): Promise<void> {
  return apiDeleteAuth<void>(`/api/friends/request/${requesterId}`, token)
}

// deshacer amistad con friendId — DELETE /api/friends/{id}
export function removeFriend(friendId: string, token: string): Promise<void> {
  return apiDeleteAuth<void>(`/api/friends/${friendId}`, token)
}

// amigos del user que asisten a un evento — GET /api/events/{id}/friends-attending.
// alimenta el badge real de "amigos acá" en los pines del mapa.
export async function getFriendsAttending(eventId: string, token: string): Promise<Friend[]> {
  try {
    return normalizeFriends(await apiGetAuth<unknown>(`/api/events/${eventId}/friends-attending`, token))
  } catch {
    return []
  }
}

export async function getDashboardData(token?: string): Promise<ApiResult<DashboardData>> {
  const fallback = mockDashboard()
  const [summary, attendeesByEvent, eventsByZone, genresByDate, checkinPeaks, livePresence] = await Promise.all([
    dashboardSection('/api/dashboard/summary', fallback.summary, normalizeSummary, token),
    dashboardSection('/api/dashboard/attendees-by-event', fallback.attendeesByEvent, normalizeAttendeesByEvent, token),
    dashboardSection('/api/dashboard/events-by-zone', fallback.eventsByZone, normalizeEventsByZone, token),
    dashboardSection('/api/dashboard/genres-by-date', fallback.genresByDate, normalizeGenresByDate, token),
    dashboardSection('/api/dashboard/checkin-peaks', fallback.checkinPeaks, normalizeCheckinPeaks, token),
    dashboardSection('/api/dashboard/live-presence', fallback.livePresence, normalizeLivePresence, token),
  ])
  const fallbackResult = [summary, attendeesByEvent, eventsByZone, genresByDate, checkinPeaks, livePresence].find((result) => result.isFallback)

  return {
    data: {
      summary: summary.data,
      attendeesByEvent: attendeesByEvent.data,
      eventsByZone: eventsByZone.data,
      genresByDate: genresByDate.data,
      checkinPeaks: checkinPeaks.data,
      livePresence: livePresence.data,
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
      isAttending: false,
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
      isAttending: false,
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
      isAttending: false,
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
      isAttending: false,
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
      totalPresentNow: 318,
    },
    livePresence: [
      { venueId: 'mock-niceto', venueName: 'Niceto Club', count: 142 },
      { venueId: 'mock-crobar', venueName: 'Crobar', count: 96 },
      { venueId: 'mock-bahrein', venueName: 'Bahrein', count: 48 },
      { venueId: 'mock-under', venueName: 'Under Club', count: 32 },
    ],
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
