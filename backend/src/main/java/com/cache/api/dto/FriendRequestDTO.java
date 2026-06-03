package com.cache.api.dto;

import jakarta.validation.constraints.NotBlank;

public record FriendRequestDTO(
        @NotBlank String targetUserId
) {}
