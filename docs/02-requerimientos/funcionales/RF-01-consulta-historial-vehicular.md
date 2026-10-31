# Requerimiento Funcional: RF-01 — Consulta del historial de servicio por placa

### Código
`RF-01`

### Descripción
El sistema debe permitir al Administrador del Taller y a los mecánicos consultar, a partir de la placa de un vehículo, el historial cronológico completo de servicios anteriores realizados en el taller: fecha, diagnóstico registrado, repuestos utilizados, garantía asociada a cada repuesto y comentarios técnicos del mecánico que atendió el caso. También debe permitir registrar el vehículo cuando su placa aún no está registrada y registrar el servicio realizado al cerrar la orden de trabajo, de modo que el historial se alimente con cada trabajo.

### Actores
* **Primarios:**
  * Administrador del Taller (rol que ejerce Don Chepe) — consulta el expediente desde la computadora de recepción.
  * Mecánico (Nacho / Chalo) — consulta el expediente y, al finalizar cada servicio, registra la información que queda en el expediente que luego se consulta.
* **Secundario:** Cliente (reporta la falla y proporciona la placa del vehículo y los datos del propietario).

### Necesidad
Hoy el taller no tiene ningún registro digital de los vehículos atendidos. Cuando llega un vehículo con una falla y el mecánico que lo atendió anteriormente no está presente, Don Chepe depende de la memoria del personal o de revisar libretas físicas manchadas de grasa para saber si un repuesto tenía garantía o qué marca se usó. Esa búsqueda manual hace perder tiempo frente al cliente y puede llevar a repetir un cobro que ya estaba cubierto por garantía, o a no cobrar algo que no lo estaba.

### Documentos de Referencia
* `RF-01-consulta-historial-vehicular.bpmn` — modelado BPMN del proceso actual y del punto de dolor que origina este requerimiento.
* Sección 1.2 del documento de problema — ejemplo real: vehículo con falla de frenos, mecánico ausente.

### Casos de Uso Relacionados
* [CU-01 — Consultar Historial Vehicular por Placa](../../03-casos-de-uso/CU-01-consultar-historial-vehicular.md)
* [CU-06 — Registrar Vehículo](../../03-casos-de-uso/CU-06-registrar-vehiculo.md)
* [CU-11 — Registrar Servicio y Cerrar Orden de Trabajo](../../03-casos-de-uso/CU-11-registrar-servicio-y-cerrar-orden.md)

### Criterios de Aceptación
1. Dada una placa con al menos un servicio anterior registrado, el sistema debe mostrar todos los servicios previos asociados a esa placa, incluyendo para cada uno la fecha, el diagnóstico, los repuestos utilizados y si tenían garantía vigente.
2. Dada una placa sin servicios previos registrados, el sistema debe indicarlo explícitamente en pantalla, en lugar de mostrar una lista vacía sin mensaje.
3. Todo servicio que se marque como finalizado debe quedar agregado al expediente del vehículo correspondiente antes de poder cerrar la orden de trabajo.
4. Dada una placa no registrada, el sistema debe ofrecer registrar el vehículo con su placa, marca, modelo, año y los datos del propietario (nombre y contacto), y al confirmar el registro debe crear el expediente del vehículo sin servicios.

### Referencias
* Entregable 1 — Descripción del problema y visión del sistema, sección 1.2.

---
**Documento Preparado Por:** Jared Morales Morales  
**Fecha:** 20 de septiembre de 2026