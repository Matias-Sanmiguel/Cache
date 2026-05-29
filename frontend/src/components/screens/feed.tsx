import { Tag } from '@/components/ui/tag'
import { Dot } from '@/components/ui/dot'
import { Avatar, AvatarStack } from '@/components/ui/avatar'
import { Icon } from '@/components/ui/icon'
import { PhotoBG } from '@/components/ui/photo-bg'
import { FlyerBG } from '@/components/ui/flyer-bg'

const MOCK_PEOPLE = [
  { name: 'Mati', online: true,  color: '#FF2E2E' },
  { name: 'Jule', online: true,  color: '#D4FF1A' },
  { name: 'Cami', online: false, color: '#7B61FF' },
  { name: 'Tomi', online: true,  color: '#00FF88' },
  { name: 'Lula', online: false, color: '#E8E6DF' },
  { name: 'Naco', online: true,  color: '#FF8A00' },
  { name: 'Vico', online: false, color: '#FF2E2E' },
  { name: 'Ezeq', online: true,  color: '#7B61FF' },
]

function FeedHeader() {
  return (
    <div style={{ padding: '12px 18px 16px', borderBottom: '1px solid var(--line)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div className="font-display" style={{ fontSize: 28, color: 'var(--bone)' }}>caché</div>
        <div style={{ display: 'flex', gap: 14, alignItems: 'center', color: 'var(--bone)' }}>
          <Icon name="search" size={20} />
          <div style={{ position: 'relative' }}>
            <Icon name="bell" size={20} />
            <span style={{ position: 'absolute', top: -2, right: -2, width: 7, height: 7, borderRadius: '50%', background: 'var(--acid)' }} />
          </div>
        </div>
      </div>
      <div style={{ display: 'flex', gap: 8, marginTop: 14, alignItems: 'center' }}>
        <Tag kind="acid">esta noche</Tag>
        <Tag kind="ghost">finde</Tag>
        <Tag kind="ghost">mis amigos</Tag>
        <Tag kind="ghost">cerca</Tag>
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginTop: 18 }}>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--mute)', letterSpacing: '0.14em' }}>VIE 02 MAY · 02:47 · BS AS</span>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--pulse)', letterSpacing: '0.14em', display: 'flex', alignItems: 'center', gap: 6 }}>
          <Dot color="var(--pulse)" size={5} /> 12 ACTIVAS
        </span>
      </div>
    </div>
  )
}

function FeedFriendStrip() {
  return (
    <div style={{ padding: '14px 16px', borderBottom: '1px solid var(--line)', background: 'var(--ink-2)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 12 }}>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.16em' }}>◉ AHORA / TUS AMIGOS</span>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>VER TODOS</span>
      </div>
      <div className="no-scroll" style={{ display: 'flex', gap: 14, overflowX: 'auto' }}>
        {MOCK_PEOPLE.slice(0, 6).map((p, i) => (
          <div key={i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, minWidth: 56 }}>
            <Avatar name={p.name} size={44} color={p.color} online={p.online} />
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)' }}>{p.name.toLowerCase()}</span>
            {i < 3 && <span className="font-mono" style={{ fontSize: 8, color: 'var(--pulse)', letterSpacing: '0.08em' }}>NICETO</span>}
          </div>
        ))}
      </div>
    </div>
  )
}

function FeedCardHero() {
  return (
    <div style={{ position: 'relative', borderBottom: '1px solid var(--line)' }}>
      <div style={{ position: 'relative' }}>
        <PhotoBG height={260} hue="red" />
        <div style={{ position: 'absolute', top: 14, left: 14, right: 14, display: 'flex', justifyContent: 'space-between' }}>
          <Tag kind="acid">livenow</Tag>
          <Tag kind="bone">cap 78%</Tag>
        </div>
        <div style={{ position: 'absolute', bottom: 14, left: 14, right: 14, color: 'var(--bone)' }}>
          <div className="font-mono" style={{ fontSize: 10, letterSpacing: '0.18em', opacity: 0.85 }}>NICETO · PALERMO · CC EUR15</div>
          <div className="font-display" style={{ fontSize: 38, marginTop: 4, lineHeight: 0.95 }}>
            SUB00<span style={{ color: 'var(--acid)' }}>.</span>
          </div>
          <div className="font-editorial-italic" style={{ fontSize: 17, color: 'var(--bone)', opacity: 0.85, marginTop: 2 }}>
            cierre de temporada — techno experimental
          </div>
        </div>
      </div>
      <div style={{ padding: '14px 16px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <AvatarStack people={MOCK_PEOPLE.slice(0, 5)} size={26} />
          <div style={{ display: 'flex', flexDirection: 'column' }}>
            <span style={{ fontSize: 13, color: 'var(--bone)' }}>jule, mati y 3 más</span>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--pulse)', letterSpacing: '0.1em', display: 'flex', alignItems: 'center', gap: 5 }}>
              <Dot color="var(--pulse)" size={5} /> 2 EN EL VENUE
            </span>
          </div>
        </div>
        <button
          style={{
            background: 'var(--acid)',
            color: 'var(--ink)',
            border: 'none',
            padding: '12px 16px',
            fontFamily: 'var(--font-mono)',
            fontSize: 11,
            letterSpacing: '0.14em',
            textTransform: 'uppercase',
            fontWeight: 600,
            display: 'flex',
            alignItems: 'center',
            gap: 8,
          }}
        >
          ANOTARME <Icon name="arrow" size={14} stroke={2} />
        </button>
      </div>
    </div>
  )
}

function FeedCardFlyer() {
  return (
    <div style={{ borderBottom: '1px solid var(--line)' }}>
      <FlyerBG variant={0} height={220}>
        <div style={{ display: 'flex', justifyContent: 'space-between' }}>
          <span className="font-mono" style={{ fontSize: 9, letterSpacing: '0.18em' }}>FIESTA PRIVADA · 18+</span>
          <span className="font-mono" style={{ fontSize: 9, letterSpacing: '0.18em' }}>CONFIDENCIAL</span>
        </div>
        <div>
          <div className="font-display" style={{ fontSize: 56, lineHeight: 0.85, mixBlendMode: 'difference' as const }}>
            NO ES UNA<br />FIESTA
          </div>
          <div className="font-editorial-italic" style={{ fontSize: 18, color: 'var(--ink)', marginTop: 8 }}>
            (es una pregunta.)
          </div>
        </div>
      </FlyerBG>
      <div style={{ padding: '14px 16px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
          <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.12em' }}>SÁB 03 · 23:30 → ?</span>
          <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.12em' }}>CHACARITA</span>
        </div>
        <div className="font-display" style={{ fontSize: 22, color: 'var(--bone)' }}>casa pelícano</div>
        <div style={{ fontSize: 12, color: 'var(--soft)', marginTop: 4 }}>el host suelta la dirección 1h antes.</div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 14 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <AvatarStack people={MOCK_PEOPLE.slice(2, 7)} size={22} max={3} />
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.06em' }}>cami + 14</span>
          </div>
          <button
            style={{
              background: 'transparent',
              color: 'var(--bone)',
              border: '1px solid var(--line-2)',
              padding: '8px 14px',
              fontFamily: 'var(--font-mono)',
              fontSize: 10,
              letterSpacing: '0.14em',
              textTransform: 'uppercase',
            }}
          >
            SOLICITAR
          </button>
        </div>
      </div>
    </div>
  )
}

type CompactCardData = {
  title: string
  venue: string
  time: string
  hue?: 'red' | 'blue' | 'green' | 'purple' | 'amber'
  flyer?: boolean
  flyerVariant?: number
  flyerWord?: string
  people: typeof MOCK_PEOPLE
  extra: number
  urgent?: boolean
  urgentText?: string
}

function FeedCardCompact({ data }: { data: CompactCardData }) {
  return (
    <div style={{ padding: '14px 16px', borderBottom: '1px solid var(--line)', display: 'flex', gap: 14, alignItems: 'flex-start' }}>
      <div style={{ width: 64, height: 64, flexShrink: 0, position: 'relative' }}>
        {data.flyer ? (
          <FlyerBG variant={data.flyerVariant} height={64}>
            <div
              className="font-display"
              style={{ fontSize: 11, lineHeight: 1, position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', textAlign: 'center', padding: 4 }}
            >
              {data.flyerWord}
            </div>
          </FlyerBG>
        ) : (
          <PhotoBG height={64} hue={data.hue} />
        )}
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
          <div className="font-display" style={{ fontSize: 18, color: 'var(--bone)' }}>{data.title}</div>
          <span
            className="font-mono"
            style={{ fontSize: 10, color: data.urgent ? 'var(--blood)' : 'var(--soft)', letterSpacing: '0.1em' }}
          >
            {data.time}
          </span>
        </div>
        <div style={{ fontSize: 12, color: 'var(--soft)', marginTop: 2 }}>{data.venue}</div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 8 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <AvatarStack people={data.people} size={18} max={3} />
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--mute)' }}>+{data.extra}</span>
          </div>
          {data.urgent && (
            <span className="font-mono cache-blink" style={{ fontSize: 9, color: 'var(--blood)', letterSpacing: '0.14em' }}>
              ● {data.urgentText}
            </span>
          )}
        </div>
      </div>
    </div>
  )
}

export function FeedScreen() {
  return (
    <div className="no-scroll" style={{ height: '100dvh', overflowY: 'auto', paddingBottom: 72 }}>
      <FeedHeader />
      <FeedFriendStrip />
      <FeedCardHero />
      <FeedCardFlyer />
      <div style={{ padding: '14px 16px 8px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.16em' }}>— PORQUE FUISTE A TRESDE —</span>
        <div style={{ flex: 1, height: 1, background: 'var(--line)' }} />
      </div>
      <FeedCardCompact data={{
        title: 'kernel', venue: 'crobar · costanera', time: '01:00',
        hue: 'green', people: MOCK_PEOPLE.slice(1, 4), extra: 22,
      }} />
      <FeedCardCompact data={{
        title: 'humedal', venue: 'galpón sin nombre', time: '23:30',
        flyer: true, flyerVariant: 2, flyerWord: 'HUM',
        people: MOCK_PEOPLE.slice(3, 6), extra: 8,
        urgent: true, urgentText: '12 LUGARES',
      }} />
      <FeedCardCompact data={{
        title: 'club berlín', venue: 'amerika · almagro', time: '00:00',
        hue: 'amber', people: MOCK_PEOPLE.slice(0, 3), extra: 41,
      }} />
      <div style={{ padding: 24, textAlign: 'center' }}>
        <span className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)' }}>(eso es todo por ahora.)</span>
      </div>
    </div>
  )
}
