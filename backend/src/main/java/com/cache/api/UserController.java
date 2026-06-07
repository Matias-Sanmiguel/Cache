package com.cache.api;

import com.cache.api.dto.AccountDTO;
import com.cache.api.dto.UpdateProfileRequest;
import com.cache.api.dto.UserProfileDTO;
import com.cache.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

// mongodb como store de identidad/perfil. el registro vive en /auth/register.
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    // búsqueda de usuarios por @handle o nombre — para agregar amigos (excluye al propio user)
    @GetMapping("/search")
    public List<UserProfileDTO> search(@AuthenticationPrincipal String userId, @RequestParam String q) {
        return userService.search(q, userId).stream().map(UserProfileDTO::from).toList();
    }

    // perfil del user autenticado — DTO completo (email/role/venueId), es self
    @GetMapping("/me")
    public AccountDTO me(@AuthenticationPrincipal String userId) {
        return userService.findById(userId)
                .map(AccountDTO::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "usuario no encontrado"));
    }

    // actualizar el propio perfil
    @PutMapping("/me")
    public AccountDTO updateMe(@AuthenticationPrincipal String userId, @RequestBody UpdateProfileRequest req) {
        return AccountDTO.from(userService.updateProfile(userId, req));
    }

    // borra la propia cuenta (mongo + nodo neo4j)
    @DeleteMapping("/me")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteMe(@AuthenticationPrincipal String userId) {
        userService.deleteUser(userId);
    }

    // perfil público de otro user
    @GetMapping("/{id}")
    public ResponseEntity<UserProfileDTO> byId(@PathVariable String id) {
        return userService.findById(id)
                .map(UserProfileDTO::from)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
