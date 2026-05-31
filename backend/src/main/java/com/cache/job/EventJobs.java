package com.cache.job;

import com.cache.service.EventCatalogService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

// jobs programados sobre la colección events
@Component
@Slf4j
@RequiredArgsConstructor
public class EventJobs {

    private final EventCatalogService eventCatalogService;

    // transición de estado upcoming → live → finished según startsAt/endsAt
    @Scheduled(fixedDelayString = "${cache.jobs.status-interval-ms:60000}")
    public void transitionStatuses() {
        int changed = eventCatalogService.transitionStatuses();
        if (changed > 0) {
            log.info("job estado: {} eventos transicionados", changed);
        }
    }

    // sincroniza attendeeCount desde redis (volátil) hacia mongo (durable)
    @Scheduled(fixedDelayString = "${cache.jobs.sync-interval-ms:120000}")
    public void syncAttendeeCounts() {
        int synced = eventCatalogService.syncAttendeeCountsFromRedis();
        if (synced > 0) {
            log.info("job sync: {} eventos actualizados desde redis", synced);
        }
    }
}
