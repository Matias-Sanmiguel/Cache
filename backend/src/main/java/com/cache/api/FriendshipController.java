package com.cache.api;

import com.cache.api.dto.UserResponse;
import com.cache.service.FriendshipService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// neo4j: grafo social. solicitudes y amistades.
// rutas anidadas bajo el user dueño del grafo.
@RestController
@RequestMapping("/api/users/{userId}/friends")
@RequiredArgsConstructor
public class FriendshipController {

    private final FriendshipService friendshipService;

    // amigos confirmados
    @GetMapping
    public List<UserResponse> friends(@PathVariable String userId) {
        return friendshipService.getFriends(userId).stream().map(UserResponse::from).toList();
    }

    // deshacer amistad
    @DeleteMapping("/{friendId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void removeFriend(@PathVariable String userId, @PathVariable String friendId) {
        friendshipService.removeFriend(userId, friendId);
    }

    // solicitudes pendientes recibidas por el user
    @GetMapping("/requests")
    public List<UserResponse> pendingRequests(@PathVariable String userId) {
        return friendshipService.getPendingRequests(userId).stream().map(UserResponse::from).toList();
    }

    // userId le envía una solicitud a targetId
    @PostMapping("/requests/{targetId}")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public void sendRequest(@PathVariable String userId, @PathVariable String targetId) {
        friendshipService.sendRequest(userId, targetId);
    }

    // userId acepta la solicitud que le mandó requesterId
    @PostMapping("/requests/{requesterId}/accept")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void accept(@PathVariable String userId, @PathVariable String requesterId) {
        friendshipService.acceptRequest(userId, requesterId);
    }

    // userId rechaza la solicitud de requesterId
    @PostMapping("/requests/{requesterId}/reject")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void reject(@PathVariable String userId, @PathVariable String requesterId) {
        friendshipService.rejectRequest(userId, requesterId);
    }
}
