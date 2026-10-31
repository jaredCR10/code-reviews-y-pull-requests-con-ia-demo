package cr.ac.ucr.tallerauto.health;

import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;
import org.springframework.stereotype.Component;

/**
 * Sonda de disponibilidad de la base de datos para el endpoint de salud
 * (readiness). Vive fuera del controlador para que este se mantenga delgado:
 * el controlador solo traduce el resultado a HTTP, la sonda hace el chequeo.
 */
@Component
public class DatabaseHealthProbe {

    /** Segundos máximos que se espera a que la conexión confirme que es válida. */
    private static final int VALIDATION_TIMEOUT_SECONDS = 2;

    private final DataSource dataSource;

    public DatabaseHealthProbe(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * Indica si la base de datos acepta conexiones. Toma una conexión del pool y
     * la valida; cualquier fallo se traduce en {@code false} sin propagar la
     * excepción, porque la salud es un estado que se consulta, no un error que
     * se lanza.
     *
     * @return {@code true} si la conexión responde dentro del tiempo límite
     */
    public boolean isDatabaseUp() {
        try (Connection connection = dataSource.getConnection()) {
            return connection.isValid(VALIDATION_TIMEOUT_SECONDS);
        } catch (SQLException ex) {
            return false;
        }
    }
}
