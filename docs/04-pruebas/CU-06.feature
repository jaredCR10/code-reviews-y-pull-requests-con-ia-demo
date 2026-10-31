# language: es
@CU-06 @RF-01
Característica: CU-06 Registrar Vehículo
  Como administrador del taller o mecánico
  Quiero registrar un vehículo y su propietario
  Para abrir el expediente del vehículo

  @flujo-principal @E1
  Escenario: E1 Registro exitoso de un vehículo y su propietario
    Dado que la placa "XYZ-999" no está registrada
    Cuando el usuario ingresa la placa "XYZ-999", la marca "Toyota", el modelo "Corolla" y el año 2015
    Y ingresa el propietario "Carlos Mora" con el teléfono "8888-1234"
    Entonces el sistema registra el vehículo asociado a su propietario
    Y crea el expediente del vehículo sin servicios
    Y confirma el registro

  @FA-01 @E2
  Escenario: E2 Datos obligatorios incompletos
    Cuando el usuario ingresa la placa "XYZ-999", el modelo "Corolla" y el año 2015 sin indicar la marca
    Y ingresa el propietario "Carlos Mora" con el teléfono "8888-1234"
    Entonces el sistema indica que la marca es obligatoria
    Y no registra el vehículo
    Y solicita corregir los datos

  @FA-02 @E3
  Escenario: E3 Cancelación del registro
    Cuando el usuario ingresa parte de los datos del vehículo
    Y solicita cancelar el registro
    Entonces el sistema descarta los datos ingresados
    Y no registra el vehículo
