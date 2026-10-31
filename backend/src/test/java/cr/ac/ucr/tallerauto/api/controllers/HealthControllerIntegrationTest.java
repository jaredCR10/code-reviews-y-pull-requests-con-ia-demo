package cr.ac.ucr.tallerauto.api.controllers;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

/**
 * Prueba de integración del endpoint de salud con la sonda <em>real</em> (sin
 * mock) contra la base de datos de pruebas (H2). Ejercita de verdad el camino
 * {@code DatabaseHealthProbe.isDatabaseUp()} → conexión válida → {@code 200 OK},
 * que las pruebas con mock no cubren.
 */
@SpringBootTest
@AutoConfigureMockMvc
class HealthControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void readinessResponde200YUpConLaSondaRealContraLaBaseDeDatos() throws Exception {
        mockMvc.perform(get("/api/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"))
                .andExpect(jsonPath("$.service").value("tallerauto-backend"))
                .andExpect(jsonPath("$.database").value("UP"));
    }
}
