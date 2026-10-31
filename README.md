# TallerAuto — Documentación del Proyecto Práctico

Sistema de Gestión Integral para Taller Mecánico de Barrio. Universidad de Costa Rica · Sede del Atlántico · Recinto de Paraíso. Curso IF-6100 — Análisis y Diseño de Software.

Toda la documentación del proyecto vive en [`docs/`](docs/). El índice completo y navegable está en [`docs/README.md`](docs/README.md).

## Integrantes

- Jared Morales Morales (Carné: C4H714)
- José Andrés Ramírez Jiménez (Carné: C4I788)
- Adrián Barboza Vargas (Carné: C20979)

## Cómo levantarlo

El backend (Spring Boot 3 + MySQL en Docker) y el frontend (Angular) se levantan desde un clon limpio siguiendo la [Guía de ambiente de desarrollo](docs/06-configuracion/ambiente-de-desarrollo.md), que incluye requisitos, pasos y problemas frecuentes.

## Estructura

| Carpeta | Contenido |
|---|---|
| `docs/01-inicio/` | Problema y visión, diagrama de contexto, diagramas BPMN (`.bpmn` y su imagen exportada) y su trazabilidad a los RF |
| `docs/02-requerimientos/` | Requerimientos funcionales (RF-01 a RF-05) y suplementarios (RS-01 a RS-03), y su trazabilidad a los CU |
| `docs/03-casos-de-uso/` | Actores, diagrama de casos de uso y CU-01 a CU-13, con un prototipo de interfaz por caso de uso |
| `docs/04-pruebas/` | Guiones Gherkin (`.feature`) por caso de uso |
| `docs/05-diseno/` | Arquitectura y lineamientos de backend, frontend y base de datos |
| `docs/06-configuracion/` | Guía de ambiente de desarrollo |
| `backend/` | Proyecto Spring Boot 3 (Java 21, Maven) |
| `frontend/` | Proyecto Angular |

## Cambios del PC1 al PC2

Ver [`docs/cambios-pc1-pc2.md`](docs/cambios-pc1-pc2.md) para el registro de las correcciones aplicadas tras la retroalimentación del profesor en el Entregable 1.
