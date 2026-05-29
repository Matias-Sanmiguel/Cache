package com.cache.domain.neo4j.relationship;

import com.cache.domain.neo4j.node.EventNode;
import lombok.Data;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.RelationshipProperties;
import org.springframework.data.neo4j.core.schema.TargetNode;

import java.time.Instant;

@RelationshipProperties
@Data
public class AttendingRel {

    @Id @GeneratedValue
    private Long id;

    @TargetNode
    private EventNode event;

    private Instant registeredAt;
    private String status; // confirmed, pending, cancelled
}
