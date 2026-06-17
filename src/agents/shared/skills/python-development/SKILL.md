---
name: python-development
description: Úsala para implementar, modificar, refactorizar o analizar código Python. Prioriza estilo idiomático, type hints, manejo de errores, análisis de dependencias y consistencia con el código existente.
---

# Desarrollo en Python

## Cuándo usar esta skill

Utilízala cuando debas implementar, modificar, refactorizar o analizar código Python.

## Objetivo de la skill

Producir cambios de Python legibles, idiomáticos y seguros, consistentes con el código y herramientas ya existentes.

## Checklist de ejecución

- Comprender el contexto del módulo y el comportamiento esperado.
- Aplicar cambios idiomáticos con type hints y errores explícitos.
- Mantener dependencias y efectos secundarios bajo control.
- Verificar consistencia con tooling y convenciones existentes.

## Principios fundamentales

Prefiere código explícito frente a código ingenioso. Prioriza soluciones idiomáticas de Python antes que patrones importados de otros lenguajes. El código debe ser fácil de leer, fácil de probar y con responsabilidades claramente delimitadas.

Evita:

- Clever code: soluciones especialmente ingeniosas. Código aburrido que funciona es mejor que código ingenioso que nadie entiende.
- Magic code: comportamientos implícitos, convenciones ocultas, efectos secundarios inesperados.
- Metaprogramación innecesaria: solo cuando aporte beneficio claro y medible.
- Efectos secundarios ocultos: funciones que modifican estado global o escriben archivos sin que sea evidente. Hace el código impredecible.
- Estado global mutable: variables globales que cambian hacen el código difícil de razonar. Si necesitas estado compartido, hazlo explícito e inyéctalo.

Respeta siempre las convenciones, herramientas y estilo existentes del proyecto antes que tus preferencias personales.

## Tipado

Utiliza type hints en interfaces públicas y en cualquier lógica donde el tipado mejore significativamente la comprensión o reduzca errores. Evita tipado ambiguo o innecesarios `Any`.

## Manejo de errores

Maneja errores de forma explícita. No captures excepciones de forma genérica salvo que exista una razón clara y documentada. No silencies errores.

## Organización

Prefiere funciones pequeñas con responsabilidades claras. Las dependencias deben ser explícitas (pasadas como parámetros) en lugar de implícitas (globales, importadas, singletons). Esto hace el código más testeable.

Evita funciones excesivamente largas (más de 20-30 líneas es señal de que hace demasiado), acoplamiento innecesario y dependencias implícitas.

## Sistema de archivos

Utiliza `pathlib` para trabajar con rutas. Es agnóstico del SO, más legible que concatenación de strings, y proporciona métodos útiles. Mantén consistencia con las convenciones existentes del proyecto.

## Verificación de herramientas

Antes de proponer herramientas nuevas, verifica su presencia en el proyecto revisando: `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt`, `requirements-dev.txt`, `poetry.lock`, `uv.lock`, `tox.ini`, `noxfile.py`, `Makefile`. Utiliza herramientas ya presentes antes de introducir alternativas.

## Entrega esperada

- Código claro, con responsabilidades acotadas.
- Type hints y manejo de errores adecuados al contexto.
- Decisiones de dependencias justificadas y alineadas con el proyecto.

## Debug

Cuando esta skill se ejecute, añade al final de la respuesta:
[SKILL_PYTHON_DEVELOPMENT_LOADED]
