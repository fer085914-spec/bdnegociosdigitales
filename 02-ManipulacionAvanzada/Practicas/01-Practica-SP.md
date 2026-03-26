# Documentación de Proceso: Base de Datos de Prácticas y Procedimientos Almacenados

Este documento detalla la creación de la base de datos `bdPracticas`, la migración de los registros de diferentes tablas desde la base de datos **Northwind** y la implementación del flujo de transacciones para el registro de ventas.


## 1. Configuración del Entorno y Estructura
Se ha creado una base de datos orientada a la gestión de inventarios y ventas.

### Creación de la Base de Datos
```sql
CREATE DATABASE bdPracticas;
USE bdPracticas;
```

### Definición de Tablas (Catálogos y Operativas)
Se definieron 4 tablas principales con integridad referencial:

* **CatProducto:** Catálogo de productos (Migrado de Northwind).
* **CatCliente:** Catálogo de clientes (Migrado de Northwind).
* **tblVenta:** Registro de ventas.
* **tblDetalleVenta:** Registro de los artículos por cada venta (Llave primaria compuesta).

## 2. Llenado de Datos en Tablas
Se realizó la carga inicial de datos desde la base de datos `NORTHWND` para llenar los catálogos maestros.

| Tabla Destino | Fuente de Datos (Northwind) | Acción |
| :--- | :--- | :--- |
| `CatProducto` | `dbo.Products` | Inserción de ID, Nombre, Stock y Precio. |
| `CatCliente` | `dbo.Customers` | Inserción de ID, Nombre, País y Ciudad. |

Para finalmente obtener el siguiente Diagrama

![Diagrama de base de datos](/img/Diagrama.png)

## 3. Store Procedure
El procedimiento `usp_agregar_venta` vigila el ciclo de vida de una venta asegurando que no existan inconsistencias en el inventario.

### Lógica:
1.  **Validaciones Previas:** Comprueba la existencia del cliente y del producto antes de proceder.
2.  **Control de Stock:** Verifica que la cantidad solicitada no supere la existencia actual.
3.  **Transaccionalidad (ACID):** Utiliza `BEGIN TRANSACTION` para asegurar que, si falla un insert o el update, no se guarde información parcial.

4.  **Para automatizar el proceso:** 
    * Se usa `GETDATE()` para la fecha de venta.
    * Se usa `SCOPE_IDENTITY()` para vincular el id con la venta recién creada.
    * Actualiza automáticamente el stock del producto.

### Código del Procedimiento Almacenado
```sql
CREATE OR ALTER PROCEDURE usp_agregar_venta
    @id_cliente NCHAR(5),
    @id_producto INT,
    @cantidad_vendida INT
AS 
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validar Cliente
        IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente = @id_cliente)
        BEGIN
            PRINT 'Error: El cliente no existe';
            ROLLBACK; RETURN;
        END

        -- 2. Validar Producto
        IF NOT EXISTS (SELECT 1 FROM CatProducto WHERE id_producto = @id_producto)
        BEGIN
            PRINT 'Error: El producto no existe';
            ROLLBACK; RETURN;
        END

        -- 3. Obtener datos y validar stock
        DECLARE @existencia INT, @precio MONEY;
        SELECT @existencia = existencia, @precio = precio 
        FROM CatProducto WHERE id_producto = @id_producto;

        IF @existencia < @cantidad_vendida
        BEGIN
            PRINT 'Error: Stock insuficiente';
            ROLLBACK; RETURN;
        END

        -- 4. Insertar Cabecera de Venta
        DECLARE @id_venta INT;
        INSERT INTO tblVenta (fecha, id_cliente) VALUES (GETDATE(), @id_cliente);
        SET @id_venta = SCOPE_IDENTITY();

        -- 5. Insertar Detalle
        INSERT INTO tblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        VALUES (@id_venta, @id_producto, @precio, @cantidad_vendida);

        -- 6. Actualizar Inventario
        UPDATE CatProducto
        SET existencia = existencia - @cantidad_vendida
        WHERE id_producto = @id_producto;

        COMMIT;
        PRINT 'Venta registrada con éxito';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        PRINT 'Ha ocurrido un error inesperado: ' + ERROR_MESSAGE();
    END CATCH
END;
```

---

## 4. Pruebas de Ejecución
Para validar el funcionamiento, se ejecutó el siguiente comando:

```sql
EXEC usp_agregar_venta 'ANTON', 1, 2;
```

> **Resultado:** Se crea un registro en `tblVenta`, un registro en `tblDetalleVenta` y el producto con `ID 1` reduce su stock en 2 unidades.


## Planteamineto del ejercicio e instrucciones

1. Crear un DB = BDPracticas

2. Crear el siguiente diagrama, utilizando como base los datos de NorthWind en las tablas de Catalogo. 
    (Northwind.dbo.products)
        CatProducto: id_producto(int, identity, primary key), nombre_producto, existencia, precio
    (Northwind.dbo.customer)
        CatCliente: id_cliente (nchar(5), primary key), nombre_cliente, pais, ciudad
    ()
        tblVenta: id_venta(Primary key, identity), fecha, id_cliente (foreign key)
    ()
        TblDetalleVenta: id_venta (foreign key), id_producto (foreign key), precio_venta, cantidad_vendida. Primary key compuesta por (id_venta, id_producto)

3. Crear un SP llamado usp_agregar_venta (try, catch, transactions)
    - Insertar en la tabla tblVenta, la fecha debe ser la fecha actual (GETDATE()),
      verificar si el cliente existe.
    - Inserta en la tabla tblDetalleVenta, 
        * verificar si el producto existe,
        * obtener de la tabla CatProducto el precio del producto,
        * la cantidad vendida sea suficiente en la existencia de la tabla CatProducto
    - Actualizar el stock o la existencia en la tabla CatProducto mediante la operacion de existencia - cantidadVendida

4. Documentar todo el procedimiento de la solucion en archivo .md

5. Crear un commit llamado Practica Venta con Store Procedure

6. Hacer un merge a Main

7. Hacer push a GitHub

