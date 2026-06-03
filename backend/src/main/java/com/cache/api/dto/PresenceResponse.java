package com.cache.api.dto;

import java.util.List;

// presencia en vivo de un venue (redis): cuántos y quiénes están ahora
public record PresenceResponse(
        String venueId,
        long present,
        List<String> userIds
) {}
