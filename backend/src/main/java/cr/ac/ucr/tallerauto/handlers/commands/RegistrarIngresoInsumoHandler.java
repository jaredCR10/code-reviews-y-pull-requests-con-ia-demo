package cr.ac.ucr.tallerauto.handlers.commands;

/**
 * CU-13 — Registrar Ingreso de Insumos (RF-03). Suma la cantidad recibida a la
 * existencia de un insumo del catálogo.
 */
public interface RegistrarIngresoInsumoHandler {

    Result handle(Command command);

    /** Insumo recibido y cantidad que ingresa al inventario. */
    record Command(String nombre, int cantidad) {
    }

    /** Desenlaces posibles del caso de uso. */
    sealed interface Result {

        /** Flujo principal: el ingreso se registró. */
        record Registrado(String nombre, int nuevaExistencia) implements Result {
        }

        /** FA-02: la cantidad no es válida. */
        record CantidadInvalida(String mensaje) implements Result {
        }
    }
}
