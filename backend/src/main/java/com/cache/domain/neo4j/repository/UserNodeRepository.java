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

    // amigos de amigos que van a un evento — base del motor de recomendación
    @Query("""
        MATCH (me:User {userId: $userId})-[:FRIENDS_WITH]-(friend:User)-[:ATTENDING]->(e:Event)
        WHERE e.startsAtEpoch > $nowEpoch
        RETURN e.eventId AS eventId, count(friend) AS friendCount
        ORDER BY friendCount DESC
        LIMIT $limit
        """)
    List<EventRecommendation> findEventsAttendedByFriends(String userId, long nowEpoch, int limit);

    // proyección para la consulta anterior
    interface EventRecommendation {
        String getEventId();
        long getFriendCount();
    }

    // amigos del user que van a un evento específico
    @Query("""
        MATCH (me:User {userId: $userId})-[:FRIENDS_WITH]-(friend:User)-[:ATTENDING]->(e:Event {eventId: $eventId})
        RETURN friend
        """)
    List<UserNode> findFriendsAttendingEvent(String userId, String eventId);

    // verificar si dos usuarios son amigos
    @Query("""
        RETURN EXISTS {
          MATCH (a:User {userId: $userId1})-[:FRIENDS_WITH]-(b:User {userId: $userId2})
        }
        """)
    boolean areFriends(String userId1, String userId2);
}
