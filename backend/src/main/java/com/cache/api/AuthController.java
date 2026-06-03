package com.cache.api;

import com.cache.api.dto.AuthResponse;
import com.cache.api.dto.LoginRequest;
import com.cache.api.dto.RegisterRequest;
import com.cache.api.dto.UserResponse;
import com.cache.domain.mongo.document.UserDocument;
import com.cache.service.AuthService;
import com.cache.service.SessionService;
import com.cache.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

// auth: register / login / logout / me.
// emite tokens de sesión opacos guardados en redis.
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService    userService;
    private final AuthService    authService;
    private final SessionService sessionService;

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public AuthResponse register(@Valid @RequestBody RegisterRequest req) {
        UserDocument user = userService.register(req);
        String token = authService.issueToken(user.getUserId());
        return new AuthResponse(token, UserResponse.from(user));
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest req) {
        UserDocument user = authService.authenticate(req);
        String token = authService.issueToken(user.getUserId());
        return new AuthResponse(token, UserResponse.from(user));
    }

    @PostMapping("/logout")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void logout(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        sessionService.destroy(extractToken(authHeader));
    }

    // perfil del usuario logueado, resuelto desde el token
    @GetMapping("/me")
    public ResponseEntity<UserResponse> me(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        String userId = sessionService.resolve(extractToken(authHeader));
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "sesión inválida o expirada");
        }
        return userService.findById(userId)
                .map(UserResponse::from)
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "usuario no encontrado"));
    }

    private static String extractToken(String authHeader) {
        if (authHeader == null) return null;
        return authHeader.regionMatches(true, 0, "Bearer ", 0, 7)
                ? authHeader.substring(7).trim()
                : authHeader.trim();
    }
}
