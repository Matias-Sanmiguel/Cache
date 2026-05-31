package com.cache.api.dto;

import com.cache.domain.mongo.document.UserDocument;

import java.time.Instant;

// nunca expone passwordHash
public record UserResponse(
        String userId,
        String email,
        String displayName,
        String handle,
        String avatarColor,
        String city,
        Instant createdAt,
        Instant lastActiveAt
) {
    public static UserResponse from(UserDocument u) {
        return new UserResponse(
                u.getUserId(),
                u.getEmail(),
                u.getDisplayName(),
                u.getHandle(),
                u.getAvatarColor(),
                u.getCity(),
                u.getCreatedAt(),
                u.getLastActiveAt()
        );
    }
}
