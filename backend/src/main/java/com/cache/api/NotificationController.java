package com.cache.api;

import com.cache.api.dto.NotificationResponse;
import com.cache.security.JwtService;
import com.cache.service.NotificationService;
import com.cache.service.NotificationStreamService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

// feed de "pings" + stream realtime (SSE) + marcar leído
@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final NotificationStreamService streamService;
    private final JwtService jwtService;

    // los pings son siempre del usuario autenticado — el userId sale del JWT,
    // no de la URL (evita que un user lea las notificaciones de otro)
    @GetMapping
    public List<NotificationResponse> forCurrentUser(@AuthenticationPrincipal String userId) {
        return notificationService.forUser(userId);
    }

    // stream SSE en vivo. EventSource no puede mandar headers → el token va por query param
    // y se valida acá (este endpoint es permitAll en SecurityConfig).
    @GetMapping("/stream")
    public SseEmitter stream(@RequestParam String token) {
        JwtService.TokenPrincipal principal;
        try {
            principal = jwtService.parse(token);
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "token inválido");
        }
        return streamService.open(principal.userId());
    }

    // marcar todas las notifs del user como leídas
    @PutMapping("/read")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void markAllRead(@AuthenticationPrincipal String userId) {
        notificationService.markAllRead(userId);
    }

    // marcar una notif puntual (id "{epochMillis}:{uuid}") como leída
    @PutMapping("/{id}/read")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void markRead(@AuthenticationPrincipal String userId, @PathVariable String id) {
        notificationService.markRead(userId, id);
    }
}
