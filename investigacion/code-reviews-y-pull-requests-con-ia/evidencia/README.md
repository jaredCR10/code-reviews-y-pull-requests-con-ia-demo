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

## Ejecuciones del CI

| PR | Ejecución | Resultado |
|---|---|---|
| #1 (primer commit) | [41344091941](https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo/actions/runs/41344091941) | backend ✅ · frontend ❌ |
| #1 (corrección de CodeRabbit) | [41347355030](https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo/actions/runs/41347355030) | backend ✅ · frontend ❌ |
| #2 | [41352052900](https://github.com/jaredCR10/code-reviews-y-pull-requests-con-ia-demo/actions/runs/41352052900) | backend ✅ · frontend ✅ |
