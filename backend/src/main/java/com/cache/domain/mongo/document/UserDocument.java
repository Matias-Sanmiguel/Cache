package com.cache.domain.mongo.document;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

// mongodb: identidad y perfil. el grafo social vive en neo4j (mismo userId)
@Document("users")
@Data
@Builder
public class UserDocument {

    @Id
    private String id;

    // UUID compartido con el UserNode de neo4j
    @Indexed(unique = true)
    private String userId;

    @Indexed(unique = true)
    private String email; // lowercase

    private String passwordHash; // bcrypt — nunca plaintext

    private String displayName;

    @Indexed(unique = true)
    private String handle; // @handle sin el @

    private String avatarColor; // hex "#FF2E2E" para el componente Avatar

    private String city;

    private Instant createdAt;
    private Instant lastActiveAt;
}
