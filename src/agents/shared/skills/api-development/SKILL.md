---
name: api-development
description: Úsala para diseñar, implementar o revisar APIs HTTP y servicios backend. Prioriza contratos claros, validación, separación de responsabilidades, compatibilidad hacia atrás y manejo consistente de errores.
---

# Desarrollo de APIs

## Cuándo usar esta skill

Utilízala para diseñar, implementar o revisar APIs HTTP y servicios backend.

## Objetivo de la skill

Diseñar y evolucionar APIs con contratos estables, responsabilidades bien separadas y manejo de errores consistente.

## Checklist de ejecución

- Identificar contrato actual y alcance del cambio.
- Revisar separación de responsabilidades (HTTP, dominio, persistencia, infraestructura).
- Validar entradas/salidas y compatibilidad hacia atrás.
- Definir manejo de errores consistente y riesgos de integración.

## Diseño de endpoints y controladores

Mantén endpoints, routers y controladores lo más simples posible. La lógica de negocio debe permanecer fuera de las capas de transporte. No mezcles responsabilidades HTTP con lógica de dominio.

Por qué importa: endpoints simples son más fáciles de testear y mantener. Si la lógica está acoplada a HTTP, cambiar el transporte requiere reescribir todo. La separación facilita testear sin cliente HTTP.

## Contratos y validación

Mantén contratos claros y explícitos entre componentes. Valida entradas y salidas utilizando los mecanismos habituales del proyecto. Considera la compatibilidad hacia atrás cuando el cambio pueda afectar a consumidores existentes.

## Responsabilidades

Mantén separadas las responsabilidades de:

- HTTP: protocolos, serialización, status codes. Cambios en API no deben tocar dominio.
- Dominio: lógica de negocio. Independiente del transporte.
- Infraestructura: conexiones, recursos externos. Permite cambiar BD sin reescribir negocio.
- Persistencia: acceso a datos. Abstracción que evita acoplamiento a ORM.

Trata explícitamente como responsabilidades diferenciadas:

- Autenticación y Autorización: separadas de endpoints, consistentes en toda la API.
- Logging: traza independiente del resultado de negocio.
- Observabilidad: métricas en todos los niveles.
- Gestión de errores: consistente, no particular a cada endpoint.

## Manejo de errores

Utiliza errores consistentes y predecibles. Los errores deben ser compatibles con el resto del sistema y comunicar claramente el motivo del fallo.

## Entrega esperada

- Decisiones de diseño justificadas y simples.
- Contratos y validaciones explícitas.
- Riesgos de compatibilidad o acoplamiento señalados.

## Debug

Cuando esta skill se ejecute, añade al final de la respuesta:
[SKILL_API_DEVELOPMENT_LOADED]
