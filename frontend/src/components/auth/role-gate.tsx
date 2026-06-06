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

// protege una RUTA: si el rol no está permitido, redirige (default a la home del rol).
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
