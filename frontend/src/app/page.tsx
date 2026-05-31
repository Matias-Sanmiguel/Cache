import { FeedScreen } from '@/components/screens/feed'
import { BottomNav } from '@/components/layout/bottom-nav'

export default function FeedPage({
  searchParams,
}: {
  searchParams: { genre?: string; page?: string }
}) {
  const genre = searchParams.genre
  const page = searchParams.page ? Math.max(0, parseInt(searchParams.page, 10) || 0) : 0
  return (
    <>
      <FeedScreen genre={genre} page={page} />
      <BottomNav />
    </>
  )
}
