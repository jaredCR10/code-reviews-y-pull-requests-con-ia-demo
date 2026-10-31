# language: es
@CU-01 @RF-01
Característica: CU-01 Consultar Historial Vehicular por Placa
  Como administrador del taller o mecánico
  Quiero buscar un vehículo por su placa
  Para conocer sus reparaciones previas, diagnósticos e insumos con su garantía

  @flujo-principal @RS-02 @E1
  Escenario: E1 Consulta exitosa de un vehículo registrado con historial
    Dado que el vehículo con placa "CL-8942" está registrado y tiene órdenes de trabajo anteriores
    Cuando el mecánico ingresa la placa "CL-8942"
    Entonces el sistema despliega en menos de 5 segundos la ficha del vehículo y su historial cronológico de órdenes
    Cuando el mecánico selecciona una orden del historial
    Entonces el sistema despliega el detalle de la orden con las fallas, el diagnóstico y los insumos utilizados con su garantía

  @FA-01 @E2
  Escenario: E2 Placa no registrada y el usuario acepta registrar el vehículo
    Dado que la placa "XYZ-999" no está registrada en el sistema
    Cuando el administrador ingresa la placa "XYZ-999"
    Entonces el sistema informa "La placa no se encuentra registrada." y ofrece registrar el vehículo
    Cuando el administrador acepta registrar el vehículo
    Entonces el sistema ejecuta CU-06 Registrar Vehículo con la placa "XYZ-999"
    Y al terminar CU-06 el sistema repite la búsqueda de la placa

  @FA-02 @E3
  Escenario: E3 Placa con formato inválido
    Cuando el mecánico ingresa la placa "12"
    Entonces el sistema informa "Formato de placa inválido. Ingrese una placa de 5 a 7 caracteres alfanuméricos."
    Y solicita la placa de nuevo

  @FA-03 @E4
  Escenario: E4 Placa no registrada y el usuario declina registrar el vehículo
    Dado que la placa "XYZ-999" no está registrada en el sistema
    Cuando el usuario ingresa la placa "XYZ-999"
    Y indica que no desea registrar el vehículo
    Entonces el caso de uso termina
    Y no se crea ningún registro

  @FA-04 @E5
  Escenario: E5 Vehículo registrado sin servicios previos
    Dado que el vehículo con placa "ABC-123" está registrado y no tiene órdenes de trabajo
    Cuando el administrador ingresa la placa "ABC-123"
    Entonces el sistema despliega la información general del vehículo
    Y informa "El vehículo no tiene servicios registrados."
