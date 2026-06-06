import { FeedScreen } from '@/components/screens/feed'
import { BottomNav } from '@/components/layout/bottom-nav'
import { VisitorRoute } from '@/components/auth/role-gate'

// el feed es público (anónimo + VISITOR); los merchants van a su dashboard
export default function FeedPage({
  searchParams,
}: {
  searchParams: { genre?: string; page?: string }
}) {
  const genre = searchParams.genre
  const page = searchParams.page ? Math.max(0, parseInt(searchParams.page, 10) || 0) : 0
  return (
    <>
      <VisitorRoute>
        <FeedScreen genre={genre} page={page} />
      </VisitorRoute>
      <BottomNav />
    </>
  )
}
