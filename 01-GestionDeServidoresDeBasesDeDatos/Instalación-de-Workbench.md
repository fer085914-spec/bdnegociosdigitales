# Guía de Instalación de MySQL Workbench

Esta guía detalla paso a paso cómo instalar **MySQL Workbench**.

## Instalación

### 1. Descarga del Software
1. Descargar el instalador **MySQL-installer-community-8.0.44.0.msi**


### 2. Instalación en Windows
   1. **Ejecutar el instalador:** Localizar el archivo descargado y haz doble clic sobre él.
   ![This is an alt text.](/img/02.png "This is a sample image.")
   2. **Carpeta de Destino:** Por defecto se instalará en `C:\Program Files\MySQL\MySQL Workbench 8.0 CE`.
      * Se recomienda dejar la ruta por defecto.
      * Haz clic en **Next**
   3. **Asistente de Instalación:** En el apartado de Choosing A Setup Type elegimos **Custom**
   4. Para seleccionar los diferentes productos vamos a **Applications** -> **MySQL Workbench** -> **MySQL Workbench 8.0** -> **MySQL Workbench 8.0.44 -  x64**
   ![This is an alt text.](/img/04.png "This is a sample image.")
   5. Luego damos en la flecha que marca hacia la derecha y esta en verde para añadir el producto.
   6. Una vez añadido el producto dame **Ejecute**
   7. Esperamos a que se descargue y damos en Instalar.
![This is an alt text.](/img/05.png "This is a sample image.")  

## Crear una nueva conexión 

Una vez instalado **MySQL Workbench** nos aparecerá una pantalla como la siguiente:

1. Para crear una nueva conexión debemos dar clic en el signo de **+** que aparece a un lado de **MySQL Connections** 
2. Despues abrirá una nueva pestaña, aqui tendremos que configurar:
   * El nombre de nuestra conexión
   * El puerto que usará esta conexión
   * Y en dado caso el nombre del usuario
![This is an alt text.](/img/06.png "This is a sample image.")
3. Damos clic en **OK** y tenemos creada nuestra conexión lista para usarse y crear bases de datos
 ![This is an alt text.](/img/07.png "This is a sample image.")