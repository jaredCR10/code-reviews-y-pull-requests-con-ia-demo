# Lineamientos de diseño — Frontend

Estas son las reglas que el grupo se compromete a seguir al construir el
frontend de **TallerAuto** en el PC3. No son teoría transcrita: cada regla se
acompaña de un ejemplo tomado de un caso de uso real del proyecto o del
esqueleto ya implementado en `frontend/` (integración con `GET /api/health`).
Cuando un ejemplo es del esqueleto, se indica **(implementado)**; cuando es la
aplicación de la regla a un caso de uso que se construirá en el PC3, se indica
**(PC3)**.

> **Stack fijado.** Angular 22 (componentes *standalone*, sin `NgModule`),
> TypeScript, RxJS para flujos asíncronos y *signals* para estado.
> El enunciado permite elegir la tecnología del frontend (sección 5.3: «la
> tecnología que escogió el grupo»); el grupo escogió Angular porque es la que
> ya conoce, frente a React, de la que no hay experiencia previa. El arranque
> está en
> [`../06-configuracion/ambiente-de-desarrollo.md`](../06-configuracion/ambiente-de-desarrollo.md);
> el contrato de datos que consume, en
> [`lineamientos-backend.md`](lineamientos-backend.md).

**Equivalencias con React**, por si se compara con la referencia del curso:
hook personalizado → servicio o función con `inject()`; `useState` → `signal`;
props → `input()`; *callbacks* hacia el padre → `output()`; contexto →
servicio `providedIn: 'root'`.

---

## 1. Organización de carpetas

```
frontend/src/app
├── app.ts / app.html / app.css      → componente raíz: compone las páginas
├── app.config.ts                    → proveedores globales (HttpClient, locale)
├── models/                          → tipos: espejo de los DTO del backend
│   └── health.model.ts                  (implementado)
├── core/                            → servicios: acceso a la API y estado compartido
│   └── health.service.ts                (implementado)
├── shared/                          → componentes, pipes y utilidades reutilizables
│                                        (sin lógica de un caso de uso concreto)
└── features/<área>/                 → una carpeta por área funcional
    └── <caso-de-uso>/                   → página (contenedor) + componentes de presentación
```

El esqueleto actual deja `health-status/` en la raíz de `app/` porque no
pertenece a ningún caso de uso; las pantallas del PC3 van bajo `features/`,
agrupadas por requerimiento: `features/historial` (RF-01), `features/ordenes`
(RF-02), `features/insumos` (RF-03), `features/citas` (RF-04) y
`features/estado` (RF-05).

**Por qué por tipo técnico en `models/` y `core/`, y por área en `features/`.**
Las entidades se cruzan entre requerimientos (una orden de trabajo, RF-02,
usa insumos, RF-03, y alimenta el historial, RF-01), así que los modelos y
servicios son comunes; en cambio, cada pantalla pertenece a un solo caso de
uso y vive junto a sus componentes. Es la misma decisión que el backend tomó
al organizar por capa.

**Regla de dependencia.** `features/` puede importar de `core/`, `models/` y
`shared/`. `core/` y `models/` nunca importan de `features/`. Un componente
nunca importa `HttpClient` ni conoce la URL de un *endpoint*.

---

## 2. Modelos tipados y tipado estricto

Cada respuesta del backend se modela con una interfaz que **espeja** el DTO de
`api.responses` del backend. Si el backend cambia un DTO, solo se actualiza
el archivo de `models/` correspondiente.

**(implementado)** Espejo del `record HealthResponse`:

```typescript
// models/health.model.ts
export interface HealthResponse {
  status: string;
  service: string;
}
```

**(PC3)** CU-09 devolvería, según el backend, un `EstadoVehiculoResponse`
(`placa`, `estado`, `ordenActivaId`); el frontend lo declara como
`EstadoVehiculo` en `models/estado-vehiculo.model.ts` con esos mismos campos.

**Tipado estricto, sin `any`.** El proyecto compila con `strict: true`
(declarado de forma explícita en `tsconfig.json`). Está prohibido `any`; un
dato de origen incierto se tipa como `unknown` y se estrecha con una
comprobación antes de usarse. Un PR que introduce `any` no se aprueba.

---

## 3. Acceso al backend: una sola capa

**Decisión del grupo: ningún componente llama a `HttpClient` directamente.**
Toda petición HTTP sale de un servicio de `core/` (`@Injectable({ providedIn:
'root' })`, inyectado con `inject()`). Si cambia la URL base, se agrega
autenticación (RS-01) o se necesita reintentar, se toca un solo archivo.

**(implementado)**

```typescript
// core/health.service.ts
@Injectable({ providedIn: 'root' })
export class HealthService {
  private readonly http = inject(HttpClient);

  getHealth(): Observable<HealthResponse> {
    return this.http.get<HealthResponse>('/api/health');
  }
}
```

- Los métodos del servicio hablan el lenguaje del dominio (`getHealth()`), no
  el de HTTP, y devuelven `Observable<T>` con el tipo de `models/`.
- Las rutas son relativas (`/api/...`). En desarrollo las resuelve el *proxy*
  de Angular CLI (`proxy.conf.json`, referenciado en `angular.json` →
  `serve.options.proxyConfig`) hacia `http://localhost:8080`, lo que evita
  CORS entre los puertos 4200 y 8080. Para producción, el mismo prefijo `/api`
  lo resolverá un *reverse proxy* (decisión pendiente para el PC3).
- Un servicio por recurso del backend: `VehiculoService`, `OrdenService`,
  `InsumoService`, `CitaService`. Los casos de uso que comparten recurso
  comparten servicio.

---

## 4. Responsabilidad de los componentes

Se separan dos roles:

| Rol | Qué hace | Qué tiene prohibido |
|---|---|---|
| **Contenedor** (página) | Inyecta servicios, pide los datos, guarda el estado en *signals*, decide qué mostrar y atiende los eventos de los hijos. | Contener marcado complejo o estilos de detalle. |
| **Presentación** | Recibe datos por `input()`, los muestra y avisa lo que pasó con `output()`. | Inyectar servicios de `core/`, llamar a la API, conocer el estado global. |

**Cuándo se divide un componente.** Cuando se cumple alguna de estas
condiciones: (a) mezcla pedir datos con dibujarlos; (b) un fragmento se
repite o se reutilizará en otro caso de uso; (c) su plantilla maneja más de
un estado visual independiente.

**(implementado)** `HealthStatus` consulta el servicio y muestra el
resultado en el mismo componente: se acepta porque es una pieza única de un
solo propósito. Es la excepción, no el modelo.

**(PC3) CU-02 — Registrar Orden de Trabajo con Presupuesto.** Se divide así:

| Componente | Rol | Entradas / salidas |
|---|---|---|
| `RegistrarOrdenPage` | Contenedor: inyecta `OrdenService`, mantiene el diagnóstico, las líneas y el resultado de cada llamada. | — |
| `LineaPresupuesto` | Presentación: una fila (insumo, cantidad, precio, marca «Por pedir a proveedor»). | `input(linea)`, `output(quitar)` |
| `PresupuestoResumen` | Presentación: subtotales, total y botón «Confirmar». | `input(lineas)`, `input(total)`, `input(puedeConfirmar)`, `output(confirmar)` |

El frontend **no recalcula el presupuesto**: muestra el subtotal y el total
que devuelve el backend (el cálculo es regla de negocio del *handler*, paso 7
del caso de uso). Los mensajes de los flujos alternativos se muestran tal
cual los define el caso de uso, por ejemplo «Existencia insuficiente.
Disponible: X» (FA-01).

---

## 5. Estado y comunicación

**Dónde vive el estado.**

| Tipo de estado | Dónde vive | Ejemplo |
|---|---|---|
| Resultado de una llamada y datos de un formulario | `signal` del **contenedor** | `state` de `HealthStatus` **(implementado)**; las líneas de `RegistrarOrdenPage` **(PC3)** |
| Valor derivado | `computed()` en el componente que lo necesita | «¿hay líneas marcadas como Por pedir?» en `PresupuestoResumen` **(PC3)** |
| Estado que comparten pantallas no relacionadas | `signal` dentro de un servicio de `core/` | `SesionService.rol` (Administrador o Mecánico, RS-01) **(PC3)** |

**Cómo se comunican.** Los datos bajan por `input()`; los eventos suben por
`output()`. Un hijo nunca modifica el estado de su padre ni de un hermano.
Las pantallas no se pasan datos entre sí por servicios globales cuando basta
con la ruta o con un `input()`.

**Cuándo se usa estado global.** Solo para lo que es realmente transversal.
En TallerAuto hay un único caso: el **rol de la sesión**, que RS-01 exige
conocer en todas las pantallas. `SesionService` expone `rol` como `signal` de
solo lectura. Con él, `RegistrarOrdenPage` calcula `puedeConfirmar` (verdadero
solo para el Administrador) y `PresupuestoResumen` oculta o desactiva el botón
«Confirmar». Esto es solo ayuda visual: la autorización real la aplica el
backend, que responde `403` con `CONFIRMACION_NO_AUTORIZADA` (FA-05 de CU-02)
y el contenedor muestra «Solo el rol Administrador puede confirmar el
presupuesto.».

**Estado de una llamada asíncrona.** Se modela siempre como unión
discriminada, para que sea imposible mostrar «éxito» sin datos.

**(implementado)**

```typescript
type HealthState =
  | { status: 'loading' }
  | { status: 'success'; data: HealthResponse }
  | { status: 'error'; message: string };

readonly state = signal<HealthState>({ status: 'loading' });
```

En la plantilla, el estado se captura **una sola vez** con `@let` antes del
`@switch`. Llamar al *signal* varias veces (`state().data`, `state().message`)
impide que TypeScript estreche la unión y la compilación falla:

```html
@let s = state();
@switch (s.status) {
  @case ('loading') { <p>Consultando backend...</p> }
  @case ('success') { <p>Backend: {{ s.data.status }}</p> }
  @case ('error')   { <p>{{ s.message }}</p> }
}
```

---

## 6. Lógica reutilizable (equivalente a los hooks)

Angular no tiene hooks; la lógica reutilizable se extrae a cuatro lugares,
según su naturaleza:

| Necesidad | Mecanismo | Ejemplo |
|---|---|---|
| Lógica con estado o acceso a la API compartida | Servicio de `core/` | `SesionService`, `OrdenService` |
| Comportamiento que se repite entre componentes (cargar, mostrar éxito o error) | Tipo genérico `LoadState<T>` + función auxiliar con `inject()` en `shared/` | Reemplaza `HealthState` cuando un segundo caso de uso repita el patrón: CU-01 y CU-09 cargan datos con los mismos tres estados |
| Valor derivado de otros | `computed()` | Total de líneas marcadas «Por pedir a proveedor» |
| Transformación pura para mostrar | `Pipe` en `shared/` | `{{ total \| currency:'CRC':'symbol-narrow':'1.0-0' }}` para mostrar ₡20 000 en CU-02 |

**Regla:** la extracción se hace cuando aparece el **segundo** uso real, no
antes. Hoy `HealthState` vive dentro de `HealthStatus` porque solo hay un
consumidor.

---

## 7. Patrones de diseño aplicados

| Patrón | Qué resuelve | Componente o archivo concreto |
|---|---|---|
| **Service Layer** | Aísla el transporte HTTP detrás de una interfaz del dominio. | `HealthService.getHealth()` **(implementado)**; `OrdenService`, `CitaService` **(PC3)** |
| **Observer** | El componente se suscribe a un flujo y se actualiza cuando llegan datos. | `HealthStatus` se suscribe al `Observable` de `getHealth()` con `next` y `error` y actualiza su `signal`; la plantilla se redibuja sola **(implementado)** |
| **Composición** | Se arman pantallas combinando componentes pequeños en lugar de heredar. | `App` compone `<app-health-status />` **(implementado)**; `RegistrarOrdenPage` compone `LineaPresupuesto` y `PresupuestoResumen` **(PC3)** |
| **Strategy** | Comportamientos intercambiables detrás de una misma interfaz. | **(PC3)** CU-09, paso 2: la consulta se hace por placa **o** por número de orden. `ConsultaEstadoPage` recibe una `BusquedaEstrategia` (`validar(dato)` y `consultar(dato)`) con dos implementaciones, `PorPlaca` y `PorOrden`; agregar un tercer criterio no modifica la página |

---

## 8. Manejo de errores y mensajes

1. **Error de transporte** (backend caído, red, tiempo agotado): la variante
   `error` del estado del contenedor, con un mensaje genérico. No se muestra
   el detalle técnico.
2. **Desenlace de negocio no exitoso**: el backend lo devuelve como
   `ErrorResponse` con su `ErrorCode` (ver `lineamientos-backend.md`, sección
   6). El servicio lo traduce a una variante propia del estado, no a un error
   genérico, para que la pantalla reaccione según el caso. Ejemplo **(PC3)**:
   en CU-04 un conflicto de rampa (FA-01) mantiene la fecha elegida, avisa que
   la rampa no está disponible en esa franja y vuelve a la selección en lugar
   de vaciar el formulario.

**Usabilidad (RS-03).** Los textos de pantalla son los de los casos de uso,
en español y sin tecnicismos; un mismo dato se llama igual en todas las
pantallas (por ejemplo, siempre «placa», nunca «matrícula» o «identificador»).

---

## 9. Convenciones

| Elemento | Convención | Ejemplo |
|---|---|---|
| Tipo de `models/` | `PascalCase`, sin prefijo `I` ni sufijo | `HealthResponse`, `EstadoVehiculo` |
| Servicio | `<Recurso>Service` | `HealthService`, `OrdenService` |
| Componente | `PascalCase`, sin sufijo `Component` | `HealthStatus`, `LineaPresupuesto` |
| Página (contenedor) | `<Caso de uso>Page` | `RegistrarOrdenPage` |
| Selector | `app-` + `kebab-case` | `app-health-status` |
| Archivos | `kebab-case`; un componente son tres archivos (`.ts`, `.html`, `.css`) | `health-status.ts` |
| Método de servicio que lee | `get<Recurso>()` | `getHealth()` |
| Método que escribe | verbo del caso de uso | `registrarOrden()` |

**Estilos.** CSS por componente (Angular lo encapsula); los estilos globales
viven únicamente en `src/styles.css`. Sin librería de componentes visuales
por ahora; si el grupo decide adoptar una en el PC3, se registra aquí.

**Idioma.** Identificadores de framework en inglés y términos del dominio en
español (`Vehiculo`, `Insumo`, `Orden`), igual que en el backend.

---

## 10. Entorno de desarrollo local

`ng serve` (puerto 4200) reenvía `/api/**` a `http://localhost:8080` mediante
`proxy.conf.json`, así que el backend debe estar corriendo en paralelo. El
paso a paso está en
[`../06-configuracion/ambiente-de-desarrollo.md`](../06-configuracion/ambiente-de-desarrollo.md).

---

**Documento preparado por:** _Adrián Barboza Vargas — Frontend_
**Fecha:** 29 de octubre de 2026
