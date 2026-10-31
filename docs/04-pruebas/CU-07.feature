# language: es
@CU-07 @RF-04
Característica: CU-07 Registrar Llegada de Vehículo sin Cita
  Como administrador del taller
  Quiero registrar el ingreso de un vehículo que llega sin cita
  Para asignarle una rampa y una franja libres del día

  @flujo-principal @E1
  Escenario: E1 Ingreso sin cita en una rampa libre
    Dado que la Rampa 2 está libre a las 10:00 a. m.
    Cuando llega el vehículo "CL-8942" sin cita para el servicio "Revisión de frenos"
    Y el administrador selecciona la Rampa 2 a las 10:00 a. m.
    Entonces el sistema registra el ingreso en la agenda del día con la marca "Sin cita previa"
    Y marca la Rampa 2 como ocupada en esa franja

  @FA-01 @E2
  Escenario: E2 Sin espacio disponible en el día
    Dado que todas las rampas del día están ocupadas
    Cuando llega un vehículo sin cita
    Entonces el sistema informa "No hay espacio disponible en el día."
    Y no registra el ingreso

  @FA-02 @E3
  Escenario: E3 Llegada sin cita de un vehículo no registrado
    Dado que la placa "XYZ-999" no está registrada
    Cuando llega sin cita el vehículo con placa "XYZ-999"
    Entonces el sistema ejecuta CU-06 Registrar Vehículo
    Y al terminar continúa con el registro de la llegada
