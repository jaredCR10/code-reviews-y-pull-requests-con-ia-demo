# TallerAuto — Backend

Backend del Sistema de Gestión Integral para Taller Mecánico.
Spring Boot 3 · Java 21 · Maven · MySQL · Liquibase.

## Arranque rápido

Requisitos: **Java 21** y **Docker**. Maven no hace falta: el repo trae el
wrapper `./mvnw` (o córrelo desde IntelliJ).

```bash
# 1. Desde la raíz del repo: levantar MySQL (espera a que quede healthy)
cp .env.example .env
docker compose up -d

# 2. Correr el backend (Windows: mvnw.cmd spring-boot:run)
cd backend
./mvnw spring-boot:run
```

Al arrancar, Liquibase crea el esquema (tabla `insumos`) y lo registra en
`DATABASECHANGELOG`. Verificación:

```bash
curl -i http://localhost:8080/api/health
# 200 OK
# {"status":"UP","service":"tallerauto-backend","database":"UP"}
```

> Las pruebas (`./mvnw test`) corren contra H2 en memoria, así que no necesitan
> MySQL ni docker.

La guía completa de instalación y configuración del ambiente está en
[`../docs/06-configuracion/ambiente-de-desarrollo.md`](../docs/06-configuracion/ambiente-de-desarrollo.md).

## Contrato de `GET /api/health` (readiness · Fase 3)

Endpoint de *readiness*: confirma que el servicio está arriba **y** conectado a
la base de datos. Es el contrato que consume el frontend (Persona 2).

| Situación | HTTP | Cuerpo |
|---|---|---|
| Servicio y BD arriba | `200 OK` | `{"status":"UP","service":"tallerauto-backend","database":"UP"}` |
| BD no responde | `503 Service Unavailable` | `{"status":"DOWN","service":"tallerauto-backend","database":"DOWN"}` |

- El campo `service` se conserva desde la Fase 1 (contrato aditivo); `database`
  es nuevo en la Fase 3.
- El código HTTP refleja el estado: un cliente puede decidir solo con el status
  (200 vs 503) o leer el detalle en el cuerpo.

> **Nota para el frontend (Persona 2 · Angular):** `HttpClient` trata cualquier
> respuesta distinta de 2xx como error, así que con la BD caída (503) verá un
> error genérico. Para distinguir «backend arriba, BD caída» debe manejar el 503
> en `core/health.service.ts` y agregar `database: string` en
> `models/health.model.ts`.

## Problemas frecuentes

**`Access denied for user 'tallerauto'@'localhost'` al arrancar.** La app se está
conectando a *otro* MySQL (uno instalado localmente), no al contenedor. Pasa
cuando el puerto que usa la app no apunta al contenedor. Dos causas típicas:

- **Ya tienes un MySQL local ocupando 3306 (o 3307).** El contenedor no puede
  publicar en un puerto ocupado; elige uno libre en `.env`, por ejemplo
  `DB_PORT=3310`, y recrea el contenedor con `docker compose up -d`.
- **IntelliJ y Maven no leen `.env`.** Ese archivo solo lo lee docker-compose.
  El backend toma `DB_PORT` de las variables de ambiente y, si no está, usa
  `3306` por defecto. Si en `.env` pusiste otro puerto, pásaselo también a la
  app para que coincidan:
  - En IntelliJ: `Run` → `Edit Configurations…` → *Environment variables* →
    `DB_PORT=3310`.
  - Por terminal: `DB_PORT=3310 ./mvnw spring-boot:run`.

> Regla práctica: el `DB_PORT` del `.env` (contenedor) y el de la app deben ser
> el mismo, y ese puerto no debe estar ocupado por otro MySQL. Comprobado con
> `DB_PORT=3310`: `/api/health` responde `200`/`UP`; al detener la BD
> (`docker compose stop mysql`), `503`/`DOWN`; al reiniciarla, vuelve a `200`
> sin reiniciar el backend.

**Java.** El proyecto apunta a Java 21; córrelo con un JDK 21 o superior.

## Estructura (por capa)

Ver [`../docs/05-diseno/lineamientos-backend.md`](../docs/05-diseno/lineamientos-backend.md).

```
cr.ac.ucr.tallerauto
├── api            → capa REST (controllers, request, responses)
├── handlers       → casos de uso CQRS (commands, queries)   [PC3]
├── persistence    → entidades JPA y repositorios            → insumos (RF-03)
└── exception      → BusinessException + ErrorCode           [Fase 4]
```
