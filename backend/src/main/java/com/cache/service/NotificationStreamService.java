package com.cache.service;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

// realtime de notificaciones (patrón pub/sub):
//   - mantiene los SseEmitter abiertos por userId (un user puede tener varias pestañas)
//   - escucha el canal redis "notifications:{userId}" y reenvía el payload a esos emitters
// así varias instancias del backend pueden publicar y todas las conexiones SSE lo reciben.
@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationStreamService implements MessageListener {

    private static final String CHANNEL_PREFIX = "notifications:";
    // SSE de larga duración: el cliente reabre solo si se cae
    private static final long EMITTER_TIMEOUT_MS = 30 * 60 * 1000L;

    private final RedisMessageListenerContainer listenerContainer;

    // userId → emitters activos
    private final Map<String, List<SseEmitter>> emitters = new ConcurrentHashMap<>();

    @PostConstruct
    void subscribe() {
        listenerContainer.addMessageListener(this, new PatternTopic(CHANNEL_PREFIX + "*"));
        log.info("notifications: suscrito al patrón redis '{}*'", CHANNEL_PREFIX);
    }

    // abre un stream SSE para un user y lo registra
    public SseEmitter open(String userId) {
        SseEmitter emitter = new SseEmitter(EMITTER_TIMEOUT_MS);
        emitters.computeIfAbsent(userId, k -> new CopyOnWriteArrayList<>()).add(emitter);

        emitter.onCompletion(() -> remove(userId, emitter));
        emitter.onTimeout(() -> remove(userId, emitter));
        emitter.onError(e -> remove(userId, emitter));

        // ping inicial: confirma la conexión y evita que proxies la corten
        try {
            emitter.send(SseEmitter.event().name("open").data("ok"));
        } catch (IOException e) {
            remove(userId, emitter);
        }
        return emitter;
    }

    // llega un mensaje de redis → reenviar a los emitters del user del canal
    @Override
    public void onMessage(Message message, byte[] pattern) {
        String channel = new String(message.getChannel(), StandardCharsets.UTF_8);
        if (!channel.startsWith(CHANNEL_PREFIX)) return;
        String userId = channel.substring(CHANNEL_PREFIX.length());
        String payload = new String(message.getBody(), StandardCharsets.UTF_8);

        List<SseEmitter> targets = emitters.get(userId);
        if (targets == null || targets.isEmpty()) return;

        for (SseEmitter emitter : targets) {
            try {
                emitter.send(SseEmitter.event().name("ping").data(payload));
            } catch (IOException e) {
                remove(userId, emitter);
            }
        }
    }

    private void remove(String userId, SseEmitter emitter) {
        List<SseEmitter> list = emitters.get(userId);
        if (list != null) {
            list.remove(emitter);
            if (list.isEmpty()) emitters.remove(userId);
        }
    }
}
