package com.cache.api;

import com.cache.api.dto.RegisterRequest;
import com.cache.api.dto.UpdateProfileRequest;
import com.cache.api.dto.UserResponse;
import com.cache.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

// mongodb como store de identidad/perfil (auth)
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse register(@Valid @RequestBody RegisterRequest req) {
        return UserResponse.from(userService.register(req));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<UserResponse> byId(@PathVariable String userId) {
        return userService.findById(userId)
                .map(UserResponse::from)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{userId}")
    public UserResponse update(@PathVariable String userId, @RequestBody UpdateProfileRequest req) {
        return UserResponse.from(userService.updateProfile(userId, req));
    }

    // borra el user en mongo y su nodo (con relaciones) en neo4j
    @DeleteMapping("/{userId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable String userId) {
        userService.deleteUser(userId);
    }
}
