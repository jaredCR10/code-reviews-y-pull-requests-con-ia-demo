# language: es
@CU-12 @RF-02
Característica: CU-12 Registrar Cobro Final
  Como administrador del taller
  Quiero registrar el monto final cobrado por una orden cerrada
  Para compararlo contra el presupuesto aprobado

  @flujo-principal @E1
  Escenario: E1 Cobro final con diferencia respecto al presupuesto
    Dado que la orden #102 está en estado "Cerrada" con un presupuesto aprobado de ₡20 000
    Cuando el administrador ingresa un monto final cobrado de ₡22 500
    Entonces el sistema registra el cobro final
    Y despliega una diferencia de +₡2 500

  @flujo-principal @E2
  Escenario: E2 Cobro final sin diferencia
    Dado que la orden #104 está en estado "Cerrada" con un presupuesto aprobado de ₡20 000
    Cuando el administrador ingresa un monto final cobrado de ₡20 000
    Entonces el sistema registra el cobro final
    Y despliega una diferencia de ₡0

  @FA-01 @E3
  Escenario: E3 Monto inválido
    Cuando el administrador ingresa un monto de -₡5 000
    Entonces el sistema informa "El monto debe ser un valor numérico mayor que cero."
    Y solicita el monto de nuevo

  @FA-02 @E4
  Escenario: E4 Orden que no está cerrada
    Dado que la orden #103 está en estado "Esperando Aprobación"
    Cuando el administrador selecciona la orden #103
    Entonces el sistema informa "La orden no existe, no está cerrada o ya fue cobrada."
    Y solicita seleccionar otra orden
