package com.cache.api.dto;

import com.fasterxml.jackson.annotation.JsonInclude;

// shape de notificación — alineado con el tipo Notification del frontend (lib/api.ts)
// campos null se omiten para no romper los normalizers opcionales del front
@JsonInclude(JsonInclude.Include.NON_NULL)
public record NotificationResponse(
        String id,
        String kind,   // friend-joined | live | urgent | recommend | system
        String tag,
        String time,
        String body,
        String sub,
        Boolean unread,
        Avatar avatar,
        String icon,   // fire | spark | pin
        String cta,
        String cta2,
        String group,
        // entidad referida: eventId (pings de evento) o userId del solicitante
        // (pings de solicitud de amistad). el front lo usa para navegar/aceptar.
        String refId
) {
    public record Avatar(String name, String color) {}
}
