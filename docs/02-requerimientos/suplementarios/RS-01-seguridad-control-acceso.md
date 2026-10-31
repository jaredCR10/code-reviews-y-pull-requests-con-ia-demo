# Requerimiento Suplementario: RS-01 — Seguridad: control de acceso por roles

### Estatus
Propuesto

### Contexto
El sistema será operado por dos tipos de usuario con responsabilidades distintas: Don Chepe, en su rol de Administrador del Taller, y los mecánicos (Nacho y Chalo), en su rol de Mecánico. Ambos roles necesitan operar el sistema desde la misma computadora de recepción, pero no toda la información debe estar igualmente disponible para los dos: el manejo de presupuestos y su confirmación es una decisión comercial que, en la situación actual, toma únicamente Don Chepe (sección 1.2, "Presupuestos y cobros desorganizados").

### Requerimiento
El sistema deberá identificar con qué rol (Administrador o Mecánico) opera cada usuario antes de permitir cualquier acción, y deberá restringir al rol Administrador la confirmación y el ajuste manual de los presupuestos (CU-02, paso 8 y FA-02). El rol Mecánico podrá registrar diagnósticos, insumos y cambios de estado de los vehículos, pero no podrá confirmar ni modificar un presupuesto.

### Justificación
Sin una distinción de roles, cualquier persona que use la computadora de recepción podría confirmar o modificar un presupuesto, lo que reproduce el mismo riesgo que hoy generan los presupuestos informales por WhatsApp: montos que cambian sin control y discrepancias al cobrar (sección 1.2, "Presupuestos y cobros desorganizados"). Restringir esa decisión al rol Administrador mantiene en una sola persona la responsabilidad sobre los montos que se le comunican al cliente.

### Implicaciones
El sistema debe implementar un mecanismo mínimo de identificación de usuario (por ejemplo, un inicio de sesión simple con un rol asignado a cada usuario) antes de habilitar la confirmación de un presupuesto. No se requiere un módulo de administración de usuarios ni perfiles de seguridad adicionales: basta con distinguir entre los dos roles existentes, Administrador y Mecánico.

### Alternativas Consideradas
Dejar que cualquier usuario autenticado confirme presupuestos sin distinción de rol: se descarta porque no resuelve el problema de control sobre los montos comunicados al cliente, que es el problema documentado en la sección 1.2.

Crear un catálogo extenso de roles y permisos, con permisos independientes por cada módulo del sistema: se descarta por ser un alcance mayor al que el taller necesita, dado que solo existen dos tipos de usuario.

### Decisión
Se acepta como criterio de seguridad verificable: un usuario con rol Mecánico no puede confirmar ni modificar un presupuesto; solo un usuario con rol Administrador puede hacerlo.

### Requerimientos Funcionales Implicados
* RF-02 — Elaboración de presupuestos desglosados

### Referencias
* Entregable 1 — Descripción del problema, sección 1.2, "Presupuestos y cobros desorganizados".

---
**Documento Preparado Por:** Jared Morales Morales
**Fecha:** 9 de octubre de 2026
