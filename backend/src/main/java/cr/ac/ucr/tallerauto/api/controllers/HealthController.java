package cr.ac.ucr.tallerauto.api.controllers;

import cr.ac.ucr.tallerauto.api.responses.HealthResponse;
import cr.ac.ucr.tallerauto.health.DatabaseHealthProbe;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Endpoint de salud (readiness) usado para verificar que el backend está arriba
 * y conectado a la base de datos, y desde el frontend (Persona 2) para probar la
 * integración.
 *
 * <p>Desde la Fase 3 el endpoint comprueba la conexión a la base de datos
 * mediante {@link DatabaseHealthProbe}. El controlador no hace el chequeo: solo
 * traduce su resultado a HTTP, respetando los lineamientos (controlador
 * delgado, sin lógica ni acceso directo a datos).</p>
 */
@RestController
@RequestMapping("/api")
public class HealthController {

    private static final String SERVICE_NAME = "tallerauto-backend";
    private static final String STATUS_UP = "UP";
    private static final String STATUS_DOWN = "DOWN";

    private final DatabaseHealthProbe databaseHealthProbe;

    public HealthController(DatabaseHealthProbe databaseHealthProbe) {
        this.databaseHealthProbe = databaseHealthProbe;
    }

    /**
     * Responde el estado de readiness del backend.
     *
     * <ul>
     *   <li>BD disponible → {@code 200 OK} con {@code status} y {@code database}
     *       en {@code "UP"}.</li>
     *   <li>BD no disponible → {@code 503 Service Unavailable} con ambos en
     *       {@code "DOWN"}.</li>
     * </ul>
     */
    @GetMapping("/health")
    public ResponseEntity<HealthResponse> health() {
        boolean databaseUp = databaseHealthProbe.isDatabaseUp();
        String estado = databaseUp ? STATUS_UP : STATUS_DOWN;
        HealthResponse body = new HealthResponse(estado, SERVICE_NAME, estado);
        HttpStatus httpStatus = databaseUp ? HttpStatus.OK : HttpStatus.SERVICE_UNAVAILABLE;
        return ResponseEntity.status(httpStatus).body(body);
    }
}
