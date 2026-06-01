package com.cache.service;

import com.cache.api.dto.LoginRequest;
import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.Optional;

// orquesta login: valida credenciales (bcrypt) y emite token de sesión (redis)
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository  userRepository;
    private final PasswordEncoder passwordEncoder;
    private final SessionService  sessionService;

    public UserDocument authenticate(LoginRequest req) {
        if (req.identifier() == null || req.identifier().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "falta email o handle");
        }
        String id = req.identifier().toLowerCase().trim();

        // permite login por email o por @handle
        Optional<UserDocument> found = id.contains("@") && id.contains(".")
                ? userRepository.findByEmail(id)
                : userRepository.findByHandle(id.replaceFirst("^@", ""));

        // fallback: si parecía email pero no estaba, probar como handle
        UserDocument user = found.or(() -> userRepository.findByHandle(id.replaceFirst("^@", "")))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "credenciales inválidas"));

        if (!passwordEncoder.matches(req.password(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "credenciales inválidas");
        }

        user.setLastActiveAt(Instant.now());
        userRepository.save(user);
        return user;
    }

    // token nuevo para un usuario ya validado / recién registrado
    public String issueToken(String userId) {
        return sessionService.createSession(userId);
    }
}
