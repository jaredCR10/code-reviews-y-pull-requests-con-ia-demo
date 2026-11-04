package cr.ac.ucr.tallerauto.handlers.commands;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import cr.ac.ucr.tallerauto.persistence.model.InsumoEntity;
import cr.ac.ucr.tallerauto.persistence.repositories.InsumoRepository;
import java.math.BigDecimal;
import java.util.Optional;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

/**
 * Escenarios de prueba de CU-13 (ver docs/03-casos-de-uso/CU-13).
 */
@ExtendWith(MockitoExtension.class)
class RegistrarIngresoInsumoHandlerImplTest {

    @Mock
    private InsumoRepository insumoRepository;

    @InjectMocks
    private RegistrarIngresoInsumoHandlerImpl handler;

    @Test
    void sumaLaCantidadRecibidaALaExistencia() {
        InsumoEntity aceite = new InsumoEntity("Aceite 10W-30", 8, new BigDecimal("6500.00"));
        when(insumoRepository.findByNombre("Aceite 10W-30")).thenReturn(Optional.of(aceite));

        var resultado = handler.handle(new RegistrarIngresoInsumoHandler.Command("Aceite 10W-30", 12));

        assertThat(resultado).isEqualTo(new RegistrarIngresoInsumoHandler.Result.Registrado("Aceite 10W-30", 20));
        verify(insumoRepository).save(aceite);
    }

    @Test
    void rechazaUnaCantidadNegativa() {
        var resultado = handler.handle(new RegistrarIngresoInsumoHandler.Command("Aceite 10W-30", -5));

        assertThat(resultado).isEqualTo(new RegistrarIngresoInsumoHandler.Result.CantidadInvalida(
                "La cantidad debe ser un número entero mayor que cero."));
        verify(insumoRepository, never()).save(org.mockito.ArgumentMatchers.any());
    }
}
