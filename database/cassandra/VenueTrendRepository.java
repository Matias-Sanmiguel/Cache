/**
 * Repositorio encargado de manejar operaciones sobre la tabla venue_trends.
 *
 * Esta tabla guarda estadísticas por venue, día y hora.
 * Sirve para analizar tendencias y detectar horarios pico.
 */
public class VenueTrendRepository {

    /**
     * Guarda o actualiza una tendencia horaria de un venue.
     *
     * En una versión real, esto impactaría en la tabla venue_trends.
     */
    public void saveTrend(
            String venueId,
            String date,
            int hour,
            int checkinCount,
            int uniqueUsers,
            String topGenre) {

        System.out.println("Guardando tendencia del venue...");
        System.out.println("Venue ID: " + venueId);
        System.out.println("Fecha: " + date);
        System.out.println("Hora: " + hour);
        System.out.println("Check-ins: " + checkinCount);
        System.out.println("Usuarios únicos: " + uniqueUsers);
        System.out.println("Género principal: " + topGenre);
    }

    /**
     * Obtiene el mapa horario de un venue en una fecha.
     *
     * Query esperada:
     *
     * SELECT * FROM venue_trends
     * WHERE venue_id = ?
     * AND date = ?;
     */
    public void getHourlyHeatmap(String venueId, String date) {
        System.out.println("Obteniendo heatmap horario...");
        System.out.println("Venue ID: " + venueId);
        System.out.println("Fecha: " + date);
    }
}