# Requerimiento Funcional: RF-02 — Elaboración de presupuestos desglosados

### Código
`RF-02`

### Descripción
El sistema debe permitir crear un presupuesto que desglose por separado el costo de repuestos y el costo de mano de obra, y que se pueda editar manualmente antes de confirmarlo, desde la computadora de recepción. También debe permitir registrar la decisión del cliente sobre el presupuesto (aprobación o rechazo) y registrar el cobro final de la orden, comparándolo contra el presupuesto aprobado.

### Actores
* **Primarios:**
  * Administrador del Taller (rol que ejerce Don Chepe) — elabora y confirma el presupuesto, registra la decisión del cliente y registra el cobro final.
  * Mecánico (Nacho / Chalo) — registra el diagnóstico y los insumos y las horas de mano de obra necesarios para el presupuesto.
* **Secundario:** Cliente — recibe el presupuesto, lo aprueba o rechaza y paga el monto final.

### Necesidad
Hoy Don Chepe envía un precio estimado por WhatsApp basándose en lo que el mecánico le indica verbalmente desde la rampa. Al terminar el trabajo, el repuesto real puede costar más de lo estimado o quedar fuera del cálculo algún insumo (por ejemplo, líquidos), y el taller termina asumiendo esa diferencia para no generar un reclamo del cliente.

### Documentos de Referencia
* `RF-02-cotizacion-y-cobro.bpmn` — modelado BPMN del proceso actual y del punto de dolor que origina este requerimiento.
* Sección 1.2 del documento de problema — ejemplo real: presupuesto por WhatsApp, líquidos omitidos.

### Casos de Uso Relacionados
* [CU-02 — Registrar Orden de Trabajo con Presupuesto](../../03-casos-de-uso/CU-02-registrar-orden-con-presupuesto.md)
* [CU-10 — Registrar Aprobación de Presupuesto](../../03-casos-de-uso/CU-10-registrar-aprobacion-de-presupuesto.md)
* [CU-12 — Registrar Cobro Final](../../03-casos-de-uso/CU-12-registrar-cobro-final.md)

### Criterios de Aceptación
1. El presupuesto generado debe mostrar, como mínimo, el subtotal de repuestos, el subtotal de mano de obra y el total.
2. El sistema debe permitir modificar manualmente cualquier línea del presupuesto antes de confirmarlo al cliente.
3. Al cerrar la orden de trabajo, el sistema debe permitir registrar el cobro final y dejar visible la diferencia, si existe, respecto al presupuesto aprobado.
4. El sistema debe registrar la decisión del cliente sobre el presupuesto: una orden aprobada queda en estado "Aprobada" y una rechazada queda en estado "Rechazada", ambas con la fecha de la decisión.

### Referencias
* Entregable 1 — Descripción del problema y visión del sistema, sección 1.2.

---
**Documento Preparado Por:** Jared Morales Morales  
**Fecha:** 20 de septiembre de 2026