# Requerimiento Suplementario: RS-02 — Tiempo de respuesta en la consulta del historial vehicular

### Estatus
Propuesto

### Contexto
El ejemplo real documentado en el problema (sección 1.2) describe a Don Chepe buscando manualmente en las libretas mientras el cliente espera frente a él, antes de poder confirmar si un repuesto tenía garantía vigente.

### Requerimiento
El sistema deberá mostrar el historial completo de servicios de un vehículo en menos de 5 segundos después de ingresar su placa, medido con un catálogo de al menos 50 vehículos registrados. El mismo límite de 5 segundos aplica a la consulta de la existencia de un insumo y a la consulta del estado de un vehículo.

### Justificación
RF-01 resuelve el problema de no tener el dato, pero no resuelve por sí solo la espera frente al cliente si la consulta es lenta. El punto de dolor documentado no es "no saber", es "hacer esperar al cliente mientras se busca". Fijar un tiempo máximo de respuesta es lo que efectivamente elimina esa espera, y evita que el requerimiento quede como una promesa sin forma de comprobarse.

### Implicaciones
La búsqueda de vehículos debe indexarse directamente por placa, no recorrer secuencialmente todos los registros del expediente. La consulta de insumos y de estado debe apoyarse en búsquedas directas por código, nombre, placa o número de orden.

### Alternativas Consideradas
Dejar el tiempo de respuesta sin definir y a criterio de quien implemente el sistema: se descarta porque, sin un número concreto, no hay manera de verificar si el requerimiento se cumplió, y la rúbrica del entregable marca como no verificable cualquier condición sin criterio medible.

### Decisión
Se fija un máximo de 5 segundos como criterio de aceptación verificable para esta consulta.

### Requerimientos Funcionales Implicados
* RF-01 — Consulta del historial de servicio por placa
* RF-03 — Catálogo de insumos y control de existencias (consulta de existencia de un insumo)
* RF-05 — Tablero de control de flujo de trabajo (consulta del estado de un vehículo)

### Referencias
* Entregable 1 — Descripción del problema, sección 1.2, ejemplo real de la consulta de frenos con el mecánico ausente.

---
**Documento Preparado Por:** Jared Morales Morales  
**Fecha:** 20 de septiembre de 2026