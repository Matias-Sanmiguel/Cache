'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Icon } from '@/components/ui/icon'
import { useAuth } from '@/lib/auth-context'
import { useNotifications } from '@/lib/notification-context'
import type { Role } from '@/lib/api'

type Tab = {
  id: string
  href: string
  icon: 'home' | 'map' | 'spark' | 'bell' | 'user' | 'fire' | 'pin'
  label: string
  dot?: boolean
}

// CLIENTE (VISITOR): experiencia social — feed, mapa, pings, perfil
const VISITOR_TABS: Tab[] = [
  { id: 'home', href: '/',        icon: 'home',  label: 'feed'   },
  { id: 'map',  href: '/mapa',    icon: 'map',   label: 'mapa'   },
  { id: 'bell', href: '/pings',   icon: 'bell',  label: 'pings', dot: true },
  { id: 'me',   href: '/perfil',  icon: 'user',  label: 'perfil' },
]

// MERCHANT (VENUE_OWNER / ADMIN): administración — dashboard, mis eventos, mi venue, perfil
const OWNER_TABS: Tab[] = [
  { id: 'dash',   href: '/dashboard',   icon: 'spark', label: 'dash'    },
  { id: 'events', href: '/mis-eventos', icon: 'fire',  label: 'eventos' },
  { id: 'venue',  href: '/mi-venue',    icon: 'pin',   label: 'venue'   },
  { id: 'me',     href: '/perfil',      icon: 'user',  label: 'perfil'  },
]

function tabsForRole(role: Role | undefined): Tab[] {
  return role === 'VENUE_OWNER' || role === 'ADMIN' ? OWNER_TABS : VISITOR_TABS
}

export function BottomNav() {
  const pathname = usePathname()
  const { user } = useAuth()
  const { unreadCount } = useNotifications()
  const tabs = tabsForRole(user?.role)

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
      {tabs.map((tab) => {
        const isActive = pathname === tab.href
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
              {tab.dot && unreadCount > 0 && (
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
