# Lineamientos de diseño — Base de datos

Reglas que el grupo se compromete a seguir para la base de datos de
**TallerAuto**. El motor es **MySQL** y los cambios de esquema se versionan con
**Liquibase**. Estos lineamientos complementan los del backend
([`lineamientos-backend.md`](lineamientos-backend.md)): las entidades JPA de
`persistence.model` se corresponden con las tablas descritas aquí.

---

## 1. Motor y justificación

Se eligió **MySQL** (relacional) porque el dominio de TallerAuto es
inherentemente relacional y transaccional: un vehículo tiene un expediente de
servicios, una orden de trabajo agrupa líneas de presupuesto que referencian
insumos, una cita ocupa una rampa en una fecha. Estas relaciones y las reglas que
las protegen (integridad referencial, unicidad de placa, existencia no negativa)
se expresan de forma natural con llaves foráneas y restricciones, y las
operaciones del taller requieren atomicidad (registrar un servicio **y** cerrar
la orden en CU-11). MySQL es maduro, ampliamente documentado y se levanta con
`docker-compose` sin fricción, lo que ayuda a que el proyecto sea reproducible
(rubro 4).

La base de datos se levanta localmente con `docker-compose.yml` en la raíz del
repositorio; los pasos están en
[`../06-configuracion/ambiente-de-desarrollo.md`](../06-configuracion/ambiente-de-desarrollo.md).

---

## 2. Convenciones de nombres

| Elemento | Convención | Ejemplo |
|---|---|---|
| Tabla | `snake_case`, sustantivo **plural** | `vehiculos`, `ordenes_trabajo`, `lineas_presupuesto` |
| Columna | `snake_case`, singular | `placa`, `precio_unitario`, `fecha_ingreso` |
| Llave primaria | `id` | `id` |
| Llave foránea | `<entidad_referida>_id` | `vehiculo_id`, `insumo_id`, `orden_trabajo_id` |
| Restricción UNIQUE | `uq_<tabla>_<columna>` | `uq_vehiculos_placa` |
| Restricción CHECK | `ck_<tabla>_<regla>` | `ck_insumos_existencia_no_negativa` |
| Llave foránea (constraint) | `fk_<tabla>_<tabla_referida>` | `fk_ordenes_trabajo_vehiculos` |
| Índice | `ix_<tabla>_<columna>` | `ix_servicios_vehiculo_id` |

- **Idioma:** los nombres del dominio van en español (`vehiculos`, `insumos`),
  igual que en los casos de uso, para mantener la trazabilidad RF → tabla.
- **Identificadores UUID.** Toda llave primaria es `UUID`, almacenada como
  `BINARY(16)` o `CHAR(36)` según se decida en el changeset inicial, consistente
  con el `@GeneratedValue(strategy = GenerationType.UUID)` de las entidades. No se
  usan autoincrementales, para no depender de secuencias coordinadas entre
  ambientes.
- **No se usa prefijo de carné** en las tablas (a diferencia del proyecto de
  referencia, que lo requería por su hosting compartido). Nuestras tablas llevan
  nombre limpio.

---

## 3. Versionado de cambios mediante migraciones (Liquibase)

Todo cambio de esquema es un **changeset nuevo** de Liquibase. El esquema nunca
se modifica a mano sobre la base corriendo ni con `ddl-auto`: JPA se configura con
`spring.jpa.hibernate.ddl-auto=validate`, de modo que Hibernate solo verifica que
las entidades concuerden con el esquema que creó Liquibase, sin alterarlo.

**Estructura de archivos:**

```
src/main/resources/db/changelog/
├── db.changelog-master.xml          → índice que registra cada changeset en orden
├── 001-crear-tablas-iniciales.sql   → esquema base (vehículos, insumos, órdenes…)
├── 002-datos-semilla.sql            → catálogo de insumos de ejemplo, roles
└── 00N-<cambio>.sql                 → un archivo por cambio posterior
```

El `master` incluye cada changeset con su `id` y `author`:

```xml
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog" ...>
    <changeSet id="1" author="tallerauto">
        <sqlFile path="db/changelog/001-crear-tablas-iniciales.sql"/>
    </changeSet>
    <changeSet id="2" author="tallerauto">
        <sqlFile path="db/changelog/002-datos-semilla.sql"/>
    </changeSet>
</databaseChangeLog>
```

**Reglas de oro:**

- **Un changeset ya aplicado nunca se edita.** Si una tabla debe cambiar, se crea
  un changeset nuevo (`ALTER TABLE …`). Editar uno existente rompe el *checksum*
  que Liquibase guarda en `DATABASECHANGELOG` y hace fallar el arranque.
- **Changesets pequeños y atómicos**, con un solo propósito cada uno, nombrados
  con prefijo numérico incremental.
- Los datos de ejemplo (catálogo de insumos, usuario administrador inicial) van
  en un changeset de **semilla** aparte del de esquema, para poder distinguir
  estructura de datos.

---

## 4. Reglas de negocio protegidas desde la base de datos

Algunas reglas del dominio no se dejan solo al código: se protegen también en el
esquema, para que ninguna ruta (un error del backend, una inserción manual) las
viole. Cada una se origina en un requerimiento del proyecto.

| Regla protegida | Mecanismo | Origen |
|---|---|---|
| **La placa de un vehículo es única.** | `UNIQUE (placa)` → `uq_vehiculos_placa` | RF-01 / CU-06: "placa no registrada" distingue un vehículo de otro |
| **La existencia de un insumo nunca es negativa.** | `CHECK (existencia >= 0)` → `ck_insumos_existencia_no_negativa` | RF-03, criterio de aceptación 3: "la existencia nunca debe quedar negativa" |
| **El precio y la cantidad de una línea de presupuesto son positivos.** | `CHECK (cantidad > 0)`, `CHECK (precio_unitario >= 0)` | RF-02 / CU-02 |
| **Toda orden pertenece a un vehículo existente; toda línea, a una orden; todo servicio, a un vehículo.** | Llaves foráneas con integridad referencial | RF-01, RF-02, RF-03 |
| **El estado de un vehículo / orden toma solo valores válidos.** | Columna con `CHECK` sobre la lista de estados (p. ej. `'Esperando Aprobación'`, `'Aprobado'`, `'En Proceso'`, `'Cerrado'`) | CU-02, CU-05, CU-10, CU-11 |
| **No se agenda dos citas en la misma rampa a la misma hora.** | `UNIQUE (rampa_id, fecha_hora)` | RF-04 / CU-04: planificador de rampas |

**Ejemplo propio (unicidad de placa).** En CU-06 (Registrar Vehículo) el
*handler* consulta `existsByPlaca(...)` y, si ya existe, devuelve
`Result.PlacaYaRegistrada` sin intentar insertar. La restricción
`uq_vehiculos_placa` es la **segunda línea de defensa**: si dos registros
concurrentes pasaran la verificación a la vez, la base de datos rechaza el
segundo `INSERT` y la transacción hace *rollback*. La regla queda garantizada aun
si el código fallara.

---

## 5. Esquema inicial (resumen)

El changeset `001` crea, como mínimo, estas tablas con sus relaciones (el detalle
de columnas se define al implementar):

```
clientes            (id, nombre, contacto)
vehiculos           (id, placa⟐, marca, modelo, anio, cliente_id→clientes, estado)
insumos             (id, nombre, existencia⟳, precio_unitario)
ordenes_trabajo     (id, vehiculo_id→vehiculos, diagnostico, estado, fecha, total)
lineas_presupuesto  (id, orden_trabajo_id→ordenes_trabajo, insumo_id→insumos,
                     cantidad, precio_unitario, por_pedir_a_proveedor)
citas               (id, vehiculo_id→vehiculos, rampa_id, fecha_hora)
servicios           (id, vehiculo_id→vehiculos, fecha, diagnostico, garantia, comentarios)
```

`⟐` = UNIQUE · `⟳` = CHECK (>= 0) · `→` = llave foránea.

> Para el PC2 basta con que el changeset inicial cree al menos una tabla
> relacionada a un RF (la tabla `insumos`, de RF-03, es la que usa el esqueleto
> para el endpoint de prueba). El esquema completo se construye en el PC3 a
> medida que se implementa cada caso de uso, siempre con un changeset nuevo por
> cambio.

---

**Documento preparado por:** _[José A. Ramírez J — Backend y Base de Datos]_
**Fecha:** 23 octubre de 2026
