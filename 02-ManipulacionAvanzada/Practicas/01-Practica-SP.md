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

```sql
    CREATE TABLE CatProducto (
        id_producto INT NOT NULL,
        nombre_producto NVARCHAR(40) NOT NULL,
        existencia INT,
        precio MONEY
        CONSTRAINT pk_CatProducto
        PRIMARY KEY (id_producto)
    );

    INSERT INTO CatProducto
        (id_producto,
        nombre_producto,
        existencia,
        precio)
    SELECT
        ProductID,
        ProductName,
        UnitsInStock,
        UnitPrice
    FROM NORTHWND.dbo.Products;
```

* **CatCliente:** Catálogo de clientes (Migrado de Northwind).

```sql
    CREATE TABLE CatCliente (
        id_cliente NCHAR(5) NOT NULL,
        nombre_cliente NVARCHAR(40) NOT NULL,
        pais NVARCHAR(15),
        ciudad NVARCHAR(15)
        CONSTRAINT pk_CatCliente
        PRIMARY KEY (id_cliente)
    );

    INSERT INTO CatCliente 
        (id_cliente,
        nombre_cliente,
        pais,
        ciudad)
    SELECT
        CustomerID,
        CompanyName,
        Country,
        City
    FROM NORTHWND.dbo.Customers;
```

* **tblVenta:** Registro de ventas.

```sql
    CREATE TABLE tblVenta
    (
        id_venta INT IDENTITY NOT NULL,
        fecha DATE,
        id_cliente NCHAR(5) NOT NULL
        CONSTRAINT pk_tblVenta
        PRIMARY KEY (id_venta)
        CONSTRAINT fk_tblVenta_CatCliente
        FOREIGN KEY (id_cliente)
        REFERENCES CatCliente (id_cliente)
    );
```

* **tblDetalleVenta:** Registro de los artículos por cada venta (Llave primaria compuesta).

```sql
    CREATE TABLE tblDetalleVenta
    (
        id_venta INT NOT NULL,
        id_producto INT NOT NULL,
        precio_venta MONEY,
        cantidad_vendida INT
        CONSTRAINT fk_tblDetalleVenta_tblVenta
        FOREIGN KEY (id_venta)
        REFERENCES tblVenta(id_venta),
        CONSTRAINT fk_tblDetalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES CatProducto (id_producto)
    );
```

## 2. Llenado de Datos en Tablas
Se realizó la carga inicial de datos desde la base de datos `NORTHWND` para llenar los catálogos maestros.

| Tabla Destino | Fuente de Datos (Northwind) | Acción |
| :--- | :--- | :--- |
| `CatProducto` | `dbo.Products` | Inserción de ID, Nombre, Stock y Precio. |
| `CatCliente` | `dbo.Customers` | Inserción de ID, Nombre, País y Ciudad. |

```sql
    INSERT INTO CatProducto
        (id_producto,
        nombre_producto,
        existencia,
        precio)
    SELECT
        ProductID,
        ProductName,
        UnitsInStock,
        UnitPrice
    FROM NORTHWND.dbo.Products;

    ---------------------------------------------------------------------------------

    INSERT INTO CatCliente 
        (id_cliente,
        nombre_cliente,
        pais,
        ciudad)
    SELECT
        CustomerID,
        CompanyName,
        Country,
        City
    FROM NORTHWND.dbo.Customers;
```

Para finalmente obtener el siguiente Diagrama

![Diagrama de base de datos](/img/Diagrama.png)

## 3. Store Procedure
El procedimiento `usp_agregar_venta` vigila el ciclo de vida de una venta asegurando que no existan inconsistencias en el inventario.

### Lógica:
1.  **Validaciones Previas:** Comprueba la existencia del cliente y del producto antes de proceder.
2.  **Control de Stock:** Verifica que la cantidad solicitada no supere la existencia actual.
3.  **Transaccionalidad (ACID):** Utiliza `BEGIN TRANSACTION` para asegurar que, si falla un insert o el update, no se guarde información.

4.  **Para automatizar el proceso:** 
    * Se usa `GETDATE()` para la fecha de venta.
    * Se usa `SCOPE_IDENTITY()` para vincular el id con la venta recién creada.
    * Actualiza automáticamente el stock del producto.

### Código del Stored Procedure

#### 1. Definición y Parámetros
Se definen los datos de entrada necesarios para procesar la transacción: el identificador del cliente, del producto y la cantidad a comprar.

```sql
CREATE OR ALTER PROCEDURE usp_agregar_venta
    @id_cliente NCHAR(5),
    @id_producto INT,
    @cantidad_vendida INT
AS 
BEGIN
```

#### 2. Validación
Antes de realizar cualquier inserción, el procedimiento utiliza `; THROW` para abortar la ejecución si los datos son inválidos. 

```sql
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación de existencia de Cliente
        IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente = @id_cliente)
        BEGIN
            ; THROW 50001, 'El cliente no se encontró', 1;
        END

        -- Validación de existencia de Producto
        IF NOT EXISTS (SELECT 1 FROM CatProducto WHERE id_producto = @id_producto)
        BEGIN
            ; THROW 50002, 'El producto no se encontró o no esta disponible', 1;
        END
```

#### 3. Consulta de Datos y Validación de Stock
Se recuperan los valores actuales de la tabla `CatProducto` para verificar si es posible realizar la venta.

```sql
        DECLARE @existencia INT;
        DECLARE @precio MONEY;

        SELECT @existencia = existencia, @precio = precio
        FROM CatProducto
        WHERE id_producto = @id_producto;

        -- Validación de disponibilidad física
        IF @existencia < @cantidad_vendida
        BEGIN
            ; THROW 50003, 'No hay suficiente stock', 1;
        END
```

#### 4. Procesamiento de la Venta
Si todas las validaciones pasan, se procede a insertar el detalle y a descontar el inventario.

```sql
        -- Registro de la cabecera (tblVenta)
        DECLARE @id_venta INT;
        INSERT INTO tblVenta (fecha, id_cliente)
        VALUES (GETDATE(), @id_cliente);

        -- Obtención del ID generado e inserción del detalle
        SET @id_venta = SCOPE_IDENTITY();
        INSERT INTO tblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        VALUES (@id_venta, @id_producto, @precio, @cantidad_vendida);

        -- Actualización del Stock en el catálogo
        UPDATE CatProducto
        SET existencia = existencia - @cantidad_vendida
        WHERE id_producto = @id_producto;

        COMMIT; -- Confirma todos los cambios
    END TRY
```

#### 5. Errores
En caso de que cualquier bloque anterior falle (incluyendo las validaciones con `THROW`), el bloque `CATCH` revierte cualquier cambio.

```sql
    BEGIN CATCH
        -- Si hay una transacción activa, se deshace
        IF @@TRANCOUNT > 0 
            ROLLBACK;

        -- Informar sobre el error ocurrido
        PRINT 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END
GO
```


## 4. Pruebas de Uso
```sql
-- Caso exitoso
EXEC usp_agregar_venta 'ANTON', 1, 5;

-- Caso con error de stock (lanzará el error 50003)
EXEC usp_agregar_venta 'ANTON', 1, 9999;
```

> **Resultado:** Se crea un registro en `tblVenta`, un registro en `tblDetalleVenta` y el producto con `ID 1` reduce su stock en 5 unidades.
