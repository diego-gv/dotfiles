---
name: python-code-review
description: Úsala para revisar código Python, pull requests o cambios propuestos. Prioriza corrección, mantenibilidad, tipado, manejo de errores, testing, seguridad, arquitectura y oportunidades de simplificación.
---

# Revisión de Código Python

## Cuándo usar esta skill

Utilízala para revisiones de código, pull requests, auditorías de cambios y análisis de calidad.

## Objetivo de la skill

Detectar problemas reales de correctitud, diseño, seguridad y mantenibilidad, priorizando impacto sobre estilo.

## Checklist de ejecución

- Revisar correctitud funcional y posibles regresiones del cambio.
- Evaluar tipado, manejo de errores y riesgos de seguridad.
- Verificar impacto en arquitectura, mantenibilidad y complejidad.
- Confirmar cobertura de tests y clasificar hallazgos por severidad.

## Checklist de verificación

### Correctitud funcional

Verifica:

- Correctitud funcional del cambio.
- Casos límite: valores extremos, inesperados o especiales.
- Escenarios de error: qué sucede cuando algo falla.
- Regresiones potenciales: cambios que podrían romper comportamiento existente.

### Tipado

Verifica consistencia de tipos, uso adecuado de type hints, y tipos ambiguos o innecesarios.

### Manejo de errores

Verifica que la gestión de excepciones sea adecuada. Busca errores silenciados (capturados pero no procesados), excepciones capturadas demasiado ampliamente, y puntos donde deberían agregarse manejo de errores.

### Seguridad

Verifica validación de entradas, gestión de secretos, acceso a recursos externos y posibles vulnerabilidades evidentes.

### APIs y compatibilidad

Verifica cambios de contrato en APIs públicas, compatibilidad hacia atrás e impacto sobre consumidores existentes.

### Concurrencia

Cuando aplique, verifica race conditions, bloqueos potenciales, uso correcto de async/await y seguridad en concurrencia.

### Rendimiento

Evalúa únicamente cuando existan indicios razonables de riesgo: loops anidados innecesarios, queries sin índices, algoritmos O(n²) donde O(n) es posible. El rendimiento no es una preocupación fundamental si no hay evidencia de problema real.

### Diseño y arquitectura

Verifica responsabilidades bien separadas, acoplamiento razonable, cohesión adecuada y complejidad innecesaria. Identifica posibles simplificaciones. Verifica que el cambio encaja con la arquitectura existente y es consistente con patrones del proyecto.

### Tests

Verifica cobertura adecuada, casos límite cubiertos, regresiones cubiertas y escenarios de error cubiertos.

## Clasificación de hallazgos

Clasifica cada hallazgo según su importancia:

### Crítico

Problemas funcionales, de seguridad o riesgo elevado que deben resolverse antes de integración.

### Recomendado

Mejoras relevantes de mantenibilidad, diseño o claridad que aportan valor significativo.

### Opcional

Sugerencias menores, preferencias no críticas o mejoras que pueden posponerse.

## Priorización

Prioriza problemas reales frente a preferencias personales o cuestiones puramente estéticas. Distingue siempre entre:

- Lo que está mal (crítico).
- Lo que podría ser mejor (recomendado).
- Lo que es materia de preferencia (opcional).

## Entrega esperada

- Hallazgos con severidad y evidencia técnica.
- Riesgos funcionales y de regresión claramente descritos.
- Recomendaciones accionables y proporcionales al impacto.

## Debug

Cuando esta skill se ejecute, añade al final de la respuesta:
[SKILL_PYTHON_CODE_REVIEW_LOADED]
