package com.cache.api;

import com.cache.api.dto.NotificationResponse;
import com.cache.service.NotificationService;
import com.cache.service.NotificationStreamService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

// feed de "pings": persistidos (cassandra) + efímeros (live/reco), realtime por SSE.
@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final NotificationStreamService streamService;

    @GetMapping("/user/{userId}")
    public List<NotificationResponse> forUser(@PathVariable String userId) {
        return notificationService.forUser(userId);
    }

    // stream SSE en vivo — el token viaja por query param porque EventSource no
    // puede setear el header Authorization (lo resuelve JwtFilter para esta ruta)
    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter stream(@AuthenticationPrincipal String me) {
        return streamService.open(me);
    }

    // marca todas las notifs del user autenticado como leídas
    @PostMapping("/read-all")
    public void readAll(@AuthenticationPrincipal String me) {
        notificationService.markAllRead(me);
    }

    // marca una notif puntual como leída
    @PostMapping("/{id}/read")
    public void read(@AuthenticationPrincipal String me, @PathVariable String id) {
        notificationService.markRead(me, id);
    }
}
