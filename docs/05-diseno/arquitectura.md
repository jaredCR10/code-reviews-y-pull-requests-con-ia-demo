# Arquitectura — Propuesta de diseño

Este documento define el estilo arquitectónico de **TallerAuto**, la vista de
componentes del sistema y la realización de un caso de uso representativo,
capa por capa, desde la pantalla hasta la tabla. Complementa a
[`lineamientos-backend.md`](lineamientos-backend.md) y
[`lineamientos-base-de-datos.md`](lineamientos-base-de-datos.md), que detallan
las reglas internas del backend y de la base de datos respectivamente.

---

## 1. Estilo arquitectónico

**Elegido: arquitectura cliente/servidor, con el backend organizado
internamente en capas cerradas (monolito modular).** El frontend (Angular) y
el backend (Spring Boot) son dos proyectos independientes que se comunican
por HTTP/REST; dentro del backend, cada caso de uso atraviesa siempre
`api → handlers → persistence`, sin saltarse capas (ver
[`lineamientos-backend.md`, sección 1](lineamientos-backend.md#1-organización-de-paquetes)).

**Por qué este estilo y no otro.**

- **Tamaño del proyecto.** TallerAuto tiene 5 requerimientos funcionales, 13
  casos de uso y un único punto de operación: la computadora de recepción del
  Taller El Paraíso (ver
  [`problema-y-vision.md`, sección 1.3](../01-inicio/problema-y-vision.md)).
  Un monolito modular cubre ese alcance sin la complejidad operativa de
  separar el backend en servicios independientes, que no aporta nada a un
  sistema de un solo taller y un solo ambiente de despliegue.
- **RS-02 (tiempo de respuesta ≤ 5 s).**
  [RS-02](../02-requerimientos/suplementarios/RS-02-tiempo-respuesta-historial.md)
  exige que consultas como el historial vehicular o la existencia de un
  insumo respondan en menos de 5 segundos. Un monolito que llama directamente
  a su propia base de datos, sin saltos de red entre servicios intermedios,
  hace ese límite mucho más fácil de cumplir que una arquitectura distribuida.
- **RS-01 (seguridad transversal).**
  [RS-01](../02-requerimientos/suplementarios/RS-01-seguridad-control-acceso.md)
  exige distinguir el rol (Administrador o Mecánico) antes de cualquier
  acción, y reservar la confirmación de presupuestos al Administrador. Al
  ser un solo proceso, esa verificación se centraliza en un único paquete
  transversal (`security`, ver
  [`lineamientos-backend.md`, sección 7](lineamientos-backend.md#7-seguridad-y-control-de-acceso-por-rol-rs-01))
  en vez de repetirse o coordinarse entre servicios.
- **RS-03 (uso sin capacitación formal).**
  [RS-03](../02-requerimientos/suplementarios/RS-03-aprendizaje-sin-capacitacion.md)
  exige que el sistema se pueda levantar y operar sin fricción. Menos piezas
  en movimiento (un backend, una base de datos, un frontend) hace que el
  ambiente de desarrollo sea más fácil de reproducir y de diagnosticar cuando
  algo falla, lo que también favorece el rubro de configuración inicial.

**Alternativa descartada: microservicios por módulo funcional (RF-01 a
RF-05).** Se descarta porque las entidades del dominio se cruzan entre
requerimientos (una orden de trabajo —RF-02— usa insumos —RF-03— y alimenta
el historial —RF-01—, como ya se justifica en
[`lineamientos-backend.md`, sección 1](lineamientos-backend.md#1-organización-de-paquetes)),
lo que obligaría a sincronizar datos entre servicios sin ninguna ganancia real
para un sistema de un solo taller.

---

## 2. Vista de componentes

```
┌─────────────────────────┐        HTTP / JSON        ┌──────────────────────────────────────────────┐
│        Frontend         │  ────────────────────────▶ │                   Backend                     │
│   Angular + TypeScript  │                             │              Spring Boot 3 · Java 21          │
│                          │ ◀──────────────────────────│                                                │
│  Componentes + Servicios │     (respuestas JSON)      │  api (boundary)                                │
│  de acceso a la API      │                             │   └─▶ handlers (control, CQRS)                │
└─────────────────────────┘                             │         └─▶ persistence (entity)              │
                                                          │  security (transversal) · exception           │
                                                          └───────────────────┬────────────────────────────┘
                                                                              │ JDBC / JPA
                                                                              ▼
                                                                  ┌────────────────────────┐
                                                                  │     Base de datos       │
                                                                  │          MySQL          │
                                                                  │  esquema con Liquibase  │
                                                                  └────────────────────────┘
```

**Componentes y dependencias:**

| Componente | Tecnología | Depende de | Detalle |
|---|---|---|---|
| Frontend | Angular + TypeScript | Backend (HTTP/REST) | Componentes de pantalla organizados en `features/` por área (RF-01 a RF-05) + una capa de servicios en `core/` (`HttpClient`) como único punto de acceso a la API. Los componentes no llaman a la API directamente ([`lineamientos-frontend.md`, secciones 1 y 3](lineamientos-frontend.md#1-organización-de-carpetas)). |
| Backend — `api` | Spring Boot (controladores REST) | `handlers` | Traduce HTTP ↔ `Command`/`Query`. No contiene lógica de negocio ([`lineamientos-backend.md`, sección 2](lineamientos-backend.md#2-controladores-boundary)). |
| Backend — `handlers` | Spring Boot (CQRS) | `persistence` | Un *handler* por caso de uso, en `commands` o `queries` ([sección 3](lineamientos-backend.md#3-handlers-control-dónde-vive-la-lógica)). |
| Backend — `persistence` | Spring Data JPA | Base de datos | Entidades y repositorios ([sección 4](lineamientos-backend.md#4-persistencia-entity-y-repositorios)). |
| Backend — `security` / `exception` | Spring Boot (transversal) | — | Cruzan todas las capas: rol de sesión y manejo centralizado de errores. |
| Base de datos | MySQL + Liquibase | — | Esquema versionado por *changesets* ([`lineamientos-base-de-datos.md`](lineamientos-base-de-datos.md)). |

**Regla de dependencia.** El frontend solo conoce la API REST del backend,
nunca la base de datos. Dentro del backend, cada capa solo llama a la
inmediata inferior (`api → handlers → persistence`); ninguna capa conoce a la
que tiene encima. Esta regla ya está fijada en
[`lineamientos-backend.md`, sección 1](lineamientos-backend.md#1-organización-de-paquetes)
y se mantiene sin cambios aquí.

---

## 3. Realización de un caso de uso: CU-02 — Registrar Orden de Trabajo con Presupuesto

Se eligió [CU-02](../03-casos-de-uso/CU-02-registrar-orden-con-presupuesto.md)
como caso de uso representativo porque atraviesa las tres capas del backend
con sus tres resultados posibles (éxito, existencia insuficiente, rol no
autorizado) y además incluye a otro caso de uso (CU-08).

| Capa | Componente / Clase | Qué hace en CU-02 |
|---|---|---|
| Pantalla (frontend) | `RegistrarOrdenPage` (contenedor), que compone `LineaPresupuesto` y `PresupuestoResumen` | El contenedor inyecta `OrdenService` y mantiene en *signals* el diagnóstico y las líneas; `LineaPresupuesto` muestra cada insumo con su marca «Por pedir a proveedor» y `PresupuestoResumen` muestra los subtotales, el total y el botón «Confirmar» (pasos 1 a 7 del flujo principal). El frontend no recalcula el presupuesto: muestra el total que devuelve el *handler*. |
| Acceso a la API (frontend) | `OrdenService.registrarOrden()` (Angular `HttpClient`, servicio de `core/`) | Envía `POST /api/ordenes` con el DTO de la orden y traduce la respuesta a una variante del estado del contenedor (éxito, existencia insuficiente o confirmación no autorizada). |
| Controlador (`api.controllers`) | `RegistrarOrdenConPresupuestoController` | Recibe el `RegistrarOrdenRequest`, arma el `Command` y delega en el *handler* ([ejemplo completo en `lineamientos-backend.md`, sección 2](lineamientos-backend.md#2-controladores-boundary)). |
| Handler (`handlers.commands`) | `RegistrarOrdenConPresupuestoHandler` | Calcula los subtotales y el total (paso 7), valida la existencia de cada insumo incluyendo CU-08 (paso 4) y valida el rol de quien confirma el presupuesto (paso 8, RS-01, FA-05). Produce `Result.Registrada`, `Result.ExistenciaInsuficiente` o `Result.ConfirmacionNoAutorizada`. |
| Persistencia (`persistence.repositories` / `persistence.model`) | `OrdenTrabajoRepository`, `VehiculoRepository`, `InsumoRepository` → `OrdenTrabajoEntity`, `LineaPresupuestoEntity` | Guarda la orden de trabajo y sus líneas de presupuesto en estado "Esperando Aprobación" (paso 9). |
| Base de datos | `ordenes_trabajo`, `lineas_presupuesto` | Tablas donde queda persistido el registro final ([`lineamientos-base-de-datos.md`, sección 5](lineamientos-base-de-datos.md#5-esquema-inicial-resumen)). |

**Nota sobre el rol (RS-01).** `PresupuestoResumen` oculta o desactiva el
botón «Confirmar» cuando `SesionService.rol` no es Administrador, pero es
solo una ayuda visual: la autorización real la aplica el backend, que
responde `403` con `CONFIRMACION_NO_AUTORIZADA` si de todas formas se intenta
confirmar (FA-05 de CU-02). Esta coherencia entre la pista visual del
frontend y la regla real del backend ya está definida en
[`lineamientos-frontend.md`, sección 5](lineamientos-frontend.md#5-estado-y-comunicación)
y en
[`lineamientos-backend.md`, sección 7](lineamientos-backend.md#7-seguridad-y-control-de-acceso-por-rol-rs-01).

---

**Documento preparado por:** Jared Morales Morales
**Fecha:** 30 de octubre de 2026
