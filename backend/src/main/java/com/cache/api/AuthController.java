package com.cache.api;

import com.cache.api.dto.AuthResponse;
import com.cache.api.dto.LoginRequest;
import com.cache.api.dto.RegisterRequest;
import com.cache.api.dto.TokenRequest;
import com.cache.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

// rutas públicas de autenticación (no requieren token)
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public AuthResponse register(@Valid @RequestBody RegisterRequest req) {
        return AuthResponse.from(authService.register(req));
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest req) {
        return AuthResponse.from(authService.login(req));
    }

    @PostMapping("/refresh")
    public AuthResponse refresh(@Valid @RequestBody TokenRequest req) {
        return AuthResponse.from(authService.refresh(req.refreshToken()));
    }

    @PostMapping("/logout")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void logout(@Valid @RequestBody TokenRequest req) {
        authService.logout(req.refreshToken());
    }
}
