# OVERVIEW

Este repositorio almacena los `dotfiles` del usuario y el instalador necesario para configurar una máquina limpia.

## Alcance actual

- Plataforma soportada: Ubuntu 26.04 `amd64` (también denominada x64 o x86_64).
- Linux Mint y otras distribuciones no están soportadas actualmente. Podrán añadirse cuando exista una ruta de instalación y validación específica.
- Se instalarán y configurarán únicamente los recursos seleccionados y gestionados por el proyecto.
- No se versionarán secretos ni credenciales. Las plantillas sensibles indicarán su ubicación final y el usuario creará y actualizará manualmente el archivo real; el instalador no creará enlaces simbólicos inversos ni guardará ese contenido en el clon.

El repositorio público del proyecto es <https://github.com/diego-gv/dotfiles>.

## Documentación

Este documento es el índice funcional del repositorio. La política de
[gobernanza de la documentación](DOCUMENTATION-GOVERNANCE.md) establece cómo
mantener coherentes los documentos, la implementación y las decisiones futuras.
La lista curada de componentes está en
[CURATED-SYSTEM-BASELINE.md](CURATED-SYSTEM-BASELINE.md), y las convenciones de
automatización en [SCRIPT-CONVENTIONS.md](SCRIPT-CONVENTIONS.md). La guía de
uso y validación del estado implementado está en el [README](../README.md).

## Instalación

**Actual:** `install.sh` es el único punto de entrada público. Su primer
contrato implementado es `--non-interactive --profile base --yes`: actualiza
los índices de APT e instala `curl` y `wget` cuando falten. El perfil no crea
ficheros de usuario ni configura esas herramientas.

**Planificado:** menú interactivo, perfiles adicionales, `--all`,
desinstalación, actualización del clon y el resto del contrato de línea de
comandos.

El modo mediante clon es la vía auditable de instalación:

```bash
git clone https://github.com/diego-gv/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh --non-interactive --profile base --yes
```

También se proporcionará un *one-liner* para sistemas nuevos, antes de disponer de Git. Descargará un bootstrap de release versionado y verificado mediante SHA-256, que clonará el repositorio oficial en `~/.dotfiles`. El clon conservará `origin` y seguirá la rama `main`, protegida contra reescritura. La verificación del bootstrap protege la descarga inicial; las actualizaciones posteriores confían en el repositorio oficial y en la protección de su rama.

Al iniciarse, el instalador ofrecerá un menú de perfiles y una opción de instalación completa. Su interfaz no sustituye los argumentos no interactivos que se definirán para automatización y pruebas.

### Perfiles de instalación

El menú no preselecciona ningún perfil: el usuario elige uno o varios perfiles, o la instalación completa. El catálogo inicial es pequeño y explícito; los componentes siguientes son ejemplos de pertenencia, no una lista cerrada.

| Perfil | Componentes que pueden incluirse | Dependencia propuesta |
| --- | --- | --- |
| `base` | **Actual:** curl y wget. **Planificado:** Git, certificados, directorios de trabajo, Timeshift, shell y dotfiles comunes | Ninguna |
| `developer` | Mise, herramientas de terminal, configuración Git de desarrollo, VS Code y Postman | `base` |
| `desktop` | Fuentes, tema, dock, navegadores, Spotify y configuraciones de escritorio | `base` |
| `agents` | Configuración no sensible, instrucciones y skills de Claude, Codex y Copilot | `base` |

`--all` selecciona la unión de todos los perfiles disponibles, incluidas sus dependencias; no representa un conjunto oculto distinto. Los perfiles pueden ampliarse, dividirse o diversificarse si surge una necesidad concreta. Todo cambio debe actualizar este catálogo, las pruebas y la información mostrada por el menú.

### Contrato de línea de comandos

La primera versión no incluirá `--dry-run`. Para un instalador que gestiona paquetes, Git, permisos, enlaces y configuraciones de escritorio, una simulación incompleta sería más engañosa que útil. La idempotencia y las pruebas aisladas en Docker e Incus son el mecanismo de validación inicial.

```text
install.sh
    Abre el menú interactivo.

install.sh --profile <nombre> [--profile <nombre>...]
    Selecciona los perfiles indicados, muestra el plan y solicita confirmación.

install.sh --all
    Selecciona todos los perfiles, muestra el plan y solicita confirmación.

install.sh --non-interactive --profile <nombre> [--profile <nombre>...] --yes
install.sh --non-interactive --all --yes
    Ejecuta sin menú ni preguntas. En modo no interactivo se requiere una selección
    explícita y --yes; --non-interactive por sí solo es un error de uso.

install.sh --uninstall
    Abre el flujo interactivo de desinstalación.

install.sh --uninstall --profile <nombre> --non-interactive --yes
install.sh --uninstall --all --non-interactive --yes
    Desinstala los recursos registrados como gestionados por el proyecto.

install.sh --update
    Actualiza de forma segura el clon de dotfiles existente.
```

`--repo-dir <ruta>` sustituye `~/.dotfiles` como ubicación del clon. Permite utilizar una instalación alternativa y ejecutar pruebas aisladas en directorios temporales. `--help` y `--version` deben estar disponibles sin requerir ninguna otra opción.

Los códigos de salida son comunes al instalador, desinstalador y scripts de componentes:

| Código | Significado |
| ---: | --- |
| `0` | Operación terminada correctamente, incluidos recursos que ya estaban conformes. |
| `1` | Error operativo durante una acción. |
| `2` | Argumentos inválidos o combinación de opciones incompatible. |
| `3` | Operación cancelada por el usuario. |
| `4` | Precondición no cumplida, como plataforma no soportada, dependencia ausente o permiso insuficiente. |
| `5` | Operación bloqueada por seguridad, como un estado Git no seguro, un conflicto o un recurso no gestionado. |

Los scripts internos deben devolver estos códigos cuando puedan clasificarlos. `install.sh` debe propagarlos y registrar qué componente falló.

La instalación mostrará progreso y la salida reciente de los comandos en la consola. No guardará logs persistentes ni registrará secretos, credenciales, contenido de plantillas locales o argumentos sensibles.

### Política de actualización

`install.sh --update` es la interfaz pública de actualización. Solo opera sobre un repositorio Git en `main`, que siga `origin/main`, y cuyo remoto `origin` sea una de las direcciones oficiales equivalentes: `https://github.com/diego-gv/dotfiles.git` o `git@github.com:diego-gv/dotfiles.git`.

Antes de modificar el clon, obtiene el estado del remoto y aborta con código `5` si hay cambios sin confirmar, commits locales que divergen de `origin/main`, una rama distinta, un remoto no reconocido o una actualización que no sea *fast-forward*. No crea merges, no hace rebase, no descarta cambios ni ejecuta `reset`.

Si la actualización es posible, aplica únicamente el avance rápido y muestra los ficheros añadidos, modificados, eliminados o renombrados. Si detecta scripts de instalación nuevos o modificados, los muestra como recomendación: nunca ejecuta instalaciones nuevas automáticamente. Cuando existan cambios o commits locales pendientes, los informa junto con la acción manual recomendada —revisar, confirmar y subir, o descartarlos— antes de volver a actualizar.

## Capacidades

- Clonar el repositorio en `~/.dotfiles` cuando no exista.
- Detectar que una instalación existente pertenece al proyecto y actualizarla de forma segura, sin volver a clonar.
- Crear los directorios de trabajo, proyectos personales y demás rutas necesarias para los componentes seleccionados.
- Instalar herramientas de línea de comandos, fuentes, shell, prompt, aplicaciones de escritorio y configuraciones de interfaz seleccionadas.
- Gestionar configuraciones de herramientas de agentes (Claude, Codex y Copilot) sin incluir datos sensibles.
- Crear enlaces simbólicos para los archivos de configuración versionados.
- Proporcionar plantillas locales que el usuario creará y mantendrá manualmente, sin versionar ni registrar su contenido.
- Proporcionar instalación, actualización, validación y desinstalación de los recursos que gestione el proyecto.

Cada componente declarará si pertenece a un perfil y si su instalación requiere privilegios de administrador, fuentes externas o interacción adicional.

El software se instalará exclusivamente desde fuentes oficiales y siguiendo sus guías de instalación. Los componentes que requieran `sudo` lo solicitarán únicamente en el paso concreto que lo necesite; la elevación de privilegios es una operación normal, pero no debe anticiparse ni reutilizarse para pasos que no la requieren.

## Seguridad, actualización y desinstalación

Antes de una operación potencialmente destructiva se realizarán comprobaciones de seguridad y una copia de respaldo adecuada. El proyecto debe registrar los recursos que instala, crea o modifica y el estado necesario para revertirlos.

Timeshift será la herramienta de snapshots del sistema. Se configurará con una retención inicial de 7 snapshots diarios, 4 semanales y 2 mensuales, y creará una snapshot antes de una actualización gestionada por los dotfiles. La restauración será una operación manual y explícita: el instalador no revertirá el sistema automáticamente. Timeshift no sustituye las copias de seguridad específicas de archivos o datos que queden fuera del alcance de sus snapshots.

La desinstalación solo eliminará paquetes, enlaces, configuraciones y otros recursos registrados como gestionados por el proyecto. No eliminará recursos preexistentes ni recursos que no pueda atribuir de forma fiable al instalador. Cuando exista una copia de respaldo válida, restaurará el estado anterior.

La instalación debe ser idempotente: una segunda ejecución con el mismo perfil no debe crear conflictos ni repetir cambios que ya estén conformes. Los criterios verificables se concretarán en la documentación de validación.

Una segunda ejecución con la misma versión del repositorio y los mismos perfiles debe terminar correctamente, sin reinstalar paquetes ya conformes, recrear enlaces correctos ni modificar configuraciones locales. La validación en Docker ejecutará ese escenario dos veces y comprobará el estado de los recursos gestionados tras ambas ejecuciones.

## Configuración compartida y local

Los dotfiles versionados definen el estándar común y se enlazan desde su ubicación real. Sus actualizaciones se propagan a todos los equipos al actualizar el clon del repositorio.

Una configuración opcional por máquina solo se admite cuando la herramienta pueda cargarla explícitamente. Por ejemplo, `~/.zshrc` puede enlazar al fichero común `~/.dotfiles/config/zsh/zshrc`, que cargará `~/.zshrc.local` únicamente si existe. El archivo `.local` vive fuera del clon, no se crea si no hace falta y nunca se versiona.

Los dotfiles que no admitan una extensión local no tendrán una variante `.local` artificial. Sus cambios deben ser válidos para todos los equipos; si aparece una excepción real, se definirá un mecanismo específico para ese componente antes de modificarlo.

## Validación

Las validaciones se ejecutarán mediante objetivos de `make`.

- Docker validará scripts, instalación de paquetes y configuraciones no gráficas de forma no interactiva y repetible.
- Incus validará aplicaciones de escritorio, configuraciones de interfaz y otros comportamientos que requieran un entorno de sistema más completo.

**Actual:** `.docker/Dockerfile.ubuntu` define la imagen estable de validación
y `.docker/entrypoint.sh` la comprobación. `make validate` ejecuta `docker
build` con `.docker/` como único contexto, por lo que Docker reutiliza sus capas
si esos archivos no cambian. Después monta el checkout actual en solo lectura
como `/root/.dotfiles` dentro de un contenedor efímero. El *entrypoint* invoca
exclusivamente `install.sh` dos veces con el perfil `base` y comprueba que
`curl` y `wget` están disponibles. `make lint` ejecuta ShellCheck y `bash -n`
sobre los scripts implicados. `make shell` abre una terminal manual en esa
misma imagen, con el checkout montado en solo lectura como `/root/.dotfiles`.

**Planificado:** se ampliará esta primera validación a curl y el resto de
componentes no gráficos. Las validaciones de escritorio se añadirán de forma
independiente en Incus.

## Organización del repositorio

La estructura busca mantener cada script centrado en un componente, sin duplicar lógica común:

```text
install.sh
Makefile
core/
  common.sh
  system.sh
  managed-state.sh
agents/
  claude/
  codex/
  copilot/
  shared/
scripts/
  components/
    chrome.sh
    brave-origin.sh
    vscode.sh
    postman.sh
    zsh.sh
    oh-my-zsh.sh
  validation/
    *.sh
.docker/
  Dockerfile.ubuntu
  entrypoint.sh
config/
  zsh/
    zshrc
    aliases.zsh
  git/
    gitconfig
templates/
  ssh/
    config.sample
  secrets/
    secrets.sample
```

Los archivos específicos de cada herramienta de agentes vivirán bajo su directorio. Las definiciones portables, como las skills compartidas, vivirán bajo `agents/shared/` y se enlazarán o adaptarán únicamente cuando la herramienta destino lo admita.

Una capa interna pequeña en `core/` podrá incorporar la lógica repetida de detección de plataforma, privilegios, logs, enlaces, respaldos y manifiesto de instalación cuando se hayan cerrado sus contratos. No se añadirá una capa común antes de que sea necesaria. La estructura, los límites de responsabilidad y los contratos de los scripts se definen en [SCRIPT-CONVENTIONS.md](SCRIPT-CONVENTIONS.md).

## Guía de estilo

Los scripts deben respetar el principio de responsabilidad única: instalar, configurar y desinstalar un componente concreto. Pueden agruparse instalaciones simples que se resuelvan con un único comando de paquetes; cuando un componente requiera pasos propios de configuración, debe tener su script.

Se evaluará el uso de [Mise](https://mise.jdx.dev/) como gestor de versiones y herramientas de desarrollo cuando se concrete qué componentes resuelve mejor que el gestor de paquetes de Ubuntu.

El repositorio debe incluir un `README.md` con la instalación, perfiles, componentes, configuraciones manuales, aliases, pruebas y validaciones. También mantendrá `AGENTS.md` y sus equivalentes para orientar a las herramientas de agentes; esos documentos deberán actualizarse al introducir una funcionalidad, corrección o protocolo relevante.
