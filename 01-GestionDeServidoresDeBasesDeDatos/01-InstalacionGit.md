# Manual de Instalación y Configuración de Git

Este documento detalla el proceso paso a paso para instalar **Git**, así como la configuración inicial obligatoria.

## Instalación en Windows

El método más recomendado es utilizar el instalador oficial que incluye **Git Bash**, una terminal que emula el entorno de Linux.

### Pasos:
1.  **Descargar el instalador:**
    *  La descarga debería comenzar automáticamente. Si no, selecciona "64-bit Git for Windows Setup".

2.  **Ejecutar el instalador (`.exe`):**
    * Hacer doble clic en el archivo descargado.

3.  **Configuración del asistente:**
    * Aceptamos  la licencia y la ubicación por defecto.
    * **Editor por defecto:** Seleccionamos nuestro editor de código en este caso fue Visual Studio Code
    * **Nombre de la rama inicial:** Selecciona *"Override the default branch name for new repositories"* y escribe `main` (es el estándar moderno).
    * **Line Ending Conversions:** Deja la opción por defecto *"Checkout Windows-style, commit Unix-style line endings"*.

4.  **Finalizar:** Haz clic en **Install** y espera a que termine.
 ---

## Comandos de GIT 

### Configuración del Entorno (`git config`)

| **Comando** | **Función Principal** |
| :--- | :--- |
| `git config --global user.name` | Asigna el nombre del autor que aparecerá en el historial de cambios. |
| `git config --global user.email` | Vincula un correo electrónico a los commits (necesario para GitHub). |
| `git config --global alias.[nombre]` | Permite crear atajos personalizados (ej. escribir `git s` en lugar de `git status`) para agilizar el trabajo. |

---

### Inicialización
Estos comandos gestionan el flujo de trabajo

| Comando | Función Principal |
| :--- | :--- |
| `git init` | Transforma la carpeta actual en un repositorio de Git, creando el directorio oculto `.git`. |
| `git status` | Es el "monitor" del proyecto. Indica qué archivos han cambiado, cuáles están en el *Stage* y en qué rama estás. |
| `git add [archivo]` | Mueve cambios del directorio de trabajo al **Stage**. Indica qué archivos se incluirán en la próxima "foto" o commit. |
| `git commit -m "mensaje"` | Crea una "foto" o punto de guardado permanente en el historial con los archivos que estaban en el Stage. |
| `git log` | Muestra el historial cronológico de los commits realizados (autor, fecha y mensaje). |

---

### Gestión de Ramas (`branch` y `merge`)
Las ramas permiten trabajar en funcionalidades aisladas sin afectar el código principal.

| Comando | Función Principal |
| :--- | :--- |
| `git branch` | Lista las ramas existentes y marca la actual. También se usa para crear nuevas ramas o borrarlas (`-d`). |
| `git checkout [rama]` | Sirve para "saltar" de una rama a otra. Cambia todos los archivos de tu carpeta para reflejar el estado de esa rama. |


### Repositorios Remotos (GitHub)
Comandos para sincronizar tu trabajo local con la nube.

| Comando | Función Principal |
| :--- | :--- |
| `git remote add origin` | Conecta tu carpeta local con una URL de un repositorio en GitHub. |
| `git push` | Sube tus commits locales al servidor remoto (publica tus cambios). |

---