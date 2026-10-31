package cr.ac.ucr.tallerauto.persistence.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

/**
 * Entidad JPA del catálogo de insumos (RF-03). Se corresponde con la tabla
 * {@code insumos} creada por el changeset 001 de Liquibase.
 *
 * <p>El identificador es UUID almacenado como CHAR(36) para que sea legible al
 * inspeccionar la base de datos; {@link JdbcTypeCode} lo mapea a CHAR.</p>
 */
@Entity
@Table(name = "insumos")
public class InsumoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @JdbcTypeCode(SqlTypes.CHAR)
    @Column(name = "id", length = 36, nullable = false, updatable = false)
    private UUID id;

    @Column(name = "nombre", nullable = false, unique = true, length = 120)
    private String nombre;

    @Column(name = "existencia", nullable = false)
    private int existencia;

    @Column(name = "precio_unitario", nullable = false, precision = 12, scale = 2)
    private BigDecimal precioUnitario;

    /** Requerido por JPA. */
    protected InsumoEntity() {
    }

    public InsumoEntity(String nombre, int existencia, BigDecimal precioUnitario) {
        this.nombre = nombre;
        this.existencia = existencia;
        this.precioUnitario = precioUnitario;
    }

    public UUID getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public int getExistencia() {
        return existencia;
    }

    public BigDecimal getPrecioUnitario() {
        return precioUnitario;
    }
}
