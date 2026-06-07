package com.cache.domain.mongo.repository;

import com.cache.domain.mongo.document.UserDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<UserDocument, String> {

    Optional<UserDocument> findByEmail(String email);

    Optional<UserDocument> findByHandle(String handle);

    Optional<UserDocument> findByUserId(String userId);

    // resolución por lote de userIds (p. ej. amigos/sugerencias que vienen del grafo neo4j)
    List<UserDocument> findByUserIdIn(Collection<String> userIds);

    boolean existsByEmail(String email);

    boolean existsByHandle(String handle);

    // búsqueda por handle o nombre (regex case-insensitive) — para agregar amigos
    @Query("{ $or: [ { 'handle': { $regex: ?0, $options: 'i' } }, { 'displayName': { $regex: ?0, $options: 'i' } } ] }")
    List<UserDocument> searchByHandleOrName(String regex);
}
