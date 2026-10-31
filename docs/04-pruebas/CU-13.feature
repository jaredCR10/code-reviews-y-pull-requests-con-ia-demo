# language: es
@CU-13 @RF-03
Característica: CU-13 Registrar Ingreso de Insumos
  Como administrador del taller
  Quiero registrar la entrada de insumos recibidos
  Para sumar la cantidad recibida a sus existencias

  @flujo-principal @E1
  Escenario: E1 Ingreso de insumos recibidos
    Dado que el insumo "Aceite 10W-30" tiene existencia de 8
    Cuando el administrador registra el ingreso de 12 unidades de "Aceite 10W-30"
    Entonces el sistema suma 12 unidades a la existencia
    Y despliega la nueva existencia de 20

  @FA-01 @E2
  Escenario: E2 Insumo no encontrado
    Cuando el administrador indica el insumo "Bujía-ZZZ", que no existe en el catálogo
    Entonces el sistema informa "Insumo no encontrado en el catálogo."
    Y solicita indicar el insumo de nuevo

  @FA-02 @E3
  Escenario: E3 Cantidad inválida
    Dado que el insumo "Aceite 10W-30" tiene existencia de 8
    Cuando el administrador indica una cantidad de 0 para "Aceite 10W-30"
    Entonces el sistema informa "La cantidad debe ser un número entero mayor que cero."
    Y no modifica la existencia
    Y solicita la cantidad de nuevo
