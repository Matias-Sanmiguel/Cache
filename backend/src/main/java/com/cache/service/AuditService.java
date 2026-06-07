package com.cache.service;

import com.cache.domain.cassandra.logs.entity.*;
import com.cache.domain.cassandra.logs.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;

// escribe en cache_logs (keyspace de auditoría) — no lanza excepciones hacia afuera.
// los logs son best-effort: si Cassandra falla, la operación principal no se ve afectada.
// se inyecta en AuthService, CheckinService y RecommendationService.
@Service
@RequiredArgsConstructor
@Slf4j
public class AuditService {

    private static final ZoneId BA_ZONE = ZoneId.of("America/Argentina/Buenos_Aires");

    private final LoginLogRepository          loginLogRepo;
    private final UserActivityLogRepository   activityLogRepo;
    private final AttendanceLogRepository     attendanceLogRepo;
    private final LocationLogRepository       locationLogRepo;
    private final RecommendationLogRepository recommendationLogRepo;
    private final SystemLogRepository         systemLogRepo;

    // ── login / logout ────────────────────────────────────────────────────────

    public void logLogin(String userId, String ipAddress, String device, boolean success) {
        try {
            Instant now = Instant.now();
            loginLogRepo.save(LoginLog.builder()
                    .userId(userId)
                    .eventDate(toLocalDate(now))
                    .eventTime(now)
                    .ipAddress(ipAddress)
                    .device(device)
                    .success(success)
                    .build());
        } catch (Exception e) {
            log.warn("audit: no se pudo registrar login userId={} — {}", userId, e.getMessage());
        }
    }

    // ── actividad de usuario ──────────────────────────────────────────────────

    public void logActivity(String userId, String activityType,
                            String entityType, String entityId, String description) {
        try {
            Instant now = Instant.now();
            activityLogRepo.save(UserActivityLog.builder()
                    .userId(userId)
                    .activityDate(toLocalDate(now))
                    .activityTime(now)
                    .activityType(activityType)
                    .entityType(entityType)
                    .entityId(entityId)
                    .description(description)
                    .build());
        } catch (Exception e) {
            log.warn("audit: no se pudo registrar actividad userId={} type={} — {}", userId, activityType, e.getMessage());
        }
    }

    // ── asistencia a eventos ──────────────────────────────────────────────────

    public void logAttendance(String userId, String eventId, String actionType) {
        try {
            attendanceLogRepo.save(AttendanceLog.builder()
                    .userId(userId)
                    .actionTime(Instant.now())
                    .eventId(eventId)
                    .actionType(actionType)
                    .build());
        } catch (Exception e) {
            log.warn("audit: no se pudo registrar asistencia userId={} eventId={} — {}", userId, eventId, e.getMessage());
        }
    }

    // ── ubicación ─────────────────────────────────────────────────────────────

    public void logLocation(String userId, double latitude, double longitude) {
        try {
            Instant now = Instant.now();
            locationLogRepo.save(LocationLog.builder()
                    .userId(userId)
                    .logDate(toLocalDate(now))
                    .eventTime(now)
                    .latitude(latitude)
                    .longitude(longitude)
                    .build());
        } catch (Exception e) {
            log.warn("audit: no se pudo registrar ubicación userId={} — {}", userId, e.getMessage());
        }
    }

    // ── recomendaciones ───────────────────────────────────────────────────────

    public void logRecommendation(String userId, String eventId, double score, String reason) {
        try {
            recommendationLogRepo.save(RecommendationLog.builder()
                    .userId(userId)
                    .recommendationTime(Instant.now())
                    .eventId(eventId)
                    .score(score)
                    .reason(reason)
                    .build());
        } catch (Exception e) {
            log.warn("audit: no se pudo registrar recomendación userId={} eventId={} — {}", userId, eventId, e.getMessage());
        }
    }

    // ── sistema ───────────────────────────────────────────────────────────────

    public void logSystem(String serviceName, String level, String message) {
        try {
            Instant now = Instant.now();
            systemLogRepo.save(SystemLog.builder()
                    .serviceName(serviceName)
                    .logDate(toLocalDate(now))
                    .eventTime(now)
                    .level(level)
                    .message(message)
                    .build());
        } catch (Exception e) {
            log.warn("audit: no se pudo registrar system log service={} — {}", serviceName, e.getMessage());
        }
    }

    // ── helper ────────────────────────────────────────────────────────────────

    private LocalDate toLocalDate(Instant instant) {
        return instant.atZone(BA_ZONE).toLocalDate();
    }
}