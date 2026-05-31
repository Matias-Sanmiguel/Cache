# Export MongoDB Local - Proyecto CACHÉ

Base de datos local utilizada para el TPO de Ingeniería de Datos II.

## Motor utilizado

MongoDB local  
Base de datos: `cache_db`

## Colecciones exportadas

- `users`
- `venues`
- `events`

## Archivos incluidos

- `users.json`: usuarios de prueba
- `venues.json`: venues/boliches/locales
- `events.json`: eventos asociados a venues

## Comandos usados para exportar

```bash
mongoexport --db cache_db --collection users --out users.json --jsonArray
mongoexport --db cache_db --collection venues --out venues.json --jsonArray
mongoexport --db cache_db --collection events --out events.json --jsonArray
