package com.cache.security;

import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

// valida el Bearer token en cada request. si es válido, deja el userId como
// principal en el SecurityContext; si no, sigue sin autenticar (Security devuelve 401/403).
@Component
@RequiredArgsConstructor
public class JwtFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain chain) throws ServletException, IOException {

        String token = resolveToken(request);
        if (token != null) {
            try {
                JwtService.TokenPrincipal principal = jwtService.parse(token);
                // authority ROLE_<rol> → habilita hasRole(...) en SecurityConfig
                var authorities = principal.role() != null
                        ? List.of(new SimpleGrantedAuthority("ROLE_" + principal.role()))
                        : List.<SimpleGrantedAuthority>of();
                var authentication = new UsernamePasswordAuthenticationToken(principal.userId(), null, authorities);
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            } catch (JwtException | IllegalArgumentException ex) {
                // token inválido/expirado → request anónimo, lo resuelve la cadena de Security
                SecurityContextHolder.clearContext();
            }
        }

        chain.doFilter(request, response);
    }

    // el token llega por el header Authorization; para el stream SSE (EventSource no
    // puede setear headers) se acepta además por query param ?token= en /stream.
    private String resolveToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            return header.substring(7);
        }
        if (request.getRequestURI().endsWith("/notifications/stream")) {
            String param = request.getParameter("token");
            if (param != null && !param.isBlank()) return param;
        }
        return null;
    }
}
