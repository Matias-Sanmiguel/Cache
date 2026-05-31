/**
 * Repositorio encargado de manejar operaciones sobre la tabla checkin_history.
 *
 * Esta tabla guarda el historial de check-ins de cada usuario.
 * En Cassandra, las tablas se diseñan según las consultas que queremos hacer.
 */
public class CheckinRepository {

    /**
     * Guarda un check-in realizado por un usuario.
     *
     * En una versión conectada a Cassandra, este método haría un INSERT INTO
     * sobre la tabla checkin_history.
     */
    public void saveCheckin(
            String userId,
            String eventId,
            String venueId,
            String venueName,
            String genre,
            String city) {

        System.out.println("Guardando check-in...");
        System.out.println("Usuario: " + userId);
        System.out.println("Evento: " + eventId);
        System.out.println("Venue: " + venueName);
        System.out.println("Género: " + genre);
        System.out.println("Ciudad: " + city);
    }

    /**
     * Consulta el historial de check-ins de un usuario.
     *
     * Query esperada en Cassandra:
     *
     * SELECT * FROM checkin_history
     * WHERE user_id = ?
     * LIMIT 20;
     */
    public void getUserHistory(String userId) {
        System.out.println("Buscando historial del usuario: " + userId);
    }
}