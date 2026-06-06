import { MapScreen } from '@/components/screens/map'
import { BottomNav } from '@/components/layout/bottom-nav'
import { VisitorRoute } from '@/components/auth/role-gate'

// el mapa es público (anónimo + VISITOR); los merchants van a su dashboard
export default function MapPage() {
  return (
    <>
      <VisitorRoute>
        <MapScreen />
      </VisitorRoute>
      <BottomNav />
    </>
  )
}
