# Lineamientos de diseño — Backend

Estas son las reglas que el grupo se compromete a seguir al construir el backend
de **TallerAuto** en el PC3. No son teoría transcrita: cada regla se acompaña de
un ejemplo tomado de un caso de uso real del proyecto. El estilo sigue la
arquitectura de referencia del curso (Spring Boot + CQRS, clases *boundary*,
*control* y *entity*, capas cerradas, SOLID).

> **Stack fijado.** Spring Boot 3, Java 21, Maven, base de datos MySQL con
> migraciones Liquibase. El detalle de arranque está en
> [`../06-configuracion/ambiente-de-desarrollo.md`](../06-configuracion/ambiente-de-desarrollo.md);
> las convenciones de datos, en
> [`lineamientos-base-de-datos.md`](lineamientos-base-de-datos.md).

---

## 1. Organización de paquetes

El backend se organiza **por capa**. Cada caso de uso atraviesa las capas de
arriba hacia abajo, y ninguna capa conoce a la que tiene encima.

```
cr.ac.ucr.tallerauto
├── api                 → capa REST (boundary)
│   ├── controllers         → @RestController; sin lógica de negocio
│   ├── request             → DTOs de entrada (records)
│   └── responses           → DTOs de salida + ErrorResponse (records)
├── handlers            → capa de aplicación / CQRS (control)
│   ├── commands            → un handler por caso de uso que escribe
│   └── queries             → un handler por caso de uso que lee
├── persistence         → capa de datos (entity)
│   ├── model               → entidades JPA (id UUID)
│   └── repositories        → interfaces Spring Data
├── exception           → BusinessException + ErrorCode (solo rollback)
└── security            → control de acceso por rol (transversal, RS-01)
```

**Por qué por capa y no por módulo funcional.** TallerAuto tiene 5
requerimientos funcionales y 13 casos de uso: un tamaño en el que una sola
partición por capa se lee de un vistazo y evita duplicar la estructura de
carpetas cinco veces. Las entidades, además, se cruzan entre requerimientos (una
orden de trabajo —RF-02— usa insumos —RF-03— y alimenta el historial —RF-01—),
así que una partición por módulo obligaría a decidir arbitrariamente a qué módulo
"pertenece" cada clase compartida. `security` queda fuera de las tres capas
porque es una preocupación transversal: aplica a casi todos los casos de uso
(RS-01) sin pertenecer a ninguno.

**Regla de dependencia (capas cerradas).** El flujo de llamadas es siempre
`api → handlers → persistence`. Una capa solo llama a la inmediata inferior:
`api` nunca accede a `persistence.repositories` directamente, y `persistence`
nunca conoce a `handlers` ni a `api`.

---

## 2. Controladores (*boundary*)

Un controlador traduce entre el mundo HTTP y el mundo de los *handlers*. No hace
nada más.

**Qué hacen:**

- Reciben la petición HTTP y la validan (ver más abajo).
- Construyen el `Command` o `Query` del caso de uso.
- Invocan al *handler* **a través de su interfaz** (nunca de la implementación).
- Traducen el `Result` del *handler* a una respuesta HTTP con un `switch`
  exhaustivo.

**Qué tienen prohibido:**

- Contener reglas de negocio (cálculos, validaciones de dominio, decisiones).
- Acceder a un repositorio o a una entidad JPA.
- Devolver una entidad JPA. Solo devuelven DTOs de `api.responses`.

**Ejemplo propio (CU-02 — Registrar Orden con Presupuesto).** El
`RegistrarOrdenConPresupuestoController` recibe el DTO con el diagnóstico, los
insumos y la mano de obra, arma el `Command` y delega en
`RegistrarOrdenConPresupuestoHandler`. **No** calcula el total del presupuesto
(eso es regla de negocio, vive en el *handler*) ni consulta la existencia del
insumo (eso es CU-08, otro *handler*). Según el `Result` que recibe, responde:

| `Result` del handler | Respuesta HTTP |
|---|---|
| `Registrada(ordenId)` | `200 OK` con el id de la orden |
| `ExistenciaInsuficiente(insumo, disponible)` | `409 Conflict` con el mensaje "Existencia insuficiente. Disponible: X" (FA-01) |
| `ConfirmacionNoAutorizada` | `403 Forbidden` "Solo el rol Administrador puede confirmar el presupuesto." (FA-05 / RS-01) |

```java
@PostMapping("/ordenes")
public ResponseEntity<?> registrar(@Valid @RequestBody RegistrarOrdenRequest req) {
    var command = new RegistrarOrdenConPresupuestoHandler.Command(
            req.vehiculoId(), req.diagnostico(), req.lineasInsumo(), req.manoDeObra());
    var correlationId = SessionContextHolder.getSession().correlationId();
    return switch (handler.handle(command)) {
        case Result.Registrada r ->
                ResponseEntity.ok(new OrdenResponse(r.ordenId(), r.total(), r.estado()));
        case Result.ExistenciaInsuficiente e ->
                ResponseEntity.status(CONFLICT).body(
                        ErrorResponse.of(ErrorCode.EXISTENCIA_INSUFICIENTE, correlationId,
                                e.insumo(), String.valueOf(e.disponible())));
        case Result.ConfirmacionNoAutorizada ignored ->
                ResponseEntity.status(FORBIDDEN).body(
                        ErrorResponse.of(ErrorCode.CONFIRMACION_NO_AUTORIZADA, correlationId));
    };
}
```

**Validación de entradas.** Se valida en el borde, con Bean Validation
(`@NotNull`, `@NotBlank`, `@Positive`, `@Valid`) sobre el DTO de `request`,
activado con `@Valid` en el controlador. Esto cubre validaciones de **forma**
(campo requerido, cantidad positiva). Las validaciones de **negocio** (existe el
vehículo, hay existencia suficiente) no van aquí: son del *handler* y se
devuelven como variantes del `Result`.

**Convención de endpoints.** Rutas en plural y en minúsculas, por recurso:
`POST /api/ordenes`, `GET /api/vehiculos/{placa}/historial`,
`GET /api/insumos/{id}/existencia`, `POST /api/insumos/{id}/ingresos`. Lo público
cuelga de `/api/public/**`; lo que exige sesión, de `/api/**` autenticado (ver
sección 7).

---

## 3. *Handlers* (*control*): dónde vive la lógica

**Decisión del grupo: un *handler* por caso de uso (CQRS), no un servicio por
entidad.** Se sigue la arquitectura de referencia del curso. No existe un paquete
`service` genérico: la lógica de cada caso de uso vive en su propio *handler*.

- Cada caso de uso es **una interfaz** con su `Command` (si escribe) o `Query`
  (si lee) y su `Result` *sealed* anidados en el mismo archivo. Al abrir el
  archivo se ve el contrato completo del caso de uso: qué entra, qué sale y todos
  los resultados posibles.
- Su implementación (`*Impl`, anotada `@Component`, con **un** método público) es
  el componente de negocio.
- Los comandos (escriben) van en `handlers.commands`; las consultas (leen) en
  `handlers.queries`. Un caso de uso es comando **o** consulta, nunca ambos.

**Por qué por caso de uso y no por entidad.** Un `OrdenService` que concentrara
"todo lo de órdenes" acumularía registrar la orden (CU-02), asociar insumos
(CU-03), aprobar presupuesto (CU-10), cerrar la orden (CU-11) y registrar el
cobro (CU-12) en una sola clase con cinco motivos para cambiar. Un *handler* por
caso de uso respeta el Principio de Responsabilidad Única (SRP) y el de
Segregación de Interfaces (ISP): cada interfaz declara exactamente un método,
para un único caso de uso.

**Reparto de los 13 CU:**

| `handlers.commands` (escriben) | `handlers.queries` (leen) |
|---|---|
| CU-02 RegistrarOrdenConPresupuesto | CU-01 ConsultarHistorialVehicular |
| CU-03 AsociarInsumoAOrden | CU-08 ConsultarExistenciaDeInsumo |
| CU-04 AgendarCitaDeMantenimiento | CU-09 ConsultarEstadoDeVehiculo |
| CU-05 ActualizarEstadoDeVehiculo | |
| CU-06 RegistrarVehiculo | |
| CU-07 RegistrarLlegadaSinCita | |
| CU-10 RegistrarAprobacionDePresupuesto | |
| CU-11 RegistrarServicioYCerrarOrden | |
| CU-12 RegistrarCobroFinal | |
| CU-13 RegistrarIngresoDeInsumos | |

**Resultados tipados en vez de excepciones para el flujo normal.** Los desenlaces
de negocio esperados (éxito, conflicto, no encontrado, no autorizado) se modelan
como variantes del `Result` *sealed* y se consumen con un `switch` exhaustivo
—nunca con excepciones ni `null`—. Como el `Result` es *sealed*, el compilador
conoce todas sus variantes: si se agrega una nueva sin manejarla en algún
`switch`, **el proyecto no compila**. La exhaustividad la garantiza el compilador,
no la disciplina del equipo.

**Ejemplo propio (CU-02).** Las tres salidas del CU-02 son variantes del
`Result`, no excepciones:

```java
public interface RegistrarOrdenConPresupuestoHandler {

    Result handle(Command command);

    record Command(UUID vehiculoId, String diagnostico,
                   List<LineaInsumo> lineasInsumo, ManoDeObra manoDeObra) { }

    sealed interface Result {
        record Registrada(UUID ordenId, BigDecimal total, String estado) implements Result { }
        record ExistenciaInsuficiente(String insumo, int disponible) implements Result { }
        record ConfirmacionNoAutorizada() implements Result { }
    }
}
```

**Las *include* se resuelven por composición de *handlers*.** CU-02 y CU-03
incluyen CU-08 (Consultar Existencia de Insumo). Eso **no** se duplica: el
*handler* de CU-02 depende de la interfaz `ConsultarExistenciaDeInsumoQuery` y la
invoca. Un caso de uso incluido es un *handler* reutilizado, no código copiado.

**Transacciones.** El límite transaccional es el método `handle`/`query` del
*handler*: se anota `@Transactional` ahí, de modo que un caso de uso es una
unidad atómica. Ejemplo: en CU-11 (Registrar Servicio y Cerrar Orden) se agrega
el servicio al expediente **y** se cierra la orden; si lo segundo falla, lo
primero se revierte. Las consultas (`handlers.queries`) se anotan
`@Transactional(readOnly = true)`.

---

## 4. Persistencia (*entity* y repositorios)

- **Entidades JPA** (`persistence.model`): representan las tablas. Identificador
  **UUID** (`@GeneratedValue(strategy = GenerationType.UUID)`), para no depender
  de autoincrementales coordinados entre ambientes. Las entidades de TallerAuto:
  `VehiculoEntity`, `ClienteEntity`, `OrdenTrabajoEntity`,
  `LineaPresupuestoEntity`, `InsumoEntity`, `CitaEntity`, `ServicioEntity`.
- **Repositorios** (`persistence.repositories`): interfaces que extienden
  `JpaRepository<Entity, UUID>`. Spring Data genera la implementación en tiempo
  de ejecución; no se escribe SQL para las operaciones estándar ni para las
  consultas derivadas del nombre del método.

**Qué operaciones exponen (sin revelar implementación).** El repositorio expone
intención de negocio mediante métodos derivados, no SQL. Ejemplos propios:

```java
public interface VehiculoRepository extends JpaRepository<VehiculoEntity, UUID> {
    Optional<VehiculoEntity> findByPlaca(String placa);   // CU-01, CU-06
    boolean existsByPlaca(String placa);                  // CU-06: placa ya registrada
}

public interface InsumoRepository extends JpaRepository<InsumoEntity, UUID> {
    Optional<InsumoEntity> findByNombre(String nombre);   // CU-08: consultar existencia
}
```

**La entidad nunca sale de `persistence`/`handlers`.** El *handler* mapea de la
entidad al `Result` de forma explícita; la entidad no viaja al controlador ni se
serializa a JSON. (El porqué está en la sección 5.)

---

## 5. Objetos de transferencia (DTO)

Cruzan entre capas tres tipos de objetos, todos `record` y todos inmutables:

| Objeto | Paquete | Cruza entre |
|---|---|---|
| `*Request` | `api.request` | HTTP → controlador |
| `*Response` / `ErrorResponse` | `api.responses` | controlador → HTTP |
| `Command` / `Query` / `Result` | anidados en el *handler* | controlador ↔ handler |

**Por qué las entidades no se exponen al frontend.** Si el controlador
devolviera `VehiculoEntity`, el contrato de la API quedaría atado al esquema de
la base de datos: renombrar una columna o agregar una relación JPA (p. ej. la
lista de servicios del expediente) cambiaría el JSON que recibe el frontend, y
se filtrarían al cliente campos internos. Ejemplo propio: CU-09 (Consultar Estado
de Vehículo) devuelve un `EstadoVehiculoResponse(placa, estado, ordenActivaId)`
—justo lo que la pantalla necesita—, no la `VehiculoEntity` completa con su
historial y sus llaves foráneas.

---

## 6. Manejo de errores

Se distinguen dos caminos, y es una decisión de diseño deliberada:

1. **Desenlace de negocio esperado** → variante del `Result` (sección 3). No es
   un error: es una salida prevista del caso de uso. Ejemplo: "existencia
   insuficiente" en CU-02 no es una excepción, es `Result.ExistenciaInsuficiente`.
2. **Fallo real que obliga a deshacer una operación en curso** → se lanza
   `BusinessException` (no verificada) para que `@Transactional` haga *rollback*
   automático.

**Traducción a HTTP en un solo lugar.** Un único `@RestControllerAdvice`
(`GlobalExceptionHandler`) captura `BusinessException` (y sus subtipos por
herencia) y la traduce a un `ErrorResponse` con su `ErrorCode`, su mensaje y el
`correlationId` de la sesión. Ningún controlador individual arma respuestas de
error "a mano": por eso el formato del error es idéntico en toda la API.

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponse> handle(BusinessException ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                ErrorResponse.of(ex.getErrorCode(),
                        SessionContextHolder.getSession().correlationId(),
                        ex.getParams().stream().map(String::valueOf).toArray(String[]::new)));
    }
}
```

Los `ErrorCode` son un `enum` con código y mensaje. Los de TallerAuto se agrupan
por rango: validaciones de forma `1000–1999`, de negocio `2000–2999`, de
seguridad `401`/`403`. Ejemplos propios: `EXISTENCIA_INSUFICIENTE`,
`PLACA_YA_REGISTRADA` (CU-06), `CONFIRMACION_NO_AUTORIZADA` (RS-01).

---

## 7. Seguridad y control de acceso por rol (RS-01)

RS-01 exige identificar el rol (Administrador o Mecánico) antes de cualquier
acción, y reservar la confirmación/ajuste de presupuestos al Administrador. Se
implementa como preocupación transversal en `security`, siguiendo el esquema de
la referencia (JWT): `/api/public/**` abierto (p. ej. autenticación), el resto
autenticado; el usuario actual y su rol se leen de
`SessionContextHolder.getSession()`.

**Dos niveles de autorización:**

- **Por ruta**, para acciones exclusivas de un rol.
- **Dentro del *handler***, cuando la regla depende del estado. Ejemplo propio:
  en CU-02 paso 8, el *handler* comprueba el rol de la sesión y, si es Mecánico,
  devuelve `Result.ConfirmacionNoAutorizada` sin tocar la base de datos (FA-05).

---

## 8. Convenciones de nombres

| Elemento | Convención | Ejemplo propio |
|---|---|---|
| Controlador | `<CasoDeUso>Controller` | `RegistrarOrdenConPresupuestoController` |
| Handler (comando) | `<CasoDeUso>Handler` + `Impl` | `RegistrarVehiculoHandler` / `RegistrarVehiculoHandlerImpl` |
| Handler (consulta) | `<CasoDeUso>Query` + `Impl` | `ConsultarExistenciaDeInsumoQuery` |
| Entidad JPA | `<Nombre>Entity` | `InsumoEntity`, `OrdenTrabajoEntity` |
| Repositorio | `<Nombre>Repository` | `VehiculoRepository` |
| DTO de entrada | `<Accion>Request` | `RegistrarOrdenRequest` |
| DTO de salida | `<Nombre>Response` | `EstadoVehiculoResponse` |
| Endpoint | plural, minúsculas, por recurso | `POST /api/ordenes` |
| Método de handler | `handle` (comando) / `query` (consulta) | — |

**Estilo de código.** Convenciones Sun verificadas con Checkstyle: línea máxima
120, constantes en `UPPER_SNAKE_CASE`, sin *imports* con `*`, sin números mágicos.
Código en inglés para identificadores de framework y en español para los términos
del dominio (`Vehiculo`, `Insumo`, `Orden`), como ya hacen los casos de uso.

---

**Documento preparado por:** _[José A. Ramírez J — Backend y Base de Datos]_
**Fecha:** 23 octubre de 2026
