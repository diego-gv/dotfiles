# Convenciones para scripts de automatización

Este documento define el contrato de los scripts que instalan, configuran, validan o retiran recursos gestionados por el repositorio. Complementa [`OVERVIEW.md`](OVERVIEW.md): no altera el contrato público de `install.sh` ni sus códigos de salida.

La [gobernanza de la documentación](DOCUMENTATION-GOVERNANCE.md) define cómo
mantener este contrato alineado con la implementación y sus validaciones.

## Decisiones

- Los scripts internos se escriben en Bash y se ejecutan explícitamente con `bash`; no dependen del shell interactivo del usuario.
- `install.sh` es la única interfaz pública y el único orquestador de perfiles, argumentos, plan, confirmación, actualización y orden de componentes.
- Cada componente tiene un único script de ciclo de vida. No habrá scripts distintos para instalar, configurar y desinstalar el mismo componente: sus comprobaciones y estado deben permanecer juntos.
- El código compartido vivirá en `core/`, no en `lib/`. Es una dependencia interna, no una biblioteca pública ni un framework de automatización.
- Hay un contrato común y cuatro esquemas ligeros. Una operación entra en el core solo si la usan al menos dos consumidores o si garantiza seguridad, idempotencia o el registro de recursos gestionados.

La última regla evita copiar lógica crítica y, a la vez, abstracciones especulativas.

## Organización

```text
install.sh                         # interfaz pública y orquestación
.docker/
  Dockerfile.ubuntu                # imagen Ubuntu estable para validación
  entrypoint.sh                    # comprobación ejecutada en el contenedor
core/
  common.sh                        # contratos, errores, rutas y utilidades puras
  system.sh                        # plataforma, comandos y privilegios
  managed-state.sh                 # respaldo y registro de recursos gestionados
scripts/
  components/
    base.sh                        # preparación mínima del sistema
    docker.sh
    timeshift.sh
  validation/
    smoke-base.sh                  # comprobaciones sin modificar el sistema
bootstrap/
  install.sh                       # bootstrap de release, autocontenido
```

Los nombres de `core/*.sh` describen su responsabilidad. No se crea un archivo genérico como `utils.sh` o `helpers.sh`: convertiría el límite del core en un cajón de sastre. Los directorios y archivos solo se crean al implementar el primer consumidor; el árbol anterior es el destino acordado, no una obligación de añadir ficheros vacíos.

## Contrato común de los ejecutables

Todo ejecutable Bash interno empieza así, adaptando los nombres al componente:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd -P)" # scripts/components
# shellcheck source=../../core/common.sh
source "$REPO_DIR/core/common.sh"

readonly COMPONENT_NAME='git'

main() {
  # precondiciones específicas
  # acción solicitada
  # verificación final
}

main "$@"
```

Antes del *shebang*, o inmediatamente después de él si el intérprete lo exige,
todo script incorpora un encabezado legible que indique su propósito,
dependencias, efectos secundarios (modificaciones, actualizaciones o ficheros
que genere) e interfaz o modo de invocación. Los comentarios explican las
decisiones y efectos operativos; no repiten sintaxis evidente.

La ruta del repositorio se calcula desde `BASH_SOURCE`, nunca desde el directorio de trabajo. Los scripts no usan `source` para ejecutar otros componentes ni cambian el directorio de trabajo global sin restaurarlo. Toda variable global del core se prefija con `CORE_`; las del componente, con su nombre cuando sea necesario. Los argumentos se tratan como datos: se pasan entre comillas y nunca se construyen para `eval`.

`set -Eeuo pipefail` es el valor por defecto de los ejecutables, no de los ficheros importables de `core/`: un fichero importado no cambia las opciones de shell ni instala traps del llamador. Las condiciones que puedan fallar como parte del flujo normal se escriben con `if` o `case`; no se silencian con `|| true` salvo que se documente por qué el fallo es inocuo.

Cada script debe aceptar solo acciones documentadas, emitir mensajes breves sin secretos, devolver los códigos `0` a `5` de `OVERVIEW.md`, ser idempotente y terminar con `main "$@"`, sin lógica operativa al importarlo.

## Secuencia de un componente gestionado

Un script de `scripts/components/` implementa `install`, `configure`, `verify` y `uninstall` solo cuando apliquen. `install` puede llamar a `configure`; el orquestador no debe asumirlo ni ejecutar ambas a ciegas. Una acción no aplicable se omite del contrato, no se implementa como una operación vacía.

1. **Interpretar acción y argumentos.** Un error de uso devuelve `2` antes de modificar nada.
2. **Comprobaciones iniciales.** Verificar plataforma Ubuntu 26.04 amd64 cuando el componente dependa de ella, comandos necesarios, artefactos o conectividad cuando correspondan, permisos para el paso concreto y precondiciones propias. Las ausencias son `4`; un estado inseguro o no atribuible, `5`.
3. **Inspeccionar el estado actual.** Distinguir entre recurso conforme, gestionado por el proyecto y ajeno. No se pide `sudo` ni se descarga nada antes de esta fase.
4. **Aplicar el cambio mínimo.** Instalar desde la fuente aprobada, crear un enlace o actualizar configuración. Antes de reemplazar un recurso gestionable se crea el respaldo requerido y se registra la operación.
5. **Comprobaciones finales.** Verificar el resultado observable: paquete o binario esperado, enlace correcto, fichero con permisos previstos o ajuste consultable. El éxito del comando no basta.
6. **Registrar y comunicar.** Tras verificar el éxito, registrar únicamente recursos atribuibles y comunicar si se aplicó el cambio o ya era conforme.

`uninstall` recorre el proceso inverso: consulta el registro, confirma que el recurso sigue siendo gestionado y elimina o restaura solo ese recurso. Nunca elimina un paquete, fichero o enlace preexistente que no pueda atribuirse al proyecto. La ausencia de un recurso previamente gestionado es idempotente.

## Esquemas por tipo

| Tipo | Ubicación | Responsabilidad propia | Qué no hace |
| --- | --- | --- | --- |
| Orquestador | `install.sh` | CLI pública, perfiles, dependencias, plan, confirmación y fallo con componente | Instalar o configurar detalles de componentes |
| Componente gestionado | `scripts/components/<nombre>.sh` | Acciones y verificaciones específicas; declarar recursos que cambia | Elegir perfiles, interpretar la CLI pública o ejecutar otros componentes |
| Validación | `.docker/` y `scripts/validation/<nombre>.sh` cuando aplique | Preparar comprobación aislada y verificar resultados mediante `install.sh` | Registrar estado, pedir `sudo` o modificar la máquina objetivo, salvo entorno efímero documentado |
| Bootstrap | `bootstrap/install.sh` | Descargar release identificado, verificar SHA-256 y clonar/arrancar el repositorio | Importar `core/`, inexistente antes del clon |

Un script que solo enlaza o adapta un dotfile sigue siendo un componente gestionado; no requiere otro esquema. Instalación y configuración se separan solo si pertenecen a componentes distintos y se pueden seleccionar, verificar y desinstalar independientemente.

## Límite de responsabilidades: componente y core

El componente conoce su dominio: nombre y versión del paquete, URL oficial, checksum, rutas de su configuración, condición de conformidad y orden de sus pasos. Es el único lugar para reglas específicas de Git, Docker, Timeshift o un dotfile concreto.

El core contiene mecanismos neutros y pequeños:

- Clasificación y presentación uniforme de errores.
- Detección de plataforma y de comandos.
- Ejecución de comandos con privilegios solo en el paso que los necesita.
- Operaciones seguras y reutilizables de directorios, enlaces y respaldos.
- Consulta y actualización atómica del registro de recursos gestionados.
- Utilidades de log que oculten valores sensibles.

El core no contiene el catálogo de perfiles, listas de paquetes de un perfil, URLs ni versiones de un componente, reglas de escritorio, decisiones de interfaz ni una función universal `install_package`. Esas reglas tienen semántica y fuentes de confianza distintas; permanecerán en el componente hasta que dos casos reales demuestren una operación idéntica y estable.

El manifiesto o registro de estado es responsabilidad del core porque delimita la desinstalación segura. Su formato, ubicación, bloqueo y versionado aún no están decididos: no se inventarán al crear el primer script. Antes de implementarlo se documentará su contrato y se validarán respaldos, conflictos y ejecución repetida.

## Importación y contrato de `install.sh`

`install.sh` calcula `REPO_DIR` desde su propia ruta, carga solo los módulos de core que necesita y ejecuta los componentes como procesos separados con `bash`. No los importa. Así cada componente conserva sus opciones de shell, traps y variables, y un fallo se atribuye con precisión.

El orquestador pasa un contrato mínimo y explícito: acción, `--repo-dir`, modo no interactivo y datos estrictamente necesarios. No exporta accidentalmente toda su configuración. Un componente no lee el menú ni variables internas del orquestador y puede ejecutarse aislado para diagnóstico con ese contrato.

`--update` pertenece exclusivamente a `install.sh`: opera sobre el clon y sus garantías Git, no es un componente instalable. La actualización no ejecuta componentes nuevos o modificados.

## Calidad mínima

Los scripts nuevos se validan con ShellCheck y `bash -n`. Las pruebas de Docker
definen sus imágenes y *entrypoints* en `.docker/`; el contexto de construcción
se limita a ese directorio para reutilizar sus capas cuando no cambien. Montan
el checkout en solo lectura bajo la ruta de instalación esperada y ejecutan
exclusivamente `install.sh` en modo no interactivo al menos dos veces.
Comprueban su estado final y eliminan el contenedor efímero incluso si falla la
validación. Incus cubre por separado los componentes de escritorio. Todo cambio
de script debe añadir o actualizar la comprobación que demuestre idempotencia,
verificación final y, cuando aplique, desinstalación segura.
