package com.cache.domain.neo4j.repository;

import com.cache.domain.neo4j.node.EventNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EventNodeRepository extends Neo4jRepository<EventNode, Long> {

    Optional<EventNode> findByEventId(String eventId);

    boolean existsByEventId(String eventId);

    // "eventos populares en tu ciudad": ranking por cantidad de anotados (ATTENDING).
    // pensado para usuarios sin amigos aún, donde el grafo social no aporta señales
    @Query("""
        MATCH (e:Event)<-[:ATTENDING]-(:User)
        WHERE e.city = $city AND e.startsAtEpoch > $nowEpoch
        RETURN e.eventId AS eventId, count(*) AS attendees
        ORDER BY attendees DESC
        LIMIT $limit
        """)
    List<PopularEvent> findPopularEventsInCity(String city, long nowEpoch, int limit);

    // proyección: evento y cuántos anotados tiene en el grafo
    interface PopularEvent {
        String getEventId();
        long getAttendees();
    }
}
