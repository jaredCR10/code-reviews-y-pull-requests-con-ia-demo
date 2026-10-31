# Descripción del problema y visión del sistema

**Sistema de Gestión Integral para Taller Mecánico de Barrio (TallerAuto)**

## 1.1 Situación Actual

En los talleres mecánicos de barrio, la gestión operativa se realiza comúnmente de forma empírica y manual. En el Taller Mecánico El Paraíso, ubicado en Paraíso de Cartago, Don Chepe (dueño y administrador) coordina las citas mediante una agenda de papel y mensajes de WhatsApp, mientras que sus mecánicos, Nacho y Chalo, anotan las fallas de los vehículos y las listas de repuestos en libretas físicas manchadas de grasa.

El taller cuenta únicamente con una computadora de escritorio en la oficina de recepción de Don Chepe. Al no existir registros históricos digitales de los vehículos atendidos ni un control centralizado de inventario, la búsqueda de antecedentes técnicos, la estimación de costos y la asignación del trabajo diario resultan sumamente ineficientes.

## 1.2 Problema a Resolver

Esta gestión informal y en papel genera los siguientes problemas críticos en la operación diaria del taller:

Pérdida de historial vehicular: Falta de registro de servicios pasados, obligando a depender de la memoria del mecánico o a revisar cuadernos viejos. Ejemplo real: Llega un auto con problemas de frenos; como Nacho (quien lo atendió hace dos meses) no está, Don Chepe debe buscar manualmente en las libretas para comprobar si las pastillas cambiadas tenían garantía o de qué marca eran, perdiendo valioso tiempo frente al cliente.

Control de repuestos informal: Compras sobre la marcha sin inventario claro, resultando en repuestos traspapelados, compras duplicadas o cobros omitidos al cliente final. Ejemplo real: Chalo asume que hay filtros de aceite en el estante y sube un carro a la rampa; a medio trabajo descubre que usaron el último filtro ayer, teniendo que detener el trabajo técnico para ir a comprar uno de emergencia a la repuestera local de Paraíso.

Presupuestos y cobros desorganizados: Cotizaciones informales por WhatsApp que derivan en discrepancias al cobrar u omisión de cobro de mano de obra. Ejemplo real: Don Chepe envía un precio estimado por WhatsApp basándose en lo que Nacho le gritó desde la rampa; al final el repuesto cuesta más y se omiten líquidos en el cálculo, obligando al taller a asumir la pérdida para evitar reclamos del cliente.

Comunicación caótica e interrupciones: Constantes llamadas telefónicas de clientes para consultar el estado del vehículo, lo que interrumpe la jornada de trabajo. Ejemplo real: Los clientes llaman de forma constante para preguntar por su vehículo. Don Chepe debe dejar de atender la recepción e ir a preguntarle a Chalo, interrumpiendo el trabajo técnico y aumentando el riesgo de errores en la reparación por distracciones.

Desfase en agenda y espacio físico: Ineficiente asignación de rampas y cuellos de botella por repuestos tardíos, bloqueando la entrada de nuevos vehículos. Ejemplo real: Don Chepe apunta tres cambios de embrague (trabajo de 4 horas cada uno) en la pizarra para el lunes por la mañana. A la misma hora llegan clientes sin cita para cambios de aceite, colapsando el taller y obligando a parquear carros en la vía pública.

Impacto Financiero y Operativo: Si la situación actual continúa, el taller arriesga pérdidas financieras continuas por fugas en facturación, baja productividad operativa y pérdida gradual de clientes por falta de transparencia y demora en las entregas.

## 1.3 Solución Propuesta

Se propone desarrollar un sistema de software web centralizado y exclusivo para PC de escritorio que automatice la recepción, diagnóstico, control básico de insumos, cotización y seguimiento de órdenes de trabajo en el taller desde la oficina de recepción de Don Chepe.

**Alcance del Sistema**

Dentro del alcance:

- Expediente digital por placa vehicular (RF-01): Historial cronológico de fallas, servicios, diagnósticos, repuestos utilizados y comentarios técnicos rápidos de cada vehículo.
- Catálogo ligero de insumos (RF-03): Registro de existencias de consumibles críticos de alta rotación (aceites, filtros, bujías), con alerta de existencia cero y reposición de insumos, permitiendo asociar insumos a las órdenes de trabajo sin bloquear el flujo operativo técnico: si la cantidad requerida supera la existencia, el insumo se marca como "Por pedir a proveedor".
- Módulo de cotización y emisión de presupuestos (RF-02): Creación ágil de presupuestos desglosados calculando explícitamente repuestos y mano de obra, con posibilidad de edición manual flexible en la PC de cobro.
- Tablero de control de flujo de trabajo (RF-05): Seguimiento del estado actual de los autos mediante estados lógicos (Ingresado, En Diagnóstico, Esperando Repuesto, En Reparación, Listo para Entrega, Entregado).
- Planificador de rampas y citas (RF-04): Agenda visual de citas configurada por espacios de rampa físicos y franjas horarias.

Fuera del alcance:

- Facturación electrónica directa ante el Ministerio de Hacienda.
- Integración automatizada de pasarelas de pago electrónico en línea.

## 1.4 Visión del Sistema

Para Don Chepe y su equipo del Taller Mecánico El Paraíso, que necesitan reemplazar la gestión en papel y por WhatsApp que hoy genera pérdidas de información y de dinero, TallerAuto es un sistema de gestión operativa que organiza la gestión administrativa del taller: agiliza la relación con los clientes y ordena su organización interna.
