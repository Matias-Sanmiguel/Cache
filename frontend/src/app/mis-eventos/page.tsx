import { MyEventsScreen } from '@/components/screens/my-events'
import { BottomNav } from '@/components/layout/bottom-nav'
import { RoleGuard } from '@/components/auth/role-gate'

// gestión de eventos del merchant — solo VENUE_OWNER/ADMIN
export default function MisEventosPage() {
  return (
    <>
      <RoleGuard allow={['VENUE_OWNER', 'ADMIN']} redirectTo="/">
        <MyEventsScreen />
      </RoleGuard>
      <BottomNav />
    </>
  )
}
