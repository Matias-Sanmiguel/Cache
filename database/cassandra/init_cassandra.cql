CREATE KEYSPACE IF NOT EXISTS cache_logs
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
}
    AND durable_writes = true;

USE cache_logs;


CREATE TABLE login_logs (
    user_id UUID,
    event_date DATE,
    event_time TIMESTAMP,
    ip_address TEXT,
    device TEXT,
    success BOOLEAN,

    PRIMARY KEY ((user_id), event_date, event_time)
)
WITH CLUSTERING ORDER BY (event_date DESC, event_time DESC);


CREATE TABLE user_activity_logs (
    user_id UUID,
    activity_date DATE,
    activity_time TIMESTAMP,
    activity_type TEXT,
    entity_type TEXT,
    entity_id UUID,
    description TEXT,

    PRIMARY KEY ((user_id), activity_date, activity_time)
)
WITH CLUSTERING ORDER BY (activity_date DESC, activity_time DESC);


CREATE TABLE attendance_logs (
    user_id UUID,
    event_id UUID,
    action_time TIMESTAMP,
    action_type TEXT,

    PRIMARY KEY ((user_id), action_time)
)
WITH CLUSTERING ORDER BY (action_time DESC);


CREATE TABLE location_logs (
    user_id UUID,
    log_date DATE,
    event_time TIMESTAMP,
    latitude DOUBLE,
    longitude DOUBLE,

    PRIMARY KEY ((user_id), log_date, event_time)
)
WITH CLUSTERING ORDER BY (log_date DESC, event_time DESC);


CREATE TABLE recommendation_logs (
    user_id UUID,
    recommendation_time TIMESTAMP,
    event_id UUID,
    score DOUBLE,
    reason TEXT,

    PRIMARY KEY ((user_id), recommendation_time)
)
WITH CLUSTERING ORDER BY (recommendation_time DESC);


CREATE TABLE system_logs (
    service_name TEXT,
    log_date DATE,
    event_time TIMESTAMP,
    level TEXT,
    message TEXT,

    PRIMARY KEY ((service_name), log_date, event_time)
)
WITH CLUSTERING ORDER BY (log_date DESC, event_time DESC);


ALTER TABLE login_logs
WITH default_time_to_live = 31536000;
