'use client'

import { createContext, useContext, useEffect, useState, useCallback } from 'react'
import {
  apiLogin,
  apiRegister,
  apiMe,
  apiLogout,
  type AuthUser,
  type RegisterPayload,
} from '@/lib/api'

const TOKEN_KEY = 'cache_token'

type AuthState = {
  user: AuthUser | null
  token: string | null
  loading: boolean
  login: (identifier: string, password: string) => Promise<void>
  register: (payload: RegisterPayload) => Promise<void>
  logout: () => Promise<void>
  setUser: (u: AuthUser) => void
}

const AuthContext = createContext<AuthState | null>(null)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(null)
  const [token, setToken] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)

  // rehidratar sesión desde localStorage al montar
  useEffect(() => {
    const saved = localStorage.getItem(TOKEN_KEY)
    if (!saved) {
      setLoading(false)
      return
    }
    setToken(saved)
    apiMe(saved)
      .then((u) => setUser(u))
      .catch(() => {
        localStorage.removeItem(TOKEN_KEY)
        setToken(null)
      })
      .finally(() => setLoading(false))
  }, [])

  const persist = useCallback((tok: string, u: AuthUser) => {
    localStorage.setItem(TOKEN_KEY, tok)
    setToken(tok)
    setUser(u)
  }, [])

  const login = useCallback(
    async (identifier: string, password: string) => {
      const res = await apiLogin(identifier, password)
      persist(res.token, res.user)
    },
    [persist],
  )

  const register = useCallback(
    async (payload: RegisterPayload) => {
      const res = await apiRegister(payload)
      persist(res.token, res.user)
    },
    [persist],
  )

  const logout = useCallback(async () => {
    if (token) await apiLogout(token).catch(() => {})
    localStorage.removeItem(TOKEN_KEY)
    setToken(null)
    setUser(null)
  }, [token])

  return (
    <AuthContext.Provider value={{ user, token, loading, login, register, logout, setUser }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth(): AuthState {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth fuera de <AuthProvider>')
  return ctx
}
