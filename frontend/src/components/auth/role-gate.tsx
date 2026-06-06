'use client'

import { useEffect, type ReactNode } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import type { Role } from '@/lib/api'

// muestra children solo si el rol del user está en `allow`. si no, renderiza `fallback`.
// pensado para protección VISUAL (ocultar botones/secciones), no de seguridad real.
export function RoleGate({
  allow,
  children,
  fallback = null,
}: {
  allow: Role[]
  children: ReactNode
  fallback?: ReactNode
}) {
  const { user, loading } = useAuth()
  if (loading) return null
  if (!user?.role || !allow.includes(user.role)) return <>{fallback}</>
  return <>{children}</>
}

// protege una RUTA de MERCHANT: solo VENUE_OWNER/ADMIN. al resto (incluido anónimo)
// lo redirige (default a la home del visitante).
export function RoleGuard({
  allow,
  redirectTo = '/',
  children,
}: {
  allow: Role[]
  redirectTo?: string
  children: ReactNode
}) {
  const { user, loading } = useAuth()
  const router = useRouter()
  const allowed = !!user?.role && allow.includes(user.role)

  useEffect(() => {
    if (!loading && !allowed) router.replace(redirectTo)
  }, [loading, allowed, redirectTo, router])

  if (loading || !allowed) return null
  return <>{children}</>
}

// protege una RUTA de VISITANTE: feed/mapa/pings son públicos (anónimo + VISITOR).
// SOLO redirige a los merchants (VENUE_OWNER/ADMIN) a su dashboard.
// no usamos RoleGuard acá porque redirigiría también al anónimo → loop con /dashboard.
export function VisitorRoute({
  redirectTo = '/dashboard',
  children,
}: {
  redirectTo?: string
  children: ReactNode
}) {
  const { user, loading } = useAuth()
  const router = useRouter()
  const isMerchant = user?.role === 'VENUE_OWNER' || user?.role === 'ADMIN'

  useEffect(() => {
    if (!loading && isMerchant) router.replace(redirectTo)
  }, [loading, isMerchant, redirectTo, router])

  if (isMerchant) return null
  return <>{children}</>
}
