-- RF-03: Catálogo de insumos. Primera tabla del esquema (Fase 2).
-- Las reglas de negocio se protegen desde la base de datos (ver
-- docs/05-diseno/lineamientos-base-de-datos.md).

CREATE TABLE insumos (
    id              CHAR(36)       NOT NULL,
    nombre          VARCHAR(120)   NOT NULL,
    existencia      INT            NOT NULL,
    precio_unitario DECIMAL(12, 2) NOT NULL,
    CONSTRAINT pk_insumos PRIMARY KEY (id),
    CONSTRAINT uq_insumos_nombre UNIQUE (nombre),
    CONSTRAINT ck_insumos_existencia_no_negativa CHECK (existencia >= 0),
    CONSTRAINT ck_insumos_precio_no_negativo CHECK (precio_unitario >= 0)
);
