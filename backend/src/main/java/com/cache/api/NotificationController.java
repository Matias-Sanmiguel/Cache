package com.cache.api;

import com.cache.api.dto.NotificationResponse;
import com.cache.service.NotificationService;
import com.cache.service.NotificationStreamService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

// feed de "pings" — generado de eventos live + red social
@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService       notificationService;
    private final NotificationStreamService streamService;

    // los pings son siempre del usuario autenticado — el userId sale del JWT,
    // no de la URL (evita que un user lea las notificaciones de otro)
    @GetMapping
    public List<NotificationResponse> forCurrentUser(@AuthenticationPrincipal String userId) {
        return notificationService.forUser(userId);
    }

    // SSE stream de pings en tiempo real — el token llega por query param ?token=
    // porque EventSource del browser no puede setear headers (ver JwtFilter)
    @GetMapping("/stream")
    public SseEmitter stream(@AuthenticationPrincipal String userId) {
        return streamService.open(userId);
    }
}
