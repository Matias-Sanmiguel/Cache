package com.cache.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;

// emite y valida los access tokens (JWT firmado HS256).
// el refresh token NO es un JWT: es opaco y vive en redis (ver SessionService).
@Service
public class JwtService {

    private final SecretKey key;
    private final long accessTtlMs;

    public JwtService(
            @Value("${app.jwt.secret}") String secret,
            @Value("${app.jwt.access-ttl-minutes}") long accessTtlMinutes) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.accessTtlMs = accessTtlMinutes * 60_000L;
    }

    // genera un access token: subject = userId, claim "role" = rol del user
    public String generateAccessToken(String userId, String role) {
        Instant now = Instant.now();
        return Jwts.builder()
                .subject(userId)
                .claim("role", role)
                .issuedAt(Date.from(now))
                .expiration(Date.from(now.plusMillis(accessTtlMs)))
                .signWith(key)
                .compact();
    }

    // valida la firma/vencimiento y devuelve userId + rol; lanza JwtException si no valida
    public TokenPrincipal parse(String token) {
        var claims = Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
        return new TokenPrincipal(claims.getSubject(), claims.get("role", String.class));
    }

    // datos que viajan en el access token
    public record TokenPrincipal(String userId, String role) {}
}
