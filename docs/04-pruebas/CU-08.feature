# language: es
@CU-08 @RF-03
Característica: CU-08 Consultar Existencia de Insumo
  Como administrador del taller o mecánico
  Quiero consultar el precio unitario y la existencia de un insumo
  Para saber si hay suficiente antes de usarlo o presupuestarlo

  @flujo-principal @RS-02 @E1
  Escenario: E1 Consulta de un insumo con existencia
    Dado que el insumo "Aceite 10W-30" tiene existencia de 10
    Cuando el usuario consulta "Aceite 10W-30"
    Entonces el sistema despliega en menos de 5 segundos el nombre, el precio unitario y la existencia de 10

  @FA-01 @E2
  Escenario: E2 Consulta de un insumo con existencia cero
    Dado que el insumo "Filtro de Aire" tiene existencia de 0
    Cuando el usuario consulta "Filtro de Aire"
    Entonces el sistema despliega el insumo con una alerta de existencia cero

  @FA-02 @E3
  Escenario: E3 Insumo no encontrado
    Cuando el usuario consulta "Bujía-ZZZ", que no existe en el catálogo
    Entonces el sistema informa "Insumo no encontrado en el catálogo."
    Y solicita indicar el insumo de nuevo
