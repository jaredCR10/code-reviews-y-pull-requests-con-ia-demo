# Requerimiento Funcional: RF-05 — Tablero de control de flujo de trabajo

### Código
`RF-05`

### Descripción
El sistema debe mostrar el estado actual de cada vehículo en el taller mediante seis estados lógicos (Ingresado, En Diagnóstico, Esperando Repuesto, En Reparación, Listo para Entrega, Entregado), consultable desde la computadora de recepción sin necesidad de preguntar directamente al mecánico.

### Actores
* **Primarios:**
  * Administrador del Taller (rol que ejerce Don Chepe) — consulta y actualiza el estado del vehículo para responder al cliente.
  * Mecánico (Nacho / Chalo) — actualiza y consulta el estado del vehículo en el que está trabajando.
* **Secundario:** Cliente — recibe la información de estado al llamar o preguntar.

### Necesidad
Hoy, cada vez que un cliente llama a preguntar por su vehículo, Don Chepe debe dejar la recepción e ir personalmente a preguntarle al mecánico en qué va la reparación. Esto interrumpe el trabajo técnico en curso y aumenta el riesgo de errores en la reparación por las distracciones que genera.

### Documentos de Referencia
* `RF-05-consulta-estado-vehiculo.bpmn` — modelado BPMN del proceso actual y del punto de dolor que origina este requerimiento.
* Sección 1.2 del documento de problema — ejemplo real: llamadas constantes que interrumpen el trabajo técnico.

### Casos de Uso Relacionados
* [CU-05 — Actualizar Estado de Vehículo](../../03-casos-de-uso/CU-05-actualizar-estado-de-vehiculo.md)
* [CU-09 — Consultar Estado de Vehículo](../../03-casos-de-uso/CU-09-consultar-estado-de-vehiculo.md)

### Criterios de Aceptación
1. El sistema debe permitir cambiar el estado de un vehículo únicamente entre los seis estados definidos (Ingresado, En Diagnóstico, Esperando Repuesto, En Reparación, Listo para Entrega, Entregado).
2. Al consultar un vehículo por placa o por número de orden de trabajo, el sistema debe mostrar su estado actual sin requerir ninguna búsqueda o paso adicional.
3. Todo cambio de estado debe quedar registrado con fecha y hora, de forma que se pueda reconstruir el recorrido completo del vehículo dentro del taller.

### Referencias
* Entregable 1 — Descripción del problema y visión del sistema, sección 1.2.

---
**Documento Preparado Por:** Jared Morales Morales  
**Fecha:** 20 de septiembre de 2026