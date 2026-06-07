import Link from 'next/link'
import { Tag } from '@/components/ui/tag'
import { Dot } from '@/components/ui/dot'
import { Icon } from '@/components/ui/icon'
import { PhotoBG } from '@/components/ui/photo-bg'
import { PlaceholderBadge } from '@/components/ui/placeholder-badge'
import { FriendStrip } from '@/components/social/friend-strip'
import { EventFriendsStack } from '@/components/social/event-friends'
import { FeedActions } from '@/components/feed/feed-actions'
import { EventCTALink } from '@/components/screens/event-cta-link'
import {
  getFeed,
  getLive,
  getEvents,
  getWeather,
  weatherGlyph,
  fmtTime,
  fmtDate,
  fmtPrice,
  capacityPct,
  type CacheEvent,
  type Weather,
} from '@/lib/api'

const HUES = ['red', 'green', 'purple', 'amber', 'blue'] as const
const GENRES = ['techno', 'house', 'disco', 'bass', 'minimal', 'melodic']
const PAGE_SIZE = 4

// imagen real si existe; si no, PhotoBG marcado como placeholder
function EventImage({ event, height, hue }: { event: CacheEvent; height: number; hue?: (typeof HUES)[number] }) {
  if (event.imageUrl) {
    // eslint-disable-next-line @next/next/no-img-element
    return <img src={event.imageUrl} alt={event.name} style={{ width: '100%', height, objectFit: 'cover', display: 'block' }} />
  }
  return (
    <span style={{ position: 'relative', display: 'block' }}>
      <PlaceholderBadge label="SIN IMG" style={{ top: 6, left: 6, right: 'auto', padding: '1px 5px' }} />
      <PhotoBG height={height} hue={hue} />
    </span>
  )
}

function AccessTag({ accessType }: { accessType: string | null }) {
  if (!accessType || accessType === 'public') return null
  return <Tag kind="blood">{accessType === 'invite-only' ? 'invite' : 'privada'}</Tag>
}

function WeatherBadge({ weather }: { weather: Weather | null }) {
  if (!weather) return null
  const { icon, label } = weatherGlyph(weather.weatherCode)
  return (
    <span
      className="font-mono"
      title={`${label} · ${weather.humidity}% humedad · ${weather.precipitation}mm`}
      style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.12em', display: 'inline-flex', alignItems: 'center', gap: 5 }}
    >
      {icon} {Math.round(weather.temperature)}°
    </span>
  )
}

function FeedHeader({ liveCount, genre, weather }: { liveCount: number; genre?: string; weather: Weather | null }) {
  const now = new Date()
  return (
    <div style={{ padding: '12px 18px 16px', borderBottom: '1px solid var(--line)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>caché</div>
        <FeedActions />
      </div>

      {/* filtro por género — real, pega a mongo via ?genre= */}
      <div className="no-scroll" style={{ display: 'flex', gap: 8, marginTop: 14, alignItems: 'center', overflowX: 'auto' }}>
        <Link href="/" style={{ textDecoration: 'none' }}>
          <Tag kind={!genre ? 'acid' : 'ghost'}>todos</Tag>
        </Link>
        {GENRES.map((g) => (
          <Link key={g} href={`/?genre=${g}`} style={{ textDecoration: 'none' }}>
            <Tag kind={genre === g ? 'acid' : 'ghost'}>{g}</Tag>
          </Link>
        ))}
      </div>

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginTop: 18 }}>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--mute)', letterSpacing: '0.14em', display: 'flex', alignItems: 'center', gap: 8 }}>
          {fmtDate(now.toISOString())} · {fmtTime(now.toISOString())} · BS AS
          <WeatherBadge weather={weather} />
        </span>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--pulse)', letterSpacing: '0.14em', display: 'flex', alignItems: 'center', gap: 6 }}>
          <Dot color="var(--pulse)" size={5} /> {liveCount} ACTIVAS
        </span>
      </div>
    </div>
  )
}

function HeroCard({ event }: { event: CacheEvent }) {
  const pct = capacityPct(event)
  const live = event.status === 'live'
  return (
    <Link className="cache-card cache-event-card" href={`/evento/${event.id}`} style={{ display: 'block', textDecoration: 'none', position: 'relative', borderBottom: '1px solid var(--line)' }}>
      <div style={{ position: 'relative' }}>
        <EventImage event={event} height={260} hue="red" />
        <div style={{ position: 'absolute', top: 14, left: 14, right: 14, display: 'flex', justifyContent: 'space-between', gap: 8 }}>
          <Tag kind="acid">{live ? 'livenow' : 'próximo'}</Tag>
          <div style={{ display: 'flex', gap: 8 }}>
            <AccessTag accessType={event.accessType} />
            <Tag kind="bone">cap {pct}%</Tag>
          </div>
        </div>
        <div style={{ position: 'absolute', bottom: 14, left: 14, right: 14, color: 'var(--bone)' }}>
          <div className="font-mono" style={{ fontSize: 10, letterSpacing: '0.18em', opacity: 0.85 }}>
            {event.venueName.toUpperCase()} · {event.city.toUpperCase()}
          </div>
          <div className="font-display" style={{ fontSize: 38, marginTop: 4, lineHeight: 0.95 }}>
            {event.name}<span style={{ color: 'var(--acid)' }}>.</span>
          </div>
          <div className="font-editorial-italic" style={{ fontSize: 17, color: 'var(--bone)', opacity: 0.85, marginTop: 2 }}>
            {event.description}
          </div>
        </div>
      </div>
        <div style={{ padding: '14px 16px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <EventFriendsStack eventId={event.id} size={26} max={5} />
            <div style={{ display: 'flex', flexDirection: 'column' }}>
              <span style={{ fontSize: 13, color: 'var(--bone)' }}>{event.attendeeCount} anotados</span>
              <span className="font-mono" style={{ fontSize: 10, color: 'var(--pulse)', letterSpacing: '0.1em', display: 'flex', alignItems: 'center', gap: 5 }}>
                <Dot color="var(--pulse)" size={5} /> {event.genres.slice(0, 2).join(' · ')}
              </span>
            </div>
          </div>
          {event.price > 0 && (
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.1em' }}>
              {fmtPrice(event.price)}
            </span>
          )}
          <EventCTALink eventId={event.id} asLink={false} />
      </div>
    </Link>
  )
}

function CompactCard({ event, hue }: { event: CacheEvent; hue: (typeof HUES)[number] }) {
  return (
    <Link className="cache-card cache-event-card" href={`/evento/${event.id}`} style={{ display: 'flex', textDecoration: 'none', padding: '14px 16px', borderBottom: '1px solid var(--line)', gap: 14, alignItems: 'flex-start' }}>
      <div style={{ width: 64, height: 64, flexShrink: 0, position: 'relative', overflow: 'hidden' }}>
        <EventImage event={event} height={64} hue={hue} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 8 }}>
          <div className="font-display" style={{ fontSize: 18, color: 'var(--bone)' }}>{event.name}</div>
          <div style={{ display: 'flex', gap: 6, alignItems: 'center', flexShrink: 0 }}>
            <AccessTag accessType={event.accessType} />
            <span className="font-mono" style={{ fontSize: 10, color: event.status === 'live' ? 'var(--pulse)' : 'var(--soft)', letterSpacing: '0.1em' }}>
              {fmtTime(event.startsAt)}
            </span>
          </div>
        </div>
        <div style={{ fontSize: 12, color: 'var(--soft)', marginTop: 2 }}>{event.venueName.toLowerCase()} · {event.venueAddress.toLowerCase()}</div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 8 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <EventFriendsStack eventId={event.id} size={18} max={3} />
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--mute)' }}>+{event.attendeeCount}</span>
          </div>
          <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
            {event.price > 0 && (
              <span className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.1em' }}>
                {fmtPrice(event.price)}
              </span>
            )}
            <span className="font-mono" style={{ fontSize: 9, color: 'var(--soft)', letterSpacing: '0.1em' }}>
              {event.genres[0]?.toUpperCase()}
            </span>
          </div>
        </div>
      </div>
    </Link>
  )
}

export async function FeedScreen({ genre, page = 0 }: { genre?: string; page?: number }) {
  let live: CacheEvent[] = []
  let upcoming: CacheEvent[] = []
  let hasNext = false
  let error: string | null = null

  // clima no rompe el feed: getWeather ya devuelve null ante fallo/204
  const weather = await getWeather()

  try {
    const [liveRes, feedPage] = await Promise.all([getLive(), getFeed('buenos aires', genre, page, PAGE_SIZE)])
    live = genre ? liveRes.filter((e) => e.genres.includes(genre)) : liveRes
    upcoming = feedPage.items
    hasNext = feedPage.hasNext
  } catch (e) {
    error = e instanceof Error ? e.message : 'error desconocido'
    const fallback = await getEvents('buenos aires', genre, PAGE_SIZE)
    upcoming = fallback.data
  }

  // en página 0 mostramos los live arriba; en páginas siguientes solo el feed paginado
  const seen = new Set(live.map((e) => e.id))
  const events = page === 0 ? [...live, ...upcoming.filter((e) => !seen.has(e.id))] : upcoming
  const liveCount = live.length
  const [hero, ...rest] = events

  const qs = (p: number) => `/?${new URLSearchParams({ ...(genre ? { genre } : {}), page: String(p) })}`

  return (
    <div className="cache-screen" style={{ minHeight: '100dvh', paddingBottom: 88 }}>
      <FeedHeader liveCount={liveCount} genre={genre} weather={weather} />
      <FriendStrip />

      {error && (
        <div style={{ padding: 24, textAlign: 'center' }}>
          <div className="font-mono" style={{ fontSize: 11, color: 'var(--blood)', letterSpacing: '0.1em' }}>BACKEND OFFLINE</div>
          <div className="font-editorial-italic" style={{ fontSize: 15, color: 'var(--mute)', marginTop: 8 }}>{error}</div>
        </div>
      )}

      {!error && events.length === 0 && (
        <div style={{ padding: 24, textAlign: 'center' }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>
            {genre ? `(no hay eventos de ${genre}.)` : '(no hay eventos cargados.)'}
          </span>
        </div>
      )}

      {hero && <HeroCard event={hero} />}

      {rest.length > 0 && (
        <div style={{ padding: '14px 16px 8px', display: 'flex', alignItems: 'center', gap: 10 }}>
          <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.16em' }}>
            — {genre ? `MÁS ${genre.toUpperCase()}` : 'MÁS EVENTOS'} —
          </span>
          <div style={{ flex: 1, height: 1, background: 'var(--line)' }} />
        </div>
      )}

      {rest.map((e, i) => (
        <CompactCard key={e.id} event={e} hue={HUES[i % HUES.length]} />
      ))}

      {/* paginación del feed */}
      {(hasNext || page > 0) && (
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '16px 18px 8px' }}>
          {page > 0 ? (
            <Link href={qs(page - 1)} className="font-mono cache-action" style={{ fontSize: 11, color: 'var(--soft)', letterSpacing: '0.14em', textDecoration: 'none', padding: '8px 0' }}>← ANTERIOR</Link>
          ) : <span />}
          <span className="font-mono" style={{ fontSize: 10, color: 'var(--mute)', letterSpacing: '0.1em' }}>PÁGINA {page + 1}</span>
          {hasNext ? (
            <Link href={qs(page + 1)} className="font-mono cache-action" style={{ fontSize: 11, color: 'var(--acid)', letterSpacing: '0.14em', textDecoration: 'none', padding: '8px 0' }}>VER MÁS →</Link>
          ) : <span />}
        </div>
      )}

      {events.length > 0 && (
        <div style={{ padding: 24, textAlign: 'center' }}>
          <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(eso es todo por ahora.)</span>
        </div>
      )}
    </div>
  )
}
