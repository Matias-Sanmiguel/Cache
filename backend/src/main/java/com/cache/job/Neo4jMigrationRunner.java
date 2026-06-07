package com.cache.job;

import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.repository.UserRepository;
import com.cache.service.GraphSyncService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.util.List;

// migración one-time: puebla Neo4j con todos los UserNode que falten,
// en base a los UserDocument que ya existen en Mongo.
//
// se ejecuta automáticamente al arrancar la app.
// es seguro correrlo múltiples veces — el upsertUser de Neo4j usa MERGE,
// así que no duplica nodos ni pisa relaciones existentes (amistades, ATTENDING, etc).
//
// una vez que todos los envs estén migrados se puede borrar esta clase o
// moverla a un perfil "migration" para que no corra en prod innecesariamente.
@Component
@RequiredArgsConstructor
@Slf4j
@Profile("!test") // no corre en tests unitarios
public class Neo4jMigrationRunner implements CommandLineRunner {

    private final UserRepository   userRepository;
    private final GraphSyncService graphSyncService;

    @Override
    public void run(String... args) {
        log.info("Neo4jMigrationRunner: iniciando sync de usuarios Mongo → Neo4j");

        List<UserDocument> allUsers = userRepository.findAll();
        int total   = allUsers.size();
        int synced  = 0;
        int failed  = 0;

        for (UserDocument user : allUsers) {
            try {
                graphSyncService.syncUser(user);
                synced++;
            } catch (Exception e) {
                // no cortamos la migración si un user falla — logueamos y seguimos
                log.error("Neo4jMigrationRunner: falló sync userId={} — {}",
                        user.getUserId(), e.getMessage());
                failed++;
            }
        }

        log.info("Neo4jMigrationRunner: finalizado — total={} synced={} failed={}",
                total, synced, failed);
    }
}