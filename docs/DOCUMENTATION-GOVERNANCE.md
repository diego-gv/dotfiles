# Gobernanza de la documentación

La documentación versionada es parte del producto y debe ser una descripción
fiel, navegable y mantenible del repositorio. Esta política se aplica a
`docs/`, `README.md`, `AGENTS.md` y cualquier documento que se añada en el
futuro.

## Fuente de verdad y estado

La implementación, las pruebas y la configuración versionada son la evidencia
del comportamiento efectivo. La documentación no puede contradecirlas ni
presentar una intención como funcionalidad existente.

Cada comportamiento debe quedar identificado de forma inequívoca como uno de
estos estados:

- **Actual:** implementado y, cuando corresponda, validado.
- **Planificado:** decisión aceptada pero aún no implementada. Debe indicar su
  condición, limitación o trabajo pendiente.
- **Por decidir:** alternativa o requisito abierto. No es un compromiso de
  implementación.

Los requisitos futuros, funcionalidades previstas y decisiones de metodología
son documentación válida, pero se marcan como planificados o por decidir. Si no
hay evidencia suficiente para corregir una discrepancia, se debe pedir
aclaración en vez de inventar el estado real.

## Responsabilidad de mantenimiento

Toda persona, agente o IA que vaya a analizar, modificar, revisar o validar el
repositorio debe leer completamente la documentación versionada aplicable antes
de actuar, empezando por [OVERVIEW.md](OVERVIEW.md), y seguir sus enlaces
relevantes. En el estado actual eso incluye todos los documentos de `docs/` y
los documentos de raíz que existan, como `README.md` y `AGENTS.md`.

Al detectar que documentación e implementación, requisitos, pruebas o procesos
no coinciden, debe corregirse de forma consistente dentro del mismo cambio. Si
el cambio técnico no está autorizado o la corrección requiere una decisión de
producto o arquitectura, se informa de la discrepancia y se solicita esa
decisión; no se deja una afirmación conocida como incorrecta.

Un cambio que introduzca o altere una funcionalidad, corrección, requisito,
protocolo, estructura, comando o validación debe actualizar todos los
documentos afectados. Esto incluye el índice de componentes, contratos de
scripts, instrucciones para agentes y guías de uso cuando sean pertinentes.

## Navegación y documentos nuevos

Crear documentación nueva es válido cuando hace más clara una responsabilidad o
evita sobrecargar un documento existente. Todo documento nuevo debe:

1. tener un propósito y alcance explícitos;
2. enlazarse desde su documento padre o índice, normalmente `OVERVIEW.md`;
3. enlazar las decisiones, contratos o documentos de los que dependa;
4. evitar duplicar una fuente de verdad; y
5. usar enlaces relativos versionados que funcionen al clonar el repositorio.

No se eliminan documentos o secciones sin comprobar enlaces, referencias y
consumidores. Las decisiones sustituidas se actualizan o se retiran de forma
que no dejen instrucciones contradictorias.

## Verificación

Antes de cerrar un cambio documental se revisan los enlaces modificados, la
coherencia con la implementación y las pruebas, y se ejecutan las validaciones
disponibles que correspondan. Cuando no exista una prueba automática, la
revisión debe indicarlo expresamente.
