package com.cache.config;

import com.cache.domain.cassandra.logs.entity.LoginLog;
import com.cache.domain.cassandra.logs.entity.UserActivityLog;
import com.cache.domain.cassandra.logs.entity.AttendanceLog;
import com.cache.domain.cassandra.logs.entity.LocationLog;
import com.cache.domain.cassandra.logs.entity.RecommendationLog;
import com.cache.domain.cassandra.logs.entity.SystemLog;
import com.datastax.oss.driver.api.core.CqlSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.cassandra.core.CassandraTemplate;
import org.springframework.data.cassandra.core.convert.CassandraConverter;
import org.springframework.data.cassandra.core.convert.MappingCassandraConverter;
import org.springframework.data.cassandra.core.mapping.CassandraMappingContext;
import org.springframework.data.cassandra.core.mapping.SimpleUserTypeResolver;
import org.springframework.data.cassandra.repository.support.CassandraRepositoryFactory;

import java.net.InetSocketAddress;

// segunda sesión Cassandra apuntando al keyspace cache_logs (logs de auditoría).
// independiente de CassandraConfig (cache_ks) para no mezclar keyspaces en un
// mismo AbstractCassandraConfiguration — Spring SDC no soporta multi-keyspace nativo.
@Configuration
@Slf4j
public class CassandraLogsConfig {

    @Value("${spring.data.cassandra.contact-points}")
    private String contactPoints;

    @Value("${spring.data.cassandra.port:9042}")
    private int port;

    @Value("${spring.data.cassandra.local-datacenter}")
    private String datacenter;

    @Value("${spring.data.cassandra.username}")
    private String username;

    @Value("${spring.data.cassandra.password}")
    private String password;

    @Value("${cache.logs.keyspace:cache_logs}")
    private String logsKeyspace;

    // sesión dedicada al keyspace cache_logs
    @Bean(name = "logsSession")
    public CqlSession logsSession() {
        CqlSession session = CqlSession.builder()
                .addContactPoint(new InetSocketAddress(contactPoints, port))
                .withLocalDatacenter(datacenter)
                .withAuthCredentials(username, password)
                .withKeyspace(logsKeyspace)
                .build();
        log.info("sesión Cassandra logs conectada al keyspace '{}'", logsKeyspace);
        return session;
    }

    // CassandraTemplate dedicado — los repositorios de logs lo usan via constructor
    @Bean(name = "logsTemplate")
    public CassandraTemplate logsTemplate() throws Exception {
        CassandraMappingContext context = new CassandraMappingContext();
        context.setUserTypeResolver(new SimpleUserTypeResolver(logsSession()));
        // registrar las entidades de logs explícitamente
        context.setInitialEntitySet(java.util.Set.of(
                LoginLog.class,
                UserActivityLog.class,
                AttendanceLog.class,
                LocationLog.class,
                RecommendationLog.class,
                SystemLog.class
        ));
        context.afterPropertiesSet();

        CassandraConverter converter = new MappingCassandraConverter(context);
        ((MappingCassandraConverter) converter).afterPropertiesSet();

        return new CassandraTemplate(logsSession(), converter);
    }
}