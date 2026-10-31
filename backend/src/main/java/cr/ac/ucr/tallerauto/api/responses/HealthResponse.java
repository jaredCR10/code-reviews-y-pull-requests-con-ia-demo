package cr.ac.ucr.tallerauto.api.responses;

/**
 * DTO de salida del endpoint de salud. Es un record inmutable, exclusivo de la
 * capa api, como establecen los lineamientos de backend.
 *
 * <p>Desde la Fase 3 el endpoint es de <em>readiness</em>: además del estado del
 * servicio reporta el de la base de datos. Contrato: cuando {@code database} es
 * {@code "UP"} el endpoint responde {@code 200 OK}; cuando es {@code "DOWN"},
 * {@code 503 Service Unavailable}.</p>
 */
public record HealthResponse(String status, String service, String database) {
}
