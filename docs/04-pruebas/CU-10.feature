# language: es
@CU-10 @RF-02
Característica: CU-10 Registrar Aprobación de Presupuesto
  Como administrador del taller
  Quiero registrar la decisión del cliente sobre un presupuesto
  Para dejar la orden aprobada o rechazada con su fecha

  @flujo-principal @E1
  Escenario: E1 El cliente aprueba el presupuesto
    Dado que la orden #103 está en estado "Esperando Aprobación" con un total de ₡20 000
    Cuando el administrador registra la aprobación del cliente
    Entonces el sistema cambia el estado de la orden a "Aprobada"
    Y registra la fecha de aprobación

  @FA-01 @E2
  Escenario: E2 El cliente rechaza el presupuesto
    Dado que la orden #103 está en estado "Esperando Aprobación"
    Cuando el administrador registra el rechazo del cliente
    Entonces el sistema cambia el estado de la orden a "Rechazada"
    Y registra la fecha

  @FA-02 @E3
  Escenario: E3 Orden que no está pendiente de aprobación
    Dado que la orden #101 está en estado "Aprobada"
    Cuando el administrador selecciona la orden #101
    Entonces el sistema informa "La orden no existe o no está pendiente de aprobación."
    Y solicita seleccionar otra orden
