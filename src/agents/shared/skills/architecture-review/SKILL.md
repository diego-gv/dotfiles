---
name: architecture-review
description: Úsala para evaluar decisiones de arquitectura, abstracciones, dependencias, capas, límites y trade-offs de diseño. Prioriza simplicidad, mantenibilidad, cohesión y bajo acoplamiento.
---

# Revisión de Arquitectura

## Cuándo usar esta skill

Utilízala cuando se evalúen decisiones arquitectónicas, diseño de componentes o impacto de nuevas capas y abstracciones.

## Objetivo de la skill

Evaluar propuestas de arquitectura para reducir complejidad innecesaria y mejorar mantenibilidad real.

## Checklist de ejecución

- Delimitar el problema actual y por qué requiere revisión arquitectónica.
- Evaluar complejidad añadida vs. beneficio real de la propuesta.
- Comparar con una alternativa más simple y explícita.
- Reportar riesgos de acoplamiento, mantenibilidad y evolución futura.

## Objetivos fundamentales

Debes favorecer:

- Separación clara de responsabilidades.
- Bajo acoplamiento.
- Alta cohesión.
- Dependencias explícitas.
- Diseños fáciles de entender y mantener.

Evita:

- Sobre-ingeniería: soluciones más complejas que lo que el problema requiere.
- Generalización prematura: abstracciones anticipadas para necesidades futuras no verificadas.
- Capas innecesarias: niveles de indirección que no resuelven un problema concreto.
- Patrones aplicados por moda: uso de patrones porque están de moda, no porque el problema los requiera.
- Abstracciones sin casos de uso reales: no justifiques una abstracción únicamente por posibles necesidades futuras.

## Gestión de dependencias

Utiliza inversión de dependencias en los límites externos cuando aporte claridad y facilite testing: bases de datos, servicios externos, clientes HTTP, sistemas de mensajería o acceso al sistema de archivos. Esto desacopla la lógica de negocio de detalles tecnológicos y permite testear de forma aislada.

No añadas capas adicionales si no resuelven un problema concreto o no mejoran claramente la mantenibilidad. Cada capa aumenta complejidad y coste cognitivo. Antes de proponer una nueva capa, explica qué problema específico resuelve hoy y por qué la solución actual no puede ampliarse de forma razonable.

## Evaluación de propuestas

Para cada propuesta de cambio arquitectónico, analiza:

- Qué problema concreto resuelve hoy, no en el futuro. Evita abstracciones especulativas.
- Qué complejidad añade: nuevas capas, conceptos, puntos de fallos.
- Si existe una alternativa más simple que no requiera cambiar arquitectura.
- Cuál es el coste de mantenimiento futuro: más capas significan más puntos de cambio cuando requisitos evolucionen.
- Cuál es el impacto en la arquitectura existente: roturas de patrones, cambios en cascada.

## Deuda técnica

Identifica deuda técnica relevante cuando la detectes. No propongas resolverla automáticamente si queda fuera del objetivo principal. Señálala para futuras iteraciones si existe riesgo directo.

## Entrega esperada

- Hallazgos priorizados por impacto (crítico, recomendado, opcional).
- Alternativa más simple cuando exista.
- Riesgos de acoplamiento, capas innecesarias o abstracciones prematuras.

## Debug

Cuando esta skill se ejecute, añade al final de la respuesta:
[SKILL_ARCHITECTURE_REVIEW_LOADED]
