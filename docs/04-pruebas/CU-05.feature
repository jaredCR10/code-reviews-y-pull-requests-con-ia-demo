# language: es
@CU-05 @RF-05
Característica: CU-05 Actualizar Estado de Vehículo
  Como administrador del taller o mecánico
  Quiero actualizar el estado de un vehículo en el taller
  Para que el estado quede registrado con fecha y hora y visible en el tablero

  @flujo-principal @E1
  Escenario: E1 Cambio de estado a En Reparación
    Dado que el vehículo de la orden #102 está en estado "En Diagnóstico"
    Cuando el usuario selecciona el estado "En Reparación" para la orden #102
    Entonces el sistema registra el nuevo estado con la fecha y la hora del cambio
    Y actualiza el tablero de estados

  @FA-01 @E2
  Escenario: E2 Estado igual al vigente
    Dado que el vehículo de la orden #102 está en estado "En Reparación"
    Cuando el usuario selecciona el estado "En Reparación"
    Entonces el sistema informa "El vehículo ya se encuentra en ese estado."
    Y no registra ningún cambio

  @FA-02 @E3
  Escenario: E3 Vehículo sin orden de trabajo
    Dado que la placa "ZZZ-000" no tiene orden de trabajo
    Cuando el usuario busca la placa "ZZZ-000"
    Entonces el sistema informa "No se encontró un vehículo con orden de trabajo para el dato ingresado."
    Y solicita ubicar el vehículo de nuevo
