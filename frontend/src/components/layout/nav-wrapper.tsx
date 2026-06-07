'use client'

import { usePathname } from 'next/navigation'
import { BottomNav } from '@/components/layout/bottom-nav'

const NO_NAV = ['/login', '/register', '/admin']

export function NavWrapper() {
  const pathname = usePathname()
  const hide = NO_NAV.includes(pathname) || pathname.startsWith('/evento/')
  if (hide) return null
  return <BottomNav />
}
