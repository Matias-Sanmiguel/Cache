package com.cache.api;

import com.cache.api.dto.UpdateProfileRequest;
import com.cache.api.dto.UserProfileDTO;
import com.cache.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

// mongodb como store de identidad/perfil. el registro vive en /auth/register.
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    // perfil del user autenticado
    @GetMapping("/me")
    public UserProfileDTO me(@AuthenticationPrincipal String userId) {
        return userService.findById(userId)
                .map(UserProfileDTO::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "usuario no encontrado"));
    }

    // actualizar el propio perfil
    @PutMapping("/me")
    public UserProfileDTO updateMe(@AuthenticationPrincipal String userId, @RequestBody UpdateProfileRequest req) {
        return UserProfileDTO.from(userService.updateProfile(userId, req));
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
