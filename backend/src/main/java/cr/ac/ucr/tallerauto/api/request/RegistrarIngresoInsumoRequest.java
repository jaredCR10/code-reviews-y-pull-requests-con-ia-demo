package cr.ac.ucr.tallerauto.api.request;

import jakarta.validation.constraints.NotBlank;

/**
 * Datos de entrada de CU-13 (Registrar Ingreso de Insumos): el insumo recibido
 * y la cantidad que se suma a su existencia.
 */
public record RegistrarIngresoInsumoRequest(
        @NotBlank String nombre,
        Integer cantidad) {
}
