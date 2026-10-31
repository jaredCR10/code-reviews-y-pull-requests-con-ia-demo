# Casos de uso: convenciones y supuestos

Índice de los casos de uso: ver la tabla en [`../README.md`](../README.md#03--casos-de-uso). Trazabilidad completa: [`../02-requerimientos/trazabilidad-rf-cu.md`](../02-requerimientos/trazabilidad-rf-cu.md).

## Convenciones

- **Actores (roles, no personas):** Administrador del Taller (rol que ejerce Don Chepe), Mecánico (rol que ejercen Nacho y Chalo) y Cliente. Administrador y Mecánico son actores primarios (operan el sistema); el Cliente es secundario (dispara o recibe la interacción, sin operar el sistema). Ver [`actores.md`](actores.md).
- **"El usuario"** significa, solo dentro de un caso de uso, cualquiera de sus actores primarios (Administrador del Taller o Mecánico); en los flujos de CU-01, CU-02, CU-05, CU-06, CU-08, CU-09 y CU-11 se nombra explícitamente "el Administrador o el Mecánico" en cada paso. Cuando el caso de uso tiene un único actor primario se nombra ese actor. Única excepción: en CU-02, la confirmación del presupuesto (paso 8) y su ajuste manual (FA-02) son exclusivos del rol Administrador (ver RS-01).
- **Insumo:** cualquier repuesto o material consumible del inventario (aceites, filtros, bujías, piezas). Es el único término usado en todo el documento.
- **Presupuesto:** desglose de insumos, mano de obra y total que se ofrece al cliente. Es el único término usado (no "cotización").
- **Estado de la orden de trabajo:** "Esperando Aprobación", "Aprobada", "Rechazada" y "Cerrada".
- **Estado del vehículo (RF-05):** "Ingresado", "En Diagnóstico", "Esperando Repuesto", "En Reparación", "Listo para Entrega" y "Entregado". Solo cambia mediante CU-05. Ningún otro caso de uso lo modifica.
- **Marca "Por pedir a proveedor":** se aplica a un insumo cuando la cantidad requerida supera su existencia. El insumo no descuenta existencias, y la existencia nunca queda negativa.
- **Restricciones de alcance:** el sistema no maneja una gestión completa de usuarios (altas, bajas, recuperación de contraseña), facturación electrónica ni reserva temporal de insumos. La única distinción de acceso es el rol (Administrador o Mecánico) que exige RS-01 para confirmar o modificar un presupuesto.
- **Requerimientos suplementarios citados:**
  - [RS-01](../02-requerimientos/suplementarios/RS-01-seguridad-control-acceso.md): control de acceso por rol; solo el Administrador puede confirmar o modificar un presupuesto (CU-02). El Mecánico puede registrar diagnósticos e insumos pero no confirmar el presupuesto.
  - [RS-02](../02-requerimientos/suplementarios/RS-02-tiempo-respuesta-historial.md): tiempo de respuesta menor a 5 segundos en las consultas.
  - [RS-03](../02-requerimientos/suplementarios/RS-03-aprendizaje-sin-capacitacion.md): un operador sin experiencia completa las tareas frecuentes (registrar orden, generar presupuesto, agendar cita y consultar estado) sin ayuda, tras 15 minutos de explicación.

## Supuestos del análisis

Decisiones tomadas por el equipo que no están definidas en los requerimientos y quedan pendientes de confirmar con Don Chepe:

1. **Formato de placa:** de 5 a 7 caracteres alfanuméricos, con guion opcional.
2. **Moneda:** colones (₡), por tratarse de un taller en Paraíso, Cartago.
3. **Estados de la orden de trabajo:** los cuatro listados en las convenciones son una propuesta. Los requerimientos solo definen los seis estados del vehículo.
4. **Transiciones válidas de estado del vehículo:** no están definidas. CU-05 solo rechaza elegir el estado que el vehículo ya tiene.
5. **Datos del propietario** (CU-06): nombre y datos de contacto.
6. **Insumos "Por pedir a proveedor":** no está definido qué ocurre cuando el insumo llega (CU-13). Falta decidir si se descuenta en ese momento o si el administrador lo asocia de nuevo.
7. **Alta de insumos nuevos en el catálogo:** no está cubierta. CU-13 solo repone insumos ya existentes.

---

**Documento Preparado Por:** José A Ramírez y Adrián Barboza Vargas
**Fecha:** 21 de septiembre de 2026
