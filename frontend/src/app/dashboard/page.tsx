import { DashboardScreen } from '@/components/screens/dashboard'
import { RoleGuard } from '@/components/auth/role-gate'
import { getDashboardData } from '@/lib/api'

// server: primer fetch (sin flash de carga); el cliente lo refresca cada 15s.
// el dashboard es solo para merchants/admin → RoleGuard redirige a los visitantes.
export default async function DashboardPage() {
  const initial = await getDashboardData()
  return (
    <RoleGuard allow={['VENUE_OWNER', 'ADMIN']} redirectTo="/">
      <DashboardScreen initial={initial} />
    </RoleGuard>
  )
}
