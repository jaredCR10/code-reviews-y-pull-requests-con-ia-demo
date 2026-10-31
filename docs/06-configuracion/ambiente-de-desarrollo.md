# Guía de configuración — Entorno de desarrollo

## Introducción

### Propósito

Este documento detalla los pasos necesarios para configurar el entorno de
desarrollo local de **TallerAuto**: backend, base de datos y frontend, de
forma que cualquier integrante del equipo (o el profesor) pueda levantar el
proyecto completo desde cero.

### Alcance

Cubre el entorno local de desarrollo de los tres componentes del proyecto.
Las secciones de **Backend** y **Base de datos** las completa la persona
responsable de esa parte (ver `lineamientos-backend.md` y
`lineamientos-base-de-datos.md`); la sección **Frontend** está completa a
continuación.

### Requisitos previos

- Git instalado.
- Un editor o IDE (el equipo usa Visual Studio Code).
- **Backend:** JDK 21 (o superior, compatible por `--release 21`) y Maven.
- **Frontend:** Node.js `^22.22.2`, `^24.15.0`, o `>= 26.0.0` (requisito de
  Angular CLI 22) — en la práctica, cualquier Node.js 24.x reciente sirve.
  Se verifica con `node -v` y `npm -v`.

---

## Backend y base de datos

El backend (Spring Boot) se conecta a una base de datos **MySQL que corre en
Docker**, de modo que no necesitas instalar MySQL en la máquina. Al terminar
esta sección, el backend queda corriendo en `http://localhost:8080`, conectado
a la base de datos y respondiendo en su endpoint de salud.

> **Maven no es obligatorio.** El repositorio incluye el **Maven Wrapper**
> (`mvnw`), que descarga Maven automáticamente; IntelliJ IDEA además trae Maven
> embebido. Tampoco necesitas instalar MySQL localmente: la base de datos corre
> en Docker (de hecho, un MySQL instalado en la máquina puede estorbar; ver
> [Problemas frecuentes](#problemas-frecuentes-backend-y-base-de-datos)).

### Paso 1: Clonar el repositorio

```bash
git clone https://github.com/IF-6100-2026/TallerAuto-docs.git
cd TallerAuto-docs
```

### Paso 2: Preparar las variables de ambiente

Las credenciales y el puerto de la base de datos se leen de variables de
ambiente; no hay contraseñas en el repositorio. Copia la plantilla a un archivo
`.env` (que está en `.gitignore` y no se sube):

```bash
cp .env.example .env
```

Contenido por defecto de `.env` (sirve tal cual para desarrollo local):

```
DB_NAME=tallerauto
DB_USER=tallerauto
DB_PASSWORD=tallerauto
DB_ROOT_PASSWORD=root
DB_PORT=3306
```

> `docker-compose` lee este `.env`. El backend **no** lo lee automáticamente
> (ver el Paso 4 y
> [Problemas frecuentes](#problemas-frecuentes-backend-y-base-de-datos)); por
> defecto usa los mismos valores, así que en local coinciden sin configurar
> nada extra.

### Paso 3: Levantar la base de datos

Desde la raíz del repositorio, con Docker Desktop abierto:

```bash
docker compose up -d
```

Esto levanta un contenedor MySQL 8.4 (`tallerauto-mysql`). Espera a que quede
`healthy`:

```bash
docker compose ps
```

> **Importante:** no sigas al Paso 4 hasta que MySQL esté `healthy`. El backend
> se conecta a la base de datos al arrancar (Liquibase corre al inicio), así que
> **con Docker apagado o la BD no disponible, el backend no inicia** —es el
> comportamiento esperado, no un error del proyecto.

### Paso 4: Correr el backend

Desde IntelliJ IDEA (lo más simple): abre el proyecto `backend/`, deja que
importe las dependencias Maven y ejecuta la clase `TallerAutoApplication`.

Desde la terminal, con el **Maven Wrapper** incluido en el repo (no necesitas
tener Maven instalado):

- En Git Bash, Linux o macOS:

  ```bash
  cd backend
  ./mvnw spring-boot:run
  ```

- En Windows (CMD o PowerShell):

  ```bash
  cd backend
  mvnw.cmd spring-boot:run
  ```

Al arrancar, **Liquibase** crea el esquema (tabla `insumos`) y lo registra en la
tabla `DATABASECHANGELOG`. Hibernate solo valida que las entidades concuerden
con el esquema (`ddl-auto=validate`); la fuente de verdad del esquema son las
migraciones.

> Si cambiaste el puerto en `.env` (por un conflicto con un MySQL local), tienes
> que pasarle ese mismo puerto al backend, porque no lee `.env`. Ver
> [Problemas frecuentes](#problemas-frecuentes-backend-y-base-de-datos).

### Paso 5: Verificar que funciona

El backend expone un endpoint de salud (*readiness*) que confirma que el
servicio está arriba **y** conectado a la base de datos:

```bash
curl -i http://localhost:8080/api/health
```

Respuesta esperada con la base de datos arriba:

```
HTTP/1.1 200
{"status":"UP","service":"tallerauto-backend","database":"UP"}
```

Si la base de datos no responde, el mismo endpoint devuelve `503`:

```
HTTP/1.1 503
{"status":"DOWN","service":"tallerauto-backend","database":"DOWN"}
```

Este es el contrato que consume el frontend. El detalle está en
[`backend/README.md`](../../backend/README.md).

### Pruebas (opcional, sin Docker)

Las pruebas corren contra una base de datos H2 en memoria, así que **no**
necesitan MySQL ni Docker:

```bash
cd backend
./mvnw test        # Windows (CMD/PowerShell): mvnw.cmd test
```

### Problemas frecuentes (backend y base de datos)

**`Access denied for user 'tallerauto'@'localhost'` al arrancar el backend.**
La app se está conectando a *otro* MySQL (uno instalado localmente), no al
contenedor. Causas típicas:

- **Ya tienes un MySQL local ocupando el puerto 3306 (o 3307).** El contenedor
  no puede publicar en un puerto ocupado. Elige un puerto libre en `.env`, por
  ejemplo `DB_PORT=3310`, y recrea el contenedor:

  ```bash
  docker compose up -d
  ```

- **IntelliJ y Maven no leen `.env`.** Ese archivo solo lo lee `docker-compose`.
  El backend toma `DB_PORT` de las variables de ambiente y, si no está, usa
  `3306` por defecto. Si cambiaste el puerto en `.env`, pásaselo también a la
  app para que coincidan:
  - En IntelliJ: `Run` → `Edit Configurations…` → *Environment variables* →
    `DB_PORT=3310`.
  - Por terminal: `DB_PORT=3310 mvn spring-boot:run`.

  > Regla práctica: el `DB_PORT` del `.env` (contenedor) y el de la app deben ser
  > el mismo, y ese puerto no debe estar ocupado por otro MySQL.

**El backend no enciende con Docker apagado (o el error menciona la base de
datos: `Communications link failure`, `Connection refused`).** Es esperado: el
backend se conecta a MySQL al arrancar (Liquibase corre al inicio), así que la
base de datos debe estar arriba **antes** de correr el backend. Solución:

1. Abre Docker Desktop y espera a que termine de iniciar.
2. `docker compose up -d` y espera a que `docker compose ps` muestre `healthy`.
3. Recién entonces corre el backend (Paso 4).

**`mvn` no se reconoce como comando (`command not found: mvn` / `'mvn' no se
reconoce como un comando...`).** No necesitas instalar Maven: usa el **wrapper**
incluido en el repositorio, desde la carpeta `backend/`:

- Git Bash, Linux o macOS: `./mvnw spring-boot:run`
- Windows (CMD o PowerShell): `mvnw.cmd spring-boot:run`

También puedes correr el backend desde IntelliJ, que trae Maven embebido.

**`Cannot connect to the Docker daemon` al hacer `docker compose up`.** Docker
Desktop no está corriendo. Ábrelo y espera a que termine de iniciar.

**La versión de Java.** El proyecto apunta a Java 21; usa un JDK 21 o superior.
Puedes verificar con `java -version`.

---

## Frontend

### Paso 1: Clonar el repositorio

1. Abra una terminal.
2. Clone el repositorio:

   ```
   git clone https://github.com/IF-6100-2026/TallerAuto-docs.git
   cd TallerAuto-docs
   ```

### Paso 2: Instalar Node.js

1. Verifique la versión instalada:

   ```
   node -v
   npm -v
   ```

2. Si no tiene Node.js, o su versión es anterior a `22.22`/`24.15`, descargue
   el instalador `.msi` (Windows) desde
   [nodejs.org](https://nodejs.org/en/download) — se recomienda la versión
   **LTS** más reciente. Ejecute el instalador con las opciones por defecto y
   reinicie el editor/terminal al terminar.

### Paso 3: Instalar las dependencias del frontend

1. Navegue a la carpeta del frontend:

   ```
   cd frontend
   ```

2. Instale las dependencias:

   ```
   npm install
   ```

   **Importante:** este comando debe correrse desde una terminal del mismo
   sistema operativo donde luego se va a ejecutar el proyecto (p. ej., desde
   PowerShell en Windows, no desde un entorno Linux que apunte a la misma
   carpeta). Si `node_modules` se genera desde un sistema operativo distinto,
   los ejecutables internos (`vite`, `ng`, etc.) pueden quedar sin el formato
   correcto para el sistema donde se van a correr, y comandos como
   `npm run start` fallarán con un error de "no se reconoce como comando".

### Paso 4: Levantar el backend (prerrequisito)

El frontend necesita el backend corriendo en `localhost:8080` para mostrar
datos reales. En otra terminal, dentro de `backend/`:

```
mvn compile spring-boot:run
```

Espere hasta ver en el log una línea similar a
`Tomcat started on port 8080`.

### Paso 5: Levantar el frontend

De vuelta en la terminal de `frontend/`:

```
npm run start
```

Espere a que la compilación termine (línea `Application bundle generation
complete`) y abra en el navegador:

```
http://localhost:4200
```

**Nota sobre CORS.** El frontend y el backend corren en puertos distintos
(4200 y 8080). Para evitar errores de CORS en desarrollo, el servidor de
Angular CLI reenvía automáticamente toda petición a `/api/**` hacia
`http://localhost:8080`, mediante la configuración en `frontend/proxy.conf.json`
(referenciada desde `angular.json` → `serve.options.proxyConfig`). No se
requiere ninguna configuración adicional del lado del navegador.

### Paso 6: Verificar la integración

Con ambos servidores corriendo, la página principal debe mostrar un recuadro
verde con el texto `Backend: UP (tallerauto-backend)`. Si en cambio aparece un
recuadro rojo de error, confirme que:

1. El backend esté efectivamente corriendo en el puerto 8080 (revise su
   terminal).
2. No haya otro proceso usando el puerto 4200 u 8080.
3. El archivo `frontend/proxy.conf.json` exista y `angular.json` lo referencie
   en `architect.serve.options.proxyConfig`.

¡Listo! El entorno de desarrollo del frontend queda configurado.

### Problemas frecuentes (frontend)

| Síntoma | Causa | Solución |
|---|---|---|
| `package.json not found` o `ENOENT` al correr `npm run start` | La terminal no está dentro de `frontend/` | `cd frontend` y volver a ejecutar |
| `'ng' no se reconoce como un comando` | `node_modules` se instaló desde otro sistema operativo (por ejemplo, desde WSL o un contenedor Linux) y quedaron sin los ejecutables de Windows | Borrar `node_modules` (`Remove-Item -Recurse -Force node_modules`) y correr `npm install` otra vez desde la terminal de Windows |
| Error de versión de Node al compilar (`The Angular CLI requires a minimum Node.js version...`) | Node.js más antiguo que lo exigido por Angular CLI 22 | Instalar la versión LTS más reciente desde nodejs.org, cerrar y abrir el editor y verificar con `node -v` |
| `ERR_CONNECTION_REFUSED` en `localhost:4200` | `npm run start` no está corriendo, o todavía está compilando | Ejecutar `npm run start` y esperar a ver `Application bundle generation complete` |
| `Whitelabel Error Page` (404) en `localhost:8080` | Se abrió el puerto del backend. El backend solo expone `/api/health`; no tiene página en `/` | Abrir `http://localhost:4200` para ver el frontend |
| Recuadro rojo «No se pudo contactar al backend» en el frontend | El backend no está corriendo, o el frontend se levantó sin el *proxy* | Levantar el backend en el puerto 8080 y reiniciar `npm run start` (el *proxy* se lee al arrancar) |
| Error `TS2339` en una plantilla que ya se corrigió, y sigue apareciendo | El modo *watch* conserva la compilación anterior | Detener con `Ctrl+C` y volver a ejecutar `npm run start` |
| `Port 4200 is already in use` | Quedó otro `ng serve` abierto | Cerrar la otra terminal, o ejecutar `npm run start -- --port 4300` |

---

**Documento preparado por:**
_Adrián Barboza Vargas — Frontend (sección Frontend)._
_José Andrés Ramírez Jiménez — Backend y Base de Datos (sección Backend y base de datos)._

**Fecha:** 25 de octubre de 2026
