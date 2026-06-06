import { AdminScreen } from '@/components/screens/admin'
import { getAdminMongoData } from '@/lib/api'

export default async function AdminPage({
  searchParams,
}: {
  searchParams: { city?: string }
}) {
  const city = searchParams.city?.trim() || 'buenos aires'
  const initial = await getAdminMongoData(city)
  return <AdminScreen initial={initial} initialCity={city} />
}
