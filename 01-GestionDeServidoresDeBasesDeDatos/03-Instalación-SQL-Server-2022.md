# Manual de Instalación: Microsoft SQL Server 2022

Este documento detalla los pasos para instalar SQL Server 2022 en un entorno Windows, partiendo del archivo de imagen (ISO) obtenido mediante la opción "Descargar medios".

## 1. Preparación de los Archivos
Debemos preparar o tener descargado el archivo instalable de llamado **SQL2022-SSEI-Dev.exe**.

Una vez descargado damos clic derecho sobre ese archivo y presionamos la opción de ejecutar como administrador.

Para descargar la imagen **ISO** elegimos la opción de descargar medios. 
![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-21%20223751.png "This is a sample image.")

Posteriormente debemos:

1. Ubicar el archivo `.iso` de SQL Server 2022.
2. Haz clic derecho sobre el archivo y selecciona **Montar**. Esto crea una unidad de DVD virtual con los archivos de instalación
3. Dentro de la unidad virtual, busca y ejecuta el archivo `setup.exe` con permisos de administrador.


## 2. SQL Server Installation Center
1. En el panel izquierdo, hacer clic en la opción **Installation** 
2. Seleccionamos la primera opción de la lista: **New SQL Server standalone installation or add features to an existing installation**

![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-21%20224440.png "This is a sample image.")


## 3. Proceso de Instalación

1. **Edition** Developer

    ![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-21%20224514.png "This is a sample image.")

2. **License Terms** Marcamos la casilla "I accept the license terms".
3. **Microsoft Update** Dejamos la casilla desmarcada.
    ![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-21%20225029.png "This is a sample image.")
4. **Global Rules** El instalador verifica prerequisitos. Si todo está correcto, pasa automáticamente.
5. **Microsoft Azure Extension** Desmarcamso la casilla Azure Extension for SQL Server.
6. **Feature Selection** Aquí decidimos qué componentes instalar.
   * *Database Engine Services*.
   * *SQL Server Replication*
    ![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-21%20225416.png "This is a sample image.")

7. **Instance Configuration** Default instance, es el único SQL Server en la máquina.
8. **Server Configuration**
9. **Database Engine Configuration** La pestaña más crítica.
    * **Mixed Mode** (SQL Server authentication and Windows authentication).
    * Creamos una contraseña para el usuario administrador `sa`.
    * **Specify SQL Server administrators:** Hacemos clic en el botón **Add Current User**

        ![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-21%20225928.png "This is a sample image.")
10. **Resumen e Instalación**
    * Revisamos las características a instalar.
    * Clic en **Install**.


## 4. Descargar interfaz gráfica

El motor de base de datos ya está instalado, pero se necesita una interfaz gráfica para manejarlo.

1. En el mismo "Installation Center", buscamos la opción **Install SQL Server Management Tools**.

![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-21%20230950.png "This is a sample image.")

2. Esto lleva a una página para descargar e instalar **SSMS (SQL Server Management Studio)**.

![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-21%20231133.png "This is a sample image.")