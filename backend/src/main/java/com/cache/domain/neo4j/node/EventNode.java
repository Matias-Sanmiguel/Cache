package com.cache.domain.neo4j.node;

import lombok.Data;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;

@Node("Event")
@Data
public class EventNode {

    @Id @GeneratedValue
    private Long id;

    private String eventId;   // referencia al _id de MongoDB
    private String name;
    private String venueId;
    private String venueName;
    private String genre;
    private String city;
    private long startsAtEpoch; // epoch millis — evita dependencia de tipo en el grafo
}
