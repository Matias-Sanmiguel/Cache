#!/usr/bin/env bash
set -euo pipefail

# Seed para Redis - Cache
# Genera estado temporal basado en los venues reales de database/mongodb/venue_mongodb.json
# Logica:
# - presence:<user_id> guarda en que venue esta un usuario ahora, con TTL
# - venue:<venue_id>:present guarda el set de usuarios presentes en cada venue
# - event:<event_id>:attendees guarda contadores temporales de asistentes
# - session:<token> guarda sesiones activas con TTL
# - notification:<user_id>:pending guarda notificaciones temporales

: "${REDIS_PASSWORD:?REDIS_PASSWORD no esta definido. Carga el .env o exportalo antes de ejecutar.}"

REDIS="docker exec cache_redis redis-cli -a $REDIS_PASSWORD"

echo "Seeding Redis data..."

# Limpieza de claves del seed anterior
$REDIS --scan --pattern "presence:u*" | xargs -r docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" DEL
$REDIS --scan --pattern "venue:*:present" | xargs -r docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" DEL
$REDIS --scan --pattern "event:e*:attendees" | xargs -r docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" DEL
$REDIS --scan --pattern "session:demo_token_u*" | xargs -r docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" DEL
$REDIS --scan --pattern "notification:u*:pending" | xargs -r docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" DEL

# 3000 usuarios presentes ahora, distribuidos en los 50 venues de MongoDB
$REDIS SET "presence:u1" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1"
$REDIS SET "presence:u2" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2"
$REDIS SET "presence:u3" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u3"
$REDIS SET "presence:u4" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u4"
$REDIS SET "presence:u5" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u5"
$REDIS SET "presence:u6" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u6"
$REDIS SET "presence:u7" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u7"
$REDIS SET "presence:u8" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u8"
$REDIS SET "presence:u9" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u9"
$REDIS SET "presence:u10" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u10"
$REDIS SET "presence:u11" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u11"
$REDIS SET "presence:u12" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u12"
$REDIS SET "presence:u13" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u13"
$REDIS SET "presence:u14" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u14"
$REDIS SET "presence:u15" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u15"
$REDIS SET "presence:u16" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u16"
$REDIS SET "presence:u17" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u17"
$REDIS SET "presence:u18" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u18"
$REDIS SET "presence:u19" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u19"
$REDIS SET "presence:u20" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u20"
$REDIS SET "presence:u21" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u21"
$REDIS SET "presence:u22" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u22"
$REDIS SET "presence:u23" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u23"
$REDIS SET "presence:u24" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u24"
$REDIS SET "presence:u25" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u25"
$REDIS SET "presence:u26" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u26"
$REDIS SET "presence:u27" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u27"
$REDIS SET "presence:u28" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u28"
$REDIS SET "presence:u29" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u29"
$REDIS SET "presence:u30" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u30"
$REDIS SET "presence:u31" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u31"
$REDIS SET "presence:u32" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u32"
$REDIS SET "presence:u33" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u33"
$REDIS SET "presence:u34" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u34"
$REDIS SET "presence:u35" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u35"
$REDIS SET "presence:u36" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u36"
$REDIS SET "presence:u37" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u37"
$REDIS SET "presence:u38" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u38"
$REDIS SET "presence:u39" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u39"
$REDIS SET "presence:u40" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u40"
$REDIS SET "presence:u41" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u41"
$REDIS SET "presence:u42" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u42"
$REDIS SET "presence:u43" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u43"
$REDIS SET "presence:u44" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u44"
$REDIS SET "presence:u45" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u45"
$REDIS SET "presence:u46" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u46"
$REDIS SET "presence:u47" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u47"
$REDIS SET "presence:u48" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u48"
$REDIS SET "presence:u49" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u49"
$REDIS SET "presence:u50" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u50"
$REDIS SET "presence:u51" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u51"
$REDIS SET "presence:u52" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u52"
$REDIS SET "presence:u53" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u53"
$REDIS SET "presence:u54" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u54"
$REDIS SET "presence:u55" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u55"
$REDIS SET "presence:u56" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u56"
$REDIS SET "presence:u57" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u57"
$REDIS SET "presence:u58" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u58"
$REDIS SET "presence:u59" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u59"
$REDIS SET "presence:u60" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u60"
$REDIS SET "presence:u61" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u61"
$REDIS SET "presence:u62" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u62"
$REDIS SET "presence:u63" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u63"
$REDIS SET "presence:u64" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u64"
$REDIS SET "presence:u65" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u65"
$REDIS SET "presence:u66" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u66"
$REDIS SET "presence:u67" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u67"
$REDIS SET "presence:u68" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u68"
$REDIS SET "presence:u69" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u69"
$REDIS SET "presence:u70" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u70"
$REDIS SET "presence:u71" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u71"
$REDIS SET "presence:u72" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u72"
$REDIS SET "presence:u73" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u73"
$REDIS SET "presence:u74" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u74"
$REDIS SET "presence:u75" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u75"
$REDIS SET "presence:u76" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u76"
$REDIS SET "presence:u77" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u77"
$REDIS SET "presence:u78" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u78"
$REDIS SET "presence:u79" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u79"
$REDIS SET "presence:u80" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u80"
$REDIS SET "presence:u81" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u81"
$REDIS SET "presence:u82" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u82"
$REDIS SET "presence:u83" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u83"
$REDIS SET "presence:u84" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u84"
$REDIS SET "presence:u85" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u85"
$REDIS SET "presence:u86" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u86"
$REDIS SET "presence:u87" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u87"
$REDIS SET "presence:u88" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u88"
$REDIS SET "presence:u89" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u89"
$REDIS SET "presence:u90" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u90"
$REDIS SET "presence:u91" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u91"
$REDIS SET "presence:u92" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u92"
$REDIS SET "presence:u93" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u93"
$REDIS SET "presence:u94" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u94"
$REDIS SET "presence:u95" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u95"
$REDIS SET "presence:u96" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u96"
$REDIS SET "presence:u97" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u97"
$REDIS SET "presence:u98" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u98"
$REDIS SET "presence:u99" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u99"
$REDIS SET "presence:u100" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u100"
$REDIS SET "presence:u101" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u101"
$REDIS SET "presence:u102" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u102"
$REDIS SET "presence:u103" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u103"
$REDIS SET "presence:u104" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u104"
$REDIS SET "presence:u105" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u105"
$REDIS SET "presence:u106" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u106"
$REDIS SET "presence:u107" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u107"
$REDIS SET "presence:u108" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u108"
$REDIS SET "presence:u109" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u109"
$REDIS SET "presence:u110" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u110"
$REDIS SET "presence:u111" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u111"
$REDIS SET "presence:u112" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u112"
$REDIS SET "presence:u113" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u113"
$REDIS SET "presence:u114" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u114"
$REDIS SET "presence:u115" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u115"
$REDIS SET "presence:u116" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u116"
$REDIS SET "presence:u117" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u117"
$REDIS SET "presence:u118" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u118"
$REDIS SET "presence:u119" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u119"
$REDIS SET "presence:u120" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u120"
$REDIS SET "presence:u121" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u121"
$REDIS SET "presence:u122" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u122"
$REDIS SET "presence:u123" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u123"
$REDIS SET "presence:u124" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u124"
$REDIS SET "presence:u125" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u125"
$REDIS SET "presence:u126" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u126"
$REDIS SET "presence:u127" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u127"
$REDIS SET "presence:u128" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u128"
$REDIS SET "presence:u129" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u129"
$REDIS SET "presence:u130" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u130"
$REDIS SET "presence:u131" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u131"
$REDIS SET "presence:u132" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u132"
$REDIS SET "presence:u133" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u133"
$REDIS SET "presence:u134" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u134"
$REDIS SET "presence:u135" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u135"
$REDIS SET "presence:u136" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u136"
$REDIS SET "presence:u137" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u137"
$REDIS SET "presence:u138" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u138"
$REDIS SET "presence:u139" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u139"
$REDIS SET "presence:u140" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u140"
$REDIS SET "presence:u141" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u141"
$REDIS SET "presence:u142" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u142"
$REDIS SET "presence:u143" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u143"
$REDIS SET "presence:u144" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u144"
$REDIS SET "presence:u145" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u145"
$REDIS SET "presence:u146" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u146"
$REDIS SET "presence:u147" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u147"
$REDIS SET "presence:u148" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u148"
$REDIS SET "presence:u149" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u149"
$REDIS SET "presence:u150" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u150"
$REDIS SET "presence:u151" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u151"
$REDIS SET "presence:u152" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u152"
$REDIS SET "presence:u153" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u153"
$REDIS SET "presence:u154" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u154"
$REDIS SET "presence:u155" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u155"
$REDIS SET "presence:u156" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u156"
$REDIS SET "presence:u157" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u157"
$REDIS SET "presence:u158" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u158"
$REDIS SET "presence:u159" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u159"
$REDIS SET "presence:u160" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u160"
$REDIS SET "presence:u161" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u161"
$REDIS SET "presence:u162" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u162"
$REDIS SET "presence:u163" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u163"
$REDIS SET "presence:u164" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u164"
$REDIS SET "presence:u165" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u165"
$REDIS SET "presence:u166" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u166"
$REDIS SET "presence:u167" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u167"
$REDIS SET "presence:u168" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u168"
$REDIS SET "presence:u169" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u169"
$REDIS SET "presence:u170" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u170"
$REDIS SET "presence:u171" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u171"
$REDIS SET "presence:u172" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u172"
$REDIS SET "presence:u173" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u173"
$REDIS SET "presence:u174" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u174"
$REDIS SET "presence:u175" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u175"
$REDIS SET "presence:u176" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u176"
$REDIS SET "presence:u177" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u177"
$REDIS SET "presence:u178" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u178"
$REDIS SET "presence:u179" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u179"
$REDIS SET "presence:u180" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u180"
$REDIS SET "presence:u181" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u181"
$REDIS SET "presence:u182" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u182"
$REDIS SET "presence:u183" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u183"
$REDIS SET "presence:u184" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u184"
$REDIS SET "presence:u185" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u185"
$REDIS SET "presence:u186" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u186"
$REDIS SET "presence:u187" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u187"
$REDIS SET "presence:u188" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u188"
$REDIS SET "presence:u189" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u189"
$REDIS SET "presence:u190" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u190"
$REDIS SET "presence:u191" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u191"
$REDIS SET "presence:u192" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u192"
$REDIS SET "presence:u193" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u193"
$REDIS SET "presence:u194" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u194"
$REDIS SET "presence:u195" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u195"
$REDIS SET "presence:u196" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u196"
$REDIS SET "presence:u197" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u197"
$REDIS SET "presence:u198" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u198"
$REDIS SET "presence:u199" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u199"
$REDIS SET "presence:u200" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u200"
$REDIS SET "presence:u201" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u201"
$REDIS SET "presence:u202" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u202"
$REDIS SET "presence:u203" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u203"
$REDIS SET "presence:u204" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u204"
$REDIS SET "presence:u205" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u205"
$REDIS SET "presence:u206" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u206"
$REDIS SET "presence:u207" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u207"
$REDIS SET "presence:u208" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u208"
$REDIS SET "presence:u209" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u209"
$REDIS SET "presence:u210" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u210"
$REDIS SET "presence:u211" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u211"
$REDIS SET "presence:u212" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u212"
$REDIS SET "presence:u213" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u213"
$REDIS SET "presence:u214" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u214"
$REDIS SET "presence:u215" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u215"
$REDIS SET "presence:u216" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u216"
$REDIS SET "presence:u217" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u217"
$REDIS SET "presence:u218" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u218"
$REDIS SET "presence:u219" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u219"
$REDIS SET "presence:u220" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u220"
$REDIS SET "presence:u221" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u221"
$REDIS SET "presence:u222" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u222"
$REDIS SET "presence:u223" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u223"
$REDIS SET "presence:u224" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u224"
$REDIS SET "presence:u225" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u225"
$REDIS SET "presence:u226" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u226"
$REDIS SET "presence:u227" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u227"
$REDIS SET "presence:u228" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u228"
$REDIS SET "presence:u229" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u229"
$REDIS SET "presence:u230" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u230"
$REDIS SET "presence:u231" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u231"
$REDIS SET "presence:u232" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u232"
$REDIS SET "presence:u233" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u233"
$REDIS SET "presence:u234" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u234"
$REDIS SET "presence:u235" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u235"
$REDIS SET "presence:u236" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u236"
$REDIS SET "presence:u237" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u237"
$REDIS SET "presence:u238" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u238"
$REDIS SET "presence:u239" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u239"
$REDIS SET "presence:u240" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u240"
$REDIS SET "presence:u241" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u241"
$REDIS SET "presence:u242" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u242"
$REDIS SET "presence:u243" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u243"
$REDIS SET "presence:u244" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u244"
$REDIS SET "presence:u245" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u245"
$REDIS SET "presence:u246" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u246"
$REDIS SET "presence:u247" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u247"
$REDIS SET "presence:u248" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u248"
$REDIS SET "presence:u249" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u249"
$REDIS SET "presence:u250" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u250"
$REDIS SET "presence:u251" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u251"
$REDIS SET "presence:u252" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u252"
$REDIS SET "presence:u253" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u253"
$REDIS SET "presence:u254" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u254"
$REDIS SET "presence:u255" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u255"
$REDIS SET "presence:u256" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u256"
$REDIS SET "presence:u257" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u257"
$REDIS SET "presence:u258" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u258"
$REDIS SET "presence:u259" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u259"
$REDIS SET "presence:u260" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u260"
$REDIS SET "presence:u261" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u261"
$REDIS SET "presence:u262" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u262"
$REDIS SET "presence:u263" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u263"
$REDIS SET "presence:u264" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u264"
$REDIS SET "presence:u265" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u265"
$REDIS SET "presence:u266" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u266"
$REDIS SET "presence:u267" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u267"
$REDIS SET "presence:u268" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u268"
$REDIS SET "presence:u269" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u269"
$REDIS SET "presence:u270" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u270"
$REDIS SET "presence:u271" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u271"
$REDIS SET "presence:u272" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u272"
$REDIS SET "presence:u273" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u273"
$REDIS SET "presence:u274" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u274"
$REDIS SET "presence:u275" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u275"
$REDIS SET "presence:u276" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u276"
$REDIS SET "presence:u277" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u277"
$REDIS SET "presence:u278" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u278"
$REDIS SET "presence:u279" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u279"
$REDIS SET "presence:u280" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u280"
$REDIS SET "presence:u281" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u281"
$REDIS SET "presence:u282" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u282"
$REDIS SET "presence:u283" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u283"
$REDIS SET "presence:u284" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u284"
$REDIS SET "presence:u285" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u285"
$REDIS SET "presence:u286" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u286"
$REDIS SET "presence:u287" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u287"
$REDIS SET "presence:u288" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u288"
$REDIS SET "presence:u289" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u289"
$REDIS SET "presence:u290" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u290"
$REDIS SET "presence:u291" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u291"
$REDIS SET "presence:u292" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u292"
$REDIS SET "presence:u293" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u293"
$REDIS SET "presence:u294" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u294"
$REDIS SET "presence:u295" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u295"
$REDIS SET "presence:u296" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u296"
$REDIS SET "presence:u297" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u297"
$REDIS SET "presence:u298" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u298"
$REDIS SET "presence:u299" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u299"
$REDIS SET "presence:u300" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u300"
$REDIS SET "presence:u301" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u301"
$REDIS SET "presence:u302" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u302"
$REDIS SET "presence:u303" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u303"
$REDIS SET "presence:u304" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u304"
$REDIS SET "presence:u305" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u305"
$REDIS SET "presence:u306" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u306"
$REDIS SET "presence:u307" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u307"
$REDIS SET "presence:u308" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u308"
$REDIS SET "presence:u309" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u309"
$REDIS SET "presence:u310" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u310"
$REDIS SET "presence:u311" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u311"
$REDIS SET "presence:u312" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u312"
$REDIS SET "presence:u313" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u313"
$REDIS SET "presence:u314" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u314"
$REDIS SET "presence:u315" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u315"
$REDIS SET "presence:u316" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u316"
$REDIS SET "presence:u317" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u317"
$REDIS SET "presence:u318" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u318"
$REDIS SET "presence:u319" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u319"
$REDIS SET "presence:u320" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u320"
$REDIS SET "presence:u321" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u321"
$REDIS SET "presence:u322" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u322"
$REDIS SET "presence:u323" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u323"
$REDIS SET "presence:u324" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u324"
$REDIS SET "presence:u325" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u325"
$REDIS SET "presence:u326" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u326"
$REDIS SET "presence:u327" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u327"
$REDIS SET "presence:u328" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u328"
$REDIS SET "presence:u329" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u329"
$REDIS SET "presence:u330" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u330"
$REDIS SET "presence:u331" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u331"
$REDIS SET "presence:u332" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u332"
$REDIS SET "presence:u333" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u333"
$REDIS SET "presence:u334" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u334"
$REDIS SET "presence:u335" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u335"
$REDIS SET "presence:u336" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u336"
$REDIS SET "presence:u337" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u337"
$REDIS SET "presence:u338" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u338"
$REDIS SET "presence:u339" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u339"
$REDIS SET "presence:u340" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u340"
$REDIS SET "presence:u341" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u341"
$REDIS SET "presence:u342" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u342"
$REDIS SET "presence:u343" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u343"
$REDIS SET "presence:u344" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u344"
$REDIS SET "presence:u345" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u345"
$REDIS SET "presence:u346" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u346"
$REDIS SET "presence:u347" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u347"
$REDIS SET "presence:u348" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u348"
$REDIS SET "presence:u349" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u349"
$REDIS SET "presence:u350" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u350"
$REDIS SET "presence:u351" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u351"
$REDIS SET "presence:u352" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u352"
$REDIS SET "presence:u353" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u353"
$REDIS SET "presence:u354" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u354"
$REDIS SET "presence:u355" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u355"
$REDIS SET "presence:u356" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u356"
$REDIS SET "presence:u357" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u357"
$REDIS SET "presence:u358" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u358"
$REDIS SET "presence:u359" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u359"
$REDIS SET "presence:u360" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u360"
$REDIS SET "presence:u361" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u361"
$REDIS SET "presence:u362" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u362"
$REDIS SET "presence:u363" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u363"
$REDIS SET "presence:u364" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u364"
$REDIS SET "presence:u365" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u365"
$REDIS SET "presence:u366" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u366"
$REDIS SET "presence:u367" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u367"
$REDIS SET "presence:u368" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u368"
$REDIS SET "presence:u369" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u369"
$REDIS SET "presence:u370" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u370"
$REDIS SET "presence:u371" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u371"
$REDIS SET "presence:u372" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u372"
$REDIS SET "presence:u373" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u373"
$REDIS SET "presence:u374" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u374"
$REDIS SET "presence:u375" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u375"
$REDIS SET "presence:u376" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u376"
$REDIS SET "presence:u377" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u377"
$REDIS SET "presence:u378" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u378"
$REDIS SET "presence:u379" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u379"
$REDIS SET "presence:u380" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u380"
$REDIS SET "presence:u381" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u381"
$REDIS SET "presence:u382" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u382"
$REDIS SET "presence:u383" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u383"
$REDIS SET "presence:u384" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u384"
$REDIS SET "presence:u385" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u385"
$REDIS SET "presence:u386" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u386"
$REDIS SET "presence:u387" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u387"
$REDIS SET "presence:u388" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u388"
$REDIS SET "presence:u389" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u389"
$REDIS SET "presence:u390" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u390"
$REDIS SET "presence:u391" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u391"
$REDIS SET "presence:u392" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u392"
$REDIS SET "presence:u393" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u393"
$REDIS SET "presence:u394" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u394"
$REDIS SET "presence:u395" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u395"
$REDIS SET "presence:u396" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u396"
$REDIS SET "presence:u397" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u397"
$REDIS SET "presence:u398" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u398"
$REDIS SET "presence:u399" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u399"
$REDIS SET "presence:u400" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u400"
$REDIS SET "presence:u401" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u401"
$REDIS SET "presence:u402" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u402"
$REDIS SET "presence:u403" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u403"
$REDIS SET "presence:u404" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u404"
$REDIS SET "presence:u405" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u405"
$REDIS SET "presence:u406" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u406"
$REDIS SET "presence:u407" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u407"
$REDIS SET "presence:u408" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u408"
$REDIS SET "presence:u409" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u409"
$REDIS SET "presence:u410" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u410"
$REDIS SET "presence:u411" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u411"
$REDIS SET "presence:u412" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u412"
$REDIS SET "presence:u413" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u413"
$REDIS SET "presence:u414" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u414"
$REDIS SET "presence:u415" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u415"
$REDIS SET "presence:u416" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u416"
$REDIS SET "presence:u417" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u417"
$REDIS SET "presence:u418" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u418"
$REDIS SET "presence:u419" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u419"
$REDIS SET "presence:u420" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u420"
$REDIS SET "presence:u421" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u421"
$REDIS SET "presence:u422" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u422"
$REDIS SET "presence:u423" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u423"
$REDIS SET "presence:u424" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u424"
$REDIS SET "presence:u425" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u425"
$REDIS SET "presence:u426" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u426"
$REDIS SET "presence:u427" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u427"
$REDIS SET "presence:u428" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u428"
$REDIS SET "presence:u429" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u429"
$REDIS SET "presence:u430" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u430"
$REDIS SET "presence:u431" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u431"
$REDIS SET "presence:u432" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u432"
$REDIS SET "presence:u433" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u433"
$REDIS SET "presence:u434" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u434"
$REDIS SET "presence:u435" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u435"
$REDIS SET "presence:u436" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u436"
$REDIS SET "presence:u437" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u437"
$REDIS SET "presence:u438" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u438"
$REDIS SET "presence:u439" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u439"
$REDIS SET "presence:u440" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u440"
$REDIS SET "presence:u441" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u441"
$REDIS SET "presence:u442" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u442"
$REDIS SET "presence:u443" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u443"
$REDIS SET "presence:u444" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u444"
$REDIS SET "presence:u445" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u445"
$REDIS SET "presence:u446" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u446"
$REDIS SET "presence:u447" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u447"
$REDIS SET "presence:u448" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u448"
$REDIS SET "presence:u449" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u449"
$REDIS SET "presence:u450" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u450"
$REDIS SET "presence:u451" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u451"
$REDIS SET "presence:u452" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u452"
$REDIS SET "presence:u453" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u453"
$REDIS SET "presence:u454" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u454"
$REDIS SET "presence:u455" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u455"
$REDIS SET "presence:u456" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u456"
$REDIS SET "presence:u457" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u457"
$REDIS SET "presence:u458" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u458"
$REDIS SET "presence:u459" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u459"
$REDIS SET "presence:u460" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u460"
$REDIS SET "presence:u461" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u461"
$REDIS SET "presence:u462" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u462"
$REDIS SET "presence:u463" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u463"
$REDIS SET "presence:u464" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u464"
$REDIS SET "presence:u465" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u465"
$REDIS SET "presence:u466" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u466"
$REDIS SET "presence:u467" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u467"
$REDIS SET "presence:u468" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u468"
$REDIS SET "presence:u469" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u469"
$REDIS SET "presence:u470" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u470"
$REDIS SET "presence:u471" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u471"
$REDIS SET "presence:u472" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u472"
$REDIS SET "presence:u473" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u473"
$REDIS SET "presence:u474" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u474"
$REDIS SET "presence:u475" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u475"
$REDIS SET "presence:u476" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u476"
$REDIS SET "presence:u477" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u477"
$REDIS SET "presence:u478" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u478"
$REDIS SET "presence:u479" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u479"
$REDIS SET "presence:u480" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u480"
$REDIS SET "presence:u481" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u481"
$REDIS SET "presence:u482" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u482"
$REDIS SET "presence:u483" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u483"
$REDIS SET "presence:u484" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u484"
$REDIS SET "presence:u485" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u485"
$REDIS SET "presence:u486" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u486"
$REDIS SET "presence:u487" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u487"
$REDIS SET "presence:u488" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u488"
$REDIS SET "presence:u489" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u489"
$REDIS SET "presence:u490" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u490"
$REDIS SET "presence:u491" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u491"
$REDIS SET "presence:u492" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u492"
$REDIS SET "presence:u493" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u493"
$REDIS SET "presence:u494" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u494"
$REDIS SET "presence:u495" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u495"
$REDIS SET "presence:u496" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u496"
$REDIS SET "presence:u497" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u497"
$REDIS SET "presence:u498" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u498"
$REDIS SET "presence:u499" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u499"
$REDIS SET "presence:u500" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u500"
$REDIS SET "presence:u501" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u501"
$REDIS SET "presence:u502" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u502"
$REDIS SET "presence:u503" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u503"
$REDIS SET "presence:u504" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u504"
$REDIS SET "presence:u505" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u505"
$REDIS SET "presence:u506" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u506"
$REDIS SET "presence:u507" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u507"
$REDIS SET "presence:u508" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u508"
$REDIS SET "presence:u509" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u509"
$REDIS SET "presence:u510" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u510"
$REDIS SET "presence:u511" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u511"
$REDIS SET "presence:u512" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u512"
$REDIS SET "presence:u513" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u513"
$REDIS SET "presence:u514" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u514"
$REDIS SET "presence:u515" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u515"
$REDIS SET "presence:u516" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u516"
$REDIS SET "presence:u517" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u517"
$REDIS SET "presence:u518" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u518"
$REDIS SET "presence:u519" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u519"
$REDIS SET "presence:u520" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u520"
$REDIS SET "presence:u521" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u521"
$REDIS SET "presence:u522" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u522"
$REDIS SET "presence:u523" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u523"
$REDIS SET "presence:u524" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u524"
$REDIS SET "presence:u525" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u525"
$REDIS SET "presence:u526" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u526"
$REDIS SET "presence:u527" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u527"
$REDIS SET "presence:u528" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u528"
$REDIS SET "presence:u529" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u529"
$REDIS SET "presence:u530" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u530"
$REDIS SET "presence:u531" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u531"
$REDIS SET "presence:u532" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u532"
$REDIS SET "presence:u533" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u533"
$REDIS SET "presence:u534" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u534"
$REDIS SET "presence:u535" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u535"
$REDIS SET "presence:u536" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u536"
$REDIS SET "presence:u537" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u537"
$REDIS SET "presence:u538" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u538"
$REDIS SET "presence:u539" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u539"
$REDIS SET "presence:u540" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u540"
$REDIS SET "presence:u541" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u541"
$REDIS SET "presence:u542" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u542"
$REDIS SET "presence:u543" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u543"
$REDIS SET "presence:u544" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u544"
$REDIS SET "presence:u545" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u545"
$REDIS SET "presence:u546" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u546"
$REDIS SET "presence:u547" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u547"
$REDIS SET "presence:u548" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u548"
$REDIS SET "presence:u549" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u549"
$REDIS SET "presence:u550" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u550"
$REDIS SET "presence:u551" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u551"
$REDIS SET "presence:u552" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u552"
$REDIS SET "presence:u553" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u553"
$REDIS SET "presence:u554" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u554"
$REDIS SET "presence:u555" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u555"
$REDIS SET "presence:u556" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u556"
$REDIS SET "presence:u557" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u557"
$REDIS SET "presence:u558" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u558"
$REDIS SET "presence:u559" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u559"
$REDIS SET "presence:u560" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u560"
$REDIS SET "presence:u561" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u561"
$REDIS SET "presence:u562" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u562"
$REDIS SET "presence:u563" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u563"
$REDIS SET "presence:u564" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u564"
$REDIS SET "presence:u565" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u565"
$REDIS SET "presence:u566" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u566"
$REDIS SET "presence:u567" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u567"
$REDIS SET "presence:u568" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u568"
$REDIS SET "presence:u569" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u569"
$REDIS SET "presence:u570" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u570"
$REDIS SET "presence:u571" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u571"
$REDIS SET "presence:u572" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u572"
$REDIS SET "presence:u573" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u573"
$REDIS SET "presence:u574" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u574"
$REDIS SET "presence:u575" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u575"
$REDIS SET "presence:u576" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u576"
$REDIS SET "presence:u577" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u577"
$REDIS SET "presence:u578" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u578"
$REDIS SET "presence:u579" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u579"
$REDIS SET "presence:u580" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u580"
$REDIS SET "presence:u581" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u581"
$REDIS SET "presence:u582" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u582"
$REDIS SET "presence:u583" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u583"
$REDIS SET "presence:u584" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u584"
$REDIS SET "presence:u585" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u585"
$REDIS SET "presence:u586" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u586"
$REDIS SET "presence:u587" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u587"
$REDIS SET "presence:u588" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u588"
$REDIS SET "presence:u589" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u589"
$REDIS SET "presence:u590" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u590"
$REDIS SET "presence:u591" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u591"
$REDIS SET "presence:u592" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u592"
$REDIS SET "presence:u593" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u593"
$REDIS SET "presence:u594" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u594"
$REDIS SET "presence:u595" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u595"
$REDIS SET "presence:u596" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u596"
$REDIS SET "presence:u597" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u597"
$REDIS SET "presence:u598" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u598"
$REDIS SET "presence:u599" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u599"
$REDIS SET "presence:u600" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u600"
$REDIS SET "presence:u601" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u601"
$REDIS SET "presence:u602" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u602"
$REDIS SET "presence:u603" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u603"
$REDIS SET "presence:u604" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u604"
$REDIS SET "presence:u605" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u605"
$REDIS SET "presence:u606" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u606"
$REDIS SET "presence:u607" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u607"
$REDIS SET "presence:u608" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u608"
$REDIS SET "presence:u609" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u609"
$REDIS SET "presence:u610" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u610"
$REDIS SET "presence:u611" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u611"
$REDIS SET "presence:u612" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u612"
$REDIS SET "presence:u613" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u613"
$REDIS SET "presence:u614" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u614"
$REDIS SET "presence:u615" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u615"
$REDIS SET "presence:u616" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u616"
$REDIS SET "presence:u617" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u617"
$REDIS SET "presence:u618" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u618"
$REDIS SET "presence:u619" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u619"
$REDIS SET "presence:u620" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u620"
$REDIS SET "presence:u621" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u621"
$REDIS SET "presence:u622" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u622"
$REDIS SET "presence:u623" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u623"
$REDIS SET "presence:u624" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u624"
$REDIS SET "presence:u625" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u625"
$REDIS SET "presence:u626" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u626"
$REDIS SET "presence:u627" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u627"
$REDIS SET "presence:u628" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u628"
$REDIS SET "presence:u629" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u629"
$REDIS SET "presence:u630" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u630"
$REDIS SET "presence:u631" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u631"
$REDIS SET "presence:u632" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u632"
$REDIS SET "presence:u633" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u633"
$REDIS SET "presence:u634" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u634"
$REDIS SET "presence:u635" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u635"
$REDIS SET "presence:u636" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u636"
$REDIS SET "presence:u637" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u637"
$REDIS SET "presence:u638" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u638"
$REDIS SET "presence:u639" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u639"
$REDIS SET "presence:u640" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u640"
$REDIS SET "presence:u641" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u641"
$REDIS SET "presence:u642" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u642"
$REDIS SET "presence:u643" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u643"
$REDIS SET "presence:u644" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u644"
$REDIS SET "presence:u645" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u645"
$REDIS SET "presence:u646" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u646"
$REDIS SET "presence:u647" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u647"
$REDIS SET "presence:u648" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u648"
$REDIS SET "presence:u649" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u649"
$REDIS SET "presence:u650" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u650"
$REDIS SET "presence:u651" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u651"
$REDIS SET "presence:u652" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u652"
$REDIS SET "presence:u653" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u653"
$REDIS SET "presence:u654" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u654"
$REDIS SET "presence:u655" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u655"
$REDIS SET "presence:u656" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u656"
$REDIS SET "presence:u657" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u657"
$REDIS SET "presence:u658" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u658"
$REDIS SET "presence:u659" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u659"
$REDIS SET "presence:u660" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u660"
$REDIS SET "presence:u661" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u661"
$REDIS SET "presence:u662" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u662"
$REDIS SET "presence:u663" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u663"
$REDIS SET "presence:u664" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u664"
$REDIS SET "presence:u665" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u665"
$REDIS SET "presence:u666" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u666"
$REDIS SET "presence:u667" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u667"
$REDIS SET "presence:u668" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u668"
$REDIS SET "presence:u669" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u669"
$REDIS SET "presence:u670" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u670"
$REDIS SET "presence:u671" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u671"
$REDIS SET "presence:u672" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u672"
$REDIS SET "presence:u673" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u673"
$REDIS SET "presence:u674" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u674"
$REDIS SET "presence:u675" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u675"
$REDIS SET "presence:u676" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u676"
$REDIS SET "presence:u677" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u677"
$REDIS SET "presence:u678" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u678"
$REDIS SET "presence:u679" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u679"
$REDIS SET "presence:u680" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u680"
$REDIS SET "presence:u681" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u681"
$REDIS SET "presence:u682" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u682"
$REDIS SET "presence:u683" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u683"
$REDIS SET "presence:u684" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u684"
$REDIS SET "presence:u685" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u685"
$REDIS SET "presence:u686" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u686"
$REDIS SET "presence:u687" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u687"
$REDIS SET "presence:u688" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u688"
$REDIS SET "presence:u689" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u689"
$REDIS SET "presence:u690" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u690"
$REDIS SET "presence:u691" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u691"
$REDIS SET "presence:u692" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u692"
$REDIS SET "presence:u693" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u693"
$REDIS SET "presence:u694" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u694"
$REDIS SET "presence:u695" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u695"
$REDIS SET "presence:u696" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u696"
$REDIS SET "presence:u697" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u697"
$REDIS SET "presence:u698" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u698"
$REDIS SET "presence:u699" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u699"
$REDIS SET "presence:u700" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u700"
$REDIS SET "presence:u701" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u701"
$REDIS SET "presence:u702" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u702"
$REDIS SET "presence:u703" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u703"
$REDIS SET "presence:u704" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u704"
$REDIS SET "presence:u705" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u705"
$REDIS SET "presence:u706" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u706"
$REDIS SET "presence:u707" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u707"
$REDIS SET "presence:u708" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u708"
$REDIS SET "presence:u709" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u709"
$REDIS SET "presence:u710" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u710"
$REDIS SET "presence:u711" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u711"
$REDIS SET "presence:u712" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u712"
$REDIS SET "presence:u713" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u713"
$REDIS SET "presence:u714" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u714"
$REDIS SET "presence:u715" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u715"
$REDIS SET "presence:u716" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u716"
$REDIS SET "presence:u717" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u717"
$REDIS SET "presence:u718" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u718"
$REDIS SET "presence:u719" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u719"
$REDIS SET "presence:u720" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u720"
$REDIS SET "presence:u721" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u721"
$REDIS SET "presence:u722" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u722"
$REDIS SET "presence:u723" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u723"
$REDIS SET "presence:u724" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u724"
$REDIS SET "presence:u725" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u725"
$REDIS SET "presence:u726" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u726"
$REDIS SET "presence:u727" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u727"
$REDIS SET "presence:u728" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u728"
$REDIS SET "presence:u729" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u729"
$REDIS SET "presence:u730" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u730"
$REDIS SET "presence:u731" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u731"
$REDIS SET "presence:u732" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u732"
$REDIS SET "presence:u733" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u733"
$REDIS SET "presence:u734" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u734"
$REDIS SET "presence:u735" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u735"
$REDIS SET "presence:u736" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u736"
$REDIS SET "presence:u737" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u737"
$REDIS SET "presence:u738" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u738"
$REDIS SET "presence:u739" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u739"
$REDIS SET "presence:u740" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u740"
$REDIS SET "presence:u741" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u741"
$REDIS SET "presence:u742" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u742"
$REDIS SET "presence:u743" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u743"
$REDIS SET "presence:u744" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u744"
$REDIS SET "presence:u745" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u745"
$REDIS SET "presence:u746" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u746"
$REDIS SET "presence:u747" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u747"
$REDIS SET "presence:u748" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u748"
$REDIS SET "presence:u749" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u749"
$REDIS SET "presence:u750" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u750"
$REDIS SET "presence:u751" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u751"
$REDIS SET "presence:u752" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u752"
$REDIS SET "presence:u753" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u753"
$REDIS SET "presence:u754" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u754"
$REDIS SET "presence:u755" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u755"
$REDIS SET "presence:u756" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u756"
$REDIS SET "presence:u757" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u757"
$REDIS SET "presence:u758" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u758"
$REDIS SET "presence:u759" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u759"
$REDIS SET "presence:u760" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u760"
$REDIS SET "presence:u761" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u761"
$REDIS SET "presence:u762" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u762"
$REDIS SET "presence:u763" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u763"
$REDIS SET "presence:u764" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u764"
$REDIS SET "presence:u765" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u765"
$REDIS SET "presence:u766" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u766"
$REDIS SET "presence:u767" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u767"
$REDIS SET "presence:u768" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u768"
$REDIS SET "presence:u769" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u769"
$REDIS SET "presence:u770" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u770"
$REDIS SET "presence:u771" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u771"
$REDIS SET "presence:u772" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u772"
$REDIS SET "presence:u773" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u773"
$REDIS SET "presence:u774" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u774"
$REDIS SET "presence:u775" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u775"
$REDIS SET "presence:u776" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u776"
$REDIS SET "presence:u777" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u777"
$REDIS SET "presence:u778" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u778"
$REDIS SET "presence:u779" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u779"
$REDIS SET "presence:u780" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u780"
$REDIS SET "presence:u781" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u781"
$REDIS SET "presence:u782" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u782"
$REDIS SET "presence:u783" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u783"
$REDIS SET "presence:u784" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u784"
$REDIS SET "presence:u785" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u785"
$REDIS SET "presence:u786" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u786"
$REDIS SET "presence:u787" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u787"
$REDIS SET "presence:u788" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u788"
$REDIS SET "presence:u789" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u789"
$REDIS SET "presence:u790" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u790"
$REDIS SET "presence:u791" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u791"
$REDIS SET "presence:u792" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u792"
$REDIS SET "presence:u793" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u793"
$REDIS SET "presence:u794" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u794"
$REDIS SET "presence:u795" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u795"
$REDIS SET "presence:u796" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u796"
$REDIS SET "presence:u797" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u797"
$REDIS SET "presence:u798" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u798"
$REDIS SET "presence:u799" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u799"
$REDIS SET "presence:u800" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u800"
$REDIS SET "presence:u801" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u801"
$REDIS SET "presence:u802" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u802"
$REDIS SET "presence:u803" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u803"
$REDIS SET "presence:u804" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u804"
$REDIS SET "presence:u805" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u805"
$REDIS SET "presence:u806" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u806"
$REDIS SET "presence:u807" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u807"
$REDIS SET "presence:u808" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u808"
$REDIS SET "presence:u809" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u809"
$REDIS SET "presence:u810" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u810"
$REDIS SET "presence:u811" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u811"
$REDIS SET "presence:u812" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u812"
$REDIS SET "presence:u813" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u813"
$REDIS SET "presence:u814" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u814"
$REDIS SET "presence:u815" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u815"
$REDIS SET "presence:u816" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u816"
$REDIS SET "presence:u817" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u817"
$REDIS SET "presence:u818" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u818"
$REDIS SET "presence:u819" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u819"
$REDIS SET "presence:u820" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u820"
$REDIS SET "presence:u821" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u821"
$REDIS SET "presence:u822" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u822"
$REDIS SET "presence:u823" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u823"
$REDIS SET "presence:u824" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u824"
$REDIS SET "presence:u825" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u825"
$REDIS SET "presence:u826" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u826"
$REDIS SET "presence:u827" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u827"
$REDIS SET "presence:u828" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u828"
$REDIS SET "presence:u829" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u829"
$REDIS SET "presence:u830" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u830"
$REDIS SET "presence:u831" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u831"
$REDIS SET "presence:u832" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u832"
$REDIS SET "presence:u833" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u833"
$REDIS SET "presence:u834" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u834"
$REDIS SET "presence:u835" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u835"
$REDIS SET "presence:u836" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u836"
$REDIS SET "presence:u837" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u837"
$REDIS SET "presence:u838" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u838"
$REDIS SET "presence:u839" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u839"
$REDIS SET "presence:u840" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u840"
$REDIS SET "presence:u841" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u841"
$REDIS SET "presence:u842" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u842"
$REDIS SET "presence:u843" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u843"
$REDIS SET "presence:u844" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u844"
$REDIS SET "presence:u845" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u845"
$REDIS SET "presence:u846" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u846"
$REDIS SET "presence:u847" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u847"
$REDIS SET "presence:u848" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u848"
$REDIS SET "presence:u849" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u849"
$REDIS SET "presence:u850" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u850"
$REDIS SET "presence:u851" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u851"
$REDIS SET "presence:u852" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u852"
$REDIS SET "presence:u853" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u853"
$REDIS SET "presence:u854" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u854"
$REDIS SET "presence:u855" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u855"
$REDIS SET "presence:u856" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u856"
$REDIS SET "presence:u857" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u857"
$REDIS SET "presence:u858" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u858"
$REDIS SET "presence:u859" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u859"
$REDIS SET "presence:u860" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u860"
$REDIS SET "presence:u861" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u861"
$REDIS SET "presence:u862" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u862"
$REDIS SET "presence:u863" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u863"
$REDIS SET "presence:u864" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u864"
$REDIS SET "presence:u865" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u865"
$REDIS SET "presence:u866" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u866"
$REDIS SET "presence:u867" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u867"
$REDIS SET "presence:u868" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u868"
$REDIS SET "presence:u869" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u869"
$REDIS SET "presence:u870" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u870"
$REDIS SET "presence:u871" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u871"
$REDIS SET "presence:u872" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u872"
$REDIS SET "presence:u873" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u873"
$REDIS SET "presence:u874" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u874"
$REDIS SET "presence:u875" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u875"
$REDIS SET "presence:u876" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u876"
$REDIS SET "presence:u877" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u877"
$REDIS SET "presence:u878" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u878"
$REDIS SET "presence:u879" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u879"
$REDIS SET "presence:u880" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u880"
$REDIS SET "presence:u881" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u881"
$REDIS SET "presence:u882" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u882"
$REDIS SET "presence:u883" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u883"
$REDIS SET "presence:u884" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u884"
$REDIS SET "presence:u885" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u885"
$REDIS SET "presence:u886" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u886"
$REDIS SET "presence:u887" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u887"
$REDIS SET "presence:u888" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u888"
$REDIS SET "presence:u889" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u889"
$REDIS SET "presence:u890" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u890"
$REDIS SET "presence:u891" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u891"
$REDIS SET "presence:u892" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u892"
$REDIS SET "presence:u893" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u893"
$REDIS SET "presence:u894" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u894"
$REDIS SET "presence:u895" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u895"
$REDIS SET "presence:u896" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u896"
$REDIS SET "presence:u897" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u897"
$REDIS SET "presence:u898" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u898"
$REDIS SET "presence:u899" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u899"
$REDIS SET "presence:u900" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u900"
$REDIS SET "presence:u901" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u901"
$REDIS SET "presence:u902" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u902"
$REDIS SET "presence:u903" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u903"
$REDIS SET "presence:u904" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u904"
$REDIS SET "presence:u905" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u905"
$REDIS SET "presence:u906" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u906"
$REDIS SET "presence:u907" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u907"
$REDIS SET "presence:u908" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u908"
$REDIS SET "presence:u909" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u909"
$REDIS SET "presence:u910" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u910"
$REDIS SET "presence:u911" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u911"
$REDIS SET "presence:u912" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u912"
$REDIS SET "presence:u913" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u913"
$REDIS SET "presence:u914" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u914"
$REDIS SET "presence:u915" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u915"
$REDIS SET "presence:u916" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u916"
$REDIS SET "presence:u917" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u917"
$REDIS SET "presence:u918" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u918"
$REDIS SET "presence:u919" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u919"
$REDIS SET "presence:u920" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u920"
$REDIS SET "presence:u921" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u921"
$REDIS SET "presence:u922" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u922"
$REDIS SET "presence:u923" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u923"
$REDIS SET "presence:u924" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u924"
$REDIS SET "presence:u925" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u925"
$REDIS SET "presence:u926" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u926"
$REDIS SET "presence:u927" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u927"
$REDIS SET "presence:u928" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u928"
$REDIS SET "presence:u929" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u929"
$REDIS SET "presence:u930" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u930"
$REDIS SET "presence:u931" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u931"
$REDIS SET "presence:u932" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u932"
$REDIS SET "presence:u933" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u933"
$REDIS SET "presence:u934" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u934"
$REDIS SET "presence:u935" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u935"
$REDIS SET "presence:u936" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u936"
$REDIS SET "presence:u937" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u937"
$REDIS SET "presence:u938" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u938"
$REDIS SET "presence:u939" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u939"
$REDIS SET "presence:u940" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u940"
$REDIS SET "presence:u941" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u941"
$REDIS SET "presence:u942" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u942"
$REDIS SET "presence:u943" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u943"
$REDIS SET "presence:u944" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u944"
$REDIS SET "presence:u945" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u945"
$REDIS SET "presence:u946" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u946"
$REDIS SET "presence:u947" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u947"
$REDIS SET "presence:u948" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u948"
$REDIS SET "presence:u949" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u949"
$REDIS SET "presence:u950" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u950"
$REDIS SET "presence:u951" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u951"
$REDIS SET "presence:u952" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u952"
$REDIS SET "presence:u953" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u953"
$REDIS SET "presence:u954" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u954"
$REDIS SET "presence:u955" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u955"
$REDIS SET "presence:u956" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u956"
$REDIS SET "presence:u957" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u957"
$REDIS SET "presence:u958" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u958"
$REDIS SET "presence:u959" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u959"
$REDIS SET "presence:u960" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u960"
$REDIS SET "presence:u961" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u961"
$REDIS SET "presence:u962" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u962"
$REDIS SET "presence:u963" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u963"
$REDIS SET "presence:u964" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u964"
$REDIS SET "presence:u965" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u965"
$REDIS SET "presence:u966" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u966"
$REDIS SET "presence:u967" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u967"
$REDIS SET "presence:u968" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u968"
$REDIS SET "presence:u969" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u969"
$REDIS SET "presence:u970" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u970"
$REDIS SET "presence:u971" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u971"
$REDIS SET "presence:u972" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u972"
$REDIS SET "presence:u973" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u973"
$REDIS SET "presence:u974" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u974"
$REDIS SET "presence:u975" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u975"
$REDIS SET "presence:u976" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u976"
$REDIS SET "presence:u977" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u977"
$REDIS SET "presence:u978" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u978"
$REDIS SET "presence:u979" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u979"
$REDIS SET "presence:u980" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u980"
$REDIS SET "presence:u981" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u981"
$REDIS SET "presence:u982" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u982"
$REDIS SET "presence:u983" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u983"
$REDIS SET "presence:u984" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u984"
$REDIS SET "presence:u985" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u985"
$REDIS SET "presence:u986" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u986"
$REDIS SET "presence:u987" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u987"
$REDIS SET "presence:u988" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u988"
$REDIS SET "presence:u989" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u989"
$REDIS SET "presence:u990" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u990"
$REDIS SET "presence:u991" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u991"
$REDIS SET "presence:u992" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u992"
$REDIS SET "presence:u993" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u993"
$REDIS SET "presence:u994" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u994"
$REDIS SET "presence:u995" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u995"
$REDIS SET "presence:u996" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u996"
$REDIS SET "presence:u997" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u997"
$REDIS SET "presence:u998" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u998"
$REDIS SET "presence:u999" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u999"
$REDIS SET "presence:u1000" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1000"
$REDIS SET "presence:u1001" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1001"
$REDIS SET "presence:u1002" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1002"
$REDIS SET "presence:u1003" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1003"
$REDIS SET "presence:u1004" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1004"
$REDIS SET "presence:u1005" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1005"
$REDIS SET "presence:u1006" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1006"
$REDIS SET "presence:u1007" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1007"
$REDIS SET "presence:u1008" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1008"
$REDIS SET "presence:u1009" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1009"
$REDIS SET "presence:u1010" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1010"
$REDIS SET "presence:u1011" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1011"
$REDIS SET "presence:u1012" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1012"
$REDIS SET "presence:u1013" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1013"
$REDIS SET "presence:u1014" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1014"
$REDIS SET "presence:u1015" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1015"
$REDIS SET "presence:u1016" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1016"
$REDIS SET "presence:u1017" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1017"
$REDIS SET "presence:u1018" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1018"
$REDIS SET "presence:u1019" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1019"
$REDIS SET "presence:u1020" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1020"
$REDIS SET "presence:u1021" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1021"
$REDIS SET "presence:u1022" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1022"
$REDIS SET "presence:u1023" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1023"
$REDIS SET "presence:u1024" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1024"
$REDIS SET "presence:u1025" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1025"
$REDIS SET "presence:u1026" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1026"
$REDIS SET "presence:u1027" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1027"
$REDIS SET "presence:u1028" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1028"
$REDIS SET "presence:u1029" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1029"
$REDIS SET "presence:u1030" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1030"
$REDIS SET "presence:u1031" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1031"
$REDIS SET "presence:u1032" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1032"
$REDIS SET "presence:u1033" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1033"
$REDIS SET "presence:u1034" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1034"
$REDIS SET "presence:u1035" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1035"
$REDIS SET "presence:u1036" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1036"
$REDIS SET "presence:u1037" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1037"
$REDIS SET "presence:u1038" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1038"
$REDIS SET "presence:u1039" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1039"
$REDIS SET "presence:u1040" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1040"
$REDIS SET "presence:u1041" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1041"
$REDIS SET "presence:u1042" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1042"
$REDIS SET "presence:u1043" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1043"
$REDIS SET "presence:u1044" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1044"
$REDIS SET "presence:u1045" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1045"
$REDIS SET "presence:u1046" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1046"
$REDIS SET "presence:u1047" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1047"
$REDIS SET "presence:u1048" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1048"
$REDIS SET "presence:u1049" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1049"
$REDIS SET "presence:u1050" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1050"
$REDIS SET "presence:u1051" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1051"
$REDIS SET "presence:u1052" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1052"
$REDIS SET "presence:u1053" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1053"
$REDIS SET "presence:u1054" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1054"
$REDIS SET "presence:u1055" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1055"
$REDIS SET "presence:u1056" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1056"
$REDIS SET "presence:u1057" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1057"
$REDIS SET "presence:u1058" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1058"
$REDIS SET "presence:u1059" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1059"
$REDIS SET "presence:u1060" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1060"
$REDIS SET "presence:u1061" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1061"
$REDIS SET "presence:u1062" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1062"
$REDIS SET "presence:u1063" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1063"
$REDIS SET "presence:u1064" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1064"
$REDIS SET "presence:u1065" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1065"
$REDIS SET "presence:u1066" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1066"
$REDIS SET "presence:u1067" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1067"
$REDIS SET "presence:u1068" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1068"
$REDIS SET "presence:u1069" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1069"
$REDIS SET "presence:u1070" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1070"
$REDIS SET "presence:u1071" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1071"
$REDIS SET "presence:u1072" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1072"
$REDIS SET "presence:u1073" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1073"
$REDIS SET "presence:u1074" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1074"
$REDIS SET "presence:u1075" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1075"
$REDIS SET "presence:u1076" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1076"
$REDIS SET "presence:u1077" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1077"
$REDIS SET "presence:u1078" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1078"
$REDIS SET "presence:u1079" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1079"
$REDIS SET "presence:u1080" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1080"
$REDIS SET "presence:u1081" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1081"
$REDIS SET "presence:u1082" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1082"
$REDIS SET "presence:u1083" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1083"
$REDIS SET "presence:u1084" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1084"
$REDIS SET "presence:u1085" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1085"
$REDIS SET "presence:u1086" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1086"
$REDIS SET "presence:u1087" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1087"
$REDIS SET "presence:u1088" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1088"
$REDIS SET "presence:u1089" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1089"
$REDIS SET "presence:u1090" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1090"
$REDIS SET "presence:u1091" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1091"
$REDIS SET "presence:u1092" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1092"
$REDIS SET "presence:u1093" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1093"
$REDIS SET "presence:u1094" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1094"
$REDIS SET "presence:u1095" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1095"
$REDIS SET "presence:u1096" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1096"
$REDIS SET "presence:u1097" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1097"
$REDIS SET "presence:u1098" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1098"
$REDIS SET "presence:u1099" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1099"
$REDIS SET "presence:u1100" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1100"
$REDIS SET "presence:u1101" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1101"
$REDIS SET "presence:u1102" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1102"
$REDIS SET "presence:u1103" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1103"
$REDIS SET "presence:u1104" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1104"
$REDIS SET "presence:u1105" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1105"
$REDIS SET "presence:u1106" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1106"
$REDIS SET "presence:u1107" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1107"
$REDIS SET "presence:u1108" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1108"
$REDIS SET "presence:u1109" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1109"
$REDIS SET "presence:u1110" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1110"
$REDIS SET "presence:u1111" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1111"
$REDIS SET "presence:u1112" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1112"
$REDIS SET "presence:u1113" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1113"
$REDIS SET "presence:u1114" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1114"
$REDIS SET "presence:u1115" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1115"
$REDIS SET "presence:u1116" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1116"
$REDIS SET "presence:u1117" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1117"
$REDIS SET "presence:u1118" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1118"
$REDIS SET "presence:u1119" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1119"
$REDIS SET "presence:u1120" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1120"
$REDIS SET "presence:u1121" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1121"
$REDIS SET "presence:u1122" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1122"
$REDIS SET "presence:u1123" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1123"
$REDIS SET "presence:u1124" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1124"
$REDIS SET "presence:u1125" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1125"
$REDIS SET "presence:u1126" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1126"
$REDIS SET "presence:u1127" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1127"
$REDIS SET "presence:u1128" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1128"
$REDIS SET "presence:u1129" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1129"
$REDIS SET "presence:u1130" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1130"
$REDIS SET "presence:u1131" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1131"
$REDIS SET "presence:u1132" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1132"
$REDIS SET "presence:u1133" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1133"
$REDIS SET "presence:u1134" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1134"
$REDIS SET "presence:u1135" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1135"
$REDIS SET "presence:u1136" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1136"
$REDIS SET "presence:u1137" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1137"
$REDIS SET "presence:u1138" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1138"
$REDIS SET "presence:u1139" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1139"
$REDIS SET "presence:u1140" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1140"
$REDIS SET "presence:u1141" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1141"
$REDIS SET "presence:u1142" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1142"
$REDIS SET "presence:u1143" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1143"
$REDIS SET "presence:u1144" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1144"
$REDIS SET "presence:u1145" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1145"
$REDIS SET "presence:u1146" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1146"
$REDIS SET "presence:u1147" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1147"
$REDIS SET "presence:u1148" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1148"
$REDIS SET "presence:u1149" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1149"
$REDIS SET "presence:u1150" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1150"
$REDIS SET "presence:u1151" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1151"
$REDIS SET "presence:u1152" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1152"
$REDIS SET "presence:u1153" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1153"
$REDIS SET "presence:u1154" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1154"
$REDIS SET "presence:u1155" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1155"
$REDIS SET "presence:u1156" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1156"
$REDIS SET "presence:u1157" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1157"
$REDIS SET "presence:u1158" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1158"
$REDIS SET "presence:u1159" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1159"
$REDIS SET "presence:u1160" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1160"
$REDIS SET "presence:u1161" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1161"
$REDIS SET "presence:u1162" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1162"
$REDIS SET "presence:u1163" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1163"
$REDIS SET "presence:u1164" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1164"
$REDIS SET "presence:u1165" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1165"
$REDIS SET "presence:u1166" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1166"
$REDIS SET "presence:u1167" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1167"
$REDIS SET "presence:u1168" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1168"
$REDIS SET "presence:u1169" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1169"
$REDIS SET "presence:u1170" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1170"
$REDIS SET "presence:u1171" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1171"
$REDIS SET "presence:u1172" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1172"
$REDIS SET "presence:u1173" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1173"
$REDIS SET "presence:u1174" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1174"
$REDIS SET "presence:u1175" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1175"
$REDIS SET "presence:u1176" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1176"
$REDIS SET "presence:u1177" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1177"
$REDIS SET "presence:u1178" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1178"
$REDIS SET "presence:u1179" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1179"
$REDIS SET "presence:u1180" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1180"
$REDIS SET "presence:u1181" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1181"
$REDIS SET "presence:u1182" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1182"
$REDIS SET "presence:u1183" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1183"
$REDIS SET "presence:u1184" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1184"
$REDIS SET "presence:u1185" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1185"
$REDIS SET "presence:u1186" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1186"
$REDIS SET "presence:u1187" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1187"
$REDIS SET "presence:u1188" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1188"
$REDIS SET "presence:u1189" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1189"
$REDIS SET "presence:u1190" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1190"
$REDIS SET "presence:u1191" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1191"
$REDIS SET "presence:u1192" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1192"
$REDIS SET "presence:u1193" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1193"
$REDIS SET "presence:u1194" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1194"
$REDIS SET "presence:u1195" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1195"
$REDIS SET "presence:u1196" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1196"
$REDIS SET "presence:u1197" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1197"
$REDIS SET "presence:u1198" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1198"
$REDIS SET "presence:u1199" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1199"
$REDIS SET "presence:u1200" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1200"
$REDIS SET "presence:u1201" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1201"
$REDIS SET "presence:u1202" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1202"
$REDIS SET "presence:u1203" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1203"
$REDIS SET "presence:u1204" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1204"
$REDIS SET "presence:u1205" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1205"
$REDIS SET "presence:u1206" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1206"
$REDIS SET "presence:u1207" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1207"
$REDIS SET "presence:u1208" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1208"
$REDIS SET "presence:u1209" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1209"
$REDIS SET "presence:u1210" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1210"
$REDIS SET "presence:u1211" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1211"
$REDIS SET "presence:u1212" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1212"
$REDIS SET "presence:u1213" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1213"
$REDIS SET "presence:u1214" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1214"
$REDIS SET "presence:u1215" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1215"
$REDIS SET "presence:u1216" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1216"
$REDIS SET "presence:u1217" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1217"
$REDIS SET "presence:u1218" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1218"
$REDIS SET "presence:u1219" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1219"
$REDIS SET "presence:u1220" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1220"
$REDIS SET "presence:u1221" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1221"
$REDIS SET "presence:u1222" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1222"
$REDIS SET "presence:u1223" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1223"
$REDIS SET "presence:u1224" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1224"
$REDIS SET "presence:u1225" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1225"
$REDIS SET "presence:u1226" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1226"
$REDIS SET "presence:u1227" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1227"
$REDIS SET "presence:u1228" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1228"
$REDIS SET "presence:u1229" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1229"
$REDIS SET "presence:u1230" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1230"
$REDIS SET "presence:u1231" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1231"
$REDIS SET "presence:u1232" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1232"
$REDIS SET "presence:u1233" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1233"
$REDIS SET "presence:u1234" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1234"
$REDIS SET "presence:u1235" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1235"
$REDIS SET "presence:u1236" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1236"
$REDIS SET "presence:u1237" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1237"
$REDIS SET "presence:u1238" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1238"
$REDIS SET "presence:u1239" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1239"
$REDIS SET "presence:u1240" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1240"
$REDIS SET "presence:u1241" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1241"
$REDIS SET "presence:u1242" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1242"
$REDIS SET "presence:u1243" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1243"
$REDIS SET "presence:u1244" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1244"
$REDIS SET "presence:u1245" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1245"
$REDIS SET "presence:u1246" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1246"
$REDIS SET "presence:u1247" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1247"
$REDIS SET "presence:u1248" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1248"
$REDIS SET "presence:u1249" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1249"
$REDIS SET "presence:u1250" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1250"
$REDIS SET "presence:u1251" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1251"
$REDIS SET "presence:u1252" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1252"
$REDIS SET "presence:u1253" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1253"
$REDIS SET "presence:u1254" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1254"
$REDIS SET "presence:u1255" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1255"
$REDIS SET "presence:u1256" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1256"
$REDIS SET "presence:u1257" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1257"
$REDIS SET "presence:u1258" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1258"
$REDIS SET "presence:u1259" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1259"
$REDIS SET "presence:u1260" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1260"
$REDIS SET "presence:u1261" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1261"
$REDIS SET "presence:u1262" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1262"
$REDIS SET "presence:u1263" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1263"
$REDIS SET "presence:u1264" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1264"
$REDIS SET "presence:u1265" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1265"
$REDIS SET "presence:u1266" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1266"
$REDIS SET "presence:u1267" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1267"
$REDIS SET "presence:u1268" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1268"
$REDIS SET "presence:u1269" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1269"
$REDIS SET "presence:u1270" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1270"
$REDIS SET "presence:u1271" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1271"
$REDIS SET "presence:u1272" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1272"
$REDIS SET "presence:u1273" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1273"
$REDIS SET "presence:u1274" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1274"
$REDIS SET "presence:u1275" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1275"
$REDIS SET "presence:u1276" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1276"
$REDIS SET "presence:u1277" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1277"
$REDIS SET "presence:u1278" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1278"
$REDIS SET "presence:u1279" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1279"
$REDIS SET "presence:u1280" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1280"
$REDIS SET "presence:u1281" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1281"
$REDIS SET "presence:u1282" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1282"
$REDIS SET "presence:u1283" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1283"
$REDIS SET "presence:u1284" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1284"
$REDIS SET "presence:u1285" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1285"
$REDIS SET "presence:u1286" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1286"
$REDIS SET "presence:u1287" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1287"
$REDIS SET "presence:u1288" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1288"
$REDIS SET "presence:u1289" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1289"
$REDIS SET "presence:u1290" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1290"
$REDIS SET "presence:u1291" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1291"
$REDIS SET "presence:u1292" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1292"
$REDIS SET "presence:u1293" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1293"
$REDIS SET "presence:u1294" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1294"
$REDIS SET "presence:u1295" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1295"
$REDIS SET "presence:u1296" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1296"
$REDIS SET "presence:u1297" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1297"
$REDIS SET "presence:u1298" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1298"
$REDIS SET "presence:u1299" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1299"
$REDIS SET "presence:u1300" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1300"
$REDIS SET "presence:u1301" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1301"
$REDIS SET "presence:u1302" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1302"
$REDIS SET "presence:u1303" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1303"
$REDIS SET "presence:u1304" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1304"
$REDIS SET "presence:u1305" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1305"
$REDIS SET "presence:u1306" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1306"
$REDIS SET "presence:u1307" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1307"
$REDIS SET "presence:u1308" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1308"
$REDIS SET "presence:u1309" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1309"
$REDIS SET "presence:u1310" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1310"
$REDIS SET "presence:u1311" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1311"
$REDIS SET "presence:u1312" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1312"
$REDIS SET "presence:u1313" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1313"
$REDIS SET "presence:u1314" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1314"
$REDIS SET "presence:u1315" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1315"
$REDIS SET "presence:u1316" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1316"
$REDIS SET "presence:u1317" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1317"
$REDIS SET "presence:u1318" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1318"
$REDIS SET "presence:u1319" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1319"
$REDIS SET "presence:u1320" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1320"
$REDIS SET "presence:u1321" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1321"
$REDIS SET "presence:u1322" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1322"
$REDIS SET "presence:u1323" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1323"
$REDIS SET "presence:u1324" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1324"
$REDIS SET "presence:u1325" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1325"
$REDIS SET "presence:u1326" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1326"
$REDIS SET "presence:u1327" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1327"
$REDIS SET "presence:u1328" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1328"
$REDIS SET "presence:u1329" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1329"
$REDIS SET "presence:u1330" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1330"
$REDIS SET "presence:u1331" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1331"
$REDIS SET "presence:u1332" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1332"
$REDIS SET "presence:u1333" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1333"
$REDIS SET "presence:u1334" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1334"
$REDIS SET "presence:u1335" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1335"
$REDIS SET "presence:u1336" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1336"
$REDIS SET "presence:u1337" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1337"
$REDIS SET "presence:u1338" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1338"
$REDIS SET "presence:u1339" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1339"
$REDIS SET "presence:u1340" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1340"
$REDIS SET "presence:u1341" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1341"
$REDIS SET "presence:u1342" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1342"
$REDIS SET "presence:u1343" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1343"
$REDIS SET "presence:u1344" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1344"
$REDIS SET "presence:u1345" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1345"
$REDIS SET "presence:u1346" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1346"
$REDIS SET "presence:u1347" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1347"
$REDIS SET "presence:u1348" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1348"
$REDIS SET "presence:u1349" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1349"
$REDIS SET "presence:u1350" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1350"
$REDIS SET "presence:u1351" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1351"
$REDIS SET "presence:u1352" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1352"
$REDIS SET "presence:u1353" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1353"
$REDIS SET "presence:u1354" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1354"
$REDIS SET "presence:u1355" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1355"
$REDIS SET "presence:u1356" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1356"
$REDIS SET "presence:u1357" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1357"
$REDIS SET "presence:u1358" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1358"
$REDIS SET "presence:u1359" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1359"
$REDIS SET "presence:u1360" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1360"
$REDIS SET "presence:u1361" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1361"
$REDIS SET "presence:u1362" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1362"
$REDIS SET "presence:u1363" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1363"
$REDIS SET "presence:u1364" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1364"
$REDIS SET "presence:u1365" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1365"
$REDIS SET "presence:u1366" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1366"
$REDIS SET "presence:u1367" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1367"
$REDIS SET "presence:u1368" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1368"
$REDIS SET "presence:u1369" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1369"
$REDIS SET "presence:u1370" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1370"
$REDIS SET "presence:u1371" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1371"
$REDIS SET "presence:u1372" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1372"
$REDIS SET "presence:u1373" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1373"
$REDIS SET "presence:u1374" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1374"
$REDIS SET "presence:u1375" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1375"
$REDIS SET "presence:u1376" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1376"
$REDIS SET "presence:u1377" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1377"
$REDIS SET "presence:u1378" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1378"
$REDIS SET "presence:u1379" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1379"
$REDIS SET "presence:u1380" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1380"
$REDIS SET "presence:u1381" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1381"
$REDIS SET "presence:u1382" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1382"
$REDIS SET "presence:u1383" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1383"
$REDIS SET "presence:u1384" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1384"
$REDIS SET "presence:u1385" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1385"
$REDIS SET "presence:u1386" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1386"
$REDIS SET "presence:u1387" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1387"
$REDIS SET "presence:u1388" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1388"
$REDIS SET "presence:u1389" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1389"
$REDIS SET "presence:u1390" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1390"
$REDIS SET "presence:u1391" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1391"
$REDIS SET "presence:u1392" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1392"
$REDIS SET "presence:u1393" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1393"
$REDIS SET "presence:u1394" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1394"
$REDIS SET "presence:u1395" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1395"
$REDIS SET "presence:u1396" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1396"
$REDIS SET "presence:u1397" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1397"
$REDIS SET "presence:u1398" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1398"
$REDIS SET "presence:u1399" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1399"
$REDIS SET "presence:u1400" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1400"
$REDIS SET "presence:u1401" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1401"
$REDIS SET "presence:u1402" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1402"
$REDIS SET "presence:u1403" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1403"
$REDIS SET "presence:u1404" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1404"
$REDIS SET "presence:u1405" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1405"
$REDIS SET "presence:u1406" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1406"
$REDIS SET "presence:u1407" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1407"
$REDIS SET "presence:u1408" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1408"
$REDIS SET "presence:u1409" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1409"
$REDIS SET "presence:u1410" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1410"
$REDIS SET "presence:u1411" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1411"
$REDIS SET "presence:u1412" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1412"
$REDIS SET "presence:u1413" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1413"
$REDIS SET "presence:u1414" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1414"
$REDIS SET "presence:u1415" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1415"
$REDIS SET "presence:u1416" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1416"
$REDIS SET "presence:u1417" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1417"
$REDIS SET "presence:u1418" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1418"
$REDIS SET "presence:u1419" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1419"
$REDIS SET "presence:u1420" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1420"
$REDIS SET "presence:u1421" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1421"
$REDIS SET "presence:u1422" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1422"
$REDIS SET "presence:u1423" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1423"
$REDIS SET "presence:u1424" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1424"
$REDIS SET "presence:u1425" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1425"
$REDIS SET "presence:u1426" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1426"
$REDIS SET "presence:u1427" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1427"
$REDIS SET "presence:u1428" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1428"
$REDIS SET "presence:u1429" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1429"
$REDIS SET "presence:u1430" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1430"
$REDIS SET "presence:u1431" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1431"
$REDIS SET "presence:u1432" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1432"
$REDIS SET "presence:u1433" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1433"
$REDIS SET "presence:u1434" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1434"
$REDIS SET "presence:u1435" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1435"
$REDIS SET "presence:u1436" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1436"
$REDIS SET "presence:u1437" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1437"
$REDIS SET "presence:u1438" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1438"
$REDIS SET "presence:u1439" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1439"
$REDIS SET "presence:u1440" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1440"
$REDIS SET "presence:u1441" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1441"
$REDIS SET "presence:u1442" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1442"
$REDIS SET "presence:u1443" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1443"
$REDIS SET "presence:u1444" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1444"
$REDIS SET "presence:u1445" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1445"
$REDIS SET "presence:u1446" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1446"
$REDIS SET "presence:u1447" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1447"
$REDIS SET "presence:u1448" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1448"
$REDIS SET "presence:u1449" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1449"
$REDIS SET "presence:u1450" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1450"
$REDIS SET "presence:u1451" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1451"
$REDIS SET "presence:u1452" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1452"
$REDIS SET "presence:u1453" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1453"
$REDIS SET "presence:u1454" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1454"
$REDIS SET "presence:u1455" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1455"
$REDIS SET "presence:u1456" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1456"
$REDIS SET "presence:u1457" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1457"
$REDIS SET "presence:u1458" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1458"
$REDIS SET "presence:u1459" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1459"
$REDIS SET "presence:u1460" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1460"
$REDIS SET "presence:u1461" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1461"
$REDIS SET "presence:u1462" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1462"
$REDIS SET "presence:u1463" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1463"
$REDIS SET "presence:u1464" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1464"
$REDIS SET "presence:u1465" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1465"
$REDIS SET "presence:u1466" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1466"
$REDIS SET "presence:u1467" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1467"
$REDIS SET "presence:u1468" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1468"
$REDIS SET "presence:u1469" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1469"
$REDIS SET "presence:u1470" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1470"
$REDIS SET "presence:u1471" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1471"
$REDIS SET "presence:u1472" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1472"
$REDIS SET "presence:u1473" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1473"
$REDIS SET "presence:u1474" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1474"
$REDIS SET "presence:u1475" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1475"
$REDIS SET "presence:u1476" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1476"
$REDIS SET "presence:u1477" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1477"
$REDIS SET "presence:u1478" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1478"
$REDIS SET "presence:u1479" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1479"
$REDIS SET "presence:u1480" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1480"
$REDIS SET "presence:u1481" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1481"
$REDIS SET "presence:u1482" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1482"
$REDIS SET "presence:u1483" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1483"
$REDIS SET "presence:u1484" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1484"
$REDIS SET "presence:u1485" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1485"
$REDIS SET "presence:u1486" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1486"
$REDIS SET "presence:u1487" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1487"
$REDIS SET "presence:u1488" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1488"
$REDIS SET "presence:u1489" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1489"
$REDIS SET "presence:u1490" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1490"
$REDIS SET "presence:u1491" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1491"
$REDIS SET "presence:u1492" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1492"
$REDIS SET "presence:u1493" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1493"
$REDIS SET "presence:u1494" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1494"
$REDIS SET "presence:u1495" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1495"
$REDIS SET "presence:u1496" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1496"
$REDIS SET "presence:u1497" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1497"
$REDIS SET "presence:u1498" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1498"
$REDIS SET "presence:u1499" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1499"
$REDIS SET "presence:u1500" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1500"
$REDIS SET "presence:u1501" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1501"
$REDIS SET "presence:u1502" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1502"
$REDIS SET "presence:u1503" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1503"
$REDIS SET "presence:u1504" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1504"
$REDIS SET "presence:u1505" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1505"
$REDIS SET "presence:u1506" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1506"
$REDIS SET "presence:u1507" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1507"
$REDIS SET "presence:u1508" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1508"
$REDIS SET "presence:u1509" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1509"
$REDIS SET "presence:u1510" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1510"
$REDIS SET "presence:u1511" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1511"
$REDIS SET "presence:u1512" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1512"
$REDIS SET "presence:u1513" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1513"
$REDIS SET "presence:u1514" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1514"
$REDIS SET "presence:u1515" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1515"
$REDIS SET "presence:u1516" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1516"
$REDIS SET "presence:u1517" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1517"
$REDIS SET "presence:u1518" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1518"
$REDIS SET "presence:u1519" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1519"
$REDIS SET "presence:u1520" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1520"
$REDIS SET "presence:u1521" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1521"
$REDIS SET "presence:u1522" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1522"
$REDIS SET "presence:u1523" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1523"
$REDIS SET "presence:u1524" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1524"
$REDIS SET "presence:u1525" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1525"
$REDIS SET "presence:u1526" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1526"
$REDIS SET "presence:u1527" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1527"
$REDIS SET "presence:u1528" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1528"
$REDIS SET "presence:u1529" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1529"
$REDIS SET "presence:u1530" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1530"
$REDIS SET "presence:u1531" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1531"
$REDIS SET "presence:u1532" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1532"
$REDIS SET "presence:u1533" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1533"
$REDIS SET "presence:u1534" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1534"
$REDIS SET "presence:u1535" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1535"
$REDIS SET "presence:u1536" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1536"
$REDIS SET "presence:u1537" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1537"
$REDIS SET "presence:u1538" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1538"
$REDIS SET "presence:u1539" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1539"
$REDIS SET "presence:u1540" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1540"
$REDIS SET "presence:u1541" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1541"
$REDIS SET "presence:u1542" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1542"
$REDIS SET "presence:u1543" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1543"
$REDIS SET "presence:u1544" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1544"
$REDIS SET "presence:u1545" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1545"
$REDIS SET "presence:u1546" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1546"
$REDIS SET "presence:u1547" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1547"
$REDIS SET "presence:u1548" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1548"
$REDIS SET "presence:u1549" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1549"
$REDIS SET "presence:u1550" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1550"
$REDIS SET "presence:u1551" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1551"
$REDIS SET "presence:u1552" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1552"
$REDIS SET "presence:u1553" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1553"
$REDIS SET "presence:u1554" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1554"
$REDIS SET "presence:u1555" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1555"
$REDIS SET "presence:u1556" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1556"
$REDIS SET "presence:u1557" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1557"
$REDIS SET "presence:u1558" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1558"
$REDIS SET "presence:u1559" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1559"
$REDIS SET "presence:u1560" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1560"
$REDIS SET "presence:u1561" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1561"
$REDIS SET "presence:u1562" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1562"
$REDIS SET "presence:u1563" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1563"
$REDIS SET "presence:u1564" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1564"
$REDIS SET "presence:u1565" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1565"
$REDIS SET "presence:u1566" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1566"
$REDIS SET "presence:u1567" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1567"
$REDIS SET "presence:u1568" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1568"
$REDIS SET "presence:u1569" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1569"
$REDIS SET "presence:u1570" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1570"
$REDIS SET "presence:u1571" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1571"
$REDIS SET "presence:u1572" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1572"
$REDIS SET "presence:u1573" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1573"
$REDIS SET "presence:u1574" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1574"
$REDIS SET "presence:u1575" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1575"
$REDIS SET "presence:u1576" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1576"
$REDIS SET "presence:u1577" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1577"
$REDIS SET "presence:u1578" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1578"
$REDIS SET "presence:u1579" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1579"
$REDIS SET "presence:u1580" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1580"
$REDIS SET "presence:u1581" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1581"
$REDIS SET "presence:u1582" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1582"
$REDIS SET "presence:u1583" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1583"
$REDIS SET "presence:u1584" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1584"
$REDIS SET "presence:u1585" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1585"
$REDIS SET "presence:u1586" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1586"
$REDIS SET "presence:u1587" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1587"
$REDIS SET "presence:u1588" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1588"
$REDIS SET "presence:u1589" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1589"
$REDIS SET "presence:u1590" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1590"
$REDIS SET "presence:u1591" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1591"
$REDIS SET "presence:u1592" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1592"
$REDIS SET "presence:u1593" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1593"
$REDIS SET "presence:u1594" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1594"
$REDIS SET "presence:u1595" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1595"
$REDIS SET "presence:u1596" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1596"
$REDIS SET "presence:u1597" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1597"
$REDIS SET "presence:u1598" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1598"
$REDIS SET "presence:u1599" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1599"
$REDIS SET "presence:u1600" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1600"
$REDIS SET "presence:u1601" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1601"
$REDIS SET "presence:u1602" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1602"
$REDIS SET "presence:u1603" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1603"
$REDIS SET "presence:u1604" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1604"
$REDIS SET "presence:u1605" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1605"
$REDIS SET "presence:u1606" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1606"
$REDIS SET "presence:u1607" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1607"
$REDIS SET "presence:u1608" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1608"
$REDIS SET "presence:u1609" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1609"
$REDIS SET "presence:u1610" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1610"
$REDIS SET "presence:u1611" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1611"
$REDIS SET "presence:u1612" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1612"
$REDIS SET "presence:u1613" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1613"
$REDIS SET "presence:u1614" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1614"
$REDIS SET "presence:u1615" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1615"
$REDIS SET "presence:u1616" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1616"
$REDIS SET "presence:u1617" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1617"
$REDIS SET "presence:u1618" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1618"
$REDIS SET "presence:u1619" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1619"
$REDIS SET "presence:u1620" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1620"
$REDIS SET "presence:u1621" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1621"
$REDIS SET "presence:u1622" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1622"
$REDIS SET "presence:u1623" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1623"
$REDIS SET "presence:u1624" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1624"
$REDIS SET "presence:u1625" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1625"
$REDIS SET "presence:u1626" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1626"
$REDIS SET "presence:u1627" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1627"
$REDIS SET "presence:u1628" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1628"
$REDIS SET "presence:u1629" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1629"
$REDIS SET "presence:u1630" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1630"
$REDIS SET "presence:u1631" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1631"
$REDIS SET "presence:u1632" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1632"
$REDIS SET "presence:u1633" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1633"
$REDIS SET "presence:u1634" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1634"
$REDIS SET "presence:u1635" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1635"
$REDIS SET "presence:u1636" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1636"
$REDIS SET "presence:u1637" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1637"
$REDIS SET "presence:u1638" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1638"
$REDIS SET "presence:u1639" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1639"
$REDIS SET "presence:u1640" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1640"
$REDIS SET "presence:u1641" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1641"
$REDIS SET "presence:u1642" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1642"
$REDIS SET "presence:u1643" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1643"
$REDIS SET "presence:u1644" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1644"
$REDIS SET "presence:u1645" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1645"
$REDIS SET "presence:u1646" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1646"
$REDIS SET "presence:u1647" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1647"
$REDIS SET "presence:u1648" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1648"
$REDIS SET "presence:u1649" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1649"
$REDIS SET "presence:u1650" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1650"
$REDIS SET "presence:u1651" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1651"
$REDIS SET "presence:u1652" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1652"
$REDIS SET "presence:u1653" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1653"
$REDIS SET "presence:u1654" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1654"
$REDIS SET "presence:u1655" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1655"
$REDIS SET "presence:u1656" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1656"
$REDIS SET "presence:u1657" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1657"
$REDIS SET "presence:u1658" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1658"
$REDIS SET "presence:u1659" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1659"
$REDIS SET "presence:u1660" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1660"
$REDIS SET "presence:u1661" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1661"
$REDIS SET "presence:u1662" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1662"
$REDIS SET "presence:u1663" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1663"
$REDIS SET "presence:u1664" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1664"
$REDIS SET "presence:u1665" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1665"
$REDIS SET "presence:u1666" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1666"
$REDIS SET "presence:u1667" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1667"
$REDIS SET "presence:u1668" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1668"
$REDIS SET "presence:u1669" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1669"
$REDIS SET "presence:u1670" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1670"
$REDIS SET "presence:u1671" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1671"
$REDIS SET "presence:u1672" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1672"
$REDIS SET "presence:u1673" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1673"
$REDIS SET "presence:u1674" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1674"
$REDIS SET "presence:u1675" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1675"
$REDIS SET "presence:u1676" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1676"
$REDIS SET "presence:u1677" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1677"
$REDIS SET "presence:u1678" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1678"
$REDIS SET "presence:u1679" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1679"
$REDIS SET "presence:u1680" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1680"
$REDIS SET "presence:u1681" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1681"
$REDIS SET "presence:u1682" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1682"
$REDIS SET "presence:u1683" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1683"
$REDIS SET "presence:u1684" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1684"
$REDIS SET "presence:u1685" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1685"
$REDIS SET "presence:u1686" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1686"
$REDIS SET "presence:u1687" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1687"
$REDIS SET "presence:u1688" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1688"
$REDIS SET "presence:u1689" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1689"
$REDIS SET "presence:u1690" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1690"
$REDIS SET "presence:u1691" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1691"
$REDIS SET "presence:u1692" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1692"
$REDIS SET "presence:u1693" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1693"
$REDIS SET "presence:u1694" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1694"
$REDIS SET "presence:u1695" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1695"
$REDIS SET "presence:u1696" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1696"
$REDIS SET "presence:u1697" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1697"
$REDIS SET "presence:u1698" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1698"
$REDIS SET "presence:u1699" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1699"
$REDIS SET "presence:u1700" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1700"
$REDIS SET "presence:u1701" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1701"
$REDIS SET "presence:u1702" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1702"
$REDIS SET "presence:u1703" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1703"
$REDIS SET "presence:u1704" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1704"
$REDIS SET "presence:u1705" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1705"
$REDIS SET "presence:u1706" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1706"
$REDIS SET "presence:u1707" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1707"
$REDIS SET "presence:u1708" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1708"
$REDIS SET "presence:u1709" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1709"
$REDIS SET "presence:u1710" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1710"
$REDIS SET "presence:u1711" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1711"
$REDIS SET "presence:u1712" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1712"
$REDIS SET "presence:u1713" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1713"
$REDIS SET "presence:u1714" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1714"
$REDIS SET "presence:u1715" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1715"
$REDIS SET "presence:u1716" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1716"
$REDIS SET "presence:u1717" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1717"
$REDIS SET "presence:u1718" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1718"
$REDIS SET "presence:u1719" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1719"
$REDIS SET "presence:u1720" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1720"
$REDIS SET "presence:u1721" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1721"
$REDIS SET "presence:u1722" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1722"
$REDIS SET "presence:u1723" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1723"
$REDIS SET "presence:u1724" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1724"
$REDIS SET "presence:u1725" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1725"
$REDIS SET "presence:u1726" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1726"
$REDIS SET "presence:u1727" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1727"
$REDIS SET "presence:u1728" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1728"
$REDIS SET "presence:u1729" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1729"
$REDIS SET "presence:u1730" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1730"
$REDIS SET "presence:u1731" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1731"
$REDIS SET "presence:u1732" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1732"
$REDIS SET "presence:u1733" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1733"
$REDIS SET "presence:u1734" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1734"
$REDIS SET "presence:u1735" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1735"
$REDIS SET "presence:u1736" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1736"
$REDIS SET "presence:u1737" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1737"
$REDIS SET "presence:u1738" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1738"
$REDIS SET "presence:u1739" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1739"
$REDIS SET "presence:u1740" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1740"
$REDIS SET "presence:u1741" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1741"
$REDIS SET "presence:u1742" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1742"
$REDIS SET "presence:u1743" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1743"
$REDIS SET "presence:u1744" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1744"
$REDIS SET "presence:u1745" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1745"
$REDIS SET "presence:u1746" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1746"
$REDIS SET "presence:u1747" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1747"
$REDIS SET "presence:u1748" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1748"
$REDIS SET "presence:u1749" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1749"
$REDIS SET "presence:u1750" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1750"
$REDIS SET "presence:u1751" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1751"
$REDIS SET "presence:u1752" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1752"
$REDIS SET "presence:u1753" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1753"
$REDIS SET "presence:u1754" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1754"
$REDIS SET "presence:u1755" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1755"
$REDIS SET "presence:u1756" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1756"
$REDIS SET "presence:u1757" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1757"
$REDIS SET "presence:u1758" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1758"
$REDIS SET "presence:u1759" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1759"
$REDIS SET "presence:u1760" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1760"
$REDIS SET "presence:u1761" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1761"
$REDIS SET "presence:u1762" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1762"
$REDIS SET "presence:u1763" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1763"
$REDIS SET "presence:u1764" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1764"
$REDIS SET "presence:u1765" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1765"
$REDIS SET "presence:u1766" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1766"
$REDIS SET "presence:u1767" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1767"
$REDIS SET "presence:u1768" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1768"
$REDIS SET "presence:u1769" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1769"
$REDIS SET "presence:u1770" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1770"
$REDIS SET "presence:u1771" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1771"
$REDIS SET "presence:u1772" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1772"
$REDIS SET "presence:u1773" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1773"
$REDIS SET "presence:u1774" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1774"
$REDIS SET "presence:u1775" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1775"
$REDIS SET "presence:u1776" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1776"
$REDIS SET "presence:u1777" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1777"
$REDIS SET "presence:u1778" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1778"
$REDIS SET "presence:u1779" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1779"
$REDIS SET "presence:u1780" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1780"
$REDIS SET "presence:u1781" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1781"
$REDIS SET "presence:u1782" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1782"
$REDIS SET "presence:u1783" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1783"
$REDIS SET "presence:u1784" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1784"
$REDIS SET "presence:u1785" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1785"
$REDIS SET "presence:u1786" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1786"
$REDIS SET "presence:u1787" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1787"
$REDIS SET "presence:u1788" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1788"
$REDIS SET "presence:u1789" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1789"
$REDIS SET "presence:u1790" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1790"
$REDIS SET "presence:u1791" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1791"
$REDIS SET "presence:u1792" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1792"
$REDIS SET "presence:u1793" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1793"
$REDIS SET "presence:u1794" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1794"
$REDIS SET "presence:u1795" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1795"
$REDIS SET "presence:u1796" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1796"
$REDIS SET "presence:u1797" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1797"
$REDIS SET "presence:u1798" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1798"
$REDIS SET "presence:u1799" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1799"
$REDIS SET "presence:u1800" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1800"
$REDIS SET "presence:u1801" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1801"
$REDIS SET "presence:u1802" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1802"
$REDIS SET "presence:u1803" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1803"
$REDIS SET "presence:u1804" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1804"
$REDIS SET "presence:u1805" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1805"
$REDIS SET "presence:u1806" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1806"
$REDIS SET "presence:u1807" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1807"
$REDIS SET "presence:u1808" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1808"
$REDIS SET "presence:u1809" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1809"
$REDIS SET "presence:u1810" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1810"
$REDIS SET "presence:u1811" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1811"
$REDIS SET "presence:u1812" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1812"
$REDIS SET "presence:u1813" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1813"
$REDIS SET "presence:u1814" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1814"
$REDIS SET "presence:u1815" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1815"
$REDIS SET "presence:u1816" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1816"
$REDIS SET "presence:u1817" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1817"
$REDIS SET "presence:u1818" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1818"
$REDIS SET "presence:u1819" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1819"
$REDIS SET "presence:u1820" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1820"
$REDIS SET "presence:u1821" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1821"
$REDIS SET "presence:u1822" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1822"
$REDIS SET "presence:u1823" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1823"
$REDIS SET "presence:u1824" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1824"
$REDIS SET "presence:u1825" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1825"
$REDIS SET "presence:u1826" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1826"
$REDIS SET "presence:u1827" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1827"
$REDIS SET "presence:u1828" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1828"
$REDIS SET "presence:u1829" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1829"
$REDIS SET "presence:u1830" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1830"
$REDIS SET "presence:u1831" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1831"
$REDIS SET "presence:u1832" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1832"
$REDIS SET "presence:u1833" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1833"
$REDIS SET "presence:u1834" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1834"
$REDIS SET "presence:u1835" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1835"
$REDIS SET "presence:u1836" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1836"
$REDIS SET "presence:u1837" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1837"
$REDIS SET "presence:u1838" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1838"
$REDIS SET "presence:u1839" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1839"
$REDIS SET "presence:u1840" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1840"
$REDIS SET "presence:u1841" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1841"
$REDIS SET "presence:u1842" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1842"
$REDIS SET "presence:u1843" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1843"
$REDIS SET "presence:u1844" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1844"
$REDIS SET "presence:u1845" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1845"
$REDIS SET "presence:u1846" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1846"
$REDIS SET "presence:u1847" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1847"
$REDIS SET "presence:u1848" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1848"
$REDIS SET "presence:u1849" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1849"
$REDIS SET "presence:u1850" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1850"
$REDIS SET "presence:u1851" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1851"
$REDIS SET "presence:u1852" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1852"
$REDIS SET "presence:u1853" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1853"
$REDIS SET "presence:u1854" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1854"
$REDIS SET "presence:u1855" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1855"
$REDIS SET "presence:u1856" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1856"
$REDIS SET "presence:u1857" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1857"
$REDIS SET "presence:u1858" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1858"
$REDIS SET "presence:u1859" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1859"
$REDIS SET "presence:u1860" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1860"
$REDIS SET "presence:u1861" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1861"
$REDIS SET "presence:u1862" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1862"
$REDIS SET "presence:u1863" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1863"
$REDIS SET "presence:u1864" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1864"
$REDIS SET "presence:u1865" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1865"
$REDIS SET "presence:u1866" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1866"
$REDIS SET "presence:u1867" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1867"
$REDIS SET "presence:u1868" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1868"
$REDIS SET "presence:u1869" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1869"
$REDIS SET "presence:u1870" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1870"
$REDIS SET "presence:u1871" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1871"
$REDIS SET "presence:u1872" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1872"
$REDIS SET "presence:u1873" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1873"
$REDIS SET "presence:u1874" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1874"
$REDIS SET "presence:u1875" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1875"
$REDIS SET "presence:u1876" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1876"
$REDIS SET "presence:u1877" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1877"
$REDIS SET "presence:u1878" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1878"
$REDIS SET "presence:u1879" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1879"
$REDIS SET "presence:u1880" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1880"
$REDIS SET "presence:u1881" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1881"
$REDIS SET "presence:u1882" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1882"
$REDIS SET "presence:u1883" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1883"
$REDIS SET "presence:u1884" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1884"
$REDIS SET "presence:u1885" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1885"
$REDIS SET "presence:u1886" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1886"
$REDIS SET "presence:u1887" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1887"
$REDIS SET "presence:u1888" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1888"
$REDIS SET "presence:u1889" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1889"
$REDIS SET "presence:u1890" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1890"
$REDIS SET "presence:u1891" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1891"
$REDIS SET "presence:u1892" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1892"
$REDIS SET "presence:u1893" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1893"
$REDIS SET "presence:u1894" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1894"
$REDIS SET "presence:u1895" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1895"
$REDIS SET "presence:u1896" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1896"
$REDIS SET "presence:u1897" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1897"
$REDIS SET "presence:u1898" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1898"
$REDIS SET "presence:u1899" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1899"
$REDIS SET "presence:u1900" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1900"
$REDIS SET "presence:u1901" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1901"
$REDIS SET "presence:u1902" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1902"
$REDIS SET "presence:u1903" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1903"
$REDIS SET "presence:u1904" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1904"
$REDIS SET "presence:u1905" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1905"
$REDIS SET "presence:u1906" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1906"
$REDIS SET "presence:u1907" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1907"
$REDIS SET "presence:u1908" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1908"
$REDIS SET "presence:u1909" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1909"
$REDIS SET "presence:u1910" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1910"
$REDIS SET "presence:u1911" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1911"
$REDIS SET "presence:u1912" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1912"
$REDIS SET "presence:u1913" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1913"
$REDIS SET "presence:u1914" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1914"
$REDIS SET "presence:u1915" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1915"
$REDIS SET "presence:u1916" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1916"
$REDIS SET "presence:u1917" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1917"
$REDIS SET "presence:u1918" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1918"
$REDIS SET "presence:u1919" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1919"
$REDIS SET "presence:u1920" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1920"
$REDIS SET "presence:u1921" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1921"
$REDIS SET "presence:u1922" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1922"
$REDIS SET "presence:u1923" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1923"
$REDIS SET "presence:u1924" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1924"
$REDIS SET "presence:u1925" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1925"
$REDIS SET "presence:u1926" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1926"
$REDIS SET "presence:u1927" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1927"
$REDIS SET "presence:u1928" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1928"
$REDIS SET "presence:u1929" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1929"
$REDIS SET "presence:u1930" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1930"
$REDIS SET "presence:u1931" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1931"
$REDIS SET "presence:u1932" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1932"
$REDIS SET "presence:u1933" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1933"
$REDIS SET "presence:u1934" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1934"
$REDIS SET "presence:u1935" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1935"
$REDIS SET "presence:u1936" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1936"
$REDIS SET "presence:u1937" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1937"
$REDIS SET "presence:u1938" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1938"
$REDIS SET "presence:u1939" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1939"
$REDIS SET "presence:u1940" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1940"
$REDIS SET "presence:u1941" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1941"
$REDIS SET "presence:u1942" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1942"
$REDIS SET "presence:u1943" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1943"
$REDIS SET "presence:u1944" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1944"
$REDIS SET "presence:u1945" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1945"
$REDIS SET "presence:u1946" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1946"
$REDIS SET "presence:u1947" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1947"
$REDIS SET "presence:u1948" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1948"
$REDIS SET "presence:u1949" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1949"
$REDIS SET "presence:u1950" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u1950"
$REDIS SET "presence:u1951" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u1951"
$REDIS SET "presence:u1952" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u1952"
$REDIS SET "presence:u1953" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u1953"
$REDIS SET "presence:u1954" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u1954"
$REDIS SET "presence:u1955" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u1955"
$REDIS SET "presence:u1956" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u1956"
$REDIS SET "presence:u1957" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u1957"
$REDIS SET "presence:u1958" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u1958"
$REDIS SET "presence:u1959" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u1959"
$REDIS SET "presence:u1960" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u1960"
$REDIS SET "presence:u1961" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u1961"
$REDIS SET "presence:u1962" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u1962"
$REDIS SET "presence:u1963" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u1963"
$REDIS SET "presence:u1964" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u1964"
$REDIS SET "presence:u1965" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u1965"
$REDIS SET "presence:u1966" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u1966"
$REDIS SET "presence:u1967" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u1967"
$REDIS SET "presence:u1968" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u1968"
$REDIS SET "presence:u1969" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u1969"
$REDIS SET "presence:u1970" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u1970"
$REDIS SET "presence:u1971" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u1971"
$REDIS SET "presence:u1972" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u1972"
$REDIS SET "presence:u1973" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u1973"
$REDIS SET "presence:u1974" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u1974"
$REDIS SET "presence:u1975" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u1975"
$REDIS SET "presence:u1976" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u1976"
$REDIS SET "presence:u1977" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u1977"
$REDIS SET "presence:u1978" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u1978"
$REDIS SET "presence:u1979" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u1979"
$REDIS SET "presence:u1980" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u1980"
$REDIS SET "presence:u1981" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u1981"
$REDIS SET "presence:u1982" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u1982"
$REDIS SET "presence:u1983" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u1983"
$REDIS SET "presence:u1984" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u1984"
$REDIS SET "presence:u1985" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u1985"
$REDIS SET "presence:u1986" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u1986"
$REDIS SET "presence:u1987" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u1987"
$REDIS SET "presence:u1988" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u1988"
$REDIS SET "presence:u1989" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u1989"
$REDIS SET "presence:u1990" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u1990"
$REDIS SET "presence:u1991" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u1991"
$REDIS SET "presence:u1992" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u1992"
$REDIS SET "presence:u1993" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u1993"
$REDIS SET "presence:u1994" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u1994"
$REDIS SET "presence:u1995" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u1995"
$REDIS SET "presence:u1996" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u1996"
$REDIS SET "presence:u1997" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u1997"
$REDIS SET "presence:u1998" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u1998"
$REDIS SET "presence:u1999" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u1999"
$REDIS SET "presence:u2000" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2000"
$REDIS SET "presence:u2001" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2001"
$REDIS SET "presence:u2002" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2002"
$REDIS SET "presence:u2003" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2003"
$REDIS SET "presence:u2004" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2004"
$REDIS SET "presence:u2005" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2005"
$REDIS SET "presence:u2006" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2006"
$REDIS SET "presence:u2007" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2007"
$REDIS SET "presence:u2008" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2008"
$REDIS SET "presence:u2009" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2009"
$REDIS SET "presence:u2010" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2010"
$REDIS SET "presence:u2011" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2011"
$REDIS SET "presence:u2012" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2012"
$REDIS SET "presence:u2013" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2013"
$REDIS SET "presence:u2014" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2014"
$REDIS SET "presence:u2015" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2015"
$REDIS SET "presence:u2016" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2016"
$REDIS SET "presence:u2017" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2017"
$REDIS SET "presence:u2018" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2018"
$REDIS SET "presence:u2019" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2019"
$REDIS SET "presence:u2020" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2020"
$REDIS SET "presence:u2021" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2021"
$REDIS SET "presence:u2022" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2022"
$REDIS SET "presence:u2023" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2023"
$REDIS SET "presence:u2024" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2024"
$REDIS SET "presence:u2025" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2025"
$REDIS SET "presence:u2026" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2026"
$REDIS SET "presence:u2027" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2027"
$REDIS SET "presence:u2028" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2028"
$REDIS SET "presence:u2029" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2029"
$REDIS SET "presence:u2030" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2030"
$REDIS SET "presence:u2031" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2031"
$REDIS SET "presence:u2032" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2032"
$REDIS SET "presence:u2033" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2033"
$REDIS SET "presence:u2034" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2034"
$REDIS SET "presence:u2035" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2035"
$REDIS SET "presence:u2036" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2036"
$REDIS SET "presence:u2037" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2037"
$REDIS SET "presence:u2038" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2038"
$REDIS SET "presence:u2039" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2039"
$REDIS SET "presence:u2040" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2040"
$REDIS SET "presence:u2041" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2041"
$REDIS SET "presence:u2042" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2042"
$REDIS SET "presence:u2043" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2043"
$REDIS SET "presence:u2044" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2044"
$REDIS SET "presence:u2045" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2045"
$REDIS SET "presence:u2046" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2046"
$REDIS SET "presence:u2047" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2047"
$REDIS SET "presence:u2048" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2048"
$REDIS SET "presence:u2049" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2049"
$REDIS SET "presence:u2050" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2050"
$REDIS SET "presence:u2051" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2051"
$REDIS SET "presence:u2052" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2052"
$REDIS SET "presence:u2053" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2053"
$REDIS SET "presence:u2054" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2054"
$REDIS SET "presence:u2055" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2055"
$REDIS SET "presence:u2056" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2056"
$REDIS SET "presence:u2057" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2057"
$REDIS SET "presence:u2058" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2058"
$REDIS SET "presence:u2059" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2059"
$REDIS SET "presence:u2060" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2060"
$REDIS SET "presence:u2061" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2061"
$REDIS SET "presence:u2062" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2062"
$REDIS SET "presence:u2063" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2063"
$REDIS SET "presence:u2064" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2064"
$REDIS SET "presence:u2065" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2065"
$REDIS SET "presence:u2066" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2066"
$REDIS SET "presence:u2067" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2067"
$REDIS SET "presence:u2068" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2068"
$REDIS SET "presence:u2069" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2069"
$REDIS SET "presence:u2070" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2070"
$REDIS SET "presence:u2071" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2071"
$REDIS SET "presence:u2072" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2072"
$REDIS SET "presence:u2073" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2073"
$REDIS SET "presence:u2074" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2074"
$REDIS SET "presence:u2075" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2075"
$REDIS SET "presence:u2076" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2076"
$REDIS SET "presence:u2077" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2077"
$REDIS SET "presence:u2078" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2078"
$REDIS SET "presence:u2079" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2079"
$REDIS SET "presence:u2080" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2080"
$REDIS SET "presence:u2081" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2081"
$REDIS SET "presence:u2082" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2082"
$REDIS SET "presence:u2083" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2083"
$REDIS SET "presence:u2084" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2084"
$REDIS SET "presence:u2085" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2085"
$REDIS SET "presence:u2086" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2086"
$REDIS SET "presence:u2087" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2087"
$REDIS SET "presence:u2088" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2088"
$REDIS SET "presence:u2089" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2089"
$REDIS SET "presence:u2090" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2090"
$REDIS SET "presence:u2091" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2091"
$REDIS SET "presence:u2092" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2092"
$REDIS SET "presence:u2093" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2093"
$REDIS SET "presence:u2094" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2094"
$REDIS SET "presence:u2095" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2095"
$REDIS SET "presence:u2096" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2096"
$REDIS SET "presence:u2097" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2097"
$REDIS SET "presence:u2098" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2098"
$REDIS SET "presence:u2099" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2099"
$REDIS SET "presence:u2100" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2100"
$REDIS SET "presence:u2101" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2101"
$REDIS SET "presence:u2102" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2102"
$REDIS SET "presence:u2103" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2103"
$REDIS SET "presence:u2104" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2104"
$REDIS SET "presence:u2105" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2105"
$REDIS SET "presence:u2106" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2106"
$REDIS SET "presence:u2107" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2107"
$REDIS SET "presence:u2108" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2108"
$REDIS SET "presence:u2109" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2109"
$REDIS SET "presence:u2110" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2110"
$REDIS SET "presence:u2111" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2111"
$REDIS SET "presence:u2112" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2112"
$REDIS SET "presence:u2113" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2113"
$REDIS SET "presence:u2114" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2114"
$REDIS SET "presence:u2115" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2115"
$REDIS SET "presence:u2116" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2116"
$REDIS SET "presence:u2117" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2117"
$REDIS SET "presence:u2118" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2118"
$REDIS SET "presence:u2119" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2119"
$REDIS SET "presence:u2120" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2120"
$REDIS SET "presence:u2121" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2121"
$REDIS SET "presence:u2122" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2122"
$REDIS SET "presence:u2123" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2123"
$REDIS SET "presence:u2124" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2124"
$REDIS SET "presence:u2125" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2125"
$REDIS SET "presence:u2126" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2126"
$REDIS SET "presence:u2127" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2127"
$REDIS SET "presence:u2128" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2128"
$REDIS SET "presence:u2129" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2129"
$REDIS SET "presence:u2130" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2130"
$REDIS SET "presence:u2131" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2131"
$REDIS SET "presence:u2132" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2132"
$REDIS SET "presence:u2133" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2133"
$REDIS SET "presence:u2134" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2134"
$REDIS SET "presence:u2135" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2135"
$REDIS SET "presence:u2136" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2136"
$REDIS SET "presence:u2137" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2137"
$REDIS SET "presence:u2138" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2138"
$REDIS SET "presence:u2139" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2139"
$REDIS SET "presence:u2140" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2140"
$REDIS SET "presence:u2141" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2141"
$REDIS SET "presence:u2142" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2142"
$REDIS SET "presence:u2143" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2143"
$REDIS SET "presence:u2144" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2144"
$REDIS SET "presence:u2145" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2145"
$REDIS SET "presence:u2146" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2146"
$REDIS SET "presence:u2147" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2147"
$REDIS SET "presence:u2148" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2148"
$REDIS SET "presence:u2149" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2149"
$REDIS SET "presence:u2150" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2150"
$REDIS SET "presence:u2151" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2151"
$REDIS SET "presence:u2152" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2152"
$REDIS SET "presence:u2153" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2153"
$REDIS SET "presence:u2154" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2154"
$REDIS SET "presence:u2155" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2155"
$REDIS SET "presence:u2156" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2156"
$REDIS SET "presence:u2157" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2157"
$REDIS SET "presence:u2158" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2158"
$REDIS SET "presence:u2159" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2159"
$REDIS SET "presence:u2160" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2160"
$REDIS SET "presence:u2161" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2161"
$REDIS SET "presence:u2162" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2162"
$REDIS SET "presence:u2163" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2163"
$REDIS SET "presence:u2164" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2164"
$REDIS SET "presence:u2165" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2165"
$REDIS SET "presence:u2166" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2166"
$REDIS SET "presence:u2167" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2167"
$REDIS SET "presence:u2168" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2168"
$REDIS SET "presence:u2169" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2169"
$REDIS SET "presence:u2170" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2170"
$REDIS SET "presence:u2171" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2171"
$REDIS SET "presence:u2172" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2172"
$REDIS SET "presence:u2173" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2173"
$REDIS SET "presence:u2174" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2174"
$REDIS SET "presence:u2175" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2175"
$REDIS SET "presence:u2176" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2176"
$REDIS SET "presence:u2177" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2177"
$REDIS SET "presence:u2178" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2178"
$REDIS SET "presence:u2179" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2179"
$REDIS SET "presence:u2180" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2180"
$REDIS SET "presence:u2181" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2181"
$REDIS SET "presence:u2182" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2182"
$REDIS SET "presence:u2183" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2183"
$REDIS SET "presence:u2184" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2184"
$REDIS SET "presence:u2185" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2185"
$REDIS SET "presence:u2186" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2186"
$REDIS SET "presence:u2187" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2187"
$REDIS SET "presence:u2188" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2188"
$REDIS SET "presence:u2189" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2189"
$REDIS SET "presence:u2190" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2190"
$REDIS SET "presence:u2191" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2191"
$REDIS SET "presence:u2192" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2192"
$REDIS SET "presence:u2193" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2193"
$REDIS SET "presence:u2194" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2194"
$REDIS SET "presence:u2195" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2195"
$REDIS SET "presence:u2196" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2196"
$REDIS SET "presence:u2197" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2197"
$REDIS SET "presence:u2198" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2198"
$REDIS SET "presence:u2199" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2199"
$REDIS SET "presence:u2200" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2200"
$REDIS SET "presence:u2201" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2201"
$REDIS SET "presence:u2202" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2202"
$REDIS SET "presence:u2203" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2203"
$REDIS SET "presence:u2204" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2204"
$REDIS SET "presence:u2205" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2205"
$REDIS SET "presence:u2206" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2206"
$REDIS SET "presence:u2207" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2207"
$REDIS SET "presence:u2208" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2208"
$REDIS SET "presence:u2209" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2209"
$REDIS SET "presence:u2210" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2210"
$REDIS SET "presence:u2211" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2211"
$REDIS SET "presence:u2212" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2212"
$REDIS SET "presence:u2213" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2213"
$REDIS SET "presence:u2214" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2214"
$REDIS SET "presence:u2215" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2215"
$REDIS SET "presence:u2216" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2216"
$REDIS SET "presence:u2217" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2217"
$REDIS SET "presence:u2218" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2218"
$REDIS SET "presence:u2219" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2219"
$REDIS SET "presence:u2220" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2220"
$REDIS SET "presence:u2221" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2221"
$REDIS SET "presence:u2222" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2222"
$REDIS SET "presence:u2223" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2223"
$REDIS SET "presence:u2224" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2224"
$REDIS SET "presence:u2225" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2225"
$REDIS SET "presence:u2226" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2226"
$REDIS SET "presence:u2227" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2227"
$REDIS SET "presence:u2228" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2228"
$REDIS SET "presence:u2229" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2229"
$REDIS SET "presence:u2230" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2230"
$REDIS SET "presence:u2231" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2231"
$REDIS SET "presence:u2232" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2232"
$REDIS SET "presence:u2233" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2233"
$REDIS SET "presence:u2234" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2234"
$REDIS SET "presence:u2235" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2235"
$REDIS SET "presence:u2236" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2236"
$REDIS SET "presence:u2237" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2237"
$REDIS SET "presence:u2238" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2238"
$REDIS SET "presence:u2239" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2239"
$REDIS SET "presence:u2240" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2240"
$REDIS SET "presence:u2241" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2241"
$REDIS SET "presence:u2242" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2242"
$REDIS SET "presence:u2243" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2243"
$REDIS SET "presence:u2244" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2244"
$REDIS SET "presence:u2245" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2245"
$REDIS SET "presence:u2246" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2246"
$REDIS SET "presence:u2247" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2247"
$REDIS SET "presence:u2248" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2248"
$REDIS SET "presence:u2249" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2249"
$REDIS SET "presence:u2250" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2250"
$REDIS SET "presence:u2251" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2251"
$REDIS SET "presence:u2252" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2252"
$REDIS SET "presence:u2253" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2253"
$REDIS SET "presence:u2254" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2254"
$REDIS SET "presence:u2255" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2255"
$REDIS SET "presence:u2256" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2256"
$REDIS SET "presence:u2257" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2257"
$REDIS SET "presence:u2258" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2258"
$REDIS SET "presence:u2259" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2259"
$REDIS SET "presence:u2260" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2260"
$REDIS SET "presence:u2261" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2261"
$REDIS SET "presence:u2262" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2262"
$REDIS SET "presence:u2263" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2263"
$REDIS SET "presence:u2264" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2264"
$REDIS SET "presence:u2265" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2265"
$REDIS SET "presence:u2266" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2266"
$REDIS SET "presence:u2267" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2267"
$REDIS SET "presence:u2268" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2268"
$REDIS SET "presence:u2269" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2269"
$REDIS SET "presence:u2270" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2270"
$REDIS SET "presence:u2271" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2271"
$REDIS SET "presence:u2272" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2272"
$REDIS SET "presence:u2273" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2273"
$REDIS SET "presence:u2274" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2274"
$REDIS SET "presence:u2275" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2275"
$REDIS SET "presence:u2276" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2276"
$REDIS SET "presence:u2277" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2277"
$REDIS SET "presence:u2278" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2278"
$REDIS SET "presence:u2279" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2279"
$REDIS SET "presence:u2280" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2280"
$REDIS SET "presence:u2281" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2281"
$REDIS SET "presence:u2282" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2282"
$REDIS SET "presence:u2283" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2283"
$REDIS SET "presence:u2284" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2284"
$REDIS SET "presence:u2285" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2285"
$REDIS SET "presence:u2286" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2286"
$REDIS SET "presence:u2287" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2287"
$REDIS SET "presence:u2288" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2288"
$REDIS SET "presence:u2289" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2289"
$REDIS SET "presence:u2290" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2290"
$REDIS SET "presence:u2291" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2291"
$REDIS SET "presence:u2292" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2292"
$REDIS SET "presence:u2293" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2293"
$REDIS SET "presence:u2294" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2294"
$REDIS SET "presence:u2295" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2295"
$REDIS SET "presence:u2296" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2296"
$REDIS SET "presence:u2297" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2297"
$REDIS SET "presence:u2298" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2298"
$REDIS SET "presence:u2299" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2299"
$REDIS SET "presence:u2300" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2300"
$REDIS SET "presence:u2301" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2301"
$REDIS SET "presence:u2302" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2302"
$REDIS SET "presence:u2303" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2303"
$REDIS SET "presence:u2304" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2304"
$REDIS SET "presence:u2305" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2305"
$REDIS SET "presence:u2306" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2306"
$REDIS SET "presence:u2307" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2307"
$REDIS SET "presence:u2308" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2308"
$REDIS SET "presence:u2309" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2309"
$REDIS SET "presence:u2310" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2310"
$REDIS SET "presence:u2311" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2311"
$REDIS SET "presence:u2312" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2312"
$REDIS SET "presence:u2313" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2313"
$REDIS SET "presence:u2314" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2314"
$REDIS SET "presence:u2315" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2315"
$REDIS SET "presence:u2316" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2316"
$REDIS SET "presence:u2317" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2317"
$REDIS SET "presence:u2318" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2318"
$REDIS SET "presence:u2319" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2319"
$REDIS SET "presence:u2320" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2320"
$REDIS SET "presence:u2321" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2321"
$REDIS SET "presence:u2322" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2322"
$REDIS SET "presence:u2323" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2323"
$REDIS SET "presence:u2324" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2324"
$REDIS SET "presence:u2325" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2325"
$REDIS SET "presence:u2326" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2326"
$REDIS SET "presence:u2327" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2327"
$REDIS SET "presence:u2328" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2328"
$REDIS SET "presence:u2329" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2329"
$REDIS SET "presence:u2330" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2330"
$REDIS SET "presence:u2331" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2331"
$REDIS SET "presence:u2332" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2332"
$REDIS SET "presence:u2333" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2333"
$REDIS SET "presence:u2334" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2334"
$REDIS SET "presence:u2335" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2335"
$REDIS SET "presence:u2336" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2336"
$REDIS SET "presence:u2337" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2337"
$REDIS SET "presence:u2338" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2338"
$REDIS SET "presence:u2339" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2339"
$REDIS SET "presence:u2340" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2340"
$REDIS SET "presence:u2341" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2341"
$REDIS SET "presence:u2342" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2342"
$REDIS SET "presence:u2343" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2343"
$REDIS SET "presence:u2344" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2344"
$REDIS SET "presence:u2345" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2345"
$REDIS SET "presence:u2346" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2346"
$REDIS SET "presence:u2347" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2347"
$REDIS SET "presence:u2348" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2348"
$REDIS SET "presence:u2349" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2349"
$REDIS SET "presence:u2350" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2350"
$REDIS SET "presence:u2351" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2351"
$REDIS SET "presence:u2352" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2352"
$REDIS SET "presence:u2353" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2353"
$REDIS SET "presence:u2354" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2354"
$REDIS SET "presence:u2355" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2355"
$REDIS SET "presence:u2356" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2356"
$REDIS SET "presence:u2357" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2357"
$REDIS SET "presence:u2358" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2358"
$REDIS SET "presence:u2359" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2359"
$REDIS SET "presence:u2360" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2360"
$REDIS SET "presence:u2361" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2361"
$REDIS SET "presence:u2362" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2362"
$REDIS SET "presence:u2363" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2363"
$REDIS SET "presence:u2364" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2364"
$REDIS SET "presence:u2365" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2365"
$REDIS SET "presence:u2366" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2366"
$REDIS SET "presence:u2367" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2367"
$REDIS SET "presence:u2368" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2368"
$REDIS SET "presence:u2369" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2369"
$REDIS SET "presence:u2370" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2370"
$REDIS SET "presence:u2371" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2371"
$REDIS SET "presence:u2372" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2372"
$REDIS SET "presence:u2373" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2373"
$REDIS SET "presence:u2374" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2374"
$REDIS SET "presence:u2375" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2375"
$REDIS SET "presence:u2376" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2376"
$REDIS SET "presence:u2377" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2377"
$REDIS SET "presence:u2378" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2378"
$REDIS SET "presence:u2379" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2379"
$REDIS SET "presence:u2380" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2380"
$REDIS SET "presence:u2381" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2381"
$REDIS SET "presence:u2382" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2382"
$REDIS SET "presence:u2383" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2383"
$REDIS SET "presence:u2384" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2384"
$REDIS SET "presence:u2385" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2385"
$REDIS SET "presence:u2386" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2386"
$REDIS SET "presence:u2387" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2387"
$REDIS SET "presence:u2388" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2388"
$REDIS SET "presence:u2389" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2389"
$REDIS SET "presence:u2390" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2390"
$REDIS SET "presence:u2391" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2391"
$REDIS SET "presence:u2392" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2392"
$REDIS SET "presence:u2393" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2393"
$REDIS SET "presence:u2394" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2394"
$REDIS SET "presence:u2395" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2395"
$REDIS SET "presence:u2396" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2396"
$REDIS SET "presence:u2397" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2397"
$REDIS SET "presence:u2398" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2398"
$REDIS SET "presence:u2399" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2399"
$REDIS SET "presence:u2400" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2400"
$REDIS SET "presence:u2401" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2401"
$REDIS SET "presence:u2402" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2402"
$REDIS SET "presence:u2403" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2403"
$REDIS SET "presence:u2404" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2404"
$REDIS SET "presence:u2405" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2405"
$REDIS SET "presence:u2406" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2406"
$REDIS SET "presence:u2407" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2407"
$REDIS SET "presence:u2408" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2408"
$REDIS SET "presence:u2409" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2409"
$REDIS SET "presence:u2410" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2410"
$REDIS SET "presence:u2411" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2411"
$REDIS SET "presence:u2412" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2412"
$REDIS SET "presence:u2413" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2413"
$REDIS SET "presence:u2414" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2414"
$REDIS SET "presence:u2415" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2415"
$REDIS SET "presence:u2416" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2416"
$REDIS SET "presence:u2417" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2417"
$REDIS SET "presence:u2418" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2418"
$REDIS SET "presence:u2419" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2419"
$REDIS SET "presence:u2420" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2420"
$REDIS SET "presence:u2421" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2421"
$REDIS SET "presence:u2422" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2422"
$REDIS SET "presence:u2423" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2423"
$REDIS SET "presence:u2424" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2424"
$REDIS SET "presence:u2425" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2425"
$REDIS SET "presence:u2426" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2426"
$REDIS SET "presence:u2427" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2427"
$REDIS SET "presence:u2428" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2428"
$REDIS SET "presence:u2429" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2429"
$REDIS SET "presence:u2430" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2430"
$REDIS SET "presence:u2431" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2431"
$REDIS SET "presence:u2432" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2432"
$REDIS SET "presence:u2433" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2433"
$REDIS SET "presence:u2434" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2434"
$REDIS SET "presence:u2435" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2435"
$REDIS SET "presence:u2436" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2436"
$REDIS SET "presence:u2437" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2437"
$REDIS SET "presence:u2438" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2438"
$REDIS SET "presence:u2439" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2439"
$REDIS SET "presence:u2440" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2440"
$REDIS SET "presence:u2441" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2441"
$REDIS SET "presence:u2442" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2442"
$REDIS SET "presence:u2443" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2443"
$REDIS SET "presence:u2444" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2444"
$REDIS SET "presence:u2445" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2445"
$REDIS SET "presence:u2446" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2446"
$REDIS SET "presence:u2447" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2447"
$REDIS SET "presence:u2448" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2448"
$REDIS SET "presence:u2449" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2449"
$REDIS SET "presence:u2450" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2450"
$REDIS SET "presence:u2451" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2451"
$REDIS SET "presence:u2452" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2452"
$REDIS SET "presence:u2453" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2453"
$REDIS SET "presence:u2454" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2454"
$REDIS SET "presence:u2455" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2455"
$REDIS SET "presence:u2456" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2456"
$REDIS SET "presence:u2457" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2457"
$REDIS SET "presence:u2458" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2458"
$REDIS SET "presence:u2459" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2459"
$REDIS SET "presence:u2460" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2460"
$REDIS SET "presence:u2461" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2461"
$REDIS SET "presence:u2462" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2462"
$REDIS SET "presence:u2463" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2463"
$REDIS SET "presence:u2464" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2464"
$REDIS SET "presence:u2465" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2465"
$REDIS SET "presence:u2466" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2466"
$REDIS SET "presence:u2467" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2467"
$REDIS SET "presence:u2468" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2468"
$REDIS SET "presence:u2469" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2469"
$REDIS SET "presence:u2470" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2470"
$REDIS SET "presence:u2471" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2471"
$REDIS SET "presence:u2472" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2472"
$REDIS SET "presence:u2473" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2473"
$REDIS SET "presence:u2474" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2474"
$REDIS SET "presence:u2475" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2475"
$REDIS SET "presence:u2476" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2476"
$REDIS SET "presence:u2477" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2477"
$REDIS SET "presence:u2478" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2478"
$REDIS SET "presence:u2479" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2479"
$REDIS SET "presence:u2480" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2480"
$REDIS SET "presence:u2481" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2481"
$REDIS SET "presence:u2482" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2482"
$REDIS SET "presence:u2483" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2483"
$REDIS SET "presence:u2484" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2484"
$REDIS SET "presence:u2485" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2485"
$REDIS SET "presence:u2486" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2486"
$REDIS SET "presence:u2487" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2487"
$REDIS SET "presence:u2488" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2488"
$REDIS SET "presence:u2489" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2489"
$REDIS SET "presence:u2490" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2490"
$REDIS SET "presence:u2491" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2491"
$REDIS SET "presence:u2492" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2492"
$REDIS SET "presence:u2493" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2493"
$REDIS SET "presence:u2494" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2494"
$REDIS SET "presence:u2495" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2495"
$REDIS SET "presence:u2496" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2496"
$REDIS SET "presence:u2497" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2497"
$REDIS SET "presence:u2498" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2498"
$REDIS SET "presence:u2499" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2499"
$REDIS SET "presence:u2500" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2500"
$REDIS SET "presence:u2501" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2501"
$REDIS SET "presence:u2502" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2502"
$REDIS SET "presence:u2503" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2503"
$REDIS SET "presence:u2504" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2504"
$REDIS SET "presence:u2505" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2505"
$REDIS SET "presence:u2506" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2506"
$REDIS SET "presence:u2507" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2507"
$REDIS SET "presence:u2508" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2508"
$REDIS SET "presence:u2509" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2509"
$REDIS SET "presence:u2510" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2510"
$REDIS SET "presence:u2511" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2511"
$REDIS SET "presence:u2512" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2512"
$REDIS SET "presence:u2513" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2513"
$REDIS SET "presence:u2514" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2514"
$REDIS SET "presence:u2515" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2515"
$REDIS SET "presence:u2516" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2516"
$REDIS SET "presence:u2517" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2517"
$REDIS SET "presence:u2518" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2518"
$REDIS SET "presence:u2519" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2519"
$REDIS SET "presence:u2520" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2520"
$REDIS SET "presence:u2521" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2521"
$REDIS SET "presence:u2522" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2522"
$REDIS SET "presence:u2523" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2523"
$REDIS SET "presence:u2524" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2524"
$REDIS SET "presence:u2525" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2525"
$REDIS SET "presence:u2526" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2526"
$REDIS SET "presence:u2527" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2527"
$REDIS SET "presence:u2528" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2528"
$REDIS SET "presence:u2529" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2529"
$REDIS SET "presence:u2530" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2530"
$REDIS SET "presence:u2531" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2531"
$REDIS SET "presence:u2532" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2532"
$REDIS SET "presence:u2533" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2533"
$REDIS SET "presence:u2534" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2534"
$REDIS SET "presence:u2535" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2535"
$REDIS SET "presence:u2536" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2536"
$REDIS SET "presence:u2537" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2537"
$REDIS SET "presence:u2538" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2538"
$REDIS SET "presence:u2539" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2539"
$REDIS SET "presence:u2540" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2540"
$REDIS SET "presence:u2541" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2541"
$REDIS SET "presence:u2542" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2542"
$REDIS SET "presence:u2543" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2543"
$REDIS SET "presence:u2544" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2544"
$REDIS SET "presence:u2545" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2545"
$REDIS SET "presence:u2546" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2546"
$REDIS SET "presence:u2547" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2547"
$REDIS SET "presence:u2548" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2548"
$REDIS SET "presence:u2549" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2549"
$REDIS SET "presence:u2550" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2550"
$REDIS SET "presence:u2551" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2551"
$REDIS SET "presence:u2552" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2552"
$REDIS SET "presence:u2553" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2553"
$REDIS SET "presence:u2554" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2554"
$REDIS SET "presence:u2555" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2555"
$REDIS SET "presence:u2556" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2556"
$REDIS SET "presence:u2557" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2557"
$REDIS SET "presence:u2558" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2558"
$REDIS SET "presence:u2559" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2559"
$REDIS SET "presence:u2560" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2560"
$REDIS SET "presence:u2561" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2561"
$REDIS SET "presence:u2562" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2562"
$REDIS SET "presence:u2563" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2563"
$REDIS SET "presence:u2564" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2564"
$REDIS SET "presence:u2565" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2565"
$REDIS SET "presence:u2566" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2566"
$REDIS SET "presence:u2567" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2567"
$REDIS SET "presence:u2568" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2568"
$REDIS SET "presence:u2569" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2569"
$REDIS SET "presence:u2570" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2570"
$REDIS SET "presence:u2571" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2571"
$REDIS SET "presence:u2572" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2572"
$REDIS SET "presence:u2573" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2573"
$REDIS SET "presence:u2574" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2574"
$REDIS SET "presence:u2575" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2575"
$REDIS SET "presence:u2576" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2576"
$REDIS SET "presence:u2577" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2577"
$REDIS SET "presence:u2578" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2578"
$REDIS SET "presence:u2579" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2579"
$REDIS SET "presence:u2580" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2580"
$REDIS SET "presence:u2581" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2581"
$REDIS SET "presence:u2582" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2582"
$REDIS SET "presence:u2583" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2583"
$REDIS SET "presence:u2584" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2584"
$REDIS SET "presence:u2585" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2585"
$REDIS SET "presence:u2586" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2586"
$REDIS SET "presence:u2587" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2587"
$REDIS SET "presence:u2588" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2588"
$REDIS SET "presence:u2589" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2589"
$REDIS SET "presence:u2590" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2590"
$REDIS SET "presence:u2591" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2591"
$REDIS SET "presence:u2592" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2592"
$REDIS SET "presence:u2593" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2593"
$REDIS SET "presence:u2594" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2594"
$REDIS SET "presence:u2595" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2595"
$REDIS SET "presence:u2596" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2596"
$REDIS SET "presence:u2597" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2597"
$REDIS SET "presence:u2598" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2598"
$REDIS SET "presence:u2599" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2599"
$REDIS SET "presence:u2600" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2600"
$REDIS SET "presence:u2601" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2601"
$REDIS SET "presence:u2602" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2602"
$REDIS SET "presence:u2603" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2603"
$REDIS SET "presence:u2604" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2604"
$REDIS SET "presence:u2605" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2605"
$REDIS SET "presence:u2606" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2606"
$REDIS SET "presence:u2607" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2607"
$REDIS SET "presence:u2608" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2608"
$REDIS SET "presence:u2609" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2609"
$REDIS SET "presence:u2610" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2610"
$REDIS SET "presence:u2611" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2611"
$REDIS SET "presence:u2612" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2612"
$REDIS SET "presence:u2613" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2613"
$REDIS SET "presence:u2614" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2614"
$REDIS SET "presence:u2615" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2615"
$REDIS SET "presence:u2616" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2616"
$REDIS SET "presence:u2617" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2617"
$REDIS SET "presence:u2618" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2618"
$REDIS SET "presence:u2619" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2619"
$REDIS SET "presence:u2620" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2620"
$REDIS SET "presence:u2621" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2621"
$REDIS SET "presence:u2622" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2622"
$REDIS SET "presence:u2623" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2623"
$REDIS SET "presence:u2624" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2624"
$REDIS SET "presence:u2625" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2625"
$REDIS SET "presence:u2626" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2626"
$REDIS SET "presence:u2627" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2627"
$REDIS SET "presence:u2628" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2628"
$REDIS SET "presence:u2629" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2629"
$REDIS SET "presence:u2630" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2630"
$REDIS SET "presence:u2631" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2631"
$REDIS SET "presence:u2632" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2632"
$REDIS SET "presence:u2633" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2633"
$REDIS SET "presence:u2634" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2634"
$REDIS SET "presence:u2635" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2635"
$REDIS SET "presence:u2636" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2636"
$REDIS SET "presence:u2637" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2637"
$REDIS SET "presence:u2638" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2638"
$REDIS SET "presence:u2639" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2639"
$REDIS SET "presence:u2640" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2640"
$REDIS SET "presence:u2641" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2641"
$REDIS SET "presence:u2642" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2642"
$REDIS SET "presence:u2643" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2643"
$REDIS SET "presence:u2644" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2644"
$REDIS SET "presence:u2645" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2645"
$REDIS SET "presence:u2646" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2646"
$REDIS SET "presence:u2647" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2647"
$REDIS SET "presence:u2648" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2648"
$REDIS SET "presence:u2649" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2649"
$REDIS SET "presence:u2650" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2650"
$REDIS SET "presence:u2651" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2651"
$REDIS SET "presence:u2652" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2652"
$REDIS SET "presence:u2653" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2653"
$REDIS SET "presence:u2654" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2654"
$REDIS SET "presence:u2655" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2655"
$REDIS SET "presence:u2656" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2656"
$REDIS SET "presence:u2657" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2657"
$REDIS SET "presence:u2658" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2658"
$REDIS SET "presence:u2659" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2659"
$REDIS SET "presence:u2660" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2660"
$REDIS SET "presence:u2661" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2661"
$REDIS SET "presence:u2662" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2662"
$REDIS SET "presence:u2663" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2663"
$REDIS SET "presence:u2664" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2664"
$REDIS SET "presence:u2665" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2665"
$REDIS SET "presence:u2666" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2666"
$REDIS SET "presence:u2667" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2667"
$REDIS SET "presence:u2668" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2668"
$REDIS SET "presence:u2669" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2669"
$REDIS SET "presence:u2670" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2670"
$REDIS SET "presence:u2671" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2671"
$REDIS SET "presence:u2672" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2672"
$REDIS SET "presence:u2673" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2673"
$REDIS SET "presence:u2674" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2674"
$REDIS SET "presence:u2675" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2675"
$REDIS SET "presence:u2676" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2676"
$REDIS SET "presence:u2677" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2677"
$REDIS SET "presence:u2678" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2678"
$REDIS SET "presence:u2679" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2679"
$REDIS SET "presence:u2680" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2680"
$REDIS SET "presence:u2681" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2681"
$REDIS SET "presence:u2682" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2682"
$REDIS SET "presence:u2683" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2683"
$REDIS SET "presence:u2684" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2684"
$REDIS SET "presence:u2685" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2685"
$REDIS SET "presence:u2686" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2686"
$REDIS SET "presence:u2687" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2687"
$REDIS SET "presence:u2688" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2688"
$REDIS SET "presence:u2689" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2689"
$REDIS SET "presence:u2690" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2690"
$REDIS SET "presence:u2691" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2691"
$REDIS SET "presence:u2692" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2692"
$REDIS SET "presence:u2693" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2693"
$REDIS SET "presence:u2694" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2694"
$REDIS SET "presence:u2695" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2695"
$REDIS SET "presence:u2696" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2696"
$REDIS SET "presence:u2697" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2697"
$REDIS SET "presence:u2698" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2698"
$REDIS SET "presence:u2699" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2699"
$REDIS SET "presence:u2700" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2700"
$REDIS SET "presence:u2701" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2701"
$REDIS SET "presence:u2702" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2702"
$REDIS SET "presence:u2703" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2703"
$REDIS SET "presence:u2704" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2704"
$REDIS SET "presence:u2705" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2705"
$REDIS SET "presence:u2706" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2706"
$REDIS SET "presence:u2707" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2707"
$REDIS SET "presence:u2708" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2708"
$REDIS SET "presence:u2709" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2709"
$REDIS SET "presence:u2710" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2710"
$REDIS SET "presence:u2711" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2711"
$REDIS SET "presence:u2712" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2712"
$REDIS SET "presence:u2713" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2713"
$REDIS SET "presence:u2714" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2714"
$REDIS SET "presence:u2715" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2715"
$REDIS SET "presence:u2716" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2716"
$REDIS SET "presence:u2717" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2717"
$REDIS SET "presence:u2718" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2718"
$REDIS SET "presence:u2719" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2719"
$REDIS SET "presence:u2720" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2720"
$REDIS SET "presence:u2721" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2721"
$REDIS SET "presence:u2722" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2722"
$REDIS SET "presence:u2723" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2723"
$REDIS SET "presence:u2724" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2724"
$REDIS SET "presence:u2725" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2725"
$REDIS SET "presence:u2726" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2726"
$REDIS SET "presence:u2727" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2727"
$REDIS SET "presence:u2728" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2728"
$REDIS SET "presence:u2729" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2729"
$REDIS SET "presence:u2730" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2730"
$REDIS SET "presence:u2731" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2731"
$REDIS SET "presence:u2732" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2732"
$REDIS SET "presence:u2733" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2733"
$REDIS SET "presence:u2734" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2734"
$REDIS SET "presence:u2735" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2735"
$REDIS SET "presence:u2736" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2736"
$REDIS SET "presence:u2737" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2737"
$REDIS SET "presence:u2738" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2738"
$REDIS SET "presence:u2739" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2739"
$REDIS SET "presence:u2740" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2740"
$REDIS SET "presence:u2741" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2741"
$REDIS SET "presence:u2742" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2742"
$REDIS SET "presence:u2743" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2743"
$REDIS SET "presence:u2744" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2744"
$REDIS SET "presence:u2745" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2745"
$REDIS SET "presence:u2746" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2746"
$REDIS SET "presence:u2747" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2747"
$REDIS SET "presence:u2748" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2748"
$REDIS SET "presence:u2749" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2749"
$REDIS SET "presence:u2750" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2750"
$REDIS SET "presence:u2751" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2751"
$REDIS SET "presence:u2752" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2752"
$REDIS SET "presence:u2753" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2753"
$REDIS SET "presence:u2754" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2754"
$REDIS SET "presence:u2755" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2755"
$REDIS SET "presence:u2756" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2756"
$REDIS SET "presence:u2757" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2757"
$REDIS SET "presence:u2758" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2758"
$REDIS SET "presence:u2759" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2759"
$REDIS SET "presence:u2760" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2760"
$REDIS SET "presence:u2761" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2761"
$REDIS SET "presence:u2762" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2762"
$REDIS SET "presence:u2763" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2763"
$REDIS SET "presence:u2764" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2764"
$REDIS SET "presence:u2765" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2765"
$REDIS SET "presence:u2766" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2766"
$REDIS SET "presence:u2767" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2767"
$REDIS SET "presence:u2768" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2768"
$REDIS SET "presence:u2769" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2769"
$REDIS SET "presence:u2770" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2770"
$REDIS SET "presence:u2771" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2771"
$REDIS SET "presence:u2772" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2772"
$REDIS SET "presence:u2773" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2773"
$REDIS SET "presence:u2774" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2774"
$REDIS SET "presence:u2775" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2775"
$REDIS SET "presence:u2776" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2776"
$REDIS SET "presence:u2777" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2777"
$REDIS SET "presence:u2778" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2778"
$REDIS SET "presence:u2779" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2779"
$REDIS SET "presence:u2780" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2780"
$REDIS SET "presence:u2781" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2781"
$REDIS SET "presence:u2782" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2782"
$REDIS SET "presence:u2783" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2783"
$REDIS SET "presence:u2784" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2784"
$REDIS SET "presence:u2785" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2785"
$REDIS SET "presence:u2786" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2786"
$REDIS SET "presence:u2787" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2787"
$REDIS SET "presence:u2788" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2788"
$REDIS SET "presence:u2789" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2789"
$REDIS SET "presence:u2790" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2790"
$REDIS SET "presence:u2791" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2791"
$REDIS SET "presence:u2792" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2792"
$REDIS SET "presence:u2793" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2793"
$REDIS SET "presence:u2794" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2794"
$REDIS SET "presence:u2795" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2795"
$REDIS SET "presence:u2796" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2796"
$REDIS SET "presence:u2797" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2797"
$REDIS SET "presence:u2798" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2798"
$REDIS SET "presence:u2799" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2799"
$REDIS SET "presence:u2800" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2800"
$REDIS SET "presence:u2801" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2801"
$REDIS SET "presence:u2802" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2802"
$REDIS SET "presence:u2803" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2803"
$REDIS SET "presence:u2804" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2804"
$REDIS SET "presence:u2805" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2805"
$REDIS SET "presence:u2806" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2806"
$REDIS SET "presence:u2807" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2807"
$REDIS SET "presence:u2808" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2808"
$REDIS SET "presence:u2809" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2809"
$REDIS SET "presence:u2810" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2810"
$REDIS SET "presence:u2811" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2811"
$REDIS SET "presence:u2812" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2812"
$REDIS SET "presence:u2813" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2813"
$REDIS SET "presence:u2814" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2814"
$REDIS SET "presence:u2815" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2815"
$REDIS SET "presence:u2816" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2816"
$REDIS SET "presence:u2817" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2817"
$REDIS SET "presence:u2818" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2818"
$REDIS SET "presence:u2819" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2819"
$REDIS SET "presence:u2820" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2820"
$REDIS SET "presence:u2821" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2821"
$REDIS SET "presence:u2822" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2822"
$REDIS SET "presence:u2823" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2823"
$REDIS SET "presence:u2824" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2824"
$REDIS SET "presence:u2825" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2825"
$REDIS SET "presence:u2826" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2826"
$REDIS SET "presence:u2827" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2827"
$REDIS SET "presence:u2828" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2828"
$REDIS SET "presence:u2829" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2829"
$REDIS SET "presence:u2830" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2830"
$REDIS SET "presence:u2831" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2831"
$REDIS SET "presence:u2832" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2832"
$REDIS SET "presence:u2833" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2833"
$REDIS SET "presence:u2834" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2834"
$REDIS SET "presence:u2835" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2835"
$REDIS SET "presence:u2836" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2836"
$REDIS SET "presence:u2837" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2837"
$REDIS SET "presence:u2838" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2838"
$REDIS SET "presence:u2839" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2839"
$REDIS SET "presence:u2840" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2840"
$REDIS SET "presence:u2841" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2841"
$REDIS SET "presence:u2842" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2842"
$REDIS SET "presence:u2843" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2843"
$REDIS SET "presence:u2844" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2844"
$REDIS SET "presence:u2845" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2845"
$REDIS SET "presence:u2846" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2846"
$REDIS SET "presence:u2847" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2847"
$REDIS SET "presence:u2848" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2848"
$REDIS SET "presence:u2849" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2849"
$REDIS SET "presence:u2850" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2850"
$REDIS SET "presence:u2851" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2851"
$REDIS SET "presence:u2852" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2852"
$REDIS SET "presence:u2853" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2853"
$REDIS SET "presence:u2854" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2854"
$REDIS SET "presence:u2855" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2855"
$REDIS SET "presence:u2856" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2856"
$REDIS SET "presence:u2857" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2857"
$REDIS SET "presence:u2858" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2858"
$REDIS SET "presence:u2859" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2859"
$REDIS SET "presence:u2860" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2860"
$REDIS SET "presence:u2861" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2861"
$REDIS SET "presence:u2862" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2862"
$REDIS SET "presence:u2863" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2863"
$REDIS SET "presence:u2864" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2864"
$REDIS SET "presence:u2865" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2865"
$REDIS SET "presence:u2866" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2866"
$REDIS SET "presence:u2867" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2867"
$REDIS SET "presence:u2868" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2868"
$REDIS SET "presence:u2869" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2869"
$REDIS SET "presence:u2870" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2870"
$REDIS SET "presence:u2871" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2871"
$REDIS SET "presence:u2872" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2872"
$REDIS SET "presence:u2873" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2873"
$REDIS SET "presence:u2874" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2874"
$REDIS SET "presence:u2875" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2875"
$REDIS SET "presence:u2876" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2876"
$REDIS SET "presence:u2877" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2877"
$REDIS SET "presence:u2878" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2878"
$REDIS SET "presence:u2879" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2879"
$REDIS SET "presence:u2880" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2880"
$REDIS SET "presence:u2881" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2881"
$REDIS SET "presence:u2882" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2882"
$REDIS SET "presence:u2883" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2883"
$REDIS SET "presence:u2884" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2884"
$REDIS SET "presence:u2885" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2885"
$REDIS SET "presence:u2886" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2886"
$REDIS SET "presence:u2887" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2887"
$REDIS SET "presence:u2888" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2888"
$REDIS SET "presence:u2889" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2889"
$REDIS SET "presence:u2890" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2890"
$REDIS SET "presence:u2891" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2891"
$REDIS SET "presence:u2892" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2892"
$REDIS SET "presence:u2893" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2893"
$REDIS SET "presence:u2894" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2894"
$REDIS SET "presence:u2895" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2895"
$REDIS SET "presence:u2896" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2896"
$REDIS SET "presence:u2897" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2897"
$REDIS SET "presence:u2898" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2898"
$REDIS SET "presence:u2899" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2899"
$REDIS SET "presence:u2900" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2900"
$REDIS SET "presence:u2901" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2901"
$REDIS SET "presence:u2902" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2902"
$REDIS SET "presence:u2903" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2903"
$REDIS SET "presence:u2904" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2904"
$REDIS SET "presence:u2905" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2905"
$REDIS SET "presence:u2906" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2906"
$REDIS SET "presence:u2907" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2907"
$REDIS SET "presence:u2908" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2908"
$REDIS SET "presence:u2909" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2909"
$REDIS SET "presence:u2910" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2910"
$REDIS SET "presence:u2911" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2911"
$REDIS SET "presence:u2912" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2912"
$REDIS SET "presence:u2913" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2913"
$REDIS SET "presence:u2914" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2914"
$REDIS SET "presence:u2915" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2915"
$REDIS SET "presence:u2916" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2916"
$REDIS SET "presence:u2917" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2917"
$REDIS SET "presence:u2918" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2918"
$REDIS SET "presence:u2919" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2919"
$REDIS SET "presence:u2920" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2920"
$REDIS SET "presence:u2921" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2921"
$REDIS SET "presence:u2922" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2922"
$REDIS SET "presence:u2923" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2923"
$REDIS SET "presence:u2924" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2924"
$REDIS SET "presence:u2925" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2925"
$REDIS SET "presence:u2926" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2926"
$REDIS SET "presence:u2927" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2927"
$REDIS SET "presence:u2928" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2928"
$REDIS SET "presence:u2929" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2929"
$REDIS SET "presence:u2930" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2930"
$REDIS SET "presence:u2931" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2931"
$REDIS SET "presence:u2932" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2932"
$REDIS SET "presence:u2933" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2933"
$REDIS SET "presence:u2934" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2934"
$REDIS SET "presence:u2935" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2935"
$REDIS SET "presence:u2936" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2936"
$REDIS SET "presence:u2937" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2937"
$REDIS SET "presence:u2938" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2938"
$REDIS SET "presence:u2939" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2939"
$REDIS SET "presence:u2940" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2940"
$REDIS SET "presence:u2941" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T20:07:13Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2941"
$REDIS SET "presence:u2942" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T21:14:26Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2942"
$REDIS SET "presence:u2943" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T22:21:39Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2943"
$REDIS SET "presence:u2944" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T23:28:52Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2944"
$REDIS SET "presence:u2945" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T20:35:05Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2945"
$REDIS SET "presence:u2946" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T21:42:18Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2946"
$REDIS SET "presence:u2947" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T22:49:31Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2947"
$REDIS SET "presence:u2948" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T23:56:44Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2948"
$REDIS SET "presence:u2949" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T20:03:57Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2949"
$REDIS SET "presence:u2950" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T21:10:10Z"}' EX 3600
$REDIS SADD "venue:50:present" "u2950"
$REDIS SET "presence:u2951" '{"status":"online","venue_id":"1","venue_name":"Crobar","since":"2026-06-01T22:17:23Z"}' EX 3600
$REDIS SADD "venue:1:present" "u2951"
$REDIS SET "presence:u2952" '{"status":"online","venue_id":"2","venue_name":"Jet","since":"2026-06-01T23:24:36Z"}' EX 3600
$REDIS SADD "venue:2:present" "u2952"
$REDIS SET "presence:u2953" '{"status":"online","venue_id":"3","venue_name":"Ink","since":"2026-06-01T20:31:49Z"}' EX 3600
$REDIS SADD "venue:3:present" "u2953"
$REDIS SET "presence:u2954" '{"status":"online","venue_id":"4","venue_name":"Mandarine","since":"2026-06-01T21:38:02Z"}' EX 3600
$REDIS SADD "venue:4:present" "u2954"
$REDIS SET "presence:u2955" '{"status":"online","venue_id":"5","venue_name":"Pacha","since":"2026-06-01T22:45:15Z"}' EX 3600
$REDIS SADD "venue:5:present" "u2955"
$REDIS SET "presence:u2956" '{"status":"online","venue_id":"6","venue_name":"Rosebar","since":"2026-06-01T23:52:28Z"}' EX 3600
$REDIS SADD "venue:6:present" "u2956"
$REDIS SET "presence:u2957" '{"status":"online","venue_id":"7","venue_name":"Kika","since":"2026-06-01T20:59:41Z"}' EX 3600
$REDIS SADD "venue:7:present" "u2957"
$REDIS SET "presence:u2958" '{"status":"online","venue_id":"8","venue_name":"BNN","since":"2026-06-01T21:06:54Z"}' EX 3600
$REDIS SADD "venue:8:present" "u2958"
$REDIS SET "presence:u2959" '{"status":"online","venue_id":"9","venue_name":"Museum","since":"2026-06-01T22:13:07Z"}' EX 3600
$REDIS SADD "venue:9:present" "u2959"
$REDIS SET "presence:u2960" '{"status":"online","venue_id":"10","venue_name":"Bahrein","since":"2026-06-01T23:20:20Z"}' EX 3600
$REDIS SADD "venue:10:present" "u2960"
$REDIS SET "presence:u2961" '{"status":"online","venue_id":"11","venue_name":"Niceto Club","since":"2026-06-01T20:27:33Z"}' EX 3600
$REDIS SADD "venue:11:present" "u2961"
$REDIS SET "presence:u2962" '{"status":"online","venue_id":"12","venue_name":"Input","since":"2026-06-01T21:34:46Z"}' EX 3600
$REDIS SADD "venue:12:present" "u2962"
$REDIS SET "presence:u2963" '{"status":"online","venue_id":"13","venue_name":"Rio Electronic","since":"2026-06-01T22:41:59Z"}' EX 3600
$REDIS SADD "venue:13:present" "u2963"
$REDIS SET "presence:u2964" '{"status":"online","venue_id":"14","venue_name":"Malia","since":"2026-06-01T23:48:12Z"}' EX 3600
$REDIS SADD "venue:14:present" "u2964"
$REDIS SET "presence:u2965" '{"status":"online","venue_id":"15","venue_name":"Dorsia","since":"2026-06-01T20:55:25Z"}' EX 3600
$REDIS SADD "venue:15:present" "u2965"
$REDIS SET "presence:u2966" '{"status":"online","venue_id":"16","venue_name":"Arenas","since":"2026-06-01T21:02:38Z"}' EX 3600
$REDIS SADD "venue:16:present" "u2966"
$REDIS SET "presence:u2967" '{"status":"online","venue_id":"17","venue_name":"Cluster","since":"2026-06-01T22:09:51Z"}' EX 3600
$REDIS SADD "venue:17:present" "u2967"
$REDIS SET "presence:u2968" '{"status":"online","venue_id":"18","venue_name":"Prisma","since":"2026-06-01T23:16:04Z"}' EX 3600
$REDIS SADD "venue:18:present" "u2968"
$REDIS SET "presence:u2969" '{"status":"online","venue_id":"19","venue_name":"Aura","since":"2026-06-01T20:23:17Z"}' EX 3600
$REDIS SADD "venue:19:present" "u2969"
$REDIS SET "presence:u2970" '{"status":"online","venue_id":"20","venue_name":"Monaco","since":"2026-06-01T21:30:30Z"}' EX 3600
$REDIS SADD "venue:20:present" "u2970"
$REDIS SET "presence:u2971" '{"status":"online","venue_id":"21","venue_name":"Blackroom","since":"2026-06-01T22:37:43Z"}' EX 3600
$REDIS SADD "venue:21:present" "u2971"
$REDIS SET "presence:u2972" '{"status":"online","venue_id":"22","venue_name":"VÃ©rtigo","since":"2026-06-01T23:44:56Z"}' EX 3600
$REDIS SADD "venue:22:present" "u2972"
$REDIS SET "presence:u2973" '{"status":"online","venue_id":"23","venue_name":"Distrito","since":"2026-06-01T20:51:09Z"}' EX 3600
$REDIS SADD "venue:23:present" "u2973"
$REDIS SET "presence:u2974" '{"status":"online","venue_id":"24","venue_name":"Celsius","since":"2026-06-01T21:58:22Z"}' EX 3600
$REDIS SADD "venue:24:present" "u2974"
$REDIS SET "presence:u2975" '{"status":"online","venue_id":"25","venue_name":"Lumen","since":"2026-06-01T22:05:35Z"}' EX 3600
$REDIS SADD "venue:25:present" "u2975"
$REDIS SET "presence:u2976" '{"status":"online","venue_id":"26","venue_name":"Skyline","since":"2026-06-01T23:12:48Z"}' EX 3600
$REDIS SADD "venue:26:present" "u2976"
$REDIS SET "presence:u2977" '{"status":"online","venue_id":"27","venue_name":"Vox","since":"2026-06-01T20:19:01Z"}' EX 3600
$REDIS SADD "venue:27:present" "u2977"
$REDIS SET "presence:u2978" '{"status":"online","venue_id":"28","venue_name":"Fahrenheit","since":"2026-06-01T21:26:14Z"}' EX 3600
$REDIS SADD "venue:28:present" "u2978"
$REDIS SET "presence:u2979" '{"status":"online","venue_id":"29","venue_name":"Pulse","since":"2026-06-01T22:33:27Z"}' EX 3600
$REDIS SADD "venue:29:present" "u2979"
$REDIS SET "presence:u2980" '{"status":"online","venue_id":"30","venue_name":"Nebula","since":"2026-06-01T23:40:40Z"}' EX 3600
$REDIS SADD "venue:30:present" "u2980"
$REDIS SET "presence:u2981" '{"status":"online","venue_id":"31","venue_name":"Empire","since":"2026-06-01T20:47:53Z"}' EX 3600
$REDIS SADD "venue:31:present" "u2981"
$REDIS SET "presence:u2982" '{"status":"online","venue_id":"32","venue_name":"Zenith","since":"2026-06-01T21:54:06Z"}' EX 3600
$REDIS SADD "venue:32:present" "u2982"
$REDIS SET "presence:u2983" '{"status":"online","venue_id":"33","venue_name":"Moscow","since":"2026-06-01T22:01:19Z"}' EX 3600
$REDIS SADD "venue:33:present" "u2983"
$REDIS SET "presence:u2984" '{"status":"online","venue_id":"34","venue_name":"Oasis","since":"2026-06-01T23:08:32Z"}' EX 3600
$REDIS SADD "venue:34:present" "u2984"
$REDIS SET "presence:u2985" '{"status":"online","venue_id":"35","venue_name":"Nova","since":"2026-06-01T20:15:45Z"}' EX 3600
$REDIS SADD "venue:35:present" "u2985"
$REDIS SET "presence:u2986" '{"status":"online","venue_id":"36","venue_name":"Mamba","since":"2026-06-01T21:22:58Z"}' EX 3600
$REDIS SADD "venue:36:present" "u2986"
$REDIS SET "presence:u2987" '{"status":"online","venue_id":"37","venue_name":"Titan","since":"2026-06-01T22:29:11Z"}' EX 3600
$REDIS SADD "venue:37:present" "u2987"
$REDIS SET "presence:u2988" '{"status":"online","venue_id":"38","venue_name":"Metropolis","since":"2026-06-01T23:36:24Z"}' EX 3600
$REDIS SADD "venue:38:present" "u2988"
$REDIS SET "presence:u2989" '{"status":"online","venue_id":"39","venue_name":"Eclipse","since":"2026-06-01T20:43:37Z"}' EX 3600
$REDIS SADD "venue:39:present" "u2989"
$REDIS SET "presence:u2990" '{"status":"online","venue_id":"40","venue_name":"Lounge X","since":"2026-06-01T21:50:50Z"}' EX 3600
$REDIS SADD "venue:40:present" "u2990"
$REDIS SET "presence:u2991" '{"status":"online","venue_id":"41","venue_name":"Velvet","since":"2026-06-01T22:57:03Z"}' EX 3600
$REDIS SADD "venue:41:present" "u2991"
$REDIS SET "presence:u2992" '{"status":"online","venue_id":"42","venue_name":"Satori","since":"2026-06-01T23:04:16Z"}' EX 3600
$REDIS SADD "venue:42:present" "u2992"
$REDIS SET "presence:u2993" '{"status":"online","venue_id":"43","venue_name":"Code","since":"2026-06-01T20:11:29Z"}' EX 3600
$REDIS SADD "venue:43:present" "u2993"
$REDIS SET "presence:u2994" '{"status":"online","venue_id":"44","venue_name":"Temple","since":"2026-06-01T21:18:42Z"}' EX 3600
$REDIS SADD "venue:44:present" "u2994"
$REDIS SET "presence:u2995" '{"status":"online","venue_id":"45","venue_name":"Nox","since":"2026-06-01T22:25:55Z"}' EX 3600
$REDIS SADD "venue:45:present" "u2995"
$REDIS SET "presence:u2996" '{"status":"online","venue_id":"46","venue_name":"Solar","since":"2026-06-01T23:32:08Z"}' EX 3600
$REDIS SADD "venue:46:present" "u2996"
$REDIS SET "presence:u2997" '{"status":"online","venue_id":"47","venue_name":"Myst","since":"2026-06-01T20:39:21Z"}' EX 3600
$REDIS SADD "venue:47:present" "u2997"
$REDIS SET "presence:u2998" '{"status":"online","venue_id":"48","venue_name":"Replay","since":"2026-06-01T21:46:34Z"}' EX 3600
$REDIS SADD "venue:48:present" "u2998"
$REDIS SET "presence:u2999" '{"status":"online","venue_id":"49","venue_name":"Atomic","since":"2026-06-01T22:53:47Z"}' EX 3600
$REDIS SADD "venue:49:present" "u2999"
$REDIS SET "presence:u3000" '{"status":"online","venue_id":"50","venue_name":"Mirage","since":"2026-06-01T23:00:00Z"}' EX 3600
$REDIS SADD "venue:50:present" "u3000"

# TTL para los sets de presencia por venue
$REDIS EXPIRE "venue:1:present" 3600
$REDIS EXPIRE "venue:2:present" 3600
$REDIS EXPIRE "venue:3:present" 3600
$REDIS EXPIRE "venue:4:present" 3600
$REDIS EXPIRE "venue:5:present" 3600
$REDIS EXPIRE "venue:6:present" 3600
$REDIS EXPIRE "venue:7:present" 3600
$REDIS EXPIRE "venue:8:present" 3600
$REDIS EXPIRE "venue:9:present" 3600
$REDIS EXPIRE "venue:10:present" 3600
$REDIS EXPIRE "venue:11:present" 3600
$REDIS EXPIRE "venue:12:present" 3600
$REDIS EXPIRE "venue:13:present" 3600
$REDIS EXPIRE "venue:14:present" 3600
$REDIS EXPIRE "venue:15:present" 3600
$REDIS EXPIRE "venue:16:present" 3600
$REDIS EXPIRE "venue:17:present" 3600
$REDIS EXPIRE "venue:18:present" 3600
$REDIS EXPIRE "venue:19:present" 3600
$REDIS EXPIRE "venue:20:present" 3600
$REDIS EXPIRE "venue:21:present" 3600
$REDIS EXPIRE "venue:22:present" 3600
$REDIS EXPIRE "venue:23:present" 3600
$REDIS EXPIRE "venue:24:present" 3600
$REDIS EXPIRE "venue:25:present" 3600
$REDIS EXPIRE "venue:26:present" 3600
$REDIS EXPIRE "venue:27:present" 3600
$REDIS EXPIRE "venue:28:present" 3600
$REDIS EXPIRE "venue:29:present" 3600
$REDIS EXPIRE "venue:30:present" 3600
$REDIS EXPIRE "venue:31:present" 3600
$REDIS EXPIRE "venue:32:present" 3600
$REDIS EXPIRE "venue:33:present" 3600
$REDIS EXPIRE "venue:34:present" 3600
$REDIS EXPIRE "venue:35:present" 3600
$REDIS EXPIRE "venue:36:present" 3600
$REDIS EXPIRE "venue:37:present" 3600
$REDIS EXPIRE "venue:38:present" 3600
$REDIS EXPIRE "venue:39:present" 3600
$REDIS EXPIRE "venue:40:present" 3600
$REDIS EXPIRE "venue:41:present" 3600
$REDIS EXPIRE "venue:42:present" 3600
$REDIS EXPIRE "venue:43:present" 3600
$REDIS EXPIRE "venue:44:present" 3600
$REDIS EXPIRE "venue:45:present" 3600
$REDIS EXPIRE "venue:46:present" 3600
$REDIS EXPIRE "venue:47:present" 3600
$REDIS EXPIRE "venue:48:present" 3600
$REDIS EXPIRE "venue:49:present" 3600
$REDIS EXPIRE "venue:50:present" 3600

# Contadores temporales de asistentes por eventos
$REDIS SET "event:e1:attendees" 117 EX 86400
$REDIS SET "event:e2:attendees" 154 EX 86400
$REDIS SET "event:e3:attendees" 191 EX 86400
$REDIS SET "event:e4:attendees" 228 EX 86400
$REDIS SET "event:e5:attendees" 265 EX 86400
$REDIS SET "event:e6:attendees" 302 EX 86400
$REDIS SET "event:e7:attendees" 339 EX 86400
$REDIS SET "event:e8:attendees" 376 EX 86400
$REDIS SET "event:e9:attendees" 413 EX 86400
$REDIS SET "event:e10:attendees" 450 EX 86400
$REDIS SET "event:e11:attendees" 487 EX 86400
$REDIS SET "event:e12:attendees" 524 EX 86400
$REDIS SET "event:e13:attendees" 561 EX 86400
$REDIS SET "event:e14:attendees" 598 EX 86400
$REDIS SET "event:e15:attendees" 635 EX 86400
$REDIS SET "event:e16:attendees" 672 EX 86400
$REDIS SET "event:e17:attendees" 709 EX 86400
$REDIS SET "event:e18:attendees" 746 EX 86400
$REDIS SET "event:e19:attendees" 783 EX 86400
$REDIS SET "event:e20:attendees" 820 EX 86400
$REDIS SET "event:e21:attendees" 857 EX 86400
$REDIS SET "event:e22:attendees" 894 EX 86400
$REDIS SET "event:e23:attendees" 931 EX 86400
$REDIS SET "event:e24:attendees" 968 EX 86400
$REDIS SET "event:e25:attendees" 105 EX 86400
$REDIS SET "event:e26:attendees" 142 EX 86400
$REDIS SET "event:e27:attendees" 179 EX 86400
$REDIS SET "event:e28:attendees" 216 EX 86400
$REDIS SET "event:e29:attendees" 253 EX 86400
$REDIS SET "event:e30:attendees" 290 EX 86400
$REDIS SET "event:e31:attendees" 327 EX 86400
$REDIS SET "event:e32:attendees" 364 EX 86400
$REDIS SET "event:e33:attendees" 401 EX 86400
$REDIS SET "event:e34:attendees" 438 EX 86400
$REDIS SET "event:e35:attendees" 475 EX 86400
$REDIS SET "event:e36:attendees" 512 EX 86400
$REDIS SET "event:e37:attendees" 549 EX 86400
$REDIS SET "event:e38:attendees" 586 EX 86400
$REDIS SET "event:e39:attendees" 623 EX 86400
$REDIS SET "event:e40:attendees" 660 EX 86400
$REDIS SET "event:e41:attendees" 697 EX 86400
$REDIS SET "event:e42:attendees" 734 EX 86400
$REDIS SET "event:e43:attendees" 771 EX 86400
$REDIS SET "event:e44:attendees" 808 EX 86400
$REDIS SET "event:e45:attendees" 845 EX 86400
$REDIS SET "event:e46:attendees" 882 EX 86400
$REDIS SET "event:e47:attendees" 919 EX 86400
$REDIS SET "event:e48:attendees" 956 EX 86400
$REDIS SET "event:e49:attendees" 93 EX 86400
$REDIS SET "event:e50:attendees" 130 EX 86400
$REDIS SET "event:e51:attendees" 167 EX 86400
$REDIS SET "event:e52:attendees" 204 EX 86400
$REDIS SET "event:e53:attendees" 241 EX 86400
$REDIS SET "event:e54:attendees" 278 EX 86400
$REDIS SET "event:e55:attendees" 315 EX 86400
$REDIS SET "event:e56:attendees" 352 EX 86400
$REDIS SET "event:e57:attendees" 389 EX 86400
$REDIS SET "event:e58:attendees" 426 EX 86400
$REDIS SET "event:e59:attendees" 463 EX 86400
$REDIS SET "event:e60:attendees" 500 EX 86400
$REDIS SET "event:e61:attendees" 537 EX 86400
$REDIS SET "event:e62:attendees" 574 EX 86400
$REDIS SET "event:e63:attendees" 611 EX 86400
$REDIS SET "event:e64:attendees" 648 EX 86400
$REDIS SET "event:e65:attendees" 685 EX 86400
$REDIS SET "event:e66:attendees" 722 EX 86400
$REDIS SET "event:e67:attendees" 759 EX 86400
$REDIS SET "event:e68:attendees" 796 EX 86400
$REDIS SET "event:e69:attendees" 833 EX 86400
$REDIS SET "event:e70:attendees" 870 EX 86400
$REDIS SET "event:e71:attendees" 907 EX 86400
$REDIS SET "event:e72:attendees" 944 EX 86400
$REDIS SET "event:e73:attendees" 81 EX 86400
$REDIS SET "event:e74:attendees" 118 EX 86400
$REDIS SET "event:e75:attendees" 155 EX 86400
$REDIS SET "event:e76:attendees" 192 EX 86400
$REDIS SET "event:e77:attendees" 229 EX 86400
$REDIS SET "event:e78:attendees" 266 EX 86400
$REDIS SET "event:e79:attendees" 303 EX 86400
$REDIS SET "event:e80:attendees" 340 EX 86400
$REDIS SET "event:e81:attendees" 377 EX 86400
$REDIS SET "event:e82:attendees" 414 EX 86400
$REDIS SET "event:e83:attendees" 451 EX 86400
$REDIS SET "event:e84:attendees" 488 EX 86400
$REDIS SET "event:e85:attendees" 525 EX 86400
$REDIS SET "event:e86:attendees" 562 EX 86400
$REDIS SET "event:e87:attendees" 599 EX 86400
$REDIS SET "event:e88:attendees" 636 EX 86400
$REDIS SET "event:e89:attendees" 673 EX 86400
$REDIS SET "event:e90:attendees" 710 EX 86400
$REDIS SET "event:e91:attendees" 747 EX 86400
$REDIS SET "event:e92:attendees" 784 EX 86400
$REDIS SET "event:e93:attendees" 821 EX 86400
$REDIS SET "event:e94:attendees" 858 EX 86400
$REDIS SET "event:e95:attendees" 895 EX 86400
$REDIS SET "event:e96:attendees" 932 EX 86400
$REDIS SET "event:e97:attendees" 969 EX 86400
$REDIS SET "event:e98:attendees" 106 EX 86400
$REDIS SET "event:e99:attendees" 143 EX 86400
$REDIS SET "event:e100:attendees" 180 EX 86400

# Sesiones activas de muestra para 500 usuarios
$REDIS SET "session:demo_token_u1" "u1" EX 86400
$REDIS SET "session:demo_token_u2" "u2" EX 86400
$REDIS SET "session:demo_token_u3" "u3" EX 86400
$REDIS SET "session:demo_token_u4" "u4" EX 86400
$REDIS SET "session:demo_token_u5" "u5" EX 86400
$REDIS SET "session:demo_token_u6" "u6" EX 86400
$REDIS SET "session:demo_token_u7" "u7" EX 86400
$REDIS SET "session:demo_token_u8" "u8" EX 86400
$REDIS SET "session:demo_token_u9" "u9" EX 86400
$REDIS SET "session:demo_token_u10" "u10" EX 86400
$REDIS SET "session:demo_token_u11" "u11" EX 86400
$REDIS SET "session:demo_token_u12" "u12" EX 86400
$REDIS SET "session:demo_token_u13" "u13" EX 86400
$REDIS SET "session:demo_token_u14" "u14" EX 86400
$REDIS SET "session:demo_token_u15" "u15" EX 86400
$REDIS SET "session:demo_token_u16" "u16" EX 86400
$REDIS SET "session:demo_token_u17" "u17" EX 86400
$REDIS SET "session:demo_token_u18" "u18" EX 86400
$REDIS SET "session:demo_token_u19" "u19" EX 86400
$REDIS SET "session:demo_token_u20" "u20" EX 86400
$REDIS SET "session:demo_token_u21" "u21" EX 86400
$REDIS SET "session:demo_token_u22" "u22" EX 86400
$REDIS SET "session:demo_token_u23" "u23" EX 86400
$REDIS SET "session:demo_token_u24" "u24" EX 86400
$REDIS SET "session:demo_token_u25" "u25" EX 86400
$REDIS SET "session:demo_token_u26" "u26" EX 86400
$REDIS SET "session:demo_token_u27" "u27" EX 86400
$REDIS SET "session:demo_token_u28" "u28" EX 86400
$REDIS SET "session:demo_token_u29" "u29" EX 86400
$REDIS SET "session:demo_token_u30" "u30" EX 86400
$REDIS SET "session:demo_token_u31" "u31" EX 86400
$REDIS SET "session:demo_token_u32" "u32" EX 86400
$REDIS SET "session:demo_token_u33" "u33" EX 86400
$REDIS SET "session:demo_token_u34" "u34" EX 86400
$REDIS SET "session:demo_token_u35" "u35" EX 86400
$REDIS SET "session:demo_token_u36" "u36" EX 86400
$REDIS SET "session:demo_token_u37" "u37" EX 86400
$REDIS SET "session:demo_token_u38" "u38" EX 86400
$REDIS SET "session:demo_token_u39" "u39" EX 86400
$REDIS SET "session:demo_token_u40" "u40" EX 86400
$REDIS SET "session:demo_token_u41" "u41" EX 86400
$REDIS SET "session:demo_token_u42" "u42" EX 86400
$REDIS SET "session:demo_token_u43" "u43" EX 86400
$REDIS SET "session:demo_token_u44" "u44" EX 86400
$REDIS SET "session:demo_token_u45" "u45" EX 86400
$REDIS SET "session:demo_token_u46" "u46" EX 86400
$REDIS SET "session:demo_token_u47" "u47" EX 86400
$REDIS SET "session:demo_token_u48" "u48" EX 86400
$REDIS SET "session:demo_token_u49" "u49" EX 86400
$REDIS SET "session:demo_token_u50" "u50" EX 86400
$REDIS SET "session:demo_token_u51" "u51" EX 86400
$REDIS SET "session:demo_token_u52" "u52" EX 86400
$REDIS SET "session:demo_token_u53" "u53" EX 86400
$REDIS SET "session:demo_token_u54" "u54" EX 86400
$REDIS SET "session:demo_token_u55" "u55" EX 86400
$REDIS SET "session:demo_token_u56" "u56" EX 86400
$REDIS SET "session:demo_token_u57" "u57" EX 86400
$REDIS SET "session:demo_token_u58" "u58" EX 86400
$REDIS SET "session:demo_token_u59" "u59" EX 86400
$REDIS SET "session:demo_token_u60" "u60" EX 86400
$REDIS SET "session:demo_token_u61" "u61" EX 86400
$REDIS SET "session:demo_token_u62" "u62" EX 86400
$REDIS SET "session:demo_token_u63" "u63" EX 86400
$REDIS SET "session:demo_token_u64" "u64" EX 86400
$REDIS SET "session:demo_token_u65" "u65" EX 86400
$REDIS SET "session:demo_token_u66" "u66" EX 86400
$REDIS SET "session:demo_token_u67" "u67" EX 86400
$REDIS SET "session:demo_token_u68" "u68" EX 86400
$REDIS SET "session:demo_token_u69" "u69" EX 86400
$REDIS SET "session:demo_token_u70" "u70" EX 86400
$REDIS SET "session:demo_token_u71" "u71" EX 86400
$REDIS SET "session:demo_token_u72" "u72" EX 86400
$REDIS SET "session:demo_token_u73" "u73" EX 86400
$REDIS SET "session:demo_token_u74" "u74" EX 86400
$REDIS SET "session:demo_token_u75" "u75" EX 86400
$REDIS SET "session:demo_token_u76" "u76" EX 86400
$REDIS SET "session:demo_token_u77" "u77" EX 86400
$REDIS SET "session:demo_token_u78" "u78" EX 86400
$REDIS SET "session:demo_token_u79" "u79" EX 86400
$REDIS SET "session:demo_token_u80" "u80" EX 86400
$REDIS SET "session:demo_token_u81" "u81" EX 86400
$REDIS SET "session:demo_token_u82" "u82" EX 86400
$REDIS SET "session:demo_token_u83" "u83" EX 86400
$REDIS SET "session:demo_token_u84" "u84" EX 86400
$REDIS SET "session:demo_token_u85" "u85" EX 86400
$REDIS SET "session:demo_token_u86" "u86" EX 86400
$REDIS SET "session:demo_token_u87" "u87" EX 86400
$REDIS SET "session:demo_token_u88" "u88" EX 86400
$REDIS SET "session:demo_token_u89" "u89" EX 86400
$REDIS SET "session:demo_token_u90" "u90" EX 86400
$REDIS SET "session:demo_token_u91" "u91" EX 86400
$REDIS SET "session:demo_token_u92" "u92" EX 86400
$REDIS SET "session:demo_token_u93" "u93" EX 86400
$REDIS SET "session:demo_token_u94" "u94" EX 86400
$REDIS SET "session:demo_token_u95" "u95" EX 86400
$REDIS SET "session:demo_token_u96" "u96" EX 86400
$REDIS SET "session:demo_token_u97" "u97" EX 86400
$REDIS SET "session:demo_token_u98" "u98" EX 86400
$REDIS SET "session:demo_token_u99" "u99" EX 86400
$REDIS SET "session:demo_token_u100" "u100" EX 86400
$REDIS SET "session:demo_token_u101" "u101" EX 86400
$REDIS SET "session:demo_token_u102" "u102" EX 86400
$REDIS SET "session:demo_token_u103" "u103" EX 86400
$REDIS SET "session:demo_token_u104" "u104" EX 86400
$REDIS SET "session:demo_token_u105" "u105" EX 86400
$REDIS SET "session:demo_token_u106" "u106" EX 86400
$REDIS SET "session:demo_token_u107" "u107" EX 86400
$REDIS SET "session:demo_token_u108" "u108" EX 86400
$REDIS SET "session:demo_token_u109" "u109" EX 86400
$REDIS SET "session:demo_token_u110" "u110" EX 86400
$REDIS SET "session:demo_token_u111" "u111" EX 86400
$REDIS SET "session:demo_token_u112" "u112" EX 86400
$REDIS SET "session:demo_token_u113" "u113" EX 86400
$REDIS SET "session:demo_token_u114" "u114" EX 86400
$REDIS SET "session:demo_token_u115" "u115" EX 86400
$REDIS SET "session:demo_token_u116" "u116" EX 86400
$REDIS SET "session:demo_token_u117" "u117" EX 86400
$REDIS SET "session:demo_token_u118" "u118" EX 86400
$REDIS SET "session:demo_token_u119" "u119" EX 86400
$REDIS SET "session:demo_token_u120" "u120" EX 86400
$REDIS SET "session:demo_token_u121" "u121" EX 86400
$REDIS SET "session:demo_token_u122" "u122" EX 86400
$REDIS SET "session:demo_token_u123" "u123" EX 86400
$REDIS SET "session:demo_token_u124" "u124" EX 86400
$REDIS SET "session:demo_token_u125" "u125" EX 86400
$REDIS SET "session:demo_token_u126" "u126" EX 86400
$REDIS SET "session:demo_token_u127" "u127" EX 86400
$REDIS SET "session:demo_token_u128" "u128" EX 86400
$REDIS SET "session:demo_token_u129" "u129" EX 86400
$REDIS SET "session:demo_token_u130" "u130" EX 86400
$REDIS SET "session:demo_token_u131" "u131" EX 86400
$REDIS SET "session:demo_token_u132" "u132" EX 86400
$REDIS SET "session:demo_token_u133" "u133" EX 86400
$REDIS SET "session:demo_token_u134" "u134" EX 86400
$REDIS SET "session:demo_token_u135" "u135" EX 86400
$REDIS SET "session:demo_token_u136" "u136" EX 86400
$REDIS SET "session:demo_token_u137" "u137" EX 86400
$REDIS SET "session:demo_token_u138" "u138" EX 86400
$REDIS SET "session:demo_token_u139" "u139" EX 86400
$REDIS SET "session:demo_token_u140" "u140" EX 86400
$REDIS SET "session:demo_token_u141" "u141" EX 86400
$REDIS SET "session:demo_token_u142" "u142" EX 86400
$REDIS SET "session:demo_token_u143" "u143" EX 86400
$REDIS SET "session:demo_token_u144" "u144" EX 86400
$REDIS SET "session:demo_token_u145" "u145" EX 86400
$REDIS SET "session:demo_token_u146" "u146" EX 86400
$REDIS SET "session:demo_token_u147" "u147" EX 86400
$REDIS SET "session:demo_token_u148" "u148" EX 86400
$REDIS SET "session:demo_token_u149" "u149" EX 86400
$REDIS SET "session:demo_token_u150" "u150" EX 86400
$REDIS SET "session:demo_token_u151" "u151" EX 86400
$REDIS SET "session:demo_token_u152" "u152" EX 86400
$REDIS SET "session:demo_token_u153" "u153" EX 86400
$REDIS SET "session:demo_token_u154" "u154" EX 86400
$REDIS SET "session:demo_token_u155" "u155" EX 86400
$REDIS SET "session:demo_token_u156" "u156" EX 86400
$REDIS SET "session:demo_token_u157" "u157" EX 86400
$REDIS SET "session:demo_token_u158" "u158" EX 86400
$REDIS SET "session:demo_token_u159" "u159" EX 86400
$REDIS SET "session:demo_token_u160" "u160" EX 86400
$REDIS SET "session:demo_token_u161" "u161" EX 86400
$REDIS SET "session:demo_token_u162" "u162" EX 86400
$REDIS SET "session:demo_token_u163" "u163" EX 86400
$REDIS SET "session:demo_token_u164" "u164" EX 86400
$REDIS SET "session:demo_token_u165" "u165" EX 86400
$REDIS SET "session:demo_token_u166" "u166" EX 86400
$REDIS SET "session:demo_token_u167" "u167" EX 86400
$REDIS SET "session:demo_token_u168" "u168" EX 86400
$REDIS SET "session:demo_token_u169" "u169" EX 86400
$REDIS SET "session:demo_token_u170" "u170" EX 86400
$REDIS SET "session:demo_token_u171" "u171" EX 86400
$REDIS SET "session:demo_token_u172" "u172" EX 86400
$REDIS SET "session:demo_token_u173" "u173" EX 86400
$REDIS SET "session:demo_token_u174" "u174" EX 86400
$REDIS SET "session:demo_token_u175" "u175" EX 86400
$REDIS SET "session:demo_token_u176" "u176" EX 86400
$REDIS SET "session:demo_token_u177" "u177" EX 86400
$REDIS SET "session:demo_token_u178" "u178" EX 86400
$REDIS SET "session:demo_token_u179" "u179" EX 86400
$REDIS SET "session:demo_token_u180" "u180" EX 86400
$REDIS SET "session:demo_token_u181" "u181" EX 86400
$REDIS SET "session:demo_token_u182" "u182" EX 86400
$REDIS SET "session:demo_token_u183" "u183" EX 86400
$REDIS SET "session:demo_token_u184" "u184" EX 86400
$REDIS SET "session:demo_token_u185" "u185" EX 86400
$REDIS SET "session:demo_token_u186" "u186" EX 86400
$REDIS SET "session:demo_token_u187" "u187" EX 86400
$REDIS SET "session:demo_token_u188" "u188" EX 86400
$REDIS SET "session:demo_token_u189" "u189" EX 86400
$REDIS SET "session:demo_token_u190" "u190" EX 86400
$REDIS SET "session:demo_token_u191" "u191" EX 86400
$REDIS SET "session:demo_token_u192" "u192" EX 86400
$REDIS SET "session:demo_token_u193" "u193" EX 86400
$REDIS SET "session:demo_token_u194" "u194" EX 86400
$REDIS SET "session:demo_token_u195" "u195" EX 86400
$REDIS SET "session:demo_token_u196" "u196" EX 86400
$REDIS SET "session:demo_token_u197" "u197" EX 86400
$REDIS SET "session:demo_token_u198" "u198" EX 86400
$REDIS SET "session:demo_token_u199" "u199" EX 86400
$REDIS SET "session:demo_token_u200" "u200" EX 86400
$REDIS SET "session:demo_token_u201" "u201" EX 86400
$REDIS SET "session:demo_token_u202" "u202" EX 86400
$REDIS SET "session:demo_token_u203" "u203" EX 86400
$REDIS SET "session:demo_token_u204" "u204" EX 86400
$REDIS SET "session:demo_token_u205" "u205" EX 86400
$REDIS SET "session:demo_token_u206" "u206" EX 86400
$REDIS SET "session:demo_token_u207" "u207" EX 86400
$REDIS SET "session:demo_token_u208" "u208" EX 86400
$REDIS SET "session:demo_token_u209" "u209" EX 86400
$REDIS SET "session:demo_token_u210" "u210" EX 86400
$REDIS SET "session:demo_token_u211" "u211" EX 86400
$REDIS SET "session:demo_token_u212" "u212" EX 86400
$REDIS SET "session:demo_token_u213" "u213" EX 86400
$REDIS SET "session:demo_token_u214" "u214" EX 86400
$REDIS SET "session:demo_token_u215" "u215" EX 86400
$REDIS SET "session:demo_token_u216" "u216" EX 86400
$REDIS SET "session:demo_token_u217" "u217" EX 86400
$REDIS SET "session:demo_token_u218" "u218" EX 86400
$REDIS SET "session:demo_token_u219" "u219" EX 86400
$REDIS SET "session:demo_token_u220" "u220" EX 86400
$REDIS SET "session:demo_token_u221" "u221" EX 86400
$REDIS SET "session:demo_token_u222" "u222" EX 86400
$REDIS SET "session:demo_token_u223" "u223" EX 86400
$REDIS SET "session:demo_token_u224" "u224" EX 86400
$REDIS SET "session:demo_token_u225" "u225" EX 86400
$REDIS SET "session:demo_token_u226" "u226" EX 86400
$REDIS SET "session:demo_token_u227" "u227" EX 86400
$REDIS SET "session:demo_token_u228" "u228" EX 86400
$REDIS SET "session:demo_token_u229" "u229" EX 86400
$REDIS SET "session:demo_token_u230" "u230" EX 86400
$REDIS SET "session:demo_token_u231" "u231" EX 86400
$REDIS SET "session:demo_token_u232" "u232" EX 86400
$REDIS SET "session:demo_token_u233" "u233" EX 86400
$REDIS SET "session:demo_token_u234" "u234" EX 86400
$REDIS SET "session:demo_token_u235" "u235" EX 86400
$REDIS SET "session:demo_token_u236" "u236" EX 86400
$REDIS SET "session:demo_token_u237" "u237" EX 86400
$REDIS SET "session:demo_token_u238" "u238" EX 86400
$REDIS SET "session:demo_token_u239" "u239" EX 86400
$REDIS SET "session:demo_token_u240" "u240" EX 86400
$REDIS SET "session:demo_token_u241" "u241" EX 86400
$REDIS SET "session:demo_token_u242" "u242" EX 86400
$REDIS SET "session:demo_token_u243" "u243" EX 86400
$REDIS SET "session:demo_token_u244" "u244" EX 86400
$REDIS SET "session:demo_token_u245" "u245" EX 86400
$REDIS SET "session:demo_token_u246" "u246" EX 86400
$REDIS SET "session:demo_token_u247" "u247" EX 86400
$REDIS SET "session:demo_token_u248" "u248" EX 86400
$REDIS SET "session:demo_token_u249" "u249" EX 86400
$REDIS SET "session:demo_token_u250" "u250" EX 86400
$REDIS SET "session:demo_token_u251" "u251" EX 86400
$REDIS SET "session:demo_token_u252" "u252" EX 86400
$REDIS SET "session:demo_token_u253" "u253" EX 86400
$REDIS SET "session:demo_token_u254" "u254" EX 86400
$REDIS SET "session:demo_token_u255" "u255" EX 86400
$REDIS SET "session:demo_token_u256" "u256" EX 86400
$REDIS SET "session:demo_token_u257" "u257" EX 86400
$REDIS SET "session:demo_token_u258" "u258" EX 86400
$REDIS SET "session:demo_token_u259" "u259" EX 86400
$REDIS SET "session:demo_token_u260" "u260" EX 86400
$REDIS SET "session:demo_token_u261" "u261" EX 86400
$REDIS SET "session:demo_token_u262" "u262" EX 86400
$REDIS SET "session:demo_token_u263" "u263" EX 86400
$REDIS SET "session:demo_token_u264" "u264" EX 86400
$REDIS SET "session:demo_token_u265" "u265" EX 86400
$REDIS SET "session:demo_token_u266" "u266" EX 86400
$REDIS SET "session:demo_token_u267" "u267" EX 86400
$REDIS SET "session:demo_token_u268" "u268" EX 86400
$REDIS SET "session:demo_token_u269" "u269" EX 86400
$REDIS SET "session:demo_token_u270" "u270" EX 86400
$REDIS SET "session:demo_token_u271" "u271" EX 86400
$REDIS SET "session:demo_token_u272" "u272" EX 86400
$REDIS SET "session:demo_token_u273" "u273" EX 86400
$REDIS SET "session:demo_token_u274" "u274" EX 86400
$REDIS SET "session:demo_token_u275" "u275" EX 86400
$REDIS SET "session:demo_token_u276" "u276" EX 86400
$REDIS SET "session:demo_token_u277" "u277" EX 86400
$REDIS SET "session:demo_token_u278" "u278" EX 86400
$REDIS SET "session:demo_token_u279" "u279" EX 86400
$REDIS SET "session:demo_token_u280" "u280" EX 86400
$REDIS SET "session:demo_token_u281" "u281" EX 86400
$REDIS SET "session:demo_token_u282" "u282" EX 86400
$REDIS SET "session:demo_token_u283" "u283" EX 86400
$REDIS SET "session:demo_token_u284" "u284" EX 86400
$REDIS SET "session:demo_token_u285" "u285" EX 86400
$REDIS SET "session:demo_token_u286" "u286" EX 86400
$REDIS SET "session:demo_token_u287" "u287" EX 86400
$REDIS SET "session:demo_token_u288" "u288" EX 86400
$REDIS SET "session:demo_token_u289" "u289" EX 86400
$REDIS SET "session:demo_token_u290" "u290" EX 86400
$REDIS SET "session:demo_token_u291" "u291" EX 86400
$REDIS SET "session:demo_token_u292" "u292" EX 86400
$REDIS SET "session:demo_token_u293" "u293" EX 86400
$REDIS SET "session:demo_token_u294" "u294" EX 86400
$REDIS SET "session:demo_token_u295" "u295" EX 86400
$REDIS SET "session:demo_token_u296" "u296" EX 86400
$REDIS SET "session:demo_token_u297" "u297" EX 86400
$REDIS SET "session:demo_token_u298" "u298" EX 86400
$REDIS SET "session:demo_token_u299" "u299" EX 86400
$REDIS SET "session:demo_token_u300" "u300" EX 86400
$REDIS SET "session:demo_token_u301" "u301" EX 86400
$REDIS SET "session:demo_token_u302" "u302" EX 86400
$REDIS SET "session:demo_token_u303" "u303" EX 86400
$REDIS SET "session:demo_token_u304" "u304" EX 86400
$REDIS SET "session:demo_token_u305" "u305" EX 86400
$REDIS SET "session:demo_token_u306" "u306" EX 86400
$REDIS SET "session:demo_token_u307" "u307" EX 86400
$REDIS SET "session:demo_token_u308" "u308" EX 86400
$REDIS SET "session:demo_token_u309" "u309" EX 86400
$REDIS SET "session:demo_token_u310" "u310" EX 86400
$REDIS SET "session:demo_token_u311" "u311" EX 86400
$REDIS SET "session:demo_token_u312" "u312" EX 86400
$REDIS SET "session:demo_token_u313" "u313" EX 86400
$REDIS SET "session:demo_token_u314" "u314" EX 86400
$REDIS SET "session:demo_token_u315" "u315" EX 86400
$REDIS SET "session:demo_token_u316" "u316" EX 86400
$REDIS SET "session:demo_token_u317" "u317" EX 86400
$REDIS SET "session:demo_token_u318" "u318" EX 86400
$REDIS SET "session:demo_token_u319" "u319" EX 86400
$REDIS SET "session:demo_token_u320" "u320" EX 86400
$REDIS SET "session:demo_token_u321" "u321" EX 86400
$REDIS SET "session:demo_token_u322" "u322" EX 86400
$REDIS SET "session:demo_token_u323" "u323" EX 86400
$REDIS SET "session:demo_token_u324" "u324" EX 86400
$REDIS SET "session:demo_token_u325" "u325" EX 86400
$REDIS SET "session:demo_token_u326" "u326" EX 86400
$REDIS SET "session:demo_token_u327" "u327" EX 86400
$REDIS SET "session:demo_token_u328" "u328" EX 86400
$REDIS SET "session:demo_token_u329" "u329" EX 86400
$REDIS SET "session:demo_token_u330" "u330" EX 86400
$REDIS SET "session:demo_token_u331" "u331" EX 86400
$REDIS SET "session:demo_token_u332" "u332" EX 86400
$REDIS SET "session:demo_token_u333" "u333" EX 86400
$REDIS SET "session:demo_token_u334" "u334" EX 86400
$REDIS SET "session:demo_token_u335" "u335" EX 86400
$REDIS SET "session:demo_token_u336" "u336" EX 86400
$REDIS SET "session:demo_token_u337" "u337" EX 86400
$REDIS SET "session:demo_token_u338" "u338" EX 86400
$REDIS SET "session:demo_token_u339" "u339" EX 86400
$REDIS SET "session:demo_token_u340" "u340" EX 86400
$REDIS SET "session:demo_token_u341" "u341" EX 86400
$REDIS SET "session:demo_token_u342" "u342" EX 86400
$REDIS SET "session:demo_token_u343" "u343" EX 86400
$REDIS SET "session:demo_token_u344" "u344" EX 86400
$REDIS SET "session:demo_token_u345" "u345" EX 86400
$REDIS SET "session:demo_token_u346" "u346" EX 86400
$REDIS SET "session:demo_token_u347" "u347" EX 86400
$REDIS SET "session:demo_token_u348" "u348" EX 86400
$REDIS SET "session:demo_token_u349" "u349" EX 86400
$REDIS SET "session:demo_token_u350" "u350" EX 86400
$REDIS SET "session:demo_token_u351" "u351" EX 86400
$REDIS SET "session:demo_token_u352" "u352" EX 86400
$REDIS SET "session:demo_token_u353" "u353" EX 86400
$REDIS SET "session:demo_token_u354" "u354" EX 86400
$REDIS SET "session:demo_token_u355" "u355" EX 86400
$REDIS SET "session:demo_token_u356" "u356" EX 86400
$REDIS SET "session:demo_token_u357" "u357" EX 86400
$REDIS SET "session:demo_token_u358" "u358" EX 86400
$REDIS SET "session:demo_token_u359" "u359" EX 86400
$REDIS SET "session:demo_token_u360" "u360" EX 86400
$REDIS SET "session:demo_token_u361" "u361" EX 86400
$REDIS SET "session:demo_token_u362" "u362" EX 86400
$REDIS SET "session:demo_token_u363" "u363" EX 86400
$REDIS SET "session:demo_token_u364" "u364" EX 86400
$REDIS SET "session:demo_token_u365" "u365" EX 86400
$REDIS SET "session:demo_token_u366" "u366" EX 86400
$REDIS SET "session:demo_token_u367" "u367" EX 86400
$REDIS SET "session:demo_token_u368" "u368" EX 86400
$REDIS SET "session:demo_token_u369" "u369" EX 86400
$REDIS SET "session:demo_token_u370" "u370" EX 86400
$REDIS SET "session:demo_token_u371" "u371" EX 86400
$REDIS SET "session:demo_token_u372" "u372" EX 86400
$REDIS SET "session:demo_token_u373" "u373" EX 86400
$REDIS SET "session:demo_token_u374" "u374" EX 86400
$REDIS SET "session:demo_token_u375" "u375" EX 86400
$REDIS SET "session:demo_token_u376" "u376" EX 86400
$REDIS SET "session:demo_token_u377" "u377" EX 86400
$REDIS SET "session:demo_token_u378" "u378" EX 86400
$REDIS SET "session:demo_token_u379" "u379" EX 86400
$REDIS SET "session:demo_token_u380" "u380" EX 86400
$REDIS SET "session:demo_token_u381" "u381" EX 86400
$REDIS SET "session:demo_token_u382" "u382" EX 86400
$REDIS SET "session:demo_token_u383" "u383" EX 86400
$REDIS SET "session:demo_token_u384" "u384" EX 86400
$REDIS SET "session:demo_token_u385" "u385" EX 86400
$REDIS SET "session:demo_token_u386" "u386" EX 86400
$REDIS SET "session:demo_token_u387" "u387" EX 86400
$REDIS SET "session:demo_token_u388" "u388" EX 86400
$REDIS SET "session:demo_token_u389" "u389" EX 86400
$REDIS SET "session:demo_token_u390" "u390" EX 86400
$REDIS SET "session:demo_token_u391" "u391" EX 86400
$REDIS SET "session:demo_token_u392" "u392" EX 86400
$REDIS SET "session:demo_token_u393" "u393" EX 86400
$REDIS SET "session:demo_token_u394" "u394" EX 86400
$REDIS SET "session:demo_token_u395" "u395" EX 86400
$REDIS SET "session:demo_token_u396" "u396" EX 86400
$REDIS SET "session:demo_token_u397" "u397" EX 86400
$REDIS SET "session:demo_token_u398" "u398" EX 86400
$REDIS SET "session:demo_token_u399" "u399" EX 86400
$REDIS SET "session:demo_token_u400" "u400" EX 86400
$REDIS SET "session:demo_token_u401" "u401" EX 86400
$REDIS SET "session:demo_token_u402" "u402" EX 86400
$REDIS SET "session:demo_token_u403" "u403" EX 86400
$REDIS SET "session:demo_token_u404" "u404" EX 86400
$REDIS SET "session:demo_token_u405" "u405" EX 86400
$REDIS SET "session:demo_token_u406" "u406" EX 86400
$REDIS SET "session:demo_token_u407" "u407" EX 86400
$REDIS SET "session:demo_token_u408" "u408" EX 86400
$REDIS SET "session:demo_token_u409" "u409" EX 86400
$REDIS SET "session:demo_token_u410" "u410" EX 86400
$REDIS SET "session:demo_token_u411" "u411" EX 86400
$REDIS SET "session:demo_token_u412" "u412" EX 86400
$REDIS SET "session:demo_token_u413" "u413" EX 86400
$REDIS SET "session:demo_token_u414" "u414" EX 86400
$REDIS SET "session:demo_token_u415" "u415" EX 86400
$REDIS SET "session:demo_token_u416" "u416" EX 86400
$REDIS SET "session:demo_token_u417" "u417" EX 86400
$REDIS SET "session:demo_token_u418" "u418" EX 86400
$REDIS SET "session:demo_token_u419" "u419" EX 86400
$REDIS SET "session:demo_token_u420" "u420" EX 86400
$REDIS SET "session:demo_token_u421" "u421" EX 86400
$REDIS SET "session:demo_token_u422" "u422" EX 86400
$REDIS SET "session:demo_token_u423" "u423" EX 86400
$REDIS SET "session:demo_token_u424" "u424" EX 86400
$REDIS SET "session:demo_token_u425" "u425" EX 86400
$REDIS SET "session:demo_token_u426" "u426" EX 86400
$REDIS SET "session:demo_token_u427" "u427" EX 86400
$REDIS SET "session:demo_token_u428" "u428" EX 86400
$REDIS SET "session:demo_token_u429" "u429" EX 86400
$REDIS SET "session:demo_token_u430" "u430" EX 86400
$REDIS SET "session:demo_token_u431" "u431" EX 86400
$REDIS SET "session:demo_token_u432" "u432" EX 86400
$REDIS SET "session:demo_token_u433" "u433" EX 86400
$REDIS SET "session:demo_token_u434" "u434" EX 86400
$REDIS SET "session:demo_token_u435" "u435" EX 86400
$REDIS SET "session:demo_token_u436" "u436" EX 86400
$REDIS SET "session:demo_token_u437" "u437" EX 86400
$REDIS SET "session:demo_token_u438" "u438" EX 86400
$REDIS SET "session:demo_token_u439" "u439" EX 86400
$REDIS SET "session:demo_token_u440" "u440" EX 86400
$REDIS SET "session:demo_token_u441" "u441" EX 86400
$REDIS SET "session:demo_token_u442" "u442" EX 86400
$REDIS SET "session:demo_token_u443" "u443" EX 86400
$REDIS SET "session:demo_token_u444" "u444" EX 86400
$REDIS SET "session:demo_token_u445" "u445" EX 86400
$REDIS SET "session:demo_token_u446" "u446" EX 86400
$REDIS SET "session:demo_token_u447" "u447" EX 86400
$REDIS SET "session:demo_token_u448" "u448" EX 86400
$REDIS SET "session:demo_token_u449" "u449" EX 86400
$REDIS SET "session:demo_token_u450" "u450" EX 86400
$REDIS SET "session:demo_token_u451" "u451" EX 86400
$REDIS SET "session:demo_token_u452" "u452" EX 86400
$REDIS SET "session:demo_token_u453" "u453" EX 86400
$REDIS SET "session:demo_token_u454" "u454" EX 86400
$REDIS SET "session:demo_token_u455" "u455" EX 86400
$REDIS SET "session:demo_token_u456" "u456" EX 86400
$REDIS SET "session:demo_token_u457" "u457" EX 86400
$REDIS SET "session:demo_token_u458" "u458" EX 86400
$REDIS SET "session:demo_token_u459" "u459" EX 86400
$REDIS SET "session:demo_token_u460" "u460" EX 86400
$REDIS SET "session:demo_token_u461" "u461" EX 86400
$REDIS SET "session:demo_token_u462" "u462" EX 86400
$REDIS SET "session:demo_token_u463" "u463" EX 86400
$REDIS SET "session:demo_token_u464" "u464" EX 86400
$REDIS SET "session:demo_token_u465" "u465" EX 86400
$REDIS SET "session:demo_token_u466" "u466" EX 86400
$REDIS SET "session:demo_token_u467" "u467" EX 86400
$REDIS SET "session:demo_token_u468" "u468" EX 86400
$REDIS SET "session:demo_token_u469" "u469" EX 86400
$REDIS SET "session:demo_token_u470" "u470" EX 86400
$REDIS SET "session:demo_token_u471" "u471" EX 86400
$REDIS SET "session:demo_token_u472" "u472" EX 86400
$REDIS SET "session:demo_token_u473" "u473" EX 86400
$REDIS SET "session:demo_token_u474" "u474" EX 86400
$REDIS SET "session:demo_token_u475" "u475" EX 86400
$REDIS SET "session:demo_token_u476" "u476" EX 86400
$REDIS SET "session:demo_token_u477" "u477" EX 86400
$REDIS SET "session:demo_token_u478" "u478" EX 86400
$REDIS SET "session:demo_token_u479" "u479" EX 86400
$REDIS SET "session:demo_token_u480" "u480" EX 86400
$REDIS SET "session:demo_token_u481" "u481" EX 86400
$REDIS SET "session:demo_token_u482" "u482" EX 86400
$REDIS SET "session:demo_token_u483" "u483" EX 86400
$REDIS SET "session:demo_token_u484" "u484" EX 86400
$REDIS SET "session:demo_token_u485" "u485" EX 86400
$REDIS SET "session:demo_token_u486" "u486" EX 86400
$REDIS SET "session:demo_token_u487" "u487" EX 86400
$REDIS SET "session:demo_token_u488" "u488" EX 86400
$REDIS SET "session:demo_token_u489" "u489" EX 86400
$REDIS SET "session:demo_token_u490" "u490" EX 86400
$REDIS SET "session:demo_token_u491" "u491" EX 86400
$REDIS SET "session:demo_token_u492" "u492" EX 86400
$REDIS SET "session:demo_token_u493" "u493" EX 86400
$REDIS SET "session:demo_token_u494" "u494" EX 86400
$REDIS SET "session:demo_token_u495" "u495" EX 86400
$REDIS SET "session:demo_token_u496" "u496" EX 86400
$REDIS SET "session:demo_token_u497" "u497" EX 86400
$REDIS SET "session:demo_token_u498" "u498" EX 86400
$REDIS SET "session:demo_token_u499" "u499" EX 86400
$REDIS SET "session:demo_token_u500" "u500" EX 86400

# Notificaciones pendientes de muestra
$REDIS LPUSH "notification:u1:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mandarine","venue_id":"4"}'
$REDIS EXPIRE "notification:u1:pending" 7200
$REDIS LPUSH "notification:u2:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Kika","venue_id":"7"}'
$REDIS EXPIRE "notification:u2:pending" 7200
$REDIS LPUSH "notification:u3:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Bahrein","venue_id":"10"}'
$REDIS EXPIRE "notification:u3:pending" 7200
$REDIS LPUSH "notification:u4:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rio Electronic","venue_id":"13"}'
$REDIS EXPIRE "notification:u4:pending" 7200
$REDIS LPUSH "notification:u5:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Arenas","venue_id":"16"}'
$REDIS EXPIRE "notification:u5:pending" 7200
$REDIS LPUSH "notification:u6:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Aura","venue_id":"19"}'
$REDIS EXPIRE "notification:u6:pending" 7200
$REDIS LPUSH "notification:u7:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de VÃ©rtigo","venue_id":"22"}'
$REDIS EXPIRE "notification:u7:pending" 7200
$REDIS LPUSH "notification:u8:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lumen","venue_id":"25"}'
$REDIS EXPIRE "notification:u8:pending" 7200
$REDIS LPUSH "notification:u9:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Fahrenheit","venue_id":"28"}'
$REDIS EXPIRE "notification:u9:pending" 7200
$REDIS LPUSH "notification:u10:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Empire","venue_id":"31"}'
$REDIS EXPIRE "notification:u10:pending" 7200
$REDIS LPUSH "notification:u11:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Oasis","venue_id":"34"}'
$REDIS EXPIRE "notification:u11:pending" 7200
$REDIS LPUSH "notification:u12:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Titan","venue_id":"37"}'
$REDIS EXPIRE "notification:u12:pending" 7200
$REDIS LPUSH "notification:u13:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lounge X","venue_id":"40"}'
$REDIS EXPIRE "notification:u13:pending" 7200
$REDIS LPUSH "notification:u14:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Code","venue_id":"43"}'
$REDIS EXPIRE "notification:u14:pending" 7200
$REDIS LPUSH "notification:u15:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Solar","venue_id":"46"}'
$REDIS EXPIRE "notification:u15:pending" 7200
$REDIS LPUSH "notification:u16:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Atomic","venue_id":"49"}'
$REDIS EXPIRE "notification:u16:pending" 7200
$REDIS LPUSH "notification:u17:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Jet","venue_id":"2"}'
$REDIS EXPIRE "notification:u17:pending" 7200
$REDIS LPUSH "notification:u18:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pacha","venue_id":"5"}'
$REDIS EXPIRE "notification:u18:pending" 7200
$REDIS LPUSH "notification:u19:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de BNN","venue_id":"8"}'
$REDIS EXPIRE "notification:u19:pending" 7200
$REDIS LPUSH "notification:u20:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Niceto Club","venue_id":"11"}'
$REDIS EXPIRE "notification:u20:pending" 7200
$REDIS LPUSH "notification:u21:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Malia","venue_id":"14"}'
$REDIS EXPIRE "notification:u21:pending" 7200
$REDIS LPUSH "notification:u22:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Cluster","venue_id":"17"}'
$REDIS EXPIRE "notification:u22:pending" 7200
$REDIS LPUSH "notification:u23:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Monaco","venue_id":"20"}'
$REDIS EXPIRE "notification:u23:pending" 7200
$REDIS LPUSH "notification:u24:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Distrito","venue_id":"23"}'
$REDIS EXPIRE "notification:u24:pending" 7200
$REDIS LPUSH "notification:u25:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Skyline","venue_id":"26"}'
$REDIS EXPIRE "notification:u25:pending" 7200
$REDIS LPUSH "notification:u26:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pulse","venue_id":"29"}'
$REDIS EXPIRE "notification:u26:pending" 7200
$REDIS LPUSH "notification:u27:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Zenith","venue_id":"32"}'
$REDIS EXPIRE "notification:u27:pending" 7200
$REDIS LPUSH "notification:u28:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nova","venue_id":"35"}'
$REDIS EXPIRE "notification:u28:pending" 7200
$REDIS LPUSH "notification:u29:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Metropolis","venue_id":"38"}'
$REDIS EXPIRE "notification:u29:pending" 7200
$REDIS LPUSH "notification:u30:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Velvet","venue_id":"41"}'
$REDIS EXPIRE "notification:u30:pending" 7200
$REDIS LPUSH "notification:u31:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Temple","venue_id":"44"}'
$REDIS EXPIRE "notification:u31:pending" 7200
$REDIS LPUSH "notification:u32:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Myst","venue_id":"47"}'
$REDIS EXPIRE "notification:u32:pending" 7200
$REDIS LPUSH "notification:u33:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mirage","venue_id":"50"}'
$REDIS EXPIRE "notification:u33:pending" 7200
$REDIS LPUSH "notification:u34:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Ink","venue_id":"3"}'
$REDIS EXPIRE "notification:u34:pending" 7200
$REDIS LPUSH "notification:u35:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rosebar","venue_id":"6"}'
$REDIS EXPIRE "notification:u35:pending" 7200
$REDIS LPUSH "notification:u36:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Museum","venue_id":"9"}'
$REDIS EXPIRE "notification:u36:pending" 7200
$REDIS LPUSH "notification:u37:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Input","venue_id":"12"}'
$REDIS EXPIRE "notification:u37:pending" 7200
$REDIS LPUSH "notification:u38:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Dorsia","venue_id":"15"}'
$REDIS EXPIRE "notification:u38:pending" 7200
$REDIS LPUSH "notification:u39:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Prisma","venue_id":"18"}'
$REDIS EXPIRE "notification:u39:pending" 7200
$REDIS LPUSH "notification:u40:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Blackroom","venue_id":"21"}'
$REDIS EXPIRE "notification:u40:pending" 7200
$REDIS LPUSH "notification:u41:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Celsius","venue_id":"24"}'
$REDIS EXPIRE "notification:u41:pending" 7200
$REDIS LPUSH "notification:u42:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Vox","venue_id":"27"}'
$REDIS EXPIRE "notification:u42:pending" 7200
$REDIS LPUSH "notification:u43:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nebula","venue_id":"30"}'
$REDIS EXPIRE "notification:u43:pending" 7200
$REDIS LPUSH "notification:u44:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Moscow","venue_id":"33"}'
$REDIS EXPIRE "notification:u44:pending" 7200
$REDIS LPUSH "notification:u45:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mamba","venue_id":"36"}'
$REDIS EXPIRE "notification:u45:pending" 7200
$REDIS LPUSH "notification:u46:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Eclipse","venue_id":"39"}'
$REDIS EXPIRE "notification:u46:pending" 7200
$REDIS LPUSH "notification:u47:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Satori","venue_id":"42"}'
$REDIS EXPIRE "notification:u47:pending" 7200
$REDIS LPUSH "notification:u48:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nox","venue_id":"45"}'
$REDIS EXPIRE "notification:u48:pending" 7200
$REDIS LPUSH "notification:u49:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Replay","venue_id":"48"}'
$REDIS EXPIRE "notification:u49:pending" 7200
$REDIS LPUSH "notification:u50:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Crobar","venue_id":"1"}'
$REDIS EXPIRE "notification:u50:pending" 7200
$REDIS LPUSH "notification:u51:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mandarine","venue_id":"4"}'
$REDIS EXPIRE "notification:u51:pending" 7200
$REDIS LPUSH "notification:u52:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Kika","venue_id":"7"}'
$REDIS EXPIRE "notification:u52:pending" 7200
$REDIS LPUSH "notification:u53:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Bahrein","venue_id":"10"}'
$REDIS EXPIRE "notification:u53:pending" 7200
$REDIS LPUSH "notification:u54:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rio Electronic","venue_id":"13"}'
$REDIS EXPIRE "notification:u54:pending" 7200
$REDIS LPUSH "notification:u55:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Arenas","venue_id":"16"}'
$REDIS EXPIRE "notification:u55:pending" 7200
$REDIS LPUSH "notification:u56:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Aura","venue_id":"19"}'
$REDIS EXPIRE "notification:u56:pending" 7200
$REDIS LPUSH "notification:u57:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de VÃ©rtigo","venue_id":"22"}'
$REDIS EXPIRE "notification:u57:pending" 7200
$REDIS LPUSH "notification:u58:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lumen","venue_id":"25"}'
$REDIS EXPIRE "notification:u58:pending" 7200
$REDIS LPUSH "notification:u59:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Fahrenheit","venue_id":"28"}'
$REDIS EXPIRE "notification:u59:pending" 7200
$REDIS LPUSH "notification:u60:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Empire","venue_id":"31"}'
$REDIS EXPIRE "notification:u60:pending" 7200
$REDIS LPUSH "notification:u61:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Oasis","venue_id":"34"}'
$REDIS EXPIRE "notification:u61:pending" 7200
$REDIS LPUSH "notification:u62:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Titan","venue_id":"37"}'
$REDIS EXPIRE "notification:u62:pending" 7200
$REDIS LPUSH "notification:u63:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lounge X","venue_id":"40"}'
$REDIS EXPIRE "notification:u63:pending" 7200
$REDIS LPUSH "notification:u64:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Code","venue_id":"43"}'
$REDIS EXPIRE "notification:u64:pending" 7200
$REDIS LPUSH "notification:u65:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Solar","venue_id":"46"}'
$REDIS EXPIRE "notification:u65:pending" 7200
$REDIS LPUSH "notification:u66:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Atomic","venue_id":"49"}'
$REDIS EXPIRE "notification:u66:pending" 7200
$REDIS LPUSH "notification:u67:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Jet","venue_id":"2"}'
$REDIS EXPIRE "notification:u67:pending" 7200
$REDIS LPUSH "notification:u68:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pacha","venue_id":"5"}'
$REDIS EXPIRE "notification:u68:pending" 7200
$REDIS LPUSH "notification:u69:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de BNN","venue_id":"8"}'
$REDIS EXPIRE "notification:u69:pending" 7200
$REDIS LPUSH "notification:u70:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Niceto Club","venue_id":"11"}'
$REDIS EXPIRE "notification:u70:pending" 7200
$REDIS LPUSH "notification:u71:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Malia","venue_id":"14"}'
$REDIS EXPIRE "notification:u71:pending" 7200
$REDIS LPUSH "notification:u72:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Cluster","venue_id":"17"}'
$REDIS EXPIRE "notification:u72:pending" 7200
$REDIS LPUSH "notification:u73:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Monaco","venue_id":"20"}'
$REDIS EXPIRE "notification:u73:pending" 7200
$REDIS LPUSH "notification:u74:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Distrito","venue_id":"23"}'
$REDIS EXPIRE "notification:u74:pending" 7200
$REDIS LPUSH "notification:u75:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Skyline","venue_id":"26"}'
$REDIS EXPIRE "notification:u75:pending" 7200
$REDIS LPUSH "notification:u76:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pulse","venue_id":"29"}'
$REDIS EXPIRE "notification:u76:pending" 7200
$REDIS LPUSH "notification:u77:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Zenith","venue_id":"32"}'
$REDIS EXPIRE "notification:u77:pending" 7200
$REDIS LPUSH "notification:u78:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nova","venue_id":"35"}'
$REDIS EXPIRE "notification:u78:pending" 7200
$REDIS LPUSH "notification:u79:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Metropolis","venue_id":"38"}'
$REDIS EXPIRE "notification:u79:pending" 7200
$REDIS LPUSH "notification:u80:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Velvet","venue_id":"41"}'
$REDIS EXPIRE "notification:u80:pending" 7200
$REDIS LPUSH "notification:u81:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Temple","venue_id":"44"}'
$REDIS EXPIRE "notification:u81:pending" 7200
$REDIS LPUSH "notification:u82:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Myst","venue_id":"47"}'
$REDIS EXPIRE "notification:u82:pending" 7200
$REDIS LPUSH "notification:u83:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mirage","venue_id":"50"}'
$REDIS EXPIRE "notification:u83:pending" 7200
$REDIS LPUSH "notification:u84:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Ink","venue_id":"3"}'
$REDIS EXPIRE "notification:u84:pending" 7200
$REDIS LPUSH "notification:u85:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rosebar","venue_id":"6"}'
$REDIS EXPIRE "notification:u85:pending" 7200
$REDIS LPUSH "notification:u86:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Museum","venue_id":"9"}'
$REDIS EXPIRE "notification:u86:pending" 7200
$REDIS LPUSH "notification:u87:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Input","venue_id":"12"}'
$REDIS EXPIRE "notification:u87:pending" 7200
$REDIS LPUSH "notification:u88:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Dorsia","venue_id":"15"}'
$REDIS EXPIRE "notification:u88:pending" 7200
$REDIS LPUSH "notification:u89:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Prisma","venue_id":"18"}'
$REDIS EXPIRE "notification:u89:pending" 7200
$REDIS LPUSH "notification:u90:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Blackroom","venue_id":"21"}'
$REDIS EXPIRE "notification:u90:pending" 7200
$REDIS LPUSH "notification:u91:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Celsius","venue_id":"24"}'
$REDIS EXPIRE "notification:u91:pending" 7200
$REDIS LPUSH "notification:u92:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Vox","venue_id":"27"}'
$REDIS EXPIRE "notification:u92:pending" 7200
$REDIS LPUSH "notification:u93:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nebula","venue_id":"30"}'
$REDIS EXPIRE "notification:u93:pending" 7200
$REDIS LPUSH "notification:u94:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Moscow","venue_id":"33"}'
$REDIS EXPIRE "notification:u94:pending" 7200
$REDIS LPUSH "notification:u95:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mamba","venue_id":"36"}'
$REDIS EXPIRE "notification:u95:pending" 7200
$REDIS LPUSH "notification:u96:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Eclipse","venue_id":"39"}'
$REDIS EXPIRE "notification:u96:pending" 7200
$REDIS LPUSH "notification:u97:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Satori","venue_id":"42"}'
$REDIS EXPIRE "notification:u97:pending" 7200
$REDIS LPUSH "notification:u98:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nox","venue_id":"45"}'
$REDIS EXPIRE "notification:u98:pending" 7200
$REDIS LPUSH "notification:u99:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Replay","venue_id":"48"}'
$REDIS EXPIRE "notification:u99:pending" 7200
$REDIS LPUSH "notification:u100:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Crobar","venue_id":"1"}'
$REDIS EXPIRE "notification:u100:pending" 7200
$REDIS LPUSH "notification:u101:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mandarine","venue_id":"4"}'
$REDIS EXPIRE "notification:u101:pending" 7200
$REDIS LPUSH "notification:u102:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Kika","venue_id":"7"}'
$REDIS EXPIRE "notification:u102:pending" 7200
$REDIS LPUSH "notification:u103:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Bahrein","venue_id":"10"}'
$REDIS EXPIRE "notification:u103:pending" 7200
$REDIS LPUSH "notification:u104:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rio Electronic","venue_id":"13"}'
$REDIS EXPIRE "notification:u104:pending" 7200
$REDIS LPUSH "notification:u105:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Arenas","venue_id":"16"}'
$REDIS EXPIRE "notification:u105:pending" 7200
$REDIS LPUSH "notification:u106:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Aura","venue_id":"19"}'
$REDIS EXPIRE "notification:u106:pending" 7200
$REDIS LPUSH "notification:u107:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de VÃ©rtigo","venue_id":"22"}'
$REDIS EXPIRE "notification:u107:pending" 7200
$REDIS LPUSH "notification:u108:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lumen","venue_id":"25"}'
$REDIS EXPIRE "notification:u108:pending" 7200
$REDIS LPUSH "notification:u109:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Fahrenheit","venue_id":"28"}'
$REDIS EXPIRE "notification:u109:pending" 7200
$REDIS LPUSH "notification:u110:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Empire","venue_id":"31"}'
$REDIS EXPIRE "notification:u110:pending" 7200
$REDIS LPUSH "notification:u111:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Oasis","venue_id":"34"}'
$REDIS EXPIRE "notification:u111:pending" 7200
$REDIS LPUSH "notification:u112:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Titan","venue_id":"37"}'
$REDIS EXPIRE "notification:u112:pending" 7200
$REDIS LPUSH "notification:u113:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lounge X","venue_id":"40"}'
$REDIS EXPIRE "notification:u113:pending" 7200
$REDIS LPUSH "notification:u114:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Code","venue_id":"43"}'
$REDIS EXPIRE "notification:u114:pending" 7200
$REDIS LPUSH "notification:u115:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Solar","venue_id":"46"}'
$REDIS EXPIRE "notification:u115:pending" 7200
$REDIS LPUSH "notification:u116:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Atomic","venue_id":"49"}'
$REDIS EXPIRE "notification:u116:pending" 7200
$REDIS LPUSH "notification:u117:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Jet","venue_id":"2"}'
$REDIS EXPIRE "notification:u117:pending" 7200
$REDIS LPUSH "notification:u118:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pacha","venue_id":"5"}'
$REDIS EXPIRE "notification:u118:pending" 7200
$REDIS LPUSH "notification:u119:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de BNN","venue_id":"8"}'
$REDIS EXPIRE "notification:u119:pending" 7200
$REDIS LPUSH "notification:u120:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Niceto Club","venue_id":"11"}'
$REDIS EXPIRE "notification:u120:pending" 7200
$REDIS LPUSH "notification:u121:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Malia","venue_id":"14"}'
$REDIS EXPIRE "notification:u121:pending" 7200
$REDIS LPUSH "notification:u122:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Cluster","venue_id":"17"}'
$REDIS EXPIRE "notification:u122:pending" 7200
$REDIS LPUSH "notification:u123:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Monaco","venue_id":"20"}'
$REDIS EXPIRE "notification:u123:pending" 7200
$REDIS LPUSH "notification:u124:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Distrito","venue_id":"23"}'
$REDIS EXPIRE "notification:u124:pending" 7200
$REDIS LPUSH "notification:u125:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Skyline","venue_id":"26"}'
$REDIS EXPIRE "notification:u125:pending" 7200
$REDIS LPUSH "notification:u126:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pulse","venue_id":"29"}'
$REDIS EXPIRE "notification:u126:pending" 7200
$REDIS LPUSH "notification:u127:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Zenith","venue_id":"32"}'
$REDIS EXPIRE "notification:u127:pending" 7200
$REDIS LPUSH "notification:u128:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nova","venue_id":"35"}'
$REDIS EXPIRE "notification:u128:pending" 7200
$REDIS LPUSH "notification:u129:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Metropolis","venue_id":"38"}'
$REDIS EXPIRE "notification:u129:pending" 7200
$REDIS LPUSH "notification:u130:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Velvet","venue_id":"41"}'
$REDIS EXPIRE "notification:u130:pending" 7200
$REDIS LPUSH "notification:u131:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Temple","venue_id":"44"}'
$REDIS EXPIRE "notification:u131:pending" 7200
$REDIS LPUSH "notification:u132:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Myst","venue_id":"47"}'
$REDIS EXPIRE "notification:u132:pending" 7200
$REDIS LPUSH "notification:u133:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mirage","venue_id":"50"}'
$REDIS EXPIRE "notification:u133:pending" 7200
$REDIS LPUSH "notification:u134:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Ink","venue_id":"3"}'
$REDIS EXPIRE "notification:u134:pending" 7200
$REDIS LPUSH "notification:u135:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rosebar","venue_id":"6"}'
$REDIS EXPIRE "notification:u135:pending" 7200
$REDIS LPUSH "notification:u136:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Museum","venue_id":"9"}'
$REDIS EXPIRE "notification:u136:pending" 7200
$REDIS LPUSH "notification:u137:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Input","venue_id":"12"}'
$REDIS EXPIRE "notification:u137:pending" 7200
$REDIS LPUSH "notification:u138:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Dorsia","venue_id":"15"}'
$REDIS EXPIRE "notification:u138:pending" 7200
$REDIS LPUSH "notification:u139:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Prisma","venue_id":"18"}'
$REDIS EXPIRE "notification:u139:pending" 7200
$REDIS LPUSH "notification:u140:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Blackroom","venue_id":"21"}'
$REDIS EXPIRE "notification:u140:pending" 7200
$REDIS LPUSH "notification:u141:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Celsius","venue_id":"24"}'
$REDIS EXPIRE "notification:u141:pending" 7200
$REDIS LPUSH "notification:u142:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Vox","venue_id":"27"}'
$REDIS EXPIRE "notification:u142:pending" 7200
$REDIS LPUSH "notification:u143:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nebula","venue_id":"30"}'
$REDIS EXPIRE "notification:u143:pending" 7200
$REDIS LPUSH "notification:u144:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Moscow","venue_id":"33"}'
$REDIS EXPIRE "notification:u144:pending" 7200
$REDIS LPUSH "notification:u145:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mamba","venue_id":"36"}'
$REDIS EXPIRE "notification:u145:pending" 7200
$REDIS LPUSH "notification:u146:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Eclipse","venue_id":"39"}'
$REDIS EXPIRE "notification:u146:pending" 7200
$REDIS LPUSH "notification:u147:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Satori","venue_id":"42"}'
$REDIS EXPIRE "notification:u147:pending" 7200
$REDIS LPUSH "notification:u148:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nox","venue_id":"45"}'
$REDIS EXPIRE "notification:u148:pending" 7200
$REDIS LPUSH "notification:u149:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Replay","venue_id":"48"}'
$REDIS EXPIRE "notification:u149:pending" 7200
$REDIS LPUSH "notification:u150:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Crobar","venue_id":"1"}'
$REDIS EXPIRE "notification:u150:pending" 7200
$REDIS LPUSH "notification:u151:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mandarine","venue_id":"4"}'
$REDIS EXPIRE "notification:u151:pending" 7200
$REDIS LPUSH "notification:u152:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Kika","venue_id":"7"}'
$REDIS EXPIRE "notification:u152:pending" 7200
$REDIS LPUSH "notification:u153:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Bahrein","venue_id":"10"}'
$REDIS EXPIRE "notification:u153:pending" 7200
$REDIS LPUSH "notification:u154:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rio Electronic","venue_id":"13"}'
$REDIS EXPIRE "notification:u154:pending" 7200
$REDIS LPUSH "notification:u155:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Arenas","venue_id":"16"}'
$REDIS EXPIRE "notification:u155:pending" 7200
$REDIS LPUSH "notification:u156:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Aura","venue_id":"19"}'
$REDIS EXPIRE "notification:u156:pending" 7200
$REDIS LPUSH "notification:u157:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de VÃ©rtigo","venue_id":"22"}'
$REDIS EXPIRE "notification:u157:pending" 7200
$REDIS LPUSH "notification:u158:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lumen","venue_id":"25"}'
$REDIS EXPIRE "notification:u158:pending" 7200
$REDIS LPUSH "notification:u159:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Fahrenheit","venue_id":"28"}'
$REDIS EXPIRE "notification:u159:pending" 7200
$REDIS LPUSH "notification:u160:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Empire","venue_id":"31"}'
$REDIS EXPIRE "notification:u160:pending" 7200
$REDIS LPUSH "notification:u161:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Oasis","venue_id":"34"}'
$REDIS EXPIRE "notification:u161:pending" 7200
$REDIS LPUSH "notification:u162:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Titan","venue_id":"37"}'
$REDIS EXPIRE "notification:u162:pending" 7200
$REDIS LPUSH "notification:u163:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lounge X","venue_id":"40"}'
$REDIS EXPIRE "notification:u163:pending" 7200
$REDIS LPUSH "notification:u164:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Code","venue_id":"43"}'
$REDIS EXPIRE "notification:u164:pending" 7200
$REDIS LPUSH "notification:u165:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Solar","venue_id":"46"}'
$REDIS EXPIRE "notification:u165:pending" 7200
$REDIS LPUSH "notification:u166:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Atomic","venue_id":"49"}'
$REDIS EXPIRE "notification:u166:pending" 7200
$REDIS LPUSH "notification:u167:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Jet","venue_id":"2"}'
$REDIS EXPIRE "notification:u167:pending" 7200
$REDIS LPUSH "notification:u168:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pacha","venue_id":"5"}'
$REDIS EXPIRE "notification:u168:pending" 7200
$REDIS LPUSH "notification:u169:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de BNN","venue_id":"8"}'
$REDIS EXPIRE "notification:u169:pending" 7200
$REDIS LPUSH "notification:u170:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Niceto Club","venue_id":"11"}'
$REDIS EXPIRE "notification:u170:pending" 7200
$REDIS LPUSH "notification:u171:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Malia","venue_id":"14"}'
$REDIS EXPIRE "notification:u171:pending" 7200
$REDIS LPUSH "notification:u172:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Cluster","venue_id":"17"}'
$REDIS EXPIRE "notification:u172:pending" 7200
$REDIS LPUSH "notification:u173:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Monaco","venue_id":"20"}'
$REDIS EXPIRE "notification:u173:pending" 7200
$REDIS LPUSH "notification:u174:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Distrito","venue_id":"23"}'
$REDIS EXPIRE "notification:u174:pending" 7200
$REDIS LPUSH "notification:u175:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Skyline","venue_id":"26"}'
$REDIS EXPIRE "notification:u175:pending" 7200
$REDIS LPUSH "notification:u176:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pulse","venue_id":"29"}'
$REDIS EXPIRE "notification:u176:pending" 7200
$REDIS LPUSH "notification:u177:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Zenith","venue_id":"32"}'
$REDIS EXPIRE "notification:u177:pending" 7200
$REDIS LPUSH "notification:u178:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nova","venue_id":"35"}'
$REDIS EXPIRE "notification:u178:pending" 7200
$REDIS LPUSH "notification:u179:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Metropolis","venue_id":"38"}'
$REDIS EXPIRE "notification:u179:pending" 7200
$REDIS LPUSH "notification:u180:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Velvet","venue_id":"41"}'
$REDIS EXPIRE "notification:u180:pending" 7200
$REDIS LPUSH "notification:u181:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Temple","venue_id":"44"}'
$REDIS EXPIRE "notification:u181:pending" 7200
$REDIS LPUSH "notification:u182:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Myst","venue_id":"47"}'
$REDIS EXPIRE "notification:u182:pending" 7200
$REDIS LPUSH "notification:u183:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mirage","venue_id":"50"}'
$REDIS EXPIRE "notification:u183:pending" 7200
$REDIS LPUSH "notification:u184:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Ink","venue_id":"3"}'
$REDIS EXPIRE "notification:u184:pending" 7200
$REDIS LPUSH "notification:u185:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rosebar","venue_id":"6"}'
$REDIS EXPIRE "notification:u185:pending" 7200
$REDIS LPUSH "notification:u186:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Museum","venue_id":"9"}'
$REDIS EXPIRE "notification:u186:pending" 7200
$REDIS LPUSH "notification:u187:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Input","venue_id":"12"}'
$REDIS EXPIRE "notification:u187:pending" 7200
$REDIS LPUSH "notification:u188:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Dorsia","venue_id":"15"}'
$REDIS EXPIRE "notification:u188:pending" 7200
$REDIS LPUSH "notification:u189:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Prisma","venue_id":"18"}'
$REDIS EXPIRE "notification:u189:pending" 7200
$REDIS LPUSH "notification:u190:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Blackroom","venue_id":"21"}'
$REDIS EXPIRE "notification:u190:pending" 7200
$REDIS LPUSH "notification:u191:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Celsius","venue_id":"24"}'
$REDIS EXPIRE "notification:u191:pending" 7200
$REDIS LPUSH "notification:u192:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Vox","venue_id":"27"}'
$REDIS EXPIRE "notification:u192:pending" 7200
$REDIS LPUSH "notification:u193:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nebula","venue_id":"30"}'
$REDIS EXPIRE "notification:u193:pending" 7200
$REDIS LPUSH "notification:u194:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Moscow","venue_id":"33"}'
$REDIS EXPIRE "notification:u194:pending" 7200
$REDIS LPUSH "notification:u195:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mamba","venue_id":"36"}'
$REDIS EXPIRE "notification:u195:pending" 7200
$REDIS LPUSH "notification:u196:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Eclipse","venue_id":"39"}'
$REDIS EXPIRE "notification:u196:pending" 7200
$REDIS LPUSH "notification:u197:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Satori","venue_id":"42"}'
$REDIS EXPIRE "notification:u197:pending" 7200
$REDIS LPUSH "notification:u198:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nox","venue_id":"45"}'
$REDIS EXPIRE "notification:u198:pending" 7200
$REDIS LPUSH "notification:u199:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Replay","venue_id":"48"}'
$REDIS EXPIRE "notification:u199:pending" 7200
$REDIS LPUSH "notification:u200:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Crobar","venue_id":"1"}'
$REDIS EXPIRE "notification:u200:pending" 7200
$REDIS LPUSH "notification:u201:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mandarine","venue_id":"4"}'
$REDIS EXPIRE "notification:u201:pending" 7200
$REDIS LPUSH "notification:u202:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Kika","venue_id":"7"}'
$REDIS EXPIRE "notification:u202:pending" 7200
$REDIS LPUSH "notification:u203:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Bahrein","venue_id":"10"}'
$REDIS EXPIRE "notification:u203:pending" 7200
$REDIS LPUSH "notification:u204:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rio Electronic","venue_id":"13"}'
$REDIS EXPIRE "notification:u204:pending" 7200
$REDIS LPUSH "notification:u205:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Arenas","venue_id":"16"}'
$REDIS EXPIRE "notification:u205:pending" 7200
$REDIS LPUSH "notification:u206:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Aura","venue_id":"19"}'
$REDIS EXPIRE "notification:u206:pending" 7200
$REDIS LPUSH "notification:u207:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de VÃ©rtigo","venue_id":"22"}'
$REDIS EXPIRE "notification:u207:pending" 7200
$REDIS LPUSH "notification:u208:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lumen","venue_id":"25"}'
$REDIS EXPIRE "notification:u208:pending" 7200
$REDIS LPUSH "notification:u209:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Fahrenheit","venue_id":"28"}'
$REDIS EXPIRE "notification:u209:pending" 7200
$REDIS LPUSH "notification:u210:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Empire","venue_id":"31"}'
$REDIS EXPIRE "notification:u210:pending" 7200
$REDIS LPUSH "notification:u211:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Oasis","venue_id":"34"}'
$REDIS EXPIRE "notification:u211:pending" 7200
$REDIS LPUSH "notification:u212:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Titan","venue_id":"37"}'
$REDIS EXPIRE "notification:u212:pending" 7200
$REDIS LPUSH "notification:u213:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lounge X","venue_id":"40"}'
$REDIS EXPIRE "notification:u213:pending" 7200
$REDIS LPUSH "notification:u214:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Code","venue_id":"43"}'
$REDIS EXPIRE "notification:u214:pending" 7200
$REDIS LPUSH "notification:u215:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Solar","venue_id":"46"}'
$REDIS EXPIRE "notification:u215:pending" 7200
$REDIS LPUSH "notification:u216:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Atomic","venue_id":"49"}'
$REDIS EXPIRE "notification:u216:pending" 7200
$REDIS LPUSH "notification:u217:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Jet","venue_id":"2"}'
$REDIS EXPIRE "notification:u217:pending" 7200
$REDIS LPUSH "notification:u218:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pacha","venue_id":"5"}'
$REDIS EXPIRE "notification:u218:pending" 7200
$REDIS LPUSH "notification:u219:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de BNN","venue_id":"8"}'
$REDIS EXPIRE "notification:u219:pending" 7200
$REDIS LPUSH "notification:u220:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Niceto Club","venue_id":"11"}'
$REDIS EXPIRE "notification:u220:pending" 7200
$REDIS LPUSH "notification:u221:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Malia","venue_id":"14"}'
$REDIS EXPIRE "notification:u221:pending" 7200
$REDIS LPUSH "notification:u222:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Cluster","venue_id":"17"}'
$REDIS EXPIRE "notification:u222:pending" 7200
$REDIS LPUSH "notification:u223:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Monaco","venue_id":"20"}'
$REDIS EXPIRE "notification:u223:pending" 7200
$REDIS LPUSH "notification:u224:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Distrito","venue_id":"23"}'
$REDIS EXPIRE "notification:u224:pending" 7200
$REDIS LPUSH "notification:u225:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Skyline","venue_id":"26"}'
$REDIS EXPIRE "notification:u225:pending" 7200
$REDIS LPUSH "notification:u226:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pulse","venue_id":"29"}'
$REDIS EXPIRE "notification:u226:pending" 7200
$REDIS LPUSH "notification:u227:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Zenith","venue_id":"32"}'
$REDIS EXPIRE "notification:u227:pending" 7200
$REDIS LPUSH "notification:u228:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nova","venue_id":"35"}'
$REDIS EXPIRE "notification:u228:pending" 7200
$REDIS LPUSH "notification:u229:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Metropolis","venue_id":"38"}'
$REDIS EXPIRE "notification:u229:pending" 7200
$REDIS LPUSH "notification:u230:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Velvet","venue_id":"41"}'
$REDIS EXPIRE "notification:u230:pending" 7200
$REDIS LPUSH "notification:u231:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Temple","venue_id":"44"}'
$REDIS EXPIRE "notification:u231:pending" 7200
$REDIS LPUSH "notification:u232:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Myst","venue_id":"47"}'
$REDIS EXPIRE "notification:u232:pending" 7200
$REDIS LPUSH "notification:u233:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mirage","venue_id":"50"}'
$REDIS EXPIRE "notification:u233:pending" 7200
$REDIS LPUSH "notification:u234:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Ink","venue_id":"3"}'
$REDIS EXPIRE "notification:u234:pending" 7200
$REDIS LPUSH "notification:u235:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rosebar","venue_id":"6"}'
$REDIS EXPIRE "notification:u235:pending" 7200
$REDIS LPUSH "notification:u236:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Museum","venue_id":"9"}'
$REDIS EXPIRE "notification:u236:pending" 7200
$REDIS LPUSH "notification:u237:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Input","venue_id":"12"}'
$REDIS EXPIRE "notification:u237:pending" 7200
$REDIS LPUSH "notification:u238:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Dorsia","venue_id":"15"}'
$REDIS EXPIRE "notification:u238:pending" 7200
$REDIS LPUSH "notification:u239:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Prisma","venue_id":"18"}'
$REDIS EXPIRE "notification:u239:pending" 7200
$REDIS LPUSH "notification:u240:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Blackroom","venue_id":"21"}'
$REDIS EXPIRE "notification:u240:pending" 7200
$REDIS LPUSH "notification:u241:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Celsius","venue_id":"24"}'
$REDIS EXPIRE "notification:u241:pending" 7200
$REDIS LPUSH "notification:u242:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Vox","venue_id":"27"}'
$REDIS EXPIRE "notification:u242:pending" 7200
$REDIS LPUSH "notification:u243:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nebula","venue_id":"30"}'
$REDIS EXPIRE "notification:u243:pending" 7200
$REDIS LPUSH "notification:u244:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Moscow","venue_id":"33"}'
$REDIS EXPIRE "notification:u244:pending" 7200
$REDIS LPUSH "notification:u245:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mamba","venue_id":"36"}'
$REDIS EXPIRE "notification:u245:pending" 7200
$REDIS LPUSH "notification:u246:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Eclipse","venue_id":"39"}'
$REDIS EXPIRE "notification:u246:pending" 7200
$REDIS LPUSH "notification:u247:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Satori","venue_id":"42"}'
$REDIS EXPIRE "notification:u247:pending" 7200
$REDIS LPUSH "notification:u248:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nox","venue_id":"45"}'
$REDIS EXPIRE "notification:u248:pending" 7200
$REDIS LPUSH "notification:u249:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Replay","venue_id":"48"}'
$REDIS EXPIRE "notification:u249:pending" 7200
$REDIS LPUSH "notification:u250:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Crobar","venue_id":"1"}'
$REDIS EXPIRE "notification:u250:pending" 7200
$REDIS LPUSH "notification:u251:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mandarine","venue_id":"4"}'
$REDIS EXPIRE "notification:u251:pending" 7200
$REDIS LPUSH "notification:u252:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Kika","venue_id":"7"}'
$REDIS EXPIRE "notification:u252:pending" 7200
$REDIS LPUSH "notification:u253:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Bahrein","venue_id":"10"}'
$REDIS EXPIRE "notification:u253:pending" 7200
$REDIS LPUSH "notification:u254:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rio Electronic","venue_id":"13"}'
$REDIS EXPIRE "notification:u254:pending" 7200
$REDIS LPUSH "notification:u255:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Arenas","venue_id":"16"}'
$REDIS EXPIRE "notification:u255:pending" 7200
$REDIS LPUSH "notification:u256:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Aura","venue_id":"19"}'
$REDIS EXPIRE "notification:u256:pending" 7200
$REDIS LPUSH "notification:u257:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de VÃ©rtigo","venue_id":"22"}'
$REDIS EXPIRE "notification:u257:pending" 7200
$REDIS LPUSH "notification:u258:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lumen","venue_id":"25"}'
$REDIS EXPIRE "notification:u258:pending" 7200
$REDIS LPUSH "notification:u259:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Fahrenheit","venue_id":"28"}'
$REDIS EXPIRE "notification:u259:pending" 7200
$REDIS LPUSH "notification:u260:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Empire","venue_id":"31"}'
$REDIS EXPIRE "notification:u260:pending" 7200
$REDIS LPUSH "notification:u261:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Oasis","venue_id":"34"}'
$REDIS EXPIRE "notification:u261:pending" 7200
$REDIS LPUSH "notification:u262:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Titan","venue_id":"37"}'
$REDIS EXPIRE "notification:u262:pending" 7200
$REDIS LPUSH "notification:u263:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Lounge X","venue_id":"40"}'
$REDIS EXPIRE "notification:u263:pending" 7200
$REDIS LPUSH "notification:u264:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Code","venue_id":"43"}'
$REDIS EXPIRE "notification:u264:pending" 7200
$REDIS LPUSH "notification:u265:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Solar","venue_id":"46"}'
$REDIS EXPIRE "notification:u265:pending" 7200
$REDIS LPUSH "notification:u266:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Atomic","venue_id":"49"}'
$REDIS EXPIRE "notification:u266:pending" 7200
$REDIS LPUSH "notification:u267:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Jet","venue_id":"2"}'
$REDIS EXPIRE "notification:u267:pending" 7200
$REDIS LPUSH "notification:u268:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pacha","venue_id":"5"}'
$REDIS EXPIRE "notification:u268:pending" 7200
$REDIS LPUSH "notification:u269:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de BNN","venue_id":"8"}'
$REDIS EXPIRE "notification:u269:pending" 7200
$REDIS LPUSH "notification:u270:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Niceto Club","venue_id":"11"}'
$REDIS EXPIRE "notification:u270:pending" 7200
$REDIS LPUSH "notification:u271:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Malia","venue_id":"14"}'
$REDIS EXPIRE "notification:u271:pending" 7200
$REDIS LPUSH "notification:u272:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Cluster","venue_id":"17"}'
$REDIS EXPIRE "notification:u272:pending" 7200
$REDIS LPUSH "notification:u273:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Monaco","venue_id":"20"}'
$REDIS EXPIRE "notification:u273:pending" 7200
$REDIS LPUSH "notification:u274:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Distrito","venue_id":"23"}'
$REDIS EXPIRE "notification:u274:pending" 7200
$REDIS LPUSH "notification:u275:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Skyline","venue_id":"26"}'
$REDIS EXPIRE "notification:u275:pending" 7200
$REDIS LPUSH "notification:u276:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Pulse","venue_id":"29"}'
$REDIS EXPIRE "notification:u276:pending" 7200
$REDIS LPUSH "notification:u277:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Zenith","venue_id":"32"}'
$REDIS EXPIRE "notification:u277:pending" 7200
$REDIS LPUSH "notification:u278:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nova","venue_id":"35"}'
$REDIS EXPIRE "notification:u278:pending" 7200
$REDIS LPUSH "notification:u279:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Metropolis","venue_id":"38"}'
$REDIS EXPIRE "notification:u279:pending" 7200
$REDIS LPUSH "notification:u280:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Velvet","venue_id":"41"}'
$REDIS EXPIRE "notification:u280:pending" 7200
$REDIS LPUSH "notification:u281:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Temple","venue_id":"44"}'
$REDIS EXPIRE "notification:u281:pending" 7200
$REDIS LPUSH "notification:u282:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Myst","venue_id":"47"}'
$REDIS EXPIRE "notification:u282:pending" 7200
$REDIS LPUSH "notification:u283:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mirage","venue_id":"50"}'
$REDIS EXPIRE "notification:u283:pending" 7200
$REDIS LPUSH "notification:u284:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Ink","venue_id":"3"}'
$REDIS EXPIRE "notification:u284:pending" 7200
$REDIS LPUSH "notification:u285:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Rosebar","venue_id":"6"}'
$REDIS EXPIRE "notification:u285:pending" 7200
$REDIS LPUSH "notification:u286:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Museum","venue_id":"9"}'
$REDIS EXPIRE "notification:u286:pending" 7200
$REDIS LPUSH "notification:u287:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Input","venue_id":"12"}'
$REDIS EXPIRE "notification:u287:pending" 7200
$REDIS LPUSH "notification:u288:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Dorsia","venue_id":"15"}'
$REDIS EXPIRE "notification:u288:pending" 7200
$REDIS LPUSH "notification:u289:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Prisma","venue_id":"18"}'
$REDIS EXPIRE "notification:u289:pending" 7200
$REDIS LPUSH "notification:u290:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Blackroom","venue_id":"21"}'
$REDIS EXPIRE "notification:u290:pending" 7200
$REDIS LPUSH "notification:u291:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Celsius","venue_id":"24"}'
$REDIS EXPIRE "notification:u291:pending" 7200
$REDIS LPUSH "notification:u292:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Vox","venue_id":"27"}'
$REDIS EXPIRE "notification:u292:pending" 7200
$REDIS LPUSH "notification:u293:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nebula","venue_id":"30"}'
$REDIS EXPIRE "notification:u293:pending" 7200
$REDIS LPUSH "notification:u294:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Moscow","venue_id":"33"}'
$REDIS EXPIRE "notification:u294:pending" 7200
$REDIS LPUSH "notification:u295:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Mamba","venue_id":"36"}'
$REDIS EXPIRE "notification:u295:pending" 7200
$REDIS LPUSH "notification:u296:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Eclipse","venue_id":"39"}'
$REDIS EXPIRE "notification:u296:pending" 7200
$REDIS LPUSH "notification:u297:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Satori","venue_id":"42"}'
$REDIS EXPIRE "notification:u297:pending" 7200
$REDIS LPUSH "notification:u298:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Nox","venue_id":"45"}'
$REDIS EXPIRE "notification:u298:pending" 7200
$REDIS LPUSH "notification:u299:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Replay","venue_id":"48"}'
$REDIS EXPIRE "notification:u299:pending" 7200
$REDIS LPUSH "notification:u300:pending" '{"type":"friend_nearby","message":"Hay actividad cerca de Crobar","venue_id":"1"}'
$REDIS EXPIRE "notification:u300:pending" 7200

echo "Redis seed listo."
echo "Resumen esperado:"
echo "  3000 claves presence:u*"
echo "  50 sets venue:*:present"
echo "  100 contadores event:e*:attendees"
echo "  500 sesiones session:demo_token_u*"
echo "  300 listas notification:u*:pending"
echo "Comandos utiles para revisar:"
echo "  docker exec cache_redis redis-cli -a \$REDIS_PASSWORD DBSIZE"
echo "  docker exec cache_redis redis-cli -a \$REDIS_PASSWORD GET presence:u1"
echo "  docker exec cache_redis redis-cli -a \$REDIS_PASSWORD SCARD venue:1:present"
echo "  docker exec cache_redis redis-cli -a \$REDIS_PASSWORD GET event:e1:attendees"
