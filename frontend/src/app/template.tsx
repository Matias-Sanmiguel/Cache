import type { ReactNode } from 'react'

export default function Template({ children }: { children: ReactNode }) {
  return <div className="cache-route-shell">{children}</div>
}
