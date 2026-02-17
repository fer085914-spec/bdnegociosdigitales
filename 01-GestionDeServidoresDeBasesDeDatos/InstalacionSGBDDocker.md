# Procedimiento de instalación de Docker en Windows

## Instalar en subsistema de linux

Antes de iniciar con la instalación de GIT en nuestro equipo primero tenemos que buscar **Activar o desactivar caracteristicas de Windows**.

![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-26%20114459.png "This is a sample image.")

Una vez dentro de la ventana que nos abre debemos buscar la casilla que tiene ***Subsistema de Windows para linux***. Si la casilla ya esta activada no tenemos que hacer nada, pero si recien la activamos tenemos que reiniciar nuestro equipo.

![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-26%20114515.png "This is a sample image.")

``` shell
NOTA: Esto es por que Docker es nativo de linux y para usarlo en Windows necesitamos intalar Ubuntu para que Docker se instale encima de él.
```

## Instalación

Para Windows, utilizaremos **Docker Desktop**.

   1. Descargar el instalador para Windows.
   2. Hacer doble clic en el archivo `.exe` descargado.
   3. Seguir las instrucciones en pantalla hasta finalizar.
   4. Es probable que una vez instalado requiera volver a reiniciar el equipo, sino es necesario omitir.
   5. Al iniciar Docker Desktop, debemos aceptar los términos de servicio.
![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-26%20120250.png "This is a sample image.")

   6. Posteriormete solo damos Skip y ya estamos dentro de Docker.

   ![This is an alt text.](/img/Captura%20de%20pantalla%202026-01-26%20120506.png "This is a sample image.")

# Contenedor de SQLServer sin volumen 

``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```
