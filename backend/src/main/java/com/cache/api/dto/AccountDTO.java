package com.cache.api.dto;

import com.cache.domain.mongo.document.Role;
import com.cache.domain.mongo.document.UserDocument;

import java.time.Instant;

// perfil COMPLETO del propio user (self): incluye email, role, venueId y fechas.
// nunca usar para perfiles ajenos — eso es UserProfileDTO (público, sin datos sensibles).
public record AccountDTO(
        String userId,
        String displayName,
        String handle,
        String avatarColor,
        String city,
        String email,
        Role role,
        String venueId,
        Instant createdAt,
        Instant lastActiveAt
) {
    public static AccountDTO from(UserDocument u) {
        return new AccountDTO(
                u.getUserId(),
                u.getDisplayName(),
                u.getHandle(),
                u.getAvatarColor(),
                u.getCity(),
                u.getEmail(),
                u.getRole(),
                u.getVenueId(),
                u.getCreatedAt(),
                u.getLastActiveAt()
        );
    }
}
