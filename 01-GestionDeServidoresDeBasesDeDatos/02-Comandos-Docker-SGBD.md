# Documentación de Comandos de Contenedores Docker para SGBD

## Comando para contenedor de SQL Server sin Volumen
``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```

## Comando para contenedor de SQL Server con Volumen
``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -v volume-mssqlevnd:/var/opt/mssql \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```