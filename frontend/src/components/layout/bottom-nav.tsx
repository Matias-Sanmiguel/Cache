'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Icon } from '@/components/ui/icon'
import { useNotifications } from '@/lib/notification-context'

const TABS = [
  { id: 'home',  href: '/',          icon: 'home'  as const, label: 'feed'   },
  { id: 'map',   href: '/mapa',      icon: 'map'   as const, label: 'mapa'   },
  { id: 'dash',  href: '/dashboard', icon: 'spark' as const, label: 'dash'   },
  { id: 'bell',  href: '/pings',     icon: 'bell'  as const, label: 'pings'  },
  { id: 'me',    href: '/perfil',    icon: 'user'  as const, label: 'perfil' },
]

export function BottomNav() {
  const pathname = usePathname()
  const { unreadCount } = useNotifications()

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
        const isBell = tab.id === 'bell'
        return (
          <Link
            key={tab.id}
            href={tab.href}
            className="cache-nav-link"
            style={{
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              gap: 4,
              position: 'relative',
              textDecoration: 'none',
            }}
          >
            <div style={{ color: isActive ? 'var(--bone)' : 'var(--mute)', position: 'relative' }}>
              <Icon name={tab.icon} size={22} stroke={1.6} />
              {isBell && unreadCount > 0 && (
                <span
                  style={{
                    position: 'absolute',
                    top: -4,
                    right: -6,
                    minWidth: unreadCount > 9 ? 16 : 14,
                    height: 14,
                    borderRadius: 7,
                    background: 'var(--acid)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    padding: '0 3px',
                  }}
                >
                  <span
                    className="font-mono"
                    style={{ fontSize: 8, color: 'var(--ink)', fontWeight: 700, lineHeight: 1 }}
                  >
                    {unreadCount > 99 ? '99+' : unreadCount}
                  </span>
                </span>
              )}
            </div>
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
