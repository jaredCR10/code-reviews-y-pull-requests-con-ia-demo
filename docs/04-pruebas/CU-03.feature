# language: es
@CU-03 @RF-03
Característica: CU-03 Asociar Insumo a Orden de Trabajo
  Como administrador del taller
  Quiero asociar a una orden los insumos efectivamente utilizados
  Para descontar su cantidad de las existencias

  @flujo-principal @E1
  Escenario: E1 Asociación de un insumo con existencia suficiente
    Dado que la orden de trabajo #102 está en estado "Aprobada"
    Y el insumo "Aceite 10W-30" tiene existencia de 10
    Cuando el administrador asocia 2 unidades de "Aceite 10W-30" a la orden #102
    Entonces el sistema descuenta 2 unidades
    Y la existencia de "Aceite 10W-30" queda en 8
    Y el insumo queda asociado a la orden #102

  @flujo-principal @E2
  Escenario: E2 Asociación repetida de varios insumos
    Dado que la orden de trabajo #102 está en estado "Aprobada"
    Y el insumo "Aceite 10W-30" tiene existencia de 10
    Y el insumo "Filtro de Aceite" tiene existencia de 6
    Cuando el administrador asocia 2 unidades de "Aceite 10W-30" a la orden #102
    Y asocia 1 unidad de "Filtro de Aceite" a la orden #102
    Entonces las existencias quedan en 8 y en 5 respectivamente
    Y ambos insumos quedan asociados a la orden #102

  @FA-01 @E3
  Escenario: E3 Existencia cero con marca Por pedir confirmada
    Dado que la orden de trabajo #102 está en estado "Aprobada"
    Y el insumo "Filtro de Aire" tiene existencia de 0
    Cuando el administrador asocia 1 unidad de "Filtro de Aire"
    Y confirma la marca "Por pedir a proveedor"
    Entonces el sistema informa "Existencia insuficiente. Disponible: 0"
    Y asocia el filtro a la orden con la marca "Por pedir a proveedor"
    Y la existencia de "Filtro de Aire" sigue en 0

  @FA-01 @E4
  Escenario: E4 Existencia parcial con marca Por pedir confirmada
    Dado que la orden de trabajo #102 está en estado "Aprobada"
    Y el insumo "Aceite 10W-30" tiene existencia de 3
    Cuando el administrador asocia 5 unidades de "Aceite 10W-30"
    Y confirma la marca "Por pedir a proveedor"
    Entonces el sistema asocia las 5 unidades con la marca "Por pedir a proveedor"
    Y la existencia de "Aceite 10W-30" sigue en 3

  @FA-02 @E5
  Escenario: E5 Marca Por pedir rechazada
    Dado que la orden de trabajo #102 está en estado "Aprobada"
    Y el insumo "Aceite 10W-30" tiene existencia de 3
    Cuando el administrador asocia 5 unidades de "Aceite 10W-30"
    Y no confirma la marca "Por pedir a proveedor"
    Entonces el sistema no asocia el insumo
    Y la existencia de "Aceite 10W-30" sigue en 3
    Y solicita indicar la cantidad de nuevo

  @FA-03 @E6
  Escenario: E6 Insumo no encontrado en el catálogo
    Cuando el administrador busca el insumo "Bujía-ZZZ", que no existe en el catálogo
    Entonces el sistema informa "Insumo no encontrado en el catálogo."
    Y solicita buscar de nuevo
