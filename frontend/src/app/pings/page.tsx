import { NotifScreen } from '@/components/screens/notifs'
import { BottomNav } from '@/components/layout/bottom-nav'
import { VisitorRoute } from '@/components/auth/role-gate'

// pings (notificaciones sociales): anónimo/VISITOR; los merchants van a su dashboard
export default function PingsPage() {
  return (
    <>
      <VisitorRoute>
        <NotifScreen />
      </VisitorRoute>
      <BottomNav />
    </>
  )
}
