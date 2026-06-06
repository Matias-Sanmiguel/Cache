import { NotifScreen } from '@/components/screens/notifs'
import { BottomNav } from '@/components/layout/bottom-nav'
import { RoleGuard } from '@/components/auth/role-gate'

// los pings son notificaciones sociales (amigos/recomendaciones) → solo VISITOR
export default function PingsPage() {
  return (
    <>
      <RoleGuard allow={['VISITOR']} redirectTo="/dashboard">
        <NotifScreen />
      </RoleGuard>
      <BottomNav />
    </>
  )
}
