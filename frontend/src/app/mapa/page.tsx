import { MapScreen } from '@/components/screens/map'
import { BottomNav } from '@/components/layout/bottom-nav'
import { RoleGuard } from '@/components/auth/role-gate'

// el mapa social (amigos cerca) es del VISITOR → los merchants van a su dashboard
export default function MapPage() {
  return (
    <>
      <RoleGuard allow={['VISITOR']} redirectTo="/dashboard">
        <MapScreen />
      </RoleGuard>
      <BottomNav />
    </>
  )
}
