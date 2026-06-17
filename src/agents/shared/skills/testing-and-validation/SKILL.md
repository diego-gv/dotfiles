---
name: testing-and-validation
description: Úsala para evaluar impacto en tests, diseñar pruebas, validar cambios de comportamiento y estimar riesgo de regresión. Prioriza cobertura, casos límite, escenarios de fallo y verificación funcional.
---

# Testing y Validación

## Cuándo usar esta skill

Utilízala cuando un cambio pueda afectar al comportamiento observable del sistema.

## Objetivo de la skill

Definir y validar pruebas que reduzcan riesgo de regresión y confirmen comportamiento observable.

## Checklist de ejecución

- Identificar qué comportamiento observable cambia.
- Determinar tests afectados y riesgo de regresión.
- Proponer o ajustar casos para límites, errores y flujos críticos.
- Ejecutar validación mínima viable e informar cobertura resultante.

## Principio fundamental

Los tests deben validar comportamiento observable, no detalles internos de implementación. Por ejemplo: testea que una función retorna el resultado correcto, no cómo lo calcula internamente. Si refactorizas el cálculo interno sin cambiar el resultado, el test debe seguir pasando.

## Evaluación de impacto

Evalúa siempre el impacto de los cambios sobre los tests existentes. Identifica qué tests pueden verse afectados, cuál es el riesgo de regresión y qué comportamiento se modifica.

## Actualización de tests

Cuando un cambio modifica el comportamiento observable del sistema, añade o actualiza los tests correspondientes. Prioriza `pytest` cuando el proyecto ya lo utilice.

## Cobertura mínima necesaria

Presta especial atención a:

- Casos límite: valores de entrada extremos o inesperados.
- Escenarios de error: qué sucede cuando algo falla.
- Regresiones: cambios que rompan comportamiento previamente funcionando.
- Flujos críticos de negocio: las partes más importantes del sistema.

## Ejecución de tests

Cuando sea posible, ejecuta primero los tests mínimos relevantes antes de ejecutar conjuntos más amplios. Esto proporciona feedback rápido.

## Informe final

Indica siempre:

- Qué tests pueden verse afectados.
- Qué tests deberían añadirse.
- Qué tests deberían modificarse.
- Qué cobertura se gana o se pierde.

## Cuando no sea posible ejecutar tests

Explica claramente por qué no ha sido posible ejecutar tests y especifica qué comando debería ejecutarse para validarlos. No modifiques el diseño de producción únicamente para facilitar los tests sin consultarlo primero.

## Entrega esperada

- Impacto en tests identificado.
- Casos nuevos o actualizados propuestos con prioridad.
- Estado de validación reportado con comandos concretos.

## Debug

Cuando esta skill se ejecute, añade al final de la respuesta:
[SKILL_TESTING_AND_VALIDATION_LOADED]
