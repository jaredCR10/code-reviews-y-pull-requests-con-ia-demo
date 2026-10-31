# language: es
@CU-11 @RF-01
Característica: CU-11 Registrar Servicio y Cerrar Orden de Trabajo
  Como administrador del taller o mecánico
  Quiero registrar el diagnóstico final y la garantía y cerrar la orden
  Para que el servicio quede en el historial del vehículo

  @flujo-principal @E1
  Escenario: E1 Cierre exitoso de una orden aprobada
    Dado que la orden #102 está en estado "Aprobada"
    Cuando el usuario registra el diagnóstico final "Cambio de bomba de agua"
    Y registra una garantía de 6 meses para la bomba
    Y confirma el cierre de la orden
    Entonces el sistema registra el servicio en el historial del vehículo
    Y cambia el estado de la orden a "Cerrada"
    Y al consultar el historial mediante CU-01 el servicio aparece con su garantía

  @FA-01 @E2
  Escenario: E2 Cancelación del cierre
    Dado que la orden #102 está en estado "Aprobada"
    Cuando el usuario ingresa el diagnóstico final
    Y cancela el cierre
    Entonces la orden sigue en estado "Aprobada"
    Y el historial del vehículo no cambia

  @FA-02 @E3
  Escenario: E3 Orden que no está aprobada
    Dado que la orden #103 está en estado "Esperando Aprobación"
    Cuando el usuario selecciona la orden #103
    Entonces el sistema informa "La orden no existe o no está aprobada."
    Y solicita seleccionar otra orden
