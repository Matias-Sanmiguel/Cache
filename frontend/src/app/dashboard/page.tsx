import { DashboardScreen } from '@/components/screens/dashboard'
import { BottomNav } from '@/components/layout/bottom-nav'
import { getDashboardData } from '@/lib/api'

// server: primer fetch (sin flash de carga); el cliente lo refresca cada 15s
export default async function DashboardPage() {
  const initial = await getDashboardData()
  return (
    <>
      <DashboardScreen initial={initial} />
      <BottomNav />
    </>
  )
}
