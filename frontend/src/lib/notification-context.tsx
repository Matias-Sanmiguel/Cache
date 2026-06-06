'use client'

import { createContext, useContext, useEffect, useRef, useState, useCallback } from 'react'
import { useAuth } from '@/lib/auth-context'
import { subscribeNotifications, type Notification } from '@/lib/api'

type PingHandler = (n: Notification) => void

type NotificationContextType = {
  unreadCount: number
  resetUnread: () => void
  // registra un handler que recibe cada ping SSE entrante; devuelve cleanup
  subscribeToNewPings: (handler: PingHandler) => () => void
}

const NotificationContext = createContext<NotificationContextType>({
  unreadCount: 0,
  resetUnread: () => {},
  subscribeToNewPings: () => () => {},
})

export function NotificationProvider({ children }: { children: React.ReactNode }) {
  const { user, token } = useAuth()
  const [unreadCount, setUnreadCount] = useState(0)
  const handlersRef = useRef<Set<PingHandler>>(new Set())

  const resetUnread = useCallback(() => setUnreadCount(0), [])

  const subscribeToNewPings = useCallback((handler: PingHandler) => {
    handlersRef.current.add(handler)
    return () => { handlersRef.current.delete(handler) }
  }, [])

  useEffect(() => {
    if (!user || !token) return

    let es: EventSource | null = null
    let retryTimeout: ReturnType<typeof setTimeout> | null = null
    let retryDelay = 2000
    let alive = true

    const connect = () => {
      if (!alive) return
      es = subscribeNotifications(token, (notif) => {
        setUnreadCount((c) => c + 1)
        handlersRef.current.forEach((h) => h(notif))
      })
      // reconexión con backoff exponencial (max 30s)
      es.onerror = () => {
        es?.close()
        if (!alive) return
        retryTimeout = setTimeout(() => {
          retryDelay = Math.min(retryDelay * 2, 30_000)
          connect()
        }, retryDelay)
      }
      // reset del backoff al recuperar conexión
      es.onopen = () => { retryDelay = 2000 }
    }

    connect()

    return () => {
      alive = false
      if (retryTimeout) clearTimeout(retryTimeout)
      es?.close()
    }
  }, [user, token])

  return (
    <NotificationContext.Provider value={{ unreadCount, resetUnread, subscribeToNewPings }}>
      {children}
    </NotificationContext.Provider>
  )
}

export function useNotifications(): NotificationContextType {
  return useContext(NotificationContext)
}
