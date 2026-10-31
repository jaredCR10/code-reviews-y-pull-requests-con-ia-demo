# Requerimiento Funcional: RF-03 — Catálogo de insumos y control de existencias

### Código
`RF-03`

### Descripción
El sistema debe mantener un catálogo de insumos de alta rotación (aceites, filtros, bujías) con la cantidad disponible de cada uno, permitir consultar su existencia y precio unitario, asociar un insumo a una orden de trabajo descontando la cantidad utilizada, y registrar el ingreso de insumos recibidos para reponer las existencias. Cuando la cantidad requerida supera la existencia, el sistema debe mostrar una alerta y permitir marcar el insumo como "Por pedir a proveedor" sin descontar existencias, de modo que el registro de la orden no se bloquee y la existencia nunca quede negativa.

### Actores
* **Primarios:**
  * Administrador del Taller (rol que ejerce Don Chepe) — asocia los insumos utilizados a la orden de trabajo, consulta la existencia y registra el ingreso de insumos.
  * Mecánico (Nacho / Chalo) — consulta la existencia de un insumo.
* **Secundario:** Mecánico (Nacho / Chalo) — al asociar insumos a una orden, informa al Administrador qué insumo utilizó o necesita durante la reparación.

### Necesidad
Hoy no existe ningún control de inventario: los mecánicos asumen que un insumo está disponible en el estante y suben el vehículo a la rampa antes de confirmarlo. Cuando a medio trabajo descubren que no queda existencia, deben detener la reparación e ir a comprar el repuesto de emergencia a la repuestera local, perdiendo tiempo de taller y generando un reproceso evitable.

### Documentos de Referencia
* `RF-03-verificacion-uso-repuestos.bpmn` — modelado BPMN del proceso actual y del punto de dolor que origina este requerimiento.
* Sección 1.2 del documento de problema — ejemplo real: filtro de aceite agotado a medio trabajo.

### Casos de Uso Relacionados
* [CU-03 — Asociar Insumo a Orden de Trabajo](../../03-casos-de-uso/CU-03-asociar-insumo-a-orden.md)
* [CU-08 — Consultar Existencia de Insumo](../../03-casos-de-uso/CU-08-consultar-existencia-de-insumo.md)
* [CU-13 — Registrar Ingreso de Insumos](../../03-casos-de-uso/CU-13-registrar-ingreso-de-insumos.md)

### Criterios de Aceptación
1. Antes de asociar un insumo a una orden de trabajo, el sistema debe mostrar la cantidad disponible de ese insumo en el catálogo.
2. Si la cantidad disponible de un insumo es cero, el sistema debe mostrar una alerta visible, y debe permitir de todas formas registrar la orden de trabajo.
3. Cada vez que se asocie un insumo a una orden de trabajo con existencia suficiente, el sistema debe descontar del catálogo la cantidad utilizada. Si la cantidad supera la existencia, el sistema debe marcar el insumo como "Por pedir a proveedor" sin descontar, y la existencia nunca debe quedar negativa.
4. Al registrar el ingreso de insumos recibidos, el sistema debe sumar la cantidad recibida a la existencia del insumo y mostrar la nueva existencia.

### Referencias
* Entregable 1 — Descripción del problema y visión del sistema, sección 1.2.

---
**Documento Preparado Por:** Jared Morales Morales  
**Fecha:** 20 de septiembre de 2026