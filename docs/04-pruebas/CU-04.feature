# language: es
@CU-04 @RF-04
Característica: CU-04 Agendar Cita de Mantenimiento
  Como administrador del taller
  Quiero programar citas de servicio por rampa y franja horaria
  Para evitar que dos trabajos coincidan en la misma rampa

  @flujo-principal @E1
  Escenario: E1 Cita agendada en una rampa libre
    Dado que la Rampa 1 está libre el lunes a las 8:00 a. m.
    Y el vehículo "CL-8942" está registrado
    Cuando el administrador selecciona la Rampa 1 el lunes a las 8:00 a. m.
    Y indica la placa "CL-8942" y el servicio "Cambio de frenos"
    Entonces el sistema registra la cita
    Y marca la Rampa 1 como ocupada en esa franja

  @FA-01 @E2
  Escenario: E2 Conflicto de horario en la misma rampa
    Dado que la Rampa 1 está ocupada el lunes a las 8:00 a. m.
    Cuando el administrador selecciona la Rampa 1 el lunes a las 8:00 a. m.
    Entonces el sistema notifica que la rampa no está disponible en esa franja
    Y sugiere otra rampa u otra franja libre
    Y regresa a la selección de rampa y franja

  @FA-02 @E3
  Escenario: E3 Cita con un vehículo no registrado
    Dado que la placa "XYZ-999" no está registrada
    Cuando el administrador agenda una cita con la placa "XYZ-999"
    Entonces el sistema ejecuta CU-06 Registrar Vehículo
    Y al terminar continúa con el agendamiento de la cita

  @FA-03 @E4
  Escenario: E4 Cliente que llega sin cita previa
    Dado que un cliente llega al taller sin haber reservado
    Cuando el administrador solicita registrar la llegada sin cita
    Entonces el sistema ejecuta CU-07 Registrar Llegada de Vehículo sin Cita

  @RS-03 @E5
  Escenario: E5 Un operador sin experiencia agenda una cita sin ayuda
    Dado un operador sin experiencia previa que recibió 15 minutos de explicación
    Cuando agenda una cita sin ayuda
    Entonces el operador completa el agendamiento sin asistencia
