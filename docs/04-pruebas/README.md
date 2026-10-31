# Guion de pruebas

Los guiones se derivan de los escenarios de prueba de cada caso de uso y están escritos en Gherkin, uno por archivo `.feature`, según la plantilla del curso.

## Organización

- Un archivo `.feature` por caso de uso.
- Cada escenario lleva las etiquetas `@CU-XX`, `@RF-XX`, su identificador (`@E1`, `@E2`, ...) y el flujo que cubre (`@flujo-principal`, `@FA-01`, ...). Los escenarios de requerimientos suplementarios llevan además `@RS-01`, `@RS-02` o `@RS-03`.
- Los archivos usan `# language: es`: `Característica`, `Escenario`, `Dado`, `Cuando`, `Entonces`, `Y`.
- La ejecución es manual: se sigue el archivo `.feature` paso a paso y se anota el resultado en el registro de más abajo.

## Cobertura por caso de uso

| CU | Guion | Escenarios | Flujos cubiertos |
|---|---|---|---|
| [CU-01](../03-casos-de-uso/CU-01-consultar-historial-vehicular.md) | [`CU-01.feature`](CU-01.feature) | 5 | Principal, RS-02, FA-01, FA-02, FA-03, FA-04 |
| [CU-02](../03-casos-de-uso/CU-02-registrar-orden-con-presupuesto.md) | [`CU-02.feature`](CU-02.feature) | 8 | Principal, FA-01, FA-02, FA-03, FA-04, FA-05, RS-01, RS-03 |
| [CU-03](../03-casos-de-uso/CU-03-asociar-insumo-a-orden.md) | [`CU-03.feature`](CU-03.feature) | 6 | Principal, FA-01, FA-02, FA-03 |
| [CU-04](../03-casos-de-uso/CU-04-agendar-cita-de-mantenimiento.md) | [`CU-04.feature`](CU-04.feature) | 5 | Principal, FA-01, FA-02, FA-03, RS-03 |
| [CU-05](../03-casos-de-uso/CU-05-actualizar-estado-de-vehiculo.md) | [`CU-05.feature`](CU-05.feature) | 3 | Principal, FA-01, FA-02 |
| [CU-06](../03-casos-de-uso/CU-06-registrar-vehiculo.md) | [`CU-06.feature`](CU-06.feature) | 3 | Principal, FA-01, FA-02 |
| [CU-07](../03-casos-de-uso/CU-07-registrar-llegada-sin-cita.md) | [`CU-07.feature`](CU-07.feature) | 3 | Principal, FA-01, FA-02 |
| [CU-08](../03-casos-de-uso/CU-08-consultar-existencia-de-insumo.md) | [`CU-08.feature`](CU-08.feature) | 3 | Principal, RS-02, FA-01, FA-02 |
| [CU-09](../03-casos-de-uso/CU-09-consultar-estado-de-vehiculo.md) | [`CU-09.feature`](CU-09.feature) | 4 | Principal, RS-02, FA-01, RS-03 |
| [CU-10](../03-casos-de-uso/CU-10-registrar-aprobacion-de-presupuesto.md) | [`CU-10.feature`](CU-10.feature) | 3 | Principal, FA-01, FA-02 |
| [CU-11](../03-casos-de-uso/CU-11-registrar-servicio-y-cerrar-orden.md) | [`CU-11.feature`](CU-11.feature) | 3 | Principal, FA-01, FA-02 |
| [CU-12](../03-casos-de-uso/CU-12-registrar-cobro-final.md) | [`CU-12.feature`](CU-12.feature) | 4 | Principal, FA-01, FA-02 |
| [CU-13](../03-casos-de-uso/CU-13-registrar-ingreso-de-insumos.md) | [`CU-13.feature`](CU-13.feature) | 3 | Principal, FA-01, FA-02 |

Total: 13 guiones y 53 escenarios. Todos los flujos alternativos de los 13 casos de uso tienen al menos un escenario.

## Registro de ejecución manual

Resultado: `Exitoso`, `Fallido` o `Pendiente`.

| Feature | Escenario | Resultado | Fecha | QA ejecutor |
|---|---|---|---|---|
| [CU-01](CU-01.feature) Consultar Historial Vehicular por Placa | E1 Consulta exitosa de un vehículo registrado con historial | Pendiente | | |
| [CU-01](CU-01.feature) Consultar Historial Vehicular por Placa | E2 Placa no registrada y el usuario acepta registrar el vehículo | Pendiente | | |
| [CU-01](CU-01.feature) Consultar Historial Vehicular por Placa | E3 Placa con formato inválido | Pendiente | | |
| [CU-01](CU-01.feature) Consultar Historial Vehicular por Placa | E4 Placa no registrada y el usuario declina registrar el vehículo | Pendiente | | |
| [CU-01](CU-01.feature) Consultar Historial Vehicular por Placa | E5 Vehículo registrado sin servicios previos | Pendiente | | |
| [CU-02](CU-02.feature) Registrar Orden de Trabajo con Presupuesto | E1 Registro exitoso de una orden con presupuesto | Pendiente | | |
| [CU-02](CU-02.feature) Registrar Orden de Trabajo con Presupuesto | E2 Insumo con existencia cero marcado como Por pedir a proveedor | Pendiente | | |
| [CU-02](CU-02.feature) Registrar Orden de Trabajo con Presupuesto | E3 Insumo con existencia parcial marcado como Por pedir a proveedor | Pendiente | | |
| [CU-02](CU-02.feature) Registrar Orden de Trabajo con Presupuesto | E4 Ajuste manual del precio de una línea del presupuesto | Pendiente | | |
| [CU-02](CU-02.feature) Registrar Orden de Trabajo con Presupuesto | E5 Cancelación confirmada del registro | Pendiente | | |
| [CU-02](CU-02.feature) Registrar Orden de Trabajo con Presupuesto | E6 Cancelación no confirmada | Pendiente | | |
| [CU-02](CU-02.feature) Registrar Orden de Trabajo con Presupuesto | E7 Un operador sin experiencia registra una orden sin ayuda | Pendiente | | |
| [CU-02](CU-02.feature) Registrar Orden de Trabajo con Presupuesto | E8 Confirmación de presupuesto denegada para el rol Mecánico | Pendiente | | |
| [CU-03](CU-03.feature) Asociar Insumo a Orden de Trabajo | E1 Asociación de un insumo con existencia suficiente | Pendiente | | |
| [CU-03](CU-03.feature) Asociar Insumo a Orden de Trabajo | E2 Asociación repetida de varios insumos | Pendiente | | |
| [CU-03](CU-03.feature) Asociar Insumo a Orden de Trabajo | E3 Existencia cero con marca Por pedir confirmada | Pendiente | | |
| [CU-03](CU-03.feature) Asociar Insumo a Orden de Trabajo | E4 Existencia parcial con marca Por pedir confirmada | Pendiente | | |
| [CU-03](CU-03.feature) Asociar Insumo a Orden de Trabajo | E5 Marca Por pedir rechazada | Pendiente | | |
| [CU-03](CU-03.feature) Asociar Insumo a Orden de Trabajo | E6 Insumo no encontrado en el catálogo | Pendiente | | |
| [CU-04](CU-04.feature) Agendar Cita de Mantenimiento | E1 Cita agendada en una rampa libre | Pendiente | | |
| [CU-04](CU-04.feature) Agendar Cita de Mantenimiento | E2 Conflicto de horario en la misma rampa | Pendiente | | |
| [CU-04](CU-04.feature) Agendar Cita de Mantenimiento | E3 Cita con un vehículo no registrado | Pendiente | | |
| [CU-04](CU-04.feature) Agendar Cita de Mantenimiento | E4 Cliente que llega sin cita previa | Pendiente | | |
| [CU-04](CU-04.feature) Agendar Cita de Mantenimiento | E5 Un operador sin experiencia agenda una cita sin ayuda | Pendiente | | |
| [CU-05](CU-05.feature) Actualizar Estado de Vehículo | E1 Cambio de estado a En Reparación | Pendiente | | |
| [CU-05](CU-05.feature) Actualizar Estado de Vehículo | E2 Estado igual al vigente | Pendiente | | |
| [CU-05](CU-05.feature) Actualizar Estado de Vehículo | E3 Vehículo sin orden de trabajo | Pendiente | | |
| [CU-06](CU-06.feature) Registrar Vehículo | E1 Registro exitoso de un vehículo y su propietario | Pendiente | | |
| [CU-06](CU-06.feature) Registrar Vehículo | E2 Datos obligatorios incompletos | Pendiente | | |
| [CU-06](CU-06.feature) Registrar Vehículo | E3 Cancelación del registro | Pendiente | | |
| [CU-07](CU-07.feature) Registrar Llegada de Vehículo sin Cita | E1 Ingreso sin cita en una rampa libre | Pendiente | | |
| [CU-07](CU-07.feature) Registrar Llegada de Vehículo sin Cita | E2 Sin espacio disponible en el día | Pendiente | | |
| [CU-07](CU-07.feature) Registrar Llegada de Vehículo sin Cita | E3 Llegada sin cita de un vehículo no registrado | Pendiente | | |
| [CU-08](CU-08.feature) Consultar Existencia de Insumo | E1 Consulta de un insumo con existencia | Pendiente | | |
| [CU-08](CU-08.feature) Consultar Existencia de Insumo | E2 Consulta de un insumo con existencia cero | Pendiente | | |
| [CU-08](CU-08.feature) Consultar Existencia de Insumo | E3 Insumo no encontrado | Pendiente | | |
| [CU-09](CU-09.feature) Consultar Estado de Vehículo | E1 Consulta por placa | Pendiente | | |
| [CU-09](CU-09.feature) Consultar Estado de Vehículo | E2 Consulta por número de orden | Pendiente | | |
| [CU-09](CU-09.feature) Consultar Estado de Vehículo | E3 Vehículo sin orden de trabajo | Pendiente | | |
| [CU-09](CU-09.feature) Consultar Estado de Vehículo | E4 Un operador sin experiencia consulta el estado sin ayuda | Pendiente | | |
| [CU-10](CU-10.feature) Registrar Aprobación de Presupuesto | E1 El cliente aprueba el presupuesto | Pendiente | | |
| [CU-10](CU-10.feature) Registrar Aprobación de Presupuesto | E2 El cliente rechaza el presupuesto | Pendiente | | |
| [CU-10](CU-10.feature) Registrar Aprobación de Presupuesto | E3 Orden que no está pendiente de aprobación | Pendiente | | |
| [CU-11](CU-11.feature) Registrar Servicio y Cerrar Orden de Trabajo | E1 Cierre exitoso de una orden aprobada | Pendiente | | |
| [CU-11](CU-11.feature) Registrar Servicio y Cerrar Orden de Trabajo | E2 Cancelación del cierre | Pendiente | | |
| [CU-11](CU-11.feature) Registrar Servicio y Cerrar Orden de Trabajo | E3 Orden que no está aprobada | Pendiente | | |
| [CU-12](CU-12.feature) Registrar Cobro Final | E1 Cobro final con diferencia respecto al presupuesto | Pendiente | | |
| [CU-12](CU-12.feature) Registrar Cobro Final | E2 Cobro final sin diferencia | Pendiente | | |
| [CU-12](CU-12.feature) Registrar Cobro Final | E3 Monto inválido | Pendiente | | |
| [CU-12](CU-12.feature) Registrar Cobro Final | E4 Orden que no está cerrada | Pendiente | | |
| [CU-13](CU-13.feature) Registrar Ingreso de Insumos | E1 Ingreso de insumos recibidos | Pendiente | | |
| [CU-13](CU-13.feature) Registrar Ingreso de Insumos | E2 Insumo no encontrado | Pendiente | | |
| [CU-13](CU-13.feature) Registrar Ingreso de Insumos | E3 Cantidad inválida | Pendiente | | |

---

**Documento Preparado Por:** Adrián Barboza Vargas
**Fecha:** 21 de septiembre de 2026
