# language: es
@CU-09 @RF-05
Característica: CU-09 Consultar Estado de Vehículo
  Como administrador del taller o mecánico
  Quiero consultar el estado actual de un vehículo y su recorrido de estados
  Para responder al cliente sin interrumpir el trabajo técnico

  @flujo-principal @RS-02 @E1
  Escenario: E1 Consulta por placa
    Dado que el vehículo con placa "CL-8942" tiene una orden de trabajo y está en estado "Listo para Entrega"
    Cuando el administrador consulta la placa "CL-8942" desde recepción
    Entonces el sistema despliega en menos de 5 segundos el estado actual "Listo para Entrega"
    Y el recorrido histórico de estados con la fecha y la hora de cada cambio

  @flujo-principal @E2
  Escenario: E2 Consulta por número de orden
    Dado que existe la orden de trabajo #102
    Cuando el mecánico consulta la orden #102
    Entonces el sistema despliega el estado actual y el recorrido de estados de esa orden

  @FA-01 @E3
  Escenario: E3 Vehículo sin orden de trabajo
    Dado que la placa "ZZZ-000" no tiene orden de trabajo
    Cuando el usuario consulta la placa "ZZZ-000"
    Entonces el sistema informa "No se encontró un vehículo con orden de trabajo para el dato ingresado."
    Y solicita el dato de nuevo

  @RS-03 @E4
  Escenario: E4 Un operador sin experiencia consulta el estado sin ayuda
    Dado un operador sin experiencia previa que recibió 15 minutos de explicación
    Cuando consulta el estado de un vehículo sin ayuda
    Entonces el operador completa la consulta sin asistencia
