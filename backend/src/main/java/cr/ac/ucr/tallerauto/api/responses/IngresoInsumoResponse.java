package cr.ac.ucr.tallerauto.api.responses;

/**
 * Respuesta de CU-13: el insumo y su nueva existencia (paso 6 del flujo principal).
 */
public record IngresoInsumoResponse(String nombre, int existencia) {
}
