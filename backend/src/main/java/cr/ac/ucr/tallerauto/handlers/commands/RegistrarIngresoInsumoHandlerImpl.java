package cr.ac.ucr.tallerauto.handlers.commands;

import cr.ac.ucr.tallerauto.persistence.model.InsumoEntity;
import cr.ac.ucr.tallerauto.persistence.repositories.InsumoRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implementación de CU-13. Valida la cantidad, suma el ingreso a la existencia
 * del insumo y devuelve la nueva existencia.
 */
@Service
public class RegistrarIngresoInsumoHandlerImpl implements RegistrarIngresoInsumoHandler {

    private static final String MENSAJE_CANTIDAD_INVALIDA =
            "La cantidad debe ser un número entero mayor a cero.";

    private final InsumoRepository insumoRepository;

    public RegistrarIngresoInsumoHandlerImpl(InsumoRepository insumoRepository) {
        this.insumoRepository = insumoRepository;
    }

    @Override
    @Transactional
    public Result handle(Command command) {
        if (command.cantidad() < 0) {
            return new Result.CantidadInvalida(MENSAJE_CANTIDAD_INVALIDA);
        }

        InsumoEntity insumo = insumoRepository.findByNombre(command.nombre()).orElseThrow();
        insumo.registrarIngreso(command.cantidad());
        insumoRepository.save(insumo);

        return new Result.Registrado(insumo.getNombre(), insumo.getExistencia());
    }
}
