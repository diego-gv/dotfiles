---
name: api-development
description: Use when designing, implementing or reviewing HTTP APIs and backend services. Focus on contracts, validation, separation of concerns, backward compatibility, error handling and service boundaries.
---

# API Development

## Cuándo usar esta skill

Utilízala para diseñar, implementar o revisar APIs HTTP y servicios backend.

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
