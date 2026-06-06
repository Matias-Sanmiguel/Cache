package com.cache.domain.neo4j.repository;

import com.cache.domain.neo4j.node.UserNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserNodeRepository extends Neo4jRepository<UserNode, Long> {

    Optional<UserNode> findByUserId(String userId);

    // ─────────────────────────────────────────────────────────────
    // sincronización con mongodb (4.3) — el userId es la clave compartida
    // ─────────────────────────────────────────────────────────────

    // crea o actualiza el nodo manteniendo el mismo userId que el UserDocument.
    // MERGE por userId hace la operación idempotente (no duplica nodos)
    @Query("""
        MERGE (u:User {userId: $userId})
        SET u.name = $name, u.city = $city
        """)
    void upsertUser(String userId, String name, String city);

    // borra el nodo y todas sus relaciones (amistades, pending, attending)
    @Query("""
        MATCH (u:User {userId: $userId})
        DETACH DELETE u
        """)
    void deleteByUserId(String userId);

    // ─────────────────────────────────────────────────────────────
    // sistema de amistades (4.1)
    // modelo: (a)-[:PENDING_FRIEND]->(b) solicitud; (a)-[:FRIENDS_WITH]-(b) amistad
    // ─────────────────────────────────────────────────────────────

    // envía solicitud: arista dirigida solicitante → destinatario.
    // idempotente: reenviar no duplica ni resetea el timestamp
    @Query("""
        MATCH (from:User {userId: $fromUserId})
        MATCH (to:User {userId: $toUserId})
        MERGE (from)-[r:PENDING_FRIEND]->(to)
        ON CREATE SET r.requestedAt = timestamp()
        """)
    void createPendingRequest(String fromUserId, String toUserId);

    // acepta: borra la solicitud pendiente (en cualquier dirección) y crea la amistad.
    // FRIENDS_WITH se modela sin dirección — una sola arista entre los dos
    @Query("""
        MATCH (me:User {userId: $userId})
        MATCH (requester:User {userId: $requesterId})
        OPTIONAL MATCH (me)-[p:PENDING_FRIEND]-(requester)
        DELETE p
        WITH me, requester
        MERGE (me)-[f:FRIENDS_WITH]-(requester)
        ON CREATE SET f.since = timestamp()
        """)
    void acceptRequest(String userId, String requesterId);

    // rechaza: solo borra la solicitud pendiente, sin crear amistad
    @Query("""
        MATCH (me:User {userId: $userId})-[p:PENDING_FRIEND]-(requester:User {userId: $requesterId})
        DELETE p
        """)
    void rejectRequest(String userId, String requesterId);

    // deshace una amistad existente (en cualquier dirección)
    @Query("""
        MATCH (me:User {userId: $userId})-[f:FRIENDS_WITH]-(friend:User {userId: $friendId})
        DELETE f
        """)
    void deleteFriendship(String userId, String friendId);

    // solicitudes pendientes recibidas por un user — quiénes le mandaron solicitud
    @Query("""
        MATCH (requester:User)-[:PENDING_FRIEND]->(me:User {userId: $userId})
        RETURN requester
        """)
    List<UserNode> findPendingRequests(String userId);

    // amigos confirmados de un user
    @Query("""
        MATCH (me:User {userId: $userId})-[:FRIENDS_WITH]-(friend:User)
        RETURN friend
        """)
    List<UserNode> findFriends(String userId);

    // solo los userId de los amigos — liviano, para cruzar con otros motores (cassandra)
    @Query("""
        MATCH (me:User {userId: $userId})-[:FRIENDS_WITH]-(friend:User)
        RETURN friend.userId
        """)
    List<String> findFriendIds(String userId);

    // verificar si dos usuarios son amigos
    @Query("""
        RETURN EXISTS {
          MATCH (a:User {userId: $userId1})-[:FRIENDS_WITH]-(b:User {userId: $userId2})
        }
        """)
    boolean areFriends(String userId1, String userId2);

    // ─────────────────────────────────────────────────────────────
    // recomendaciones (4.2)
    // ─────────────────────────────────────────────────────────────

    // eventos futuros a los que van amigos — principal algoritmo de descubrimiento
    @Query("""
        MATCH (me:User {userId: $userId})-[:FRIENDS_WITH]-(friend:User)-[:ATTENDING]->(e:Event)
        WHERE e.startsAtEpoch > $nowEpoch
        WITH e, count(friend) AS friendCount
        RETURN e.eventId AS eventId
        ORDER BY friendCount DESC
        LIMIT $limit
        """)
    // devuelve solo el eventId (una columna escalar → List<String>). Evita las
    // projection-interfaces de SDN, que se mapean sobre el aggregate root (UserNode)
    // y rompen en queries de agregación con columnas crudas.
    List<String> findEventsAttendedByFriends(String userId, long nowEpoch, int limit);

    // amigos del user que van a un evento específico
    @Query("""
        MATCH (me:User {userId: $userId})-[:FRIENDS_WITH]-(friend:User)-[:ATTENDING]->(e:Event {eventId: $eventId})
        RETURN friend
        """)
    List<UserNode> findFriendsAttendingEvent(String userId, String eventId);

    // "personas que quizás conozcas": amigos de amigos sin relación directa ni solicitud
    // ordenado por cantidad de amigos en común
    @Query("""
        MATCH (me:User {userId: $userId})-[:FRIENDS_WITH]-(:User)-[:FRIENDS_WITH]-(suggestion:User)
        WHERE suggestion.userId <> $userId
          AND NOT (me)-[:FRIENDS_WITH]-(suggestion)
          AND NOT (me)-[:PENDING_FRIEND]-(suggestion)
        RETURN suggestion.userId AS userId, count(*) AS mutualFriends
        ORDER BY mutualFriends DESC
        LIMIT $limit
        """)
    List<PersonSuggestion> findPeopleYouMayKnow(String userId, int limit);

    // proyección: a quién sugerir y con cuántos amigos en común
    interface PersonSuggestion {
        String getUserId();
        long getMutualFriends();
    }

    // friendCount por evento, en batch — cuántos amigos del user van a cada evento de una lista.
    // alimenta EventSummaryDTO en el feed sin hacer N consultas
    @Query("""
        UNWIND $eventIds AS eid
        MATCH (me:User {userId: $userId})-[:FRIENDS_WITH]-(f:User)-[:ATTENDING]->(e:Event {eventId: eid})
        RETURN eid AS eventId, count(DISTINCT f) AS friendCount
        """)
    List<EventFriendCountRow> countFriendsAttendingEvents(String userId, List<String> eventIds);

    // DTO de resultados para queries de agregación (evita projections sobre el aggregate root)
    record EventFriendCountRow(String eventId, long friendCount) {}
}
