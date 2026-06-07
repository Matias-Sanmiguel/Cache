package com.cache.api.dto;

import com.cache.domain.mongo.document.UserDocument;

// perfil público de un user — nunca expone email ni passwordHash
public record UserProfileDTO(
        String userId,
        String displayName,
        String handle,
        String avatarColor,
        String city
) {
    public static UserProfileDTO from(UserDocument u) {
        return new UserProfileDTO(
                u.getUserId(),
                u.getDisplayName(),
                u.getHandle(),
                u.getAvatarColor(),
                u.getCity()
        );
    }
}
