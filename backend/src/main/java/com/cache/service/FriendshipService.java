package com.cache.service;

import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.repository.UserRepository;
import com.cache.domain.neo4j.node.UserNode;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

// neo4j: el grafo social. solicitudes (PENDING_FRIEND) y amistades (FRIENDS_WITH).
// sin amistades, el motor de recomendación no tiene de dónde tirar — de ahí que sea bloqueante.
@Service
@RequiredArgsConstructor
@Slf4j
public class FriendshipService {

    private final UserNodeRepository userNodeRepo;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    // envía una solicitud de amistad fromUserId → toUserId
    public void sendRequest(String fromUserId, String toUserId) {
        if (fromUserId.equals(toUserId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "no podés enviarte una solicitud a vos mismo");
        }
        requireNode(fromUserId);
        requireNode(toUserId);

        if (userNodeRepo.areFriends(fromUserId, toUserId)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "ya son amigos");
        }

        userNodeRepo.createPendingRequest(fromUserId, toUserId);
        log.debug("friend request {} → {}", fromUserId, toUserId);

        // ping al destinatario (persistido + realtime)
        userRepository.findByUserId(fromUserId).ifPresent(from ->
                notificationService.notifyFriendRequest(toUserId, fromUserId, from.getDisplayName(), from.getAvatarColor()));
    }

    // userId acepta la solicitud que le mandó requesterId
    public void acceptRequest(String userId, String requesterId) {
        requireNode(userId);
        requireNode(requesterId);
        userNodeRepo.acceptRequest(userId, requesterId);
        log.debug("friend request aceptada: {} ↔ {}", userId, requesterId);

        // avisar al que mandó la solicitud que fue aceptada
        userRepository.findByUserId(userId).ifPresent(me ->
                notificationService.notifyFriendAccepted(requesterId, me.getDisplayName(), me.getAvatarColor()));
    }

    // userId rechaza la solicitud de requesterId (no crea amistad)
    public void rejectRequest(String userId, String requesterId) {
        userNodeRepo.rejectRequest(userId, requesterId);
        log.debug("friend request rechazada: {} ✗ {}", userId, requesterId);
    }

    // deshace una amistad existente
    public void removeFriend(String userId, String friendId) {
        userNodeRepo.deleteFriendship(userId, friendId);
        log.debug("amistad deshecha: {} ✗ {}", userId, friendId);
    }

    public boolean areFriends(String userId1, String userId2) {
        return userNodeRepo.areFriends(userId1, userId2);
    }

    // amigos confirmados, con el perfil completo resuelto desde mongo
    public List<UserDocument> getFriends(String userId) {
        List<String> ids = userNodeRepo.findFriends(userId).stream()
                .map(UserNode::getUserId)
                .toList();
        return resolveProfiles(ids);
    }

    // solicitudes pendientes recibidas, con perfil completo resuelto desde mongo
    public List<UserDocument> getPendingRequests(String userId) {
        List<String> ids = userNodeRepo.findPendingRequests(userId).stream()
                .map(UserNode::getUserId)
                .toList();
        return resolveProfiles(ids);
    }

    // solicitudes enviadas por el user que siguen pendientes
    public List<UserDocument> getSentRequests(String userId) {
        List<String> ids = userNodeRepo.findSentRequests(userId).stream()
                .map(UserNode::getUserId)
                .toList();
        return resolveProfiles(ids);
    }

    // cancela una solicitud enviada por el user (borra la arista PENDING_FRIEND saliente)
    public void cancelRequest(String userId, String targetId) {
        userNodeRepo.rejectRequest(targetId, userId);
        log.debug("friend request cancelada: {} canceló solicitud a {}", userId, targetId);
    }

    // — helpers —

    // el nodo debe existir (lo crea GraphSyncService al registrarse el user)
    private void requireNode(String userId) {
        if (userNodeRepo.findByUserId(userId).isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "usuario no encontrado en el grafo: " + userId);
        }
    }

    // resuelve userIds del grafo a perfiles de mongo, preservando el orden de entrada
    private List<UserDocument> resolveProfiles(List<String> userIds) {
        if (userIds.isEmpty()) return List.of();
        Map<String, UserDocument> byId = userRepository.findByUserIdIn(userIds).stream()
                .collect(Collectors.toMap(UserDocument::getUserId, Function.identity()));
        return userIds.stream()
                .map(byId::get)
                .filter(java.util.Objects::nonNull)
                .toList();
    }
}
