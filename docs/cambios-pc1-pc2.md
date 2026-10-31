# Cambios del PC1 al PC2

Registro de los cambios aplicados a los artefactos del Entregable 1 (PC1) en atención a la retroalimentación del profesor, previo al Entregable 2 (PC2). Incluye tanto las observaciones prioritarias (afectaron la nota) como las recomendaciones no puntuadas.

## Observaciones prioritarias (corregidas antes del PC2)

| # | Observación del PC1 | Qué se cambió | Archivo(s) |
|---|---|---|---|
| 1 | **Visión del sistema.** El objetivo principal no es ser "un solo lugar confiable", sino organizar la gestión administrativa del taller: agilizar la relación con los clientes y ordenar su organización interna. | Se reformuló la sección 1.4 (Visión del Sistema) con la redacción indicada por el profesor. | [`01-inicio/problema-y-vision.md`](01-inicio/problema-y-vision.md) §1.4 |
| 2 | **Seguridad.** Ningún caso de uso tenía restricciones: no se identificaba con qué rol operaba cada usuario ni se validaba el acceso según el cargo. | Se agregó el requerimiento suplementario **RS-01 — Seguridad: control de acceso por roles**, que exige identificar el rol (Administrador o Mecánico) antes de cualquier acción y restringe la confirmación/ajuste de presupuestos al rol Administrador. Se reflejó en CU-02 (paso 8 del flujo principal y nuevo flujo alternativo FA-05), en `actores.md` (sección "Control de acceso por rol") y en el escenario de prueba E8 de `pruebas/CU-02.feature`. | [`02-requerimientos/suplementarios/RS-01-seguridad-control-acceso.md`](02-requerimientos/suplementarios/RS-01-seguridad-control-acceso.md), [`03-casos-de-uso/CU-02-registrar-orden-con-presupuesto.md`](03-casos-de-uso/CU-02-registrar-orden-con-presupuesto.md) (FA-05), [`03-casos-de-uso/actores.md`](03-casos-de-uso/actores.md), [`04-pruebas/CU-02.feature`](04-pruebas/CU-02.feature) (E8) |
| 3 | **Redacción de los casos de uso por actor.** Los flujos de CU-01, CU-02, CU-05, CU-06, CU-08, CU-09 y CU-11 usaban "el usuario" pese a tener dos actores primarios (Administrador del Taller y Mecánico), lo que generaba ambigüedad sobre quién ejecuta cada paso. | Se reescribieron los pasos del Flujo Principal y los Flujos Alternativos de los 7 casos de uso señalados, nombrando explícitamente al actor que ejecuta cada paso ("El Administrador o el Mecánico", o el rol puntual cuando el paso es exclusivo de uno). | [`03-casos-de-uso/CU-01-consultar-historial-vehicular.md`](03-casos-de-uso/CU-01-consultar-historial-vehicular.md), [`CU-02-registrar-orden-con-presupuesto.md`](03-casos-de-uso/CU-02-registrar-orden-con-presupuesto.md), [`CU-05-actualizar-estado-de-vehiculo.md`](03-casos-de-uso/CU-05-actualizar-estado-de-vehiculo.md), [`CU-06-registrar-vehiculo.md`](03-casos-de-uso/CU-06-registrar-vehiculo.md), [`CU-08-consultar-existencia-de-insumo.md`](03-casos-de-uso/CU-08-consultar-existencia-de-insumo.md), [`CU-09-consultar-estado-de-vehiculo.md`](03-casos-de-uso/CU-09-consultar-estado-de-vehiculo.md), [`CU-11-registrar-servicio-y-cerrar-orden.md`](03-casos-de-uso/CU-11-registrar-servicio-y-cerrar-orden.md) |

## Recomendaciones no puntuadas (también atendidas)

| # | Recomendación del PC1 | Qué se cambió | Archivo(s) |
|---|---|---|---|
| 4 | **RS-01 original (disponibilidad y persistencia).** El profesor recomendó eliminarlo por ser técnicamente trivial y no impactar el diseño, dejando su lugar a un RS de seguridad. | Se eliminó el documento original y, con él, sus escenarios de prueba asociados en CU-02, CU-03 y CU-05 (persistencia tras reinicio del sistema). El identificador `RS-01` se reutilizó para el nuevo requerimiento de seguridad del punto 2; se actualizó la tabla de cobertura (`pruebas/README.md`) y la matriz de trazabilidad (`trazabilidad-rf-cu.md`) para que ningún CU cite `RS-01` salvo CU-02. | [`04-pruebas/CU-02.feature`](04-pruebas/CU-02.feature), [`04-pruebas/CU-03.feature`](04-pruebas/CU-03.feature), [`04-pruebas/CU-05.feature`](04-pruebas/CU-05.feature), [`04-pruebas/README.md`](04-pruebas/README.md), [`02-requerimientos/trazabilidad-rf-cu.md`](02-requerimientos/trazabilidad-rf-cu.md) |
| 5 | **RS-03 (aprendizaje sin capacitación formal).** El nombre era adecuado pero el requerimiento era, en el fondo, de usabilidad; se pidió ajustar la redacción. | Se reescribió como criterio de usabilidad medible: un usuario sin experiencia, tras una explicación de no más de 15 minutos, debe completar sin ayuda las cuatro tareas más frecuentes del taller. Se agregó el escenario de prueba E7 en `pruebas/CU-02.feature` que lo verifica para el registro de una orden con presupuesto. | [`02-requerimientos/suplementarios/RS-03-aprendizaje-sin-capacitacion.md`](02-requerimientos/suplementarios/RS-03-aprendizaje-sin-capacitacion.md), [`04-pruebas/CU-02.feature`](04-pruebas/CU-02.feature) (E7) |

## Mejora adicional (no observada por el profesor, corregida de forma preventiva)

| # | Hallazgo | Qué se cambió | Archivo(s) |
|---|---|---|---|
| 6 | Los diagramas BPMN de RF-01, RF-02, RF-04 y RF-05 no tenían un evento de inicio explícito (solo RF-03 lo tenía), lo que podía generar inconsistencia al construir el diagrama de contexto del PC2, donde cada participante debe mapear a un elemento BPMN concreto. | Se agregó un `startEvent` explícito y nombrado a los 4 diagramas, y se reexportaron las imágenes. | [`01-inicio/bpmn/RF-01-consulta-historial-vehicular.bpmn`](01-inicio/bpmn/RF-01-consulta-historial-vehicular.bpmn), [`RF-02-cotizacion-y-cobro.bpmn`](01-inicio/bpmn/RF-02-cotizacion-y-cobro.bpmn), [`RF-04-agendamiento-citas-rampas.bpmn`](01-inicio/bpmn/RF-04-agendamiento-citas-rampas.bpmn), [`RF-05-consulta-estado-vehiculo.bpmn`](01-inicio/bpmn/RF-05-consulta-estado-vehiculo.bpmn) |

---

**Documento preparado por:** Adrián Barboza Vargas
**Fecha:** 11 de octubre de 2026
