package cr.ac.ucr.tallerauto.persistence.repositories;

import cr.ac.ucr.tallerauto.persistence.model.InsumoEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Repositorio Spring Data del catálogo de insumos. Expone intención de negocio
 * mediante métodos derivados, sin SQL explícito. Lo usará el handler de CU-08
 * (Consultar Existencia de Insumo) en el PC3.
 */
public interface InsumoRepository extends JpaRepository<InsumoEntity, UUID> {

    Optional<InsumoEntity> findByNombre(String nombre);
}
