# Requerimiento Funcional: RF-04 — Planificador de citas y asignación de rampas

### Código
`RF-04`

### Descripción
El sistema debe mostrar una agenda visual de citas organizada por espacio de rampa física, indicando qué rampas están ocupadas y cuáles disponibles en cada franja horaria, antes de confirmar una nueva cita o recibir un vehículo sin cita.

### Actores
* **Primario:** Administrador del Taller (rol que ejerce Don Chepe) — agenda las citas y decide si hay espacio para recibir un vehículo.
* **Secundario:** Cliente — solicita una cita o llega al taller sin cita previa.

### Necesidad
Hoy la agenda es una pizarra física en la que Don Chepe anota los trabajos del día sin visibilidad de cuántas rampas están realmente disponibles a cada hora. Esto ha llevado a agendar varios trabajos largos (por ejemplo, tres cambios de embrague de cuatro horas) para la misma mañana en que además llegan clientes sin cita para trabajos cortos, colapsando el taller y obligando a parquear vehículos en la vía pública.

### Documentos de Referencia
* `RF-04-agendamiento-citas-rampas.bpmn` — modelado BPMN del proceso actual y del punto de dolor que origina este requerimiento.
* Sección 1.2 del documento de problema — ejemplo real: tres cambios de embrague agendados la misma mañana que llegan clientes sin cita.

### Casos de Uso Relacionados
* [CU-04 — Agendar Cita de Mantenimiento](../../03-casos-de-uso/CU-04-agendar-cita-de-mantenimiento.md)
* [CU-07 — Registrar Llegada de Vehículo sin Cita](../../03-casos-de-uso/CU-07-registrar-llegada-sin-cita.md)

### Criterios de Aceptación
1. Antes de confirmar una cita, el sistema debe mostrar qué rampas están libres y cuáles ocupadas en la franja horaria solicitada.
2. El sistema debe impedir agendar dos citas en la misma rampa para la misma franja horaria.
3. Un vehículo que llegue sin cita debe poder registrarse en la agenda del día, quedando marcado como "sin cita previa".

### Referencias
* Entregable 1 — Descripción del problema y visión del sistema, sección 1.2.

---
**Documento Preparado Por:** Jared Morales Morales  
**Fecha:** 20 de septiembre de 2026