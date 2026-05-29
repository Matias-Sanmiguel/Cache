package com.cache.domain.neo4j.repository;

import com.cache.domain.neo4j.node.EventNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EventNodeRepository extends Neo4jRepository<EventNode, Long> {

    Optional<EventNode> findByEventId(String eventId);

    boolean existsByEventId(String eventId);
}
