# Componentes para el sistema de dotfiles

Documento único de decisión derivado de `ubuntu-audit-20260911-123647` y de la
revisión posterior. La auditoría se realizó en Ubuntu 24.04.4 LTS; el proyecto
objetivo es Ubuntu 26.04. Cada método debe validarse en esa versión antes de
automatizarlo.

Los perfiles de aplicación previstos son `base`, `developer` y `desktop`. Los
componentes de validación forman parte de `developer` porque son necesarios para
probar actualizaciones futuras de los dotfiles.

## Componentes obligatorios

| Componente | Tipo | Método de instalación | ¿Configuración? | Descripción |
| --- | --- | --- | --- | --- |
| Git | Base | APT de Ubuntu | Sí, mediante dotfiles | Control de versiones y clon del repositorio. |
| curl | Base | APT de Ubuntu | No | Descarga del bootstrap y de recursos gestionados. |
| Zsh | Shell | APT de Ubuntu | Sí, mediante dotfiles | Shell interactiva predeterminada. |
| Oh My Zsh | Shell | Instalador oficial con versión fijada | Sí, mediante dotfiles | Marco de carga para la configuración de Zsh. |
| Starship | Shell | Instalador oficial con versión fijada | Sí, mediante dotfiles | Prompt compartido de terminal. |
| Vim | CLI | APT de Ubuntu | No inicialmente | Editor de consola mínimo. |
| fzf | CLI | APT de Ubuntu | Sí, mediante dotfiles | Búsqueda interactiva en terminal. |
| bat | CLI | APT de Ubuntu | Sí, mediante dotfiles | Visualización mejorada de archivos. |
| btop | CLI | APT de Ubuntu | No | Monitor interactivo de recursos. |
| fastfetch | CLI | Fuente oficial compatible con Ubuntu 26.04, por confirmar | Sí, mediante dotfiles si se personaliza | Resumen de información del sistema. |
| Timeshift | Base | APT de Ubuntu | Sí, mediante script de componente | Snapshots del sistema antes de cambios gestionados. |
| Docker Engine (`docker-ce`) | Desarrollo | Repositorio oficial de Docker | No; proyectos aparte | Motor de contenedores local. |
| Docker CLI (`docker-ce-cli`) | Desarrollo | Repositorio oficial de Docker | No; proyectos aparte | Cliente de línea de comandos para Docker. |
| Docker Compose plugin | Desarrollo | Repositorio oficial de Docker | No; proyectos aparte | Orquestación local de servicios Docker. |
| VS Code (`code`) | Desarrollo | Repositorio oficial de Microsoft | No; ajustes y extensiones manuales | Editor principal. |
| ShellCheck | Desarrollo | APT de Ubuntu | No | Análisis estático de scripts Shell del repositorio. |
| Incus | Validación | APT de Ubuntu | Sí, mediante scripts de validación | Entorno aislado para validar componentes de escritorio y sistema. |
| QEMU (`qemu-system`) | Validación | APT de Ubuntu | Sí, mediante scripts de validación | Virtualización requerida por los flujos de prueba. |
| Virt Viewer | Validación | APT de Ubuntu | No inicialmente | Cliente gráfico para inspeccionar máquinas virtuales. |
| Google Chrome | Escritorio | Repositorio oficial de Google | No; perfil, extensiones y sesión manuales | Navegador requerido. |
| Brave Origin (`brave-origin`) | Escritorio | Repositorio oficial de Brave | No; perfil, extensiones y sesión manuales | Navegador requerido. No instalar `brave-browser`. |
| Flameshot | Escritorio | APT de Ubuntu | Sí, mediante dotfiles si se definen atajos | Captura y anotación de pantalla. |
| Diodon | Escritorio | Fuente oficial compatible con Ubuntu 26.04, por confirmar | Sí, mediante dotfiles si se definen atajos | Historial de portapapeles. |
| MesloLGS Nerd Font | Fuentes | Archivo de release del proyecto Nerd Fonts | Sí, mediante dotfiles de escritorio | Fuente Nerd para terminal y prompt. |
| Fira Code iScript | Fuentes | Archivo de release del repositorio upstream | Sí, mediante dotfiles de escritorio | Fuente monoespaciada para código. |
| Monaspace | Fuentes | Archivo de release del repositorio upstream | Sí, mediante dotfiles de escritorio | Familia tipográfica monoespaciada para desarrollo. |

Los métodos externos deben descargar una versión identificada, verificarla según
la documentación oficial correspondiente y no ejecutar instaladores remotos sin
esa trazabilidad.

## Componentes opcionales o dependientes del flujo

| Componente | Cuándo instalarlo | Método de instalación | ¿Configuración? | Descripción |
| --- | --- | --- | --- | --- |
| GnuPG (`gnupg`) | Si un componente necesita importar o convertir claves de repositorios APT externos | APT de Ubuntu | No | Gestión de claves OpenPGP para fuentes de paquetes. |
| xclip | Solo si los dotfiles o sus scripts necesitan acceder al portapapeles X11 | APT de Ubuntu | No | Interfaz CLI de portapapeles. |
| `build-essential` | Si una herramienta necesita compilar código o dependencias nativas | APT de Ubuntu | No | Compilador y herramientas base de construcción. |
| CMake | Si un proyecto o dependencia lo exige | APT de Ubuntu | No | Generador de sistemas de construcción. |
| Azure CLI | Solo en flujos que utilicen Azure | Repositorio oficial de Microsoft | No; autenticación manual | Cliente para administrar recursos Azure. |
| Node.js | Solo si un componente de dotfiles o proyecto lo necesita | Gestor de runtimes que se decida para el proyecto | Sí, mediante dotfiles si afecta al shell | Runtime JavaScript. NVM no se migra por defecto. |
| AWS CLI | Solo en flujos que utilicen AWS | Fuente oficial de AWS | No; autenticación manual | Cliente para administrar recursos AWS. |

## Componentes sin decisión o fuera del alcance actual

| Componente o hallazgo | Situación | Decisión actual |
| --- | --- | --- |
| `ca-certificates`, `unzip` y `zip` | Dependencias directas de `ubuntu-desktop` en Ubuntu 24.04 | No gestionarlas explícitamente; comprobar su presencia antes de depender de ellas. |
| `python3` y `wget` | Pertenecen a `ubuntu-minimal` y `ubuntu-standard`, respectivamente, en Ubuntu 24.04 | No gestionarlos explícitamente; comprobar su presencia antes de depender de ellos. |
| Configuración de GNOME | Tema, dock, atajos, teclado y monitores no están definidos | Configurar progresivamente mediante dotfiles de escritorio cuando se concrete la necesidad. |

## Límites de seguridad y migración

No versionar claves SSH o GPG, tokens, contraseñas, cookies, sesiones, perfiles
VPN, certificados privados, archivos `.env`, credenciales cloud ni datos de
usuario. Los componentes que necesiten configuración sensible usarán plantillas
`*.sample` sin valores reales y requerirán configuración manual posterior.
