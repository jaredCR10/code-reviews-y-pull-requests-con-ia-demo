# Guía de revisión humana — PR sembrado (José, Persona 1)

> Preparada explorando el repositorio TallerAuto en `origin/main`.
> Es la "chuleta" para la revisión humana del PR sembrado de Adrián y del PR de Jared.
> Objetivo: detectar lo que **ni el CI ni la IA** garantizan (reglas de negocio y arquitectura).

## 1. Estado real del código hoy

El backend todavía es andamiaje: lo único implementado es el endpoint `GET /api/health`
(+ `DatabaseHealthProbe`) y la entidad/repositorio de **Insumo** (`InsumoEntity`,
`InsumoRepository`). El paquete `handlers/` está **vacío** (solo `package-info`).

Conclusión clave: hoy no hay lógica de negocio en el código; **vive toda en los
documentos** (`docs/03-casos-de-uso/` y `docs/05-diseno/`). El PR sembrado va a
*implementar* algún caso de uso e introducir ahí los 6 errores. La revisión humana
consiste en contrastar ese código nuevo contra esos documentos.

## 2. Mapa de capas (lo que hay que hacer cumplir)

Arquitectura cliente/servidor; backend en capas cerradas: `api -> handlers -> persistence`
(+ `security` y `exception` transversales).

| Capa | Regla dura que el revisor verifica |
|---|---|
| `api.controllers` | Delgado. Sin reglas de negocio ni cálculos. No toca repositorios ni entidades. Solo arma `Command`/`Query`, llama al handler por su interfaz y traduce el `Result` con `switch` exhaustivo. Devuelve DTO de `api.responses`, nunca una entidad JPA. |
| `handlers` (CQRS) | Aquí vive la lógica. Un handler por caso de uso (no un `*Service` por entidad). Escribe -> `commands`; lee -> `queries`; nunca ambos. Flujo normal con `Result` sealed + `switch`, no con excepciones ni `null`. `@Transactional` en `handle`/`query`. |
| `persistence` | Entidades JPA (id UUID) y repos Spring Data con métodos derivados (sin SQL a mano). La entidad nunca sale de persistence/handlers. `persistence` no conoce a `handlers` ni a `api`. |
| Frontend (Angular) | TS estricto, prohibido `any`. El componente no importa `HttpClient` ni conoce URLs: usa un service de `core/`. `core/` y `models/` no importan de `features/`. |

## 3. Quién atrapa qué (cruzado con los 6 errores sembrados)

| Error sembrado | CI | CodeRabbit (IA) | Humano (yo) |
|---|---|---|---|
| 1. Violación de estilo | Sí (`checkstyle:check` bloquea el merge) | A veces | Respaldo |
| 2. Prueba que falla | Sí (`mvn verify` / Vitest bloquea) | No | Respaldo |
| 3. Contraseña / API key quemada | No (no hay escáner de secretos en el CI) | Sí (está en `path_instructions`) | Sí |
| 4. Null pointer / caso borde | Solo si una prueba lo ejercita | Probable, no garantizado | Sí |
| 5. Regla de negocio incumplida | No | Débil (depende del `knowledge_base`) | **Detector principal** |
| 6. Violación de arquitectura en capas | No | Probable (está en `path_instructions`) | **Juez final** |

Enfocar la revisión en las filas 5 y 6 (y 4): es lo que ni CI ni IA garantizan, y es
justo lo que el roadmap pide anotar ("errores que detecté yo que no detectaron CI ni la IA").

Detalle del CI (`.github/workflows/ci.yml`, ambos checks obligatorios):
- backend = Checkstyle + `mvn verify` (build + pruebas en H2).
- frontend = `npm run build` + Vitest.

CodeRabbit (`.coderabbit.yaml`): perfil "chill", comenta pero nunca aprueba ni bloquea
(`request_changes_workflow: false`). La aprobación es 100% humana.

## 4. Reglas de negocio concretas a vigilar (filas 5 y 6)

- RS-01: solo el rol Administrador confirma/modifica un presupuesto (CU-02 paso 8); el
  Mecánico no. Si el handler no valida el rol -> regla incumplida.
- Estado del vehículo: 6 estados fijos, y solo CU-05 lo cambia. Ningún otro CU debe tocarlo.
- "Por pedir a proveedor": cuando la cantidad supera la existencia, se marca; la existencia
  nunca queda negativa y no se descuenta.
- El total del presupuesto lo calcula el handler, no el controlador ni el frontend.
- Las include se resuelven por composición (CU-02 reutiliza el handler de CU-08, no copia código).
- Moneda en colones; placa de 5 a 7 alfanuméricos.

## 5. Hallazgo útil (inconsistencia doc vs. config)

Desajuste real entre documentación y configuración, el tipo de cosa que solo cacha un humano:

- `lineamientos-backend.md` seccion 8 dice "línea máxima 120" y "sin números mágicos".
- Pero `backend/config/checkstyle/checkstyle.xml` aplica `LineLength = 140` y no tiene regla
  `MagicNumber`.

El estándar escrito y el que el CI hace cumplir no coinciden. Sirve como ejemplo para la
discusión "qué revisa el CI vs. qué dice el equipo" y se puede mencionar en la revisión.

## 6. Checklist rápida al abrir el diff del PR sembrado

- [ ] ¿El controlador quedó delgado? (sin cálculos, sin tocar repos/entidades, devuelve DTO)
- [ ] ¿La lógica está en un handler por caso de uso, en `commands`/`queries` correcto?
- [ ] ¿La entidad JPA se filtra hacia `api` o al JSON? (no debe)
- [ ] ¿Alguna capa llama "hacia arriba" o se salta una capa?
- [ ] ¿Se respeta RS-01 (rol Administrador) donde aplica?
- [ ] ¿El estado del vehículo se cambia fuera de CU-05?
- [ ] ¿La existencia puede quedar negativa?
- [ ] ¿Hay secreto/clave quemada? (revisar aunque el CI no lo detecte)
- [ ] ¿Casos borde / posibles NPE sin manejar?
- [ ] ¿Las pruebas tienen aserciones reales o pasan siempre?
- [ ] Anotar, por cada hallazgo: ¿lo detectó el CI, CodeRabbit, yo, o nadie? (para la tabla de Adrián)
