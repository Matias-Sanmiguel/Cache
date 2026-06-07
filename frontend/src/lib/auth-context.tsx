'use client'

import { createContext, useContext, useEffect, useState, useCallback } from 'react'
import {
  apiLogin,
  apiRegister,
  apiMe,
  apiLogout,
  apiRefresh,
  type AuthUser,
  type RegisterPayload,
} from '@/lib/api'

const TOKEN_KEY = 'cache_token'
const REFRESH_KEY = 'cache_refresh'

type AuthState = {
  user: AuthUser | null
  token: string | null
  loading: boolean
  login: (identifier: string, password: string) => Promise<AuthUser>
  register: (payload: RegisterPayload) => Promise<AuthUser>
  logout: () => Promise<void>
  setUser: (u: AuthUser) => void
}

const AuthContext = createContext<AuthState | null>(null)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(null)
  const [token, setToken] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)

  const persist = useCallback((tok: string, refresh: string, u: AuthUser) => {
    localStorage.setItem(TOKEN_KEY, tok)
    if (refresh) localStorage.setItem(REFRESH_KEY, refresh)
    setToken(tok)
    setUser(u)
  }, [])

  const clearSession = useCallback(() => {
    localStorage.removeItem(TOKEN_KEY)
    localStorage.removeItem(REFRESH_KEY)
    setToken(null)
    setUser(null)
  }, [])

  // rehidratar sesión desde localStorage al montar.
  // si el access token venció, intentamos rotarlo con el refresh antes de cerrar sesión.
  useEffect(() => {
    const saved = localStorage.getItem(TOKEN_KEY)
    if (!saved) {
      setLoading(false)
      return
    }
    setToken(saved)
    apiMe(saved)
      .then((u) => setUser(u))
      .catch(async () => {
        const refresh = localStorage.getItem(REFRESH_KEY)
        if (!refresh) {
          clearSession()
          return
        }
        try {
          const res = await apiRefresh(refresh)
          persist(res.token, res.refreshToken, res.user)
        } catch {
          clearSession()
        }
      })
      .finally(() => setLoading(false))
  }, [persist, clearSession])

  // api.ts rota el access token de forma transparente ante un 401 y guarda el
  // nuevo en localStorage. escuchamos ese evento para sincronizar el token en
  // el estado de React (sino seguiríamos pasando el token viejo en cada request).
  useEffect(() => {
    const sync = () => {
      const tok = localStorage.getItem(TOKEN_KEY)
      if (tok) {
        setToken(tok)
        apiMe(tok).then(setUser).catch(() => {})
      }
    }
    window.addEventListener('cache-auth-refreshed', sync)
    return () => window.removeEventListener('cache-auth-refreshed', sync)
  }, [])

  const login = useCallback(
    async (identifier: string, password: string) => {
      const res = await apiLogin(identifier, password)
      persist(res.token, res.refreshToken, res.user)
      return res.user
    },
    [persist],
  )

  const register = useCallback(
    async (payload: RegisterPayload) => {
      const res = await apiRegister(payload)
      persist(res.token, res.refreshToken, res.user)
      return res.user
    },
    [persist],
  )

  const logout = useCallback(async () => {
    const refresh = localStorage.getItem(REFRESH_KEY)
    if (refresh) await apiLogout(refresh).catch(() => {})
    clearSession()
  }, [clearSession])

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
