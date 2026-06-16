---
name: python-development
description: Use when implementing, modifying, refactoring or analyzing Python code. Focus on idiomatic Python, type hints, error handling, dependency analysis and consistency with the existing codebase.
---

# Python Development

## Cuándo usar esta skill

Utilízala cuando debas implementar, modificar, refactorizar o analizar código Python.

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
