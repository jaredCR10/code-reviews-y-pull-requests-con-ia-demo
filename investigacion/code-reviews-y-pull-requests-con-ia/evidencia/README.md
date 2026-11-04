# Evidencia de la demostración

Repositorio: https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo

| # | Archivo | Qué muestra | Sección del documento |
|---|---|---|---|
| 01 | [01-pr1-ci-frontend-falla-prueba.png](01-pr1-ci-frontend-falla-prueba.png) | PR #1: el job `frontend` falla porque `app.spec.ts` espera "Hello, frontend" y la app muestra "TallerAuto". Error que ya existía en el proyecto | 6.3, paso 4 |
| 02 | [02-pr1-coderabbit-comentario-descartado.png](02-pr1-coderabbit-comentario-descartado.png) | PR #1: CodeRabbit sugiere `auto_pause_after_reviewed_commits: 0`, el ingeniero lo descarta con justificación y la IA retira la recomendación | 6.3, paso 5 |
| 03 | [03-pr2-coderabbit-resumen-sin-comentarios.png](03-pr2-coderabbit-resumen-sin-comentarios.png) | PR #2: CodeRabbit revisa automáticamente, resume el cambio, lo relaciona con el PR #1 y no deja comentarios accionables | 6.3, paso 8 |
| 04 | [04-pr2-checks-en-verde.png](04-pr2-checks-en-verde.png) | PR #2: los 3 checks en verde (CI backend, CI frontend y CodeRabbit) y revisión humana solicitada a otro integrante | 6.3, pasos 8 y 9 |
| 05 | [05-push-directo-rechazado.png](05-push-directo-rechazado.png) | Push directo a `main` rechazado por el ruleset (`GH013`): exige PR y los 2 checks obligatorios | 5 y 6.3, paso 10 |
| 06 | [06-pr1-coderabbit-comentario-aceptado.png](06-pr1-coderabbit-comentario-aceptado.png) | PR #1: CodeRabbit pide corregir la prueba del frontend y el ingeniero lo acepta para un PR aparte | 6.3, paso 5 |
| 07 | [07-pr1-aprobacion-humana.png](07-pr1-aprobacion-humana.png) | PR #1: otro integrante (Jose01R) deja su comentario de revisión y aprueba | 6.3, paso 6 |
| 08 | [08-pr2-aprobacion-humana.png](08-pr2-aprobacion-humana.png) | PR #2: Jose01R aprueba el cambio | 6.3, paso 9 |
| 09 | [09-ruleset-main-activo.png](09-ruleset-main-activo.png) | Settings → Rulesets: la regla `main` está activa, con 4 reglas sobre 1 rama | 5 y 6.3, paso 10 |
| P3-01 | [p3-01-ci-backend-checkstyle-falla-pruebas-omitidas.jpg](p3-01-ci-backend-checkstyle-falla-pruebas-omitidas.jpg) | PR #7, 1.ª ejecución del CI: `backend` falla en Checkstyle y el paso de pruebas queda omitido | 9.2 y 9.3 (defectos 1 y 2) |
| P3-02 | [p3-02-pr7-descripcion-y-resumen-coderabbit.jpg](p3-02-pr7-descripcion-y-resumen-coderabbit.jpg) | PR #7: descripción con la plantilla y resumen generado por CodeRabbit | 9.1 |
| P3-03 | [p3-03-ia-defecto1-import-sin-usar.jpg](p3-03-ia-defecto1-import-sin-usar.jpg) | CodeRabbit señala el import sin usar, citando el fallo del CI | 9.2 (defecto 1) |
| P3-04 | [p3-04-ia-defecto2-prueba-mensaje.jpg](p3-04-ia-defecto2-prueba-mensaje.jpg) | CodeRabbit señala que la prueba espera otro mensaje | 9.2 (defecto 2) |
| P3-05 | [p3-05-ia-defecto3-token-quemado.jpg](p3-05-ia-defecto3-token-quemado.jpg) | CodeRabbit clasifica el token quemado como vulnerabilidad (CWE-798) | 9.2 (defecto 3) |
| P3-06 | [p3-06-ia-defecto4-cantidad-null.jpg](p3-06-ia-defecto4-cantidad-null.jpg) | CodeRabbit señala el posible NullPointerException por `cantidad` nula | 9.2 (defecto 4) |
| P3-07 | [p3-07-ia-defecto5-cantidad-cero.jpg](p3-07-ia-defecto5-cantidad-cero.jpg) | CodeRabbit señala que se acepta cantidad 0 | 9.2 y 9.3 (defecto 5) |
| P3-08 | [p3-08-ia-defecto6-controller-usa-repositorio.jpg](p3-08-ia-defecto6-controller-usa-repositorio.jpg) | CodeRabbit señala que el controlador accede al repositorio, citando los lineamientos | 9.2 (defecto 6) |
| P3-09 | [p3-09-ia-extra-concurrencia.jpg](p3-09-ia-extra-concurrencia.jpg) | Comentario extra: incrementos concurrentes (riesgo real, fuera de alcance) | 9.2 |
| P3-10 | [p3-10-ia-extra-desbordamiento.jpg](p3-10-ia-extra-desbordamiento.jpg) | Comentario extra: desbordamiento con `Integer.MAX_VALUE` | 9.2 y 9.4 |
| P3-11 | [p3-11-sugerencia-ia-aceptada-y-commit.jpg](p3-11-sugerencia-ia-aceptada-y-commit.jpg) | Sugerencia del import verificada y aceptada con el commit `519885d` | 9.3 |
| P3-12 | [p3-12-ia-falso-positivo-rechazado.jpg](p3-12-ia-falso-positivo-rechazado.jpg) | Falso positivo rechazado con justificación; CodeRabbit acepta la decisión | 9.2 y 9.4 |
| P3-13 | [p3-13-ci-segunda-ejecucion-detecta-prueba-fallida.jpg](p3-13-ci-segunda-ejecucion-detecta-prueba-fallida.jpg) | PR #7, 2.ª ejecución del CI: pasa Checkstyle y falla la prueba `rechazaUnaCantidadNegativa` | 9.2 y 9.3 (defecto 2) |
| P3-14 | [p3-14-humano-revision-resumen-cambios-solicitados.jpg](p3-14-humano-revision-resumen-cambios-solicitados.jpg) | PR #7: el revisor humano (José) solicita cambios y resume lo encontrado | 9.2 |
| P3-15 | [p3-15-humano-token-quemado-rs01.jpg](p3-15-humano-token-quemado-rs01.jpg) | El revisor humano señala el token quemado y cita RS-01 (control de rol en `security`) | 9.2 (defecto 3) |
| P3-16 | [p3-16-humano-null-y-cantidad-cero-cu13.jpg](p3-16-humano-null-y-cantidad-cero-cu13.jpg) | El revisor humano señala el `null` (propone `@NotNull` y `@Positive`) y la cantidad cero, citando CU-13 | 9.2 y 9.3 (defectos 4 y 5) |
| P3-17 | [p3-17-humano-violacion-de-capas.jpg](p3-17-humano-violacion-de-capas.jpg) | El revisor humano señala la violación de capas y propone `Result.NoEncontrado` | 9.2 (defecto 6) |
| P3-18 | [p3-18-ia-conversa-fuente-defecto5.jpg](p3-18-ia-conversa-fuente-defecto5.jpg) | Conversación con `@coderabbitai`: la IA reconoce que se basó en el mensaje del código y no en CU-13 | 9.3 |

## Ejecuciones del CI

| PR | Ejecución | Resultado |
|---|---|---|
| #1 (primer commit) | [41344091941](https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo/actions/runs/41344091941) | backend ✅ · frontend ❌ |
| #1 (corrección de CodeRabbit) | [41347355030](https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo/actions/runs/41347355030) | backend ✅ · frontend ❌ |
| #2 | [41352052900](https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo/actions/runs/41352052900) | backend ✅ · frontend ✅ |
| #7 (PR sembrado) | [41787915393](https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo/actions/runs/41787915393) | backend ❌ (Checkstyle) · frontend ✅ |
| #7 (tras aceptar la sugerencia del import) | [41886028969](https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo/actions/runs/41886028969) | backend ❌ (prueba fallida) · frontend ✅ |
