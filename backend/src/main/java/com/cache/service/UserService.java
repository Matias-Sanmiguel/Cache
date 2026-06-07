package com.cache.service;

import com.cache.api.dto.RegisterRequest;
import com.cache.api.dto.UpdateProfileRequest;
import com.cache.domain.mongo.document.Role;
import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.regex.Pattern;

// identidad/perfil en mongo. el grafo social (amistades) se maneja en neo4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final GraphSyncService graphSyncService;

    public UserDocument register(RegisterRequest req) {
        String email = req.email().toLowerCase().trim();
        String handle = req.handle().toLowerCase().trim().replaceFirst("^@", "");

        if (userRepository.existsByEmail(email)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "email ya registrado");
        }
        if (userRepository.existsByHandle(handle)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "handle ya en uso");
        }

        Role role = req.role() != null ? req.role() : Role.VISITOR;

        Instant now = Instant.now();
        UserDocument user = UserDocument.builder()
                .userId(UUID.randomUUID().toString())
                .email(email)
                .passwordHash(passwordEncoder.encode(req.password()))
                .role(role)
                .venueId(role == Role.VENUE_OWNER ? req.venueId() : null)
                .displayName(req.displayName())
                .handle(handle)
                .avatarColor(req.avatarColor() != null ? req.avatarColor() : "#E8E6DF")
                .city(req.city())
                .createdAt(now)
                .lastActiveAt(now)
                .build();

        UserDocument saved = userRepository.save(user);

        // 4.3 consistencia: replicar la identidad como nodo en el grafo social (neo4j)
        graphSyncService.syncUser(saved);

        return saved;
    }

    public Optional<UserDocument> findById(String userId) {
        return userRepository.findByUserId(userId);
    }

    // vincula un venue a la cuenta del merchant (lo usa el alta de venue)
    public UserDocument assignVenue(String userId, String venueId) {
        UserDocument user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "usuario no encontrado"));
        user.setVenueId(venueId);
        user.setLastActiveAt(Instant.now());
        return userRepository.save(user);
    }

    private static final int SEARCH_LIMIT = 10;

    // busca usuarios por handle o nombre (substring, case-insensitive), excluyendo al propio.
    // mínimo 2 caracteres para no traer media base. Pattern.quote escapa metacaracteres.
    public List<UserDocument> search(String query, String excludeUserId) {
        String q = query == null ? "" : query.trim().replaceFirst("^@", "");
        if (q.length() < 2) return List.of();
        return userRepository.searchByHandleOrName(Pattern.quote(q)).stream()
                .filter(u -> !u.getUserId().equals(excludeUserId))
                .limit(SEARCH_LIMIT)
                .toList();
    }

    // borra la identidad en mongo y el nodo (con sus relaciones) en neo4j
    public void deleteUser(String userId) {
        UserDocument user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "usuario no encontrado"));

        userRepository.delete(user);
        graphSyncService.removeUser(userId);
    }

    public UserDocument updateProfile(String userId, UpdateProfileRequest req) {
        UserDocument user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "usuario no encontrado"));

        if (req.displayName() != null) user.setDisplayName(req.displayName());
        if (req.avatarColor() != null) user.setAvatarColor(req.avatarColor());
        if (req.city() != null) user.setCity(req.city());
        user.setLastActiveAt(Instant.now());

        UserDocument saved = userRepository.save(user);

        // mantener name/city del nodo alineados con el perfil
        graphSyncService.syncUser(saved);

        return saved;
    }
}
