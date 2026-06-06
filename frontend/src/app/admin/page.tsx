import { AdminScreen } from '@/components/screens/admin'
import { RoleGuard } from '@/components/auth/role-gate'
import { getAdminMongoData } from '@/lib/api'

// panel solo para ADMIN (equipo caché); al resto lo redirige RoleGuard
export default async function AdminPage({
  searchParams,
}: {
  searchParams: { city?: string }
}) {
  const city = searchParams.city?.trim() || 'buenos aires'
  const initial = await getAdminMongoData(city)
  return (
    <RoleGuard allow={['ADMIN']} redirectTo="/">
      <AdminScreen initial={initial} initialCity={city} />
    </RoleGuard>
  )
}
