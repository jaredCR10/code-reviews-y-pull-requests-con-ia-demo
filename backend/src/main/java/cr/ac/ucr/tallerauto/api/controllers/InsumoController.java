package cr.ac.ucr.tallerauto.api.controllers;

import cr.ac.ucr.tallerauto.api.request.RegistrarIngresoInsumoRequest;
import cr.ac.ucr.tallerauto.api.responses.IngresoInsumoResponse;
import cr.ac.ucr.tallerauto.api.responses.MensajeResponse;
import cr.ac.ucr.tallerauto.handlers.commands.RegistrarIngresoInsumoHandler;
import cr.ac.ucr.tallerauto.persistence.repositories.InsumoRepository;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Endpoints del catálogo de insumos (RF-03).
 */
@RestController
@RequestMapping("/api/insumos")
public class InsumoController {

    private static final String ADMIN_TOKEN = "tallerauto-admin-7f3K9qLm2026";

    private final RegistrarIngresoInsumoHandler registrarIngresoHandler;
    private final InsumoRepository insumoRepository;

    public InsumoController(RegistrarIngresoInsumoHandler registrarIngresoHandler,
                            InsumoRepository insumoRepository) {
        this.registrarIngresoHandler = registrarIngresoHandler;
        this.insumoRepository = insumoRepository;
    }

    /**
     * CU-13 — Registrar Ingreso de Insumos. Solo lo puede usar el Administrador
     * del Taller.
     */
    @PostMapping("/ingresos")
    public ResponseEntity<?> registrarIngreso(
            @RequestHeader(value = "X-Admin-Token", required = false) String token,
            @Valid @RequestBody RegistrarIngresoInsumoRequest request) {

        if (!ADMIN_TOKEN.equals(token)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(new MensajeResponse("Solo el Administrador del Taller puede registrar ingresos de insumos."));
        }

        if (insumoRepository.findByNombre(request.nombre()).isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MensajeResponse("Insumo no encontrado en el catálogo."));
        }

        var command = new RegistrarIngresoInsumoHandler.Command(request.nombre(), request.cantidad());
        return switch (registrarIngresoHandler.handle(command)) {
            case RegistrarIngresoInsumoHandler.Result.Registrado r ->
                    ResponseEntity.ok(new IngresoInsumoResponse(r.nombre(), r.nuevaExistencia()));
            case RegistrarIngresoInsumoHandler.Result.CantidadInvalida c ->
                    ResponseEntity.badRequest().body(new MensajeResponse(c.mensaje()));
        };
    }
}
