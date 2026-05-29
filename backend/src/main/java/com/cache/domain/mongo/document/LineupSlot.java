package com.cache.domain.mongo.document;

import lombok.Data;

@Data
public class LineupSlot {
    private String time;   // "23:30"
    private String slot;   // "OPEN", "PRIME", "PEAK", "CLOSE"
    private String artist;
}
