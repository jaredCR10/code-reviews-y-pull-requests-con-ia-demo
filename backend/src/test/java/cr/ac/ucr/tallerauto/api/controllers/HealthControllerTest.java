package cr.ac.ucr.tallerauto.api.controllers;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import cr.ac.ucr.tallerauto.health.DatabaseHealthProbe;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

/**
 * Verifica el contrato de readiness del endpoint de salud. La sonda de base de
 * datos se reemplaza por un mock para probar los dos desenlaces sin depender de
 * una base de datos real.
 */
@SpringBootTest
@AutoConfigureMockMvc
class HealthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private DatabaseHealthProbe databaseHealthProbe;

    @Test
    void respondeUpY200CuandoLaBaseDeDatosEstaDisponible() throws Exception {
        when(databaseHealthProbe.isDatabaseUp()).thenReturn(true);

        mockMvc.perform(get("/api/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"))
                .andExpect(jsonPath("$.service").value("tallerauto-backend"))
                .andExpect(jsonPath("$.database").value("UP"));
    }

    @Test
    void respondeDownY503CuandoLaBaseDeDatosNoResponde() throws Exception {
        when(databaseHealthProbe.isDatabaseUp()).thenReturn(false);

        mockMvc.perform(get("/api/health"))
                .andExpect(status().isServiceUnavailable())
                .andExpect(jsonPath("$.status").value("DOWN"))
                .andExpect(jsonPath("$.service").value("tallerauto-backend"))
                .andExpect(jsonPath("$.database").value("DOWN"));
    }
}
