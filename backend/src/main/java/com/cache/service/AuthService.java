package com.cache.service;

import com.cache.api.dto.LoginRequest;
import com.cache.api.dto.RegisterRequest;
import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.repository.UserRepository;
import com.cache.security.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

// orquesta la autenticación: identidad en mongo (UserService/UserRepository),
// sesión/refresh en redis (SessionService) y access token stateless (JwtService).
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserService     userService;
    private final UserRepository  userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService      jwtService;
    private final SessionService  sessionService;

    public AuthResult register(RegisterRequest req) {
        UserDocument user = userService.register(req); // valida unicidad y crea el UserNode (neo4j)
        return issueTokens(user);
    }

    public AuthResult login(LoginRequest req) {
        String email = req.email().toLowerCase().trim();
        UserDocument user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "credenciales inválidas"));

        if (!passwordEncoder.matches(req.password(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "credenciales inválidas");
        }
        return issueTokens(user);
    }

    // valida el refresh contra redis, lo rota (invalida el viejo) y emite tokens nuevos
    public AuthResult refresh(String refreshToken) {
        String userId = sessionService.userIdForRefreshToken(refreshToken)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "refresh token inválido o expirado"));

        UserDocument user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "usuario no encontrado"));

        sessionService.revoke(refreshToken);
        return issueTokens(user);
    }

    public void logout(String refreshToken) {
        sessionService.revoke(refreshToken);
    }

    private AuthResult issueTokens(UserDocument user) {
        String accessToken  = jwtService.generateAccessToken(user.getUserId());
        String refreshToken = sessionService.createRefreshToken(user.getUserId());
        return new AuthResult(accessToken, refreshToken, user);
    }

    // resultado interno: tokens + el user autenticado
    public record AuthResult(String accessToken, String refreshToken, UserDocument user) {}
}
