import { MyVenueScreen } from '@/components/screens/my-venue'
import { RoleGuard } from '@/components/auth/role-gate'

// info del venue del merchant — solo VENUE_OWNER/ADMIN
export default function MiVenuePage() {
  return (
    <RoleGuard allow={['VENUE_OWNER', 'ADMIN']} redirectTo="/">
      <MyVenueScreen />
    </RoleGuard>
  )
}
