package com.cache.domain.neo4j.node;

import com.cache.domain.neo4j.relationship.AttendingRel;
import lombok.Data;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.ArrayList;
import java.util.List;

@Node("User")
@Data
public class UserNode {

    @Id @GeneratedValue
    private Long id;

    private String userId;
    private String name;
    private String city;

    @Relationship(type = "FRIENDS_WITH")
    private List<UserNode> friends = new ArrayList<>();

    // eventos a los que el user se anotó — con timestamp en la relación
    @Relationship(type = "ATTENDING")
    private List<AttendingRel> attending = new ArrayList<>();
}
