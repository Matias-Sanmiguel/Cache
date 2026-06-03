package com.cache.api.dto;

// "personas que quizás conozcas": perfil sugerido + cuántos amigos en común
public record FriendSuggestionResponse(
        UserResponse user,
        long mutualFriends
) {}
