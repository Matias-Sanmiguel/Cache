'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Icon } from '@/components/ui/icon'

const TABS = [
  { id: 'home',  href: '/',      icon: 'home'  as const, label: 'feed'   },
  { id: 'map',   href: '/mapa',  icon: 'map'   as const, label: 'mapa'   },
  { id: 'plus',  href: '/crear', icon: 'plus'  as const, label: 'crear'  },
  { id: 'bell',  href: '/pings', icon: 'bell'  as const, label: 'pings', dot: true },
  { id: 'me',    href: '/perfil',icon: 'user'  as const, label: 'perfil' },
]

export function BottomNav() {
  const pathname = usePathname()

  return (
    <nav
      style={{
        position: 'fixed',
        bottom: 0,
        left: 0,
        right: 0,
        height: 72,
        background: 'var(--ink)',
        borderTop: '1px solid var(--line)',
        display: 'flex',
        alignItems: 'flex-start',
        justifyContent: 'space-around',
        padding: '12px 0 14px',
        zIndex: 60,
      }}
    >
      {TABS.map((tab) => {
        const isActive = pathname === tab.href
        const isPlus = tab.id === 'plus'
        return (
          <Link
            key={tab.id}
            href={tab.href}
            style={{
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              gap: 4,
              position: 'relative',
              textDecoration: 'none',
            }}
          >
            {isPlus ? (
              <div
                style={{
                  width: 36,
                  height: 36,
                  background: 'var(--acid)',
                  color: 'var(--ink)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                <Icon name="plus" size={20} stroke={2.2} />
              </div>
            ) : (
              <div style={{ color: isActive ? 'var(--bone)' : 'var(--mute)', position: 'relative' }}>
                <Icon name={tab.icon} size={22} stroke={1.6} />
                {tab.dot && (
                  <span
                    style={{
                      position: 'absolute',
                      top: -2,
                      right: -3,
                      width: 6,
                      height: 6,
                      borderRadius: '50%',
                      background: 'var(--acid)',
                    }}
                  />
                )}
              </div>
            )}
            <span
              className="font-mono"
              style={{
                fontSize: 9,
                color: isActive ? 'var(--bone)' : 'var(--mute)',
                letterSpacing: '0.12em',
                textTransform: 'uppercase',
              }}
            >
              {tab.label}
            </span>
            {isActive && (
              <span
                style={{
                  position: 'absolute',
                  top: -12,
                  width: 14,
                  height: 2,
                  background: 'var(--acid)',
                }}
              />
            )}
          </Link>
        )
      })}
    </nav>
  )
}
