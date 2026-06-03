package com.cache.service;

import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

// mantiene el grafo de neo4j en sync con la identidad que vive en mongodb (4.3).
// el userId es la clave compartida entre UserDocument (mongo) y UserNode (neo4j).
@Service
@RequiredArgsConstructor
@Slf4j
public class GraphSyncService {

    private final UserNodeRepository userNodeRepo;

    // al crear/actualizar un UserDocument → upsert del UserNode con el mismo userId.
    // idempotente: si el nodo ya existe solo refresca name/city
    public void syncUser(UserDocument user) {
        userNodeRepo.upsertUser(user.getUserId(), user.getDisplayName(), user.getCity());
        log.debug("sync neo4j: upsert UserNode userId={}", user.getUserId());
    }

    // al borrar un user → DETACH DELETE del nodo (se lleva amistades y pending requests)
    public void removeUser(String userId) {
        userNodeRepo.deleteByUserId(userId);
        log.debug("sync neo4j: delete UserNode userId={}", userId);
    }
}
