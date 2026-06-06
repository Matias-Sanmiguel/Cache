package com.cache.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Set;

// redis como memoria de corto plazo: quién está en qué venue ahora mismo
@Service
@RequiredArgsConstructor
public class PresenceService {

    private final RedisTemplate<String, Object> redis;

    private static final Duration PRESENCE_TTL = Duration.ofHours(8);

    // marca al user como presente en un venue. devuelve true si recién ingresó
    // (no estaba en el set) → el caller decide si incrementar el contador del evento.
    public boolean markPresent(String userId, String venueId) {
        String presenceKey = "presence:" + userId;
        String venueKey    = "venue:" + venueId + ":present";

        redis.opsForValue().set(presenceKey, venueId, PRESENCE_TTL);
        Long added = redis.opsForSet().add(venueKey, userId);
        redis.expire(venueKey, PRESENCE_TTL);
        return added != null && added > 0;
    }

    // saca al user del venue (salió o expiró). devuelve true si estaba presente
    // (se removió del set) → el caller decide si decrementar el contador del evento.
    public boolean markDeparted(String userId, String venueId) {
        redis.delete("presence:" + userId);
        Long removed = redis.opsForSet().remove("venue:" + venueId + ":present", userId);
        return removed != null && removed > 0;
    }

    // cuántos users hay ahora en un venue
    public long countPresent(String venueId) {
        Long count = redis.opsForSet().size("venue:" + venueId + ":present");
        return count != null ? count : 0L;
    }

    // set de userIds presentes en un venue
    public Set<Object> getPresentUsers(String venueId) {
        return redis.opsForSet().members("venue:" + venueId + ":present");
    }

    // en qué venue está un user ahora
    public String getCurrentVenue(String userId) {
        Object val = redis.opsForValue().get("presence:" + userId);
        return val != null ? val.toString() : null;
    }

    // cuántos anotados tiene un evento (contador volátil, no historial)
    public void incrementAttendeeCount(String eventId) {
        redis.opsForValue().increment("event:" + eventId + ":attendees");
    }

    public void decrementAttendeeCount(String eventId) {
        redis.opsForValue().decrement("event:" + eventId + ":attendees");
    }

    public long getAttendeeCount(String eventId) {
        Object val = redis.opsForValue().get("event:" + eventId + ":attendees");
        return val != null ? Long.parseLong(val.toString()) : 0L;
    }
}
