package com.cache.api;

import com.cache.api.dto.FriendRequestDTO;
import com.cache.api.dto.UserProfileDTO;
import com.cache.service.FriendshipService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// neo4j: grafo social. todas las operaciones son relativas al user autenticado (me).
@RestController
@RequestMapping("/api/friends")
@RequiredArgsConstructor
public class FriendController {

    private final FriendshipService friendshipService;

    // amigos confirmados del user
    @GetMapping
    public List<UserProfileDTO> friends(@AuthenticationPrincipal String me) {
        return friendshipService.getFriends(me).stream().map(UserProfileDTO::from).toList();
    }

    // solicitudes pendientes recibidas
    @GetMapping("/requests")
    public List<UserProfileDTO> pendingRequests(@AuthenticationPrincipal String me) {
        return friendshipService.getPendingRequests(me).stream().map(UserProfileDTO::from).toList();
    }

    // solicitudes enviadas por el user autenticado que siguen pendientes
    @GetMapping("/requests/sent")
    public List<UserProfileDTO> sentRequests(@AuthenticationPrincipal String me) {
        return friendshipService.getSentRequests(me).stream().map(UserProfileDTO::from).toList();
    }

    // cancelar una solicitud enviada por el user autenticado a {id}
    @DeleteMapping("/request/{id}/cancel")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void cancelRequest(@AuthenticationPrincipal String me, @PathVariable String id) {
        friendshipService.cancelRequest(me, id);
    }

    // enviar solicitud de amistad
    @PostMapping("/request")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public void sendRequest(@AuthenticationPrincipal String me, @Valid @RequestBody FriendRequestDTO req) {
        friendshipService.sendRequest(me, req.targetUserId());
    }

    // aceptar la solicitud que mandó {id}
    @PutMapping("/request/{id}/accept")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void acceptRequest(@AuthenticationPrincipal String me, @PathVariable String id) {
        friendshipService.acceptRequest(me, id);
    }

    // rechazar la solicitud que mandó {id}
    @DeleteMapping("/request/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void rejectRequest(@AuthenticationPrincipal String me, @PathVariable String id) {
        friendshipService.rejectRequest(me, id);
    }

    // deshacer amistad con {id}
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void removeFriend(@AuthenticationPrincipal String me, @PathVariable String id) {
        friendshipService.removeFriend(me, id);
    }
}
