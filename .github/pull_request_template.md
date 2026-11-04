<!--
Plantilla de Pull Request de TallerAuto.
Mantén el PR pequeño y enfocado: una sola responsabilidad por PR.
Borra las secciones que no apliquen antes de abrirlo.
-->

## Descripción

<!-- Qué cambia este PR y por qué. Dos o tres líneas en lenguaje claro. -->

## Caso de uso o requerimiento

<!-- Enlace al CU o RF que atiende, o "Ninguno" si es infraestructura o documentación. -->
- CU / RF:
- Issue relacionado: <!-- Closes #NN, o "Ninguno" -->

## Tipo de cambio

- [ ] Funcionalidad nueva
- [ ] Corrección de error
- [ ] Refactor (sin cambio de comportamiento)
- [ ] Documentación
- [ ] Infraestructura o configuración (CI, build, herramientas)

## Criterios de aceptación

<!-- Qué debe cumplirse para aprobar el PR. Tomados del .feature o del CU cuando aplique. -->

- [ ]
- [ ]

## Cómo se probó

<!-- Pasos para reproducir la prueba, comandos ejecutados y resultado observado. -->

- [ ] En `backend/`: `./mvnw test` en verde
- [ ] En `frontend/`: `npm test` y `npm run build` en verde
- [ ] Prueba manual descrita abajo

<!-- Describe la prueba manual o pega la salida relevante. -->

## Tamaño del PR

<!-- Marca una. Un PR grande cuesta más de revisar; divídelo si pasa de ~400 líneas. -->

- [ ] Pequeño (< 200 líneas de diff)
- [ ] Mediano (200 a 400 líneas)
- [ ] Grande (> 400 líneas) — justifica por qué no se pudo dividir:

## Participación de la IA

<!-- Para la investigación del Tema 3: declara cómo se usó la IA en este PR. -->

- [ ] Se usó IA para generar o modificar código de este PR
- [ ] Se usó una herramienta de revisión por IA (por ejemplo CodeRabbit) en este PR
- [ ] No se usó IA

<!-- Detalle: qué herramienta, en qué parte y qué se verificó a mano. -->

## Lista de verificación del autor

- [ ] El PR tiene un solo propósito y es del tamaño marcado arriba
- [ ] Revisé mi propio diff antes de pedir revisión
- [ ] CI en verde (build, pruebas, estilo)
- [ ] Respeté la arquitectura por capas (ver `docs/05-diseno/`)
- [ ] No hay secretos, contraseñas ni llaves quemadas en el código
- [ ] Actualicé la documentación afectada

## Notas para quien revisa

<!-- Puntos donde quieres atención especial, decisiones de diseño, dudas abiertas. -->
