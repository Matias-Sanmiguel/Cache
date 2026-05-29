import Link from 'next/link'
import { Tag } from '@/components/ui/tag'
import { Dot } from '@/components/ui/dot'
import { Avatar } from '@/components/ui/avatar'
import { Icon } from '@/components/ui/icon'
import { PhotoBG } from '@/components/ui/photo-bg'

const FRIENDS = [
  { name: 'Jule', color: '#D4FF1A', state: 'in',      sub: 'llegó hace 12 min'        },
  { name: 'Mati', color: '#FF2E2E', state: 'on-way',  sub: 'en camino — eta 23:50'    },
  { name: 'Tomi', color: '#00FF88', state: 'in',      sub: 'llegó hace 4 min'         },
  { name: 'Cami', color: '#7B61FF', state: 'pending', sub: 'anotada — sin confirmar'  },
  { name: 'Naco', color: '#FF8A00', state: 'pending', sub: 'anotado — sin confirmar'  },
]

const LINEUP = [
  ['23:30', 'OPEN',  'Marsala b2b Lila'],
  ['01:00', 'PRIME', 'CRRDR · live'     ],
  ['03:00', 'PEAK',  'Sub00 residents'  ],
  ['05:00', 'CLOSE', 'Naty Sade'        ],
]

export function DetailScreen() {
  return (
    <div style={{ background: 'var(--ink)', position: 'relative', minHeight: '100dvh' }}>
      <div className="no-scroll" style={{ overflowY: 'auto', paddingBottom: 110 }}>

        {/* hero */}
        <div style={{ position: 'relative' }}>
          <PhotoBG height={340} hue="red" />
          <div style={{ position: 'absolute', top: 58, left: 14, right: 14, display: 'flex', justifyContent: 'space-between' }}>
            <Link
              href="/"
              style={{
                width: 36, height: 36,
                background: 'rgba(10,10,10,0.6)',
                backdropFilter: 'blur(12px)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                border: '1px solid var(--line)', color: 'var(--bone)',
              }}
            >
              <Icon name="back" size={18} />
            </Link>
            <div style={{ display: 'flex', gap: 8 }}>
              {(['share', 'heart'] as const).map((ic) => (
                <button
                  key={ic}
                  style={{
                    width: 36, height: 36, background: 'rgba(10,10,10,0.6)',
                    backdropFilter: 'blur(12px)', border: '1px solid var(--line)', color: 'var(--bone)',
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                  }}
                >
                  <Icon name={ic} size={16} />
                </button>
              ))}
            </div>
          </div>
          <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, background: 'linear-gradient(to top, var(--ink) 0%, transparent 100%)', padding: '60px 18px 16px' }}>
            <div className="font-mono" style={{ fontSize: 10, letterSpacing: '0.18em', color: 'var(--acid)' }}>● LIVE NOW · TECHNO</div>
            <div className="font-display" style={{ fontSize: 48, lineHeight: 0.92, marginTop: 6 }}>
              SUB00<span style={{ color: 'var(--acid)' }}>.</span>
            </div>
            <div className="font-editorial-italic" style={{ fontSize: 17, color: 'var(--soft)', marginTop: 4 }}>cierre de temporada</div>
          </div>
        </div>

        {/* meta */}
        <div style={{ padding: '16px 18px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14, borderBottom: '1px solid var(--line)' }}>
          {[
            { icon: 'clock'  as const, label: 'CUÁNDO',    value: 'VIE 02 MAY', sub: '23:30 → 06:00'         },
            { icon: 'pin'    as const, label: 'DÓNDE',     value: 'Niceto Club',sub: 'Cnel. Niceto Vega 5510' },
            { icon: 'people' as const, label: 'CAPACIDAD', value: '234 / 400',  sub: '78% lleno', urgent: true },
            { icon: 'fire'   as const, label: 'ENTRADA',   value: 'EUR 15',     sub: 'puerta + cupos online'   },
          ].map((m) => (
            <div key={m.label} style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <span className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.14em', display: 'flex', alignItems: 'center', gap: 6 }}>
                <Icon name={m.icon} size={11} stroke={1.6} /> {m.label}
              </span>
              <span className="font-display" style={{ fontSize: 18, color: m.urgent ? 'var(--blood)' : 'var(--bone)' }}>{m.value}</span>
              <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', letterSpacing: '0.04em' }}>{m.sub}</span>
            </div>
          ))}
        </div>

        {/* blurb */}
        <div style={{ padding: '20px 18px', borderBottom: '1px solid var(--line)' }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em', marginBottom: 10 }}>— SOBRE LA NOCHE</div>
          <p className="font-editorial" style={{ fontSize: 22, color: 'var(--bone)', lineHeight: 1.3 }}>
            Sub00 cierra temporada. Sin guest list, sin filtros — un sound system armado por Marsala y un line-up que se confirma a las 22:00.
          </p>
          <div style={{ display: 'flex', gap: 6, marginTop: 14, flexWrap: 'wrap' }}>
            <Tag>techno</Tag>
            <Tag>experimental</Tag>
            <Tag>residentes</Tag>
            <Tag kind="ghost">cash only</Tag>
            <Tag kind="ghost">smoking patio</Tag>
          </div>
        </div>

        {/* friends live */}
        <div style={{ padding: '20px 18px', borderBottom: '1px solid var(--line)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 14 }}>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em' }}>— TUS AMIGOS · 5 ANOTADOS</span>
            <span className="font-mono" style={{ fontSize: 10, color: 'var(--soft)', display: 'flex', alignItems: 'center', gap: 5 }}>
              <Dot color="var(--pulse)" size={5} /> 2 EN VENUE
            </span>
          </div>
          {FRIENDS.map((p, i) => (
            <div
              key={p.name}
              style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '10px 0', borderBottom: i < FRIENDS.length - 1 ? '1px dashed var(--line)' : 'none' }}
            >
              <Avatar name={p.name} size={36} color={p.color} online={p.state === 'in' || p.state === 'on-way'} />
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, color: 'var(--bone)' }}>{p.name.toLowerCase()}</div>
                <div
                  className="font-mono"
                  style={{
                    fontSize: 10,
                    color: p.state === 'in' ? 'var(--pulse)' : p.state === 'on-way' ? 'var(--bone)' : 'var(--mute)',
                    letterSpacing: '0.04em',
                  }}
                >
                  {p.sub}
                </div>
              </div>
              {p.state === 'in'      && <Tag kind="acid">EN VENUE</Tag>}
              {p.state === 'on-way'  && <Tag>EN CAMINO</Tag>}
              {p.state === 'pending' && <Tag kind="ghost">PENDIENTE</Tag>}
            </div>
          ))}
        </div>

        {/* lineup */}
        <div style={{ padding: '20px 18px', borderBottom: '1px solid var(--line)' }}>
          <div className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.14em', marginBottom: 14 }}>— LINE UP</div>
          {LINEUP.map(([time, slot, name], i) => (
            <div
              key={i}
              style={{ display: 'grid', gridTemplateColumns: '60px 70px 1fr', gap: 12, alignItems: 'baseline', padding: '10px 0', borderBottom: i < LINEUP.length - 1 ? '1px dashed var(--line)' : 'none' }}
            >
              <span className="font-mono" style={{ fontSize: 13, color: 'var(--bone)' }}>{time}</span>
              <span className="font-mono" style={{ fontSize: 9, color: 'var(--acid)', letterSpacing: '0.14em' }}>{slot}</span>
              <span className="font-display" style={{ fontSize: 16, color: 'var(--bone)' }}>{name}</span>
            </div>
          ))}
        </div>
      </div>

      {/* sticky CTA */}
      <div
        style={{
          position: 'fixed',
          bottom: 0, left: 0, right: 0,
          padding: '14px 16px 32px',
          background: 'linear-gradient(to top, var(--ink) 70%, transparent)',
        }}
      >
        <div style={{ display: 'flex', gap: 8 }}>
          <button
            style={{
              flex: 1, background: 'var(--acid)', color: 'var(--ink)', border: 'none',
              padding: 16, fontFamily: 'var(--font-mono)',
              fontSize: 12, letterSpacing: '0.16em', textTransform: 'uppercase', fontWeight: 700,
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
            }}
          >
            ANOTARME <Icon name="arrow" size={14} stroke={2.4} />
          </button>
          <button
            style={{
              background: 'transparent', color: 'var(--bone)', border: '1px solid var(--line-2)',
              padding: 16, fontFamily: 'var(--font-mono)',
              fontSize: 11, letterSpacing: '0.14em', textTransform: 'uppercase',
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            }}
          >
            <Icon name="people" size={14} /> INVITAR
          </button>
        </div>
        <div className="font-mono" style={{ fontSize: 9, color: 'var(--mute)', letterSpacing: '0.1em', textAlign: 'center', marginTop: 8 }}>
          234 / 400 · 78% LLENO · CIERRA EN 02:13:44
        </div>
      </div>
    </div>
  )
}
