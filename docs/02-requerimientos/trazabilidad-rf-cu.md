# Trazabilidad: Requerimiento funcional → Caso de uso → Escenarios de prueba

Completa la cadena de trazabilidad del entregable: proceso actual (BPMN) → problema → requerimiento funcional → caso de uso → escenario de prueba. El tramo BPMN → RF está en [`trazabilidad-bpmn-rf.md`](../01-inicio/bpmn/trazabilidad-bpmn-rf.md).

## Por requerimiento funcional

| RF | Casos de uso | Escenarios | Requerimientos suplementarios |
|---|---|---|---|
| [RF-01](funcionales/RF-01-consulta-historial-vehicular.md) | [CU-01](../03-casos-de-uso/CU-01-consultar-historial-vehicular.md), [CU-06](../03-casos-de-uso/CU-06-registrar-vehiculo.md), [CU-11](../03-casos-de-uso/CU-11-registrar-servicio-y-cerrar-orden.md) | 11 ([CU-01](../04-pruebas/CU-01.feature), [CU-06](../04-pruebas/CU-06.feature), [CU-11](../04-pruebas/CU-11.feature)) | RS-02, RS-03 |
| [RF-02](funcionales/RF-02-cotizacion-y-cobro.md) | [CU-02](../03-casos-de-uso/CU-02-registrar-orden-con-presupuesto.md), [CU-10](../03-casos-de-uso/CU-10-registrar-aprobacion-de-presupuesto.md), [CU-12](../03-casos-de-uso/CU-12-registrar-cobro-final.md) | 15 ([CU-02](../04-pruebas/CU-02.feature), [CU-10](../04-pruebas/CU-10.feature), [CU-12](../04-pruebas/CU-12.feature)) | RS-01, RS-03 |
| [RF-03](funcionales/RF-03-catalogo-insumos.md) | [CU-03](../03-casos-de-uso/CU-03-asociar-insumo-a-orden.md), [CU-08](../03-casos-de-uso/CU-08-consultar-existencia-de-insumo.md), [CU-13](../03-casos-de-uso/CU-13-registrar-ingreso-de-insumos.md) | 12 ([CU-03](../04-pruebas/CU-03.feature), [CU-08](../04-pruebas/CU-08.feature), [CU-13](../04-pruebas/CU-13.feature)) | RS-02 |
| [RF-04](funcionales/RF-04-planificador-rampas.md) | [CU-04](../03-casos-de-uso/CU-04-agendar-cita-de-mantenimiento.md), [CU-07](../03-casos-de-uso/CU-07-registrar-llegada-sin-cita.md) | 8 ([CU-04](../04-pruebas/CU-04.feature), [CU-07](../04-pruebas/CU-07.feature)) | RS-03 |
| [RF-05](funcionales/RF-05-tablero-control-flujo.md) | [CU-05](../03-casos-de-uso/CU-05-actualizar-estado-de-vehiculo.md), [CU-09](../03-casos-de-uso/CU-09-consultar-estado-de-vehiculo.md) | 7 ([CU-05](../04-pruebas/CU-05.feature), [CU-09](../04-pruebas/CU-09.feature)) | RS-02, RS-03 |

Todos los requerimientos funcionales están cubiertos por al menos un caso de uso, y todos los casos de uso tienen escenarios de prueba para el flujo principal y para cada flujo alternativo.

## Por caso de uso

| CU | Título | RF | Actores primarios | Actores secundarios | Relaciones | RS | Escenarios | Prototipo |
|---|---|---|---|---|---|---|---|---|
| [CU-01](../03-casos-de-uso/CU-01-consultar-historial-vehicular.md) | Consultar Historial Vehicular por Placa | RF-01 | Administrador, Mecánico | Cliente | Extendido por CU-06 | RS-02 | [E1–E5](../04-pruebas/CU-01.feature) | [CU-01](../03-casos-de-uso/prototipos/CU-01.png) |
| [CU-02](../03-casos-de-uso/CU-02-registrar-orden-con-presupuesto.md) | Registrar Orden de Trabajo con Presupuesto | RF-02 | Administrador, Mecánico | Cliente | `<<include>>` CU-08 | RS-01, RS-03 | [E1–E8](../04-pruebas/CU-02.feature) | [CU-02](../03-casos-de-uso/prototipos/CU-02.png) |
| [CU-03](../03-casos-de-uso/CU-03-asociar-insumo-a-orden.md) | Asociar Insumo a Orden de Trabajo | RF-03 | Administrador | Mecánico | `<<include>>` CU-08 | Ninguno | [E1–E6](../04-pruebas/CU-03.feature) | [CU-03](../03-casos-de-uso/prototipos/CU-03.png) |
| [CU-04](../03-casos-de-uso/CU-04-agendar-cita-de-mantenimiento.md) | Agendar Cita de Mantenimiento | RF-04 | Administrador | Cliente | Extendido por CU-06 y CU-07 | RS-03 | [E1–E5](../04-pruebas/CU-04.feature) | [CU-04](../03-casos-de-uso/prototipos/CU-04.png) |
| [CU-05](../03-casos-de-uso/CU-05-actualizar-estado-de-vehiculo.md) | Actualizar Estado de Vehículo | RF-05 | Administrador, Mecánico | Cliente | Ninguna | Ninguno | [E1–E3](../04-pruebas/CU-05.feature) | [CU-05](../03-casos-de-uso/prototipos/CU-05.png) |
| [CU-06](../03-casos-de-uso/CU-06-registrar-vehiculo.md) | Registrar Vehículo | RF-01 (ampliar) | Administrador, Mecánico | Cliente | `<<extend>>` CU-01, CU-04, CU-07 | Ninguno | [E1–E3](../04-pruebas/CU-06.feature) | [CU-06](../03-casos-de-uso/prototipos/CU-06.png) |
| [CU-07](../03-casos-de-uso/CU-07-registrar-llegada-sin-cita.md) | Registrar Llegada de Vehículo sin Cita | RF-04 | Administrador | Cliente | `<<extend>>` CU-04; extendido por CU-06 | Ninguno | [E1–E3](../04-pruebas/CU-07.feature) | [CU-07](../03-casos-de-uso/prototipos/CU-07.png) |
| [CU-08](../03-casos-de-uso/CU-08-consultar-existencia-de-insumo.md) | Consultar Existencia de Insumo | RF-03 | Administrador, Mecánico | Ninguno | Incluido por CU-02 y CU-03 | RS-02 | [E1–E3](../04-pruebas/CU-08.feature) | [CU-08](../03-casos-de-uso/prototipos/CU-08.png) |
| [CU-09](../03-casos-de-uso/CU-09-consultar-estado-de-vehiculo.md) | Consultar Estado de Vehículo | RF-05 | Administrador, Mecánico | Cliente | Ninguna | RS-02, RS-03 | [E1–E4](../04-pruebas/CU-09.feature) | [CU-09](../03-casos-de-uso/prototipos/CU-09.png) |
| [CU-10](../03-casos-de-uso/CU-10-registrar-aprobacion-de-presupuesto.md) | Registrar Aprobación de Presupuesto | RF-02 | Administrador | Cliente | Ninguna | Ninguno | [E1–E3](../04-pruebas/CU-10.feature) | [CU-10](../03-casos-de-uso/prototipos/CU-10.png) |
| [CU-11](../03-casos-de-uso/CU-11-registrar-servicio-y-cerrar-orden.md) | Registrar Servicio y Cerrar Orden de Trabajo | RF-01 (criterio 3) | Administrador, Mecánico | Ninguno | Ninguna | Ninguno | [E1–E3](../04-pruebas/CU-11.feature) | [CU-11](../03-casos-de-uso/prototipos/CU-11.png) |
| [CU-12](../03-casos-de-uso/CU-12-registrar-cobro-final.md) | Registrar Cobro Final | RF-02 (criterio 3) | Administrador | Cliente | Ninguna | Ninguno | [E1–E4](../04-pruebas/CU-12.feature) | [CU-12](../03-casos-de-uso/prototipos/CU-12.png) |
| [CU-13](../03-casos-de-uso/CU-13-registrar-ingreso-de-insumos.md) | Registrar Ingreso de Insumos | RF-03 (ampliar) | Administrador | Ninguno | Ninguna | Ninguno | [E1–E3](../04-pruebas/CU-13.feature) | [CU-13](../03-casos-de-uso/prototipos/CU-13.png) |

---

**Documento Preparado Por:** José A Ramírez y Adrián Barboza Vargas  
**Fecha:** 21 de septiembre de 2026
