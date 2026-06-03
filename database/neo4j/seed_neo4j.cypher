MATCH (n)
DETACH DELETE n;

CREATE CONSTRAINT user_userId IF NOT EXISTS
FOR (u:User) REQUIRE u.userId IS UNIQUE;

CREATE CONSTRAINT event_eventId IF NOT EXISTS
FOR (e:Event) REQUIRE e.eventId IS UNIQUE;

CREATE CONSTRAINT venue_venueId IF NOT EXISTS
FOR (v:Venue) REQUIRE v.venueId IS UNIQUE;

CREATE CONSTRAINT genre_name IF NOT EXISTS
FOR (g:Genre) REQUIRE g.name IS UNIQUE;

UNWIND [
  {
    venueId: 'VEN001',
    redisVenueKey: '11',
    name: 'Niceto Club',
    zone: 'palermo',
    city: 'buenos aires',
    capacity: 400,
    tags: ['techno', 'palermo', 'club']
  },
  {
    venueId: 'VEN002',
    redisVenueKey: '1',
    name: 'Crobar',
    zone: 'costanera norte',
    city: 'buenos aires',
    capacity: 600,
    tags: ['techno', 'costanera norte', 'club', '18+']
  },
  {
    venueId: 'VEN003',
    redisVenueKey: '3',
    name: 'Galpon sin nombre',
    zone: 'chacarita',
    city: 'buenos aires',
    capacity: 250,
    tags: ['bass', 'underground', 'cash-only']
  },
  {
    venueId: 'VEN004',
    redisVenueKey: '4',
    name: 'Amerika',
    zone: 'recoleta',
    city: 'buenos aires',
    capacity: 800,
    tags: ['house', 'disco', 'recoleta', '18+']
  },
  {
    venueId: 'VEN005',
    redisVenueKey: '5',
    name: 'Club Colegiales',
    zone: 'colegiales',
    city: 'buenos aires',
    capacity: 350,
    tags: ['techno', 'melodic', 'club']
  },
  {
    venueId: 'VEN006',
    redisVenueKey: '6',
    name: 'Direccion confidencial',
    zone: 'chacarita',
    city: 'buenos aires',
    capacity: 120,
    tags: ['minimal', 'privada', 'invite-only']
  }
] AS venue
CREATE (:Venue {
  venueId: venue.venueId,
  redisVenueKey: venue.redisVenueKey,
  name: venue.name,
  zone: venue.zone,
  city: venue.city,
  capacity: venue.capacity,
  tags: venue.tags
});

UNWIND [
  {id: 7, name: 'La Terraza Palermo', zone: 'palermo', capacity: 320, tags: ['house', 'rooftop', 'palermo']},
  {id: 8, name: 'Distrito Palermo', zone: 'palermo', capacity: 450, tags: ['techno', 'club', 'palermo']},
  {id: 9, name: 'Vox Palermo', zone: 'palermo', capacity: 280, tags: ['disco', 'bar', 'palermo']},
  {id: 10, name: 'Pulse Palermo', zone: 'palermo', capacity: 520, tags: ['techno', 'club', 'palermo']},
  {id: 11, name: 'Jardin Sonoro', zone: 'palermo', capacity: 260, tags: ['minimal', 'open-air', 'palermo']},
  {id: 12, name: 'Mandarine Park', zone: 'costanera norte', capacity: 900, tags: ['techno', 'festival', 'costanera norte']},
  {id: 13, name: 'Rio Electronic', zone: 'costanera norte', capacity: 700, tags: ['house', 'river', 'costanera norte']},
  {id: 14, name: 'Input Costanera', zone: 'costanera norte', capacity: 500, tags: ['hard-groove', 'club', 'costanera norte']},
  {id: 15, name: 'Muelle Norte', zone: 'costanera norte', capacity: 420, tags: ['techno', 'warehouse', 'costanera norte']},
  {id: 16, name: 'Dique Club', zone: 'puerto madero', capacity: 380, tags: ['house', 'puerto madero']},
  {id: 17, name: 'Madero Bass', zone: 'puerto madero', capacity: 360, tags: ['bass', 'club', 'puerto madero']},
  {id: 18, name: 'Dock 7', zone: 'puerto madero', capacity: 550, tags: ['techno', 'dock', 'puerto madero']},
  {id: 19, name: 'Bahia Madero', zone: 'puerto madero', capacity: 240, tags: ['disco', 'bar', 'puerto madero']},
  {id: 20, name: 'Recoleta Room', zone: 'recoleta', capacity: 260, tags: ['deep', 'bar', 'recoleta']},
  {id: 21, name: 'Museo Club', zone: 'recoleta', capacity: 300, tags: ['house', 'recoleta']},
  {id: 22, name: 'Atlas Recoleta', zone: 'recoleta', capacity: 340, tags: ['techno', 'club', 'recoleta']},
  {id: 23, name: 'Terra Recoleta', zone: 'recoleta', capacity: 180, tags: ['minimal', 'private', 'recoleta']},
  {id: 24, name: 'Belgrano Beats', zone: 'belgrano', capacity: 310, tags: ['house', 'belgrano']},
  {id: 25, name: 'Barrancas Club', zone: 'belgrano', capacity: 400, tags: ['disco', 'club', 'belgrano']},
  {id: 26, name: 'Nunez Modular', zone: 'belgrano', capacity: 330, tags: ['techno', 'modular', 'belgrano']},
  {id: 27, name: 'Club Colegiales II', zone: 'colegiales', capacity: 370, tags: ['melodic', 'club', 'colegiales']},
  {id: 28, name: 'Galpon Colegiales', zone: 'colegiales', capacity: 420, tags: ['techno', 'warehouse', 'colegiales']},
  {id: 29, name: 'Colegiales Patio', zone: 'colegiales', capacity: 230, tags: ['house', 'open-air', 'colegiales']},
  {id: 30, name: 'Santos 404', zone: 'chacarita', capacity: 210, tags: ['experimental', 'underground', 'chacarita']},
  {id: 31, name: 'Chacarita Bass', zone: 'chacarita', capacity: 260, tags: ['bass', 'underground', 'chacarita']},
  {id: 32, name: 'El Tunel', zone: 'chacarita', capacity: 190, tags: ['minimal', 'private', 'chacarita']},
  {id: 33, name: 'Patio Dorrego', zone: 'san telmo', capacity: 280, tags: ['disco', 'san telmo']},
  {id: 34, name: 'San Telmo Dub', zone: 'san telmo', capacity: 220, tags: ['dub', 'bass', 'san telmo']},
  {id: 35, name: 'Mercado Club', zone: 'san telmo', capacity: 350, tags: ['house', 'club', 'san telmo']},
  {id: 36, name: 'Olivos Station', zone: 'olivos', capacity: 300, tags: ['techno', 'olivos']},
  {id: 37, name: 'Rio Olivos', zone: 'olivos', capacity: 450, tags: ['house', 'river', 'olivos']},
  {id: 38, name: 'Norte Bass', zone: 'olivos', capacity: 240, tags: ['bass', 'olivos']},
  {id: 39, name: 'Martinez Club', zone: 'martinez', capacity: 320, tags: ['house', 'martinez']},
  {id: 40, name: 'Avenida Modular', zone: 'martinez', capacity: 270, tags: ['melodic', 'martinez']},
  {id: 41, name: 'Bajo Martinez', zone: 'martinez', capacity: 380, tags: ['techno', 'martinez']},
  {id: 42, name: 'San Isidro House', zone: 'san isidro', capacity: 300, tags: ['house', 'san isidro']},
  {id: 43, name: 'Hipodromo Beats', zone: 'san isidro', capacity: 750, tags: ['festival', 'techno', 'san isidro']},
  {id: 44, name: 'Barranca Norte', zone: 'san isidro', capacity: 260, tags: ['deep', 'san isidro']},
  {id: 45, name: 'Palermo Loft', zone: 'palermo', capacity: 200, tags: ['minimal', 'private', 'palermo']},
  {id: 46, name: 'Costanera Warehouse', zone: 'costanera norte', capacity: 650, tags: ['techno', 'warehouse', 'costanera norte']},
  {id: 47, name: 'Madero Rooftop', zone: 'puerto madero', capacity: 280, tags: ['house', 'rooftop', 'puerto madero']},
  {id: 48, name: 'Recoleta Disco', zone: 'recoleta', capacity: 330, tags: ['disco', 'recoleta']},
  {id: 49, name: 'Belgrano Norte', zone: 'belgrano', capacity: 360, tags: ['melodic', 'belgrano']},
  {id: 50, name: 'Chacarita Experimental', zone: 'chacarita', capacity: 170, tags: ['experimental', 'underground', 'chacarita']}
] AS venue
WITH venue,
     CASE
       WHEN venue.id < 10 THEN '00' + toString(venue.id)
       ELSE '0' + toString(venue.id)
     END AS suffix
CREATE (:Venue {
  venueId: 'VEN' + suffix,
  redisVenueKey: toString(venue.id),
  name: venue.name,
  zone: venue.zone,
  city: CASE
    WHEN venue.zone IN ['olivos', 'martinez', 'san isidro'] THEN 'zona norte'
    ELSE 'buenos aires'
  END,
  capacity: venue.capacity,
  tags: venue.tags
});

UNWIND [
  {
    eventId: 'EVT001',
    redisEventKey: 'e1',
    name: 'SUB00.',
    venueId: 'VEN001',
    venueName: 'Niceto Club',
    genres: ['techno', 'experimental'],
    city: 'buenos aires',
    startsAt: '2026-06-06T02:30:00Z',
    status: 'upcoming',
    accessType: 'public',
    attendeeCount: 234
  },
  {
    eventId: 'EVT002',
    redisEventKey: 'e2',
    name: 'KERNEL',
    venueId: 'VEN002',
    venueName: 'Crobar',
    genres: ['techno', 'hard-groove'],
    city: 'buenos aires',
    startsAt: '2026-05-31T20:00:00Z',
    status: 'live',
    accessType: 'public',
    attendeeCount: 512
  },
  {
    eventId: 'EVT003',
    redisEventKey: 'e3',
    name: 'HUMEDAL',
    venueId: 'VEN003',
    venueName: 'Galpon sin nombre',
    genres: ['dub', 'bass', 'experimental'],
    city: 'buenos aires',
    startsAt: '2026-05-31T21:00:00Z',
    status: 'live',
    accessType: 'public',
    attendeeCount: 238
  },
  {
    eventId: 'EVT004',
    redisEventKey: 'e4',
    name: 'CLUB BERLIN',
    venueId: 'VEN004',
    venueName: 'Amerika',
    genres: ['house', 'disco'],
    city: 'buenos aires',
    startsAt: '2026-06-07T00:00:00Z',
    status: 'upcoming',
    accessType: 'public',
    attendeeCount: 120
  },
  {
    eventId: 'EVT005',
    redisEventKey: 'e5',
    name: 'TRESDE',
    venueId: 'VEN005',
    venueName: 'Club Colegiales',
    genres: ['techno', 'melodic'],
    city: 'buenos aires',
    startsAt: '2026-06-13T23:00:00Z',
    status: 'upcoming',
    accessType: 'public',
    attendeeCount: 89
  },
  {
    eventId: 'EVT006',
    redisEventKey: 'e6',
    name: 'CASA PELICANO',
    venueId: 'VEN006',
    venueName: 'Direccion confidencial',
    genres: ['minimal', 'deep'],
    city: 'buenos aires',
    startsAt: '2026-06-14T02:30:00Z',
    status: 'upcoming',
    accessType: 'invite-only',
    attendeeCount: 98
  }
] AS event
CREATE (:Event {
  eventId: event.eventId,
  redisEventKey: event.redisEventKey,
  name: event.name,
  venueId: event.venueId,
  venueName: event.venueName,
  genre: event.genres[0],
  genres: event.genres,
  city: event.city,
  startsAtEpoch: datetime(event.startsAt).epochMillis,
  status: event.status,
  accessType: event.accessType,
  attendeeTarget: event.attendeeCount
});

MATCH (v:Venue)
WITH v
ORDER BY v.venueId
WITH collect({
       venueId: v.venueId,
       venueName: v.name,
       capacity: v.capacity,
       genres: CASE
         WHEN 'hard-groove' IN v.tags THEN ['techno', 'hard-groove']
         WHEN 'bass' IN v.tags AND 'dub' IN v.tags THEN ['dub', 'bass']
         WHEN 'bass' IN v.tags THEN ['bass', 'experimental']
         WHEN 'disco' IN v.tags THEN ['house', 'disco']
         WHEN 'melodic' IN v.tags THEN ['techno', 'melodic']
         WHEN 'minimal' IN v.tags THEN ['minimal', 'deep']
         WHEN 'deep' IN v.tags THEN ['deep', 'house']
         WHEN 'experimental' IN v.tags THEN ['experimental', 'techno']
         WHEN 'house' IN v.tags THEN ['house', 'disco']
         ELSE ['techno', 'experimental']
       END
     }) AS venueTemplates
UNWIND range(7, 1000) AS n
WITH n,
     CASE
       WHEN n < 10 THEN '00' + toString(n)
       WHEN n < 100 THEN '0' + toString(n)
       ELSE toString(n)
     END AS suffix,
     venueTemplates,
     ['SUBSUELO', 'KERNEL', 'HUMEDAL', 'CLUB BERLIN', 'TRESDE', 'CASA PELICANO', 'NOCHE MODULAR', 'PATIO BASS'] AS names
WITH n, suffix, venueTemplates[(n - 1) % size(venueTemplates)] AS venue, names[(n - 1) % size(names)] AS baseName
WITH n, suffix, venue, baseName, 60 + ((n * 37) % 540) AS generatedAttendeeCount
CREATE (:Event {
  eventId: 'EVT' + suffix,
  redisEventKey: 'e' + toString(n),
  name: baseName + ' ' + suffix,
  venueId: venue.venueId,
  venueName: venue.venueName,
  genre: venue.genres[0],
  genres: venue.genres,
  city: 'buenos aires',
  startsAtEpoch: (datetime('2026-06-15T00:00:00Z') + duration({days: n % 45, hours: n % 6})).epochMillis,
  status: 'upcoming',
  accessType: CASE WHEN venue.capacity <= 220 AND n % 3 = 0 THEN 'invite-only' ELSE 'public' END,
  attendeeTarget: CASE
    WHEN generatedAttendeeCount > venue.capacity THEN venue.capacity
    ELSE generatedAttendeeCount
  END
});

MATCH (e:Event), (v:Venue {venueId: e.venueId})
MERGE (e)-[:HELD_AT]->(v);

UNWIND ['techno', 'experimental', 'hard-groove', 'dub', 'bass', 'house', 'disco', 'melodic', 'minimal', 'deep'] AS genre
CREATE (:Genre {name: genre});

MATCH (e:Event)
UNWIND e.genres AS genre
MATCH (g:Genre {name: genre})
MERGE (e)-[:HAS_GENRE]->(g);

UNWIND range(1, 1000) AS n
WITH n,
     CASE
       WHEN n < 10 THEN '00' + toString(n)
       WHEN n < 100 THEN '0' + toString(n)
       ELSE toString(n)
     END AS suffix,
     ['Luna', 'Nico', 'Sofi', 'Tomi', 'Cami', 'Bruno', 'Vera', 'Ivo', 'Mora', 'Rama', 'Dani', 'Lola'] AS names,
     ['palermo', 'chacarita', 'almagro', 'colegiales', 'caballito', 'san telmo', 'villa crespo', 'belgrano'] AS zones
CREATE (:User {
  userId: 'USR' + suffix,
  redisUserKey: 'u' + toString(n),
  name: CASE n
    WHEN 1 THEN 'Gus'
    WHEN 2 THEN 'Mati'
    WHEN 3 THEN 'Jule'
    ELSE names[(n - 1) % size(names)] + ' ' + suffix
  END,
  city: 'buenos aires',
  homeZone: zones[(n - 1) % size(zones)],
  cohort: toInteger((n - 1) / 20) + 1,
  createdAt: datetime('2026-05-31T13:34:12.055Z')
});

MATCH (u:User)
WITH u,
     toInteger(substring(u.redisUserKey, 1)) AS n,
     ['techno', 'house', 'bass', 'minimal', 'experimental', 'dub', 'melodic', 'disco'] AS preferredGenres
MATCH (g:Genre {name: preferredGenres[(n - 1) % size(preferredGenres)]})
MERGE (u)-[:LIKES_GENRE {weight: 3}]->(g);

MATCH (u:User)
WITH u
ORDER BY toInteger(substring(u.redisUserKey, 1))
WITH collect(u) AS users
UNWIND range(0, size(users) - 1) AS i
UNWIND [1, 2, 5] AS step
WITH users[i] AS a, users[(i + step) % size(users)] AS b
WHERE a.cohort = b.cohort
MERGE (a)-[:FRIENDS_WITH {source: 'same_cohort'}]->(b);

MATCH (a:User), (b:User)
WHERE a.cohort % 5 = 0
  AND b.cohort = a.cohort + 1
  AND toInteger(substring(a.redisUserKey, 1)) % 20 = 1
  AND toInteger(substring(b.redisUserKey, 1)) % 20 = 1
MERGE (a)-[:FRIENDS_WITH {source: 'scene_bridge'}]->(b);

MATCH (e:Event)
MATCH (u:User)
WITH e, u,
     toInteger(substring(u.redisUserKey, 1)) AS userNumber,
     toInteger(substring(e.redisEventKey, 1)) AS eventNumber
WHERE ((userNumber * (37 + (eventNumber % 97)) + (eventNumber * 11)) % 1000) < e.attendeeTarget
MERGE (u)-[r:ATTENDING]->(e)
SET r.status = CASE
      WHEN ((userNumber + eventNumber) % 17) = 0 THEN 'pending'
      ELSE 'confirmed'
    END,
    r.registeredAt = datetime({epochMillis: e.startsAtEpoch - (((userNumber % 10) + 1) * 86400000)});

MATCH (host:User {userId: 'USR001'}), (event:Event {eventId: 'EVT006'})
MERGE (host)-[:HOSTS]->(event);
