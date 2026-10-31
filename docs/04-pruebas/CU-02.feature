# language: es
@CU-02 @RF-02
Característica: CU-02 Registrar Orden de Trabajo con Presupuesto
  Como administrador del taller o mecánico
  Quiero registrar el diagnóstico, los insumos y la mano de obra de un vehículo
  Para generar un presupuesto desglosado en una orden de trabajo

  @flujo-principal @E1
  Escenario: E1 Registro exitoso de una orden con presupuesto
    Dado que el vehículo con placa "SDF-456" está registrado
    Y el insumo "Filtro de Aceite" tiene precio unitario de ₡8 000 y existencia de 5 unidades
    Cuando el usuario registra el diagnóstico "Cambio de aceite y filtro"
    Y agrega 1 unidad de "Filtro de Aceite"
    Y registra 1 hora de mano de obra a ₡12 000
    Y un usuario con rol Administrador confirma el presupuesto
    Entonces el sistema calcula un total de ₡20 000
    Y registra la orden de trabajo en estado "Esperando Aprobación"
    Y la existencia de "Filtro de Aceite" sigue en 5

  @FA-01 @E2
  Escenario: E2 Insumo con existencia cero marcado como Por pedir a proveedor
    Dado que el insumo "Bomba de Agua" tiene existencia de 0
    Cuando el usuario agrega 1 unidad de "Bomba de Agua" al presupuesto
    Y la marca como "Por pedir a proveedor"
    Entonces el sistema informa "Existencia insuficiente. Disponible: 0"
    Y agrega la bomba al presupuesto con la marca "Por pedir a proveedor"
    Y la existencia de "Bomba de Agua" sigue en 0

  @FA-01 @E3
  Escenario: E3 Insumo con existencia parcial marcado como Por pedir a proveedor
    Dado que el insumo "Bujía" tiene existencia de 2
    Cuando el usuario agrega 4 unidades de "Bujía" al presupuesto
    Y las marca como "Por pedir a proveedor"
    Entonces el sistema informa "Existencia insuficiente. Disponible: 2"
    Y agrega las 4 bujías con la marca "Por pedir a proveedor"
    Y la existencia de "Bujía" sigue en 2

  @FA-02 @E4
  Escenario: E4 Ajuste manual del precio de una línea del presupuesto
    Dado el presupuesto del escenario E1 pendiente de confirmar
    Cuando un usuario con rol Administrador cambia el precio del filtro a ₡7 500
    Entonces el sistema recalcula el total en ₡19 500
    Y solicita confirmar el presupuesto

  @FA-03 @E5
  Escenario: E5 Cancelación confirmada del registro
    Dado que el usuario ingresó un diagnóstico preliminar
    Cuando el usuario solicita cancelar el registro
    Y confirma la cancelación
    Entonces el sistema descarta los datos ingresados
    Y no registra ninguna orden de trabajo
    Y regresa al expediente del vehículo

  @FA-04 @E6
  Escenario: E6 Cancelación no confirmada
    Dado que el usuario ingresó un diagnóstico preliminar
    Cuando el usuario solicita cancelar el registro
    Y no confirma la cancelación
    Entonces el sistema conserva el diagnóstico ingresado
    Y el usuario continúa en el paso donde estaba

  @RS-03 @E7
  Escenario: E7 Un operador sin experiencia registra una orden sin ayuda
    Dado un operador sin experiencia previa que recibió 15 minutos de explicación
    Cuando registra una orden de trabajo con presupuesto sin ayuda
    Entonces el operador completa el registro sin asistencia

  @FA-05 @RS-01 @E8
  Escenario: E8 Confirmación de presupuesto denegada para el rol Mecánico
    Dado que el diagnóstico y los insumos del escenario E1 ya están registrados
    Y la sesión activa tiene el rol Mecánico
    Cuando intenta confirmar el presupuesto
    Entonces el sistema informa "Solo el rol Administrador puede confirmar el presupuesto."
    Y no registra la orden de trabajo
    Y conserva el diagnóstico y los insumos ingresados
