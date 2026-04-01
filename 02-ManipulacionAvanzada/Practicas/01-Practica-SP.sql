CREATE DATABASE bdPracticas;

USE bdPracticas;

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

SELECT *
FROM CatProducto;


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

SELECT *
FROM CatCliente;

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
GO


CREATE OR ALTER PROCEDURE usp_agregar_venta

    @id_cliente NCHAR(5),
    @id_producto INT,
    @cantidad_vendida INT

AS 
BEGIN

    BEGIN TRY

        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente = @id_cliente)
        BEGIN
            
            ; THROW 50001, 'El cliente no se encontró', 1;

        END

        IF NOT EXISTS (SELECT 1 FROM CatProducto WHERE id_producto = @id_producto)
        BEGIN
            
            ; THROW 50002, 'El producto no se encontró o no esta disponible', 1;

        END

        DECLARE @existencia INT ;
        DECLARE @precio MONEY;
        SELECT @existencia = existencia, @precio = precio
        FROM CatProducto
        WHERE id_producto = @id_producto;

        IF @existencia < @cantidad_vendida
        BEGIN
            
            ; THROW 50003, 'No hay suficiente stock', 1;

        END

        DECLARE @id_venta INT
        INSERT INTO tblVenta
        VALUES (GETDATE(), @id_cliente);

        SET @id_venta = SCOPE_IDENTITY();
        INSERT INTO tblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        VALUES(@id_venta, @id_producto, @precio, @cantidad_vendida);

        UPDATE CatProducto
        SET existencia = existencia - @cantidad_vendida
        WHERE id_producto = @id_producto;

        PRINT 'Venta completada y stock actualizado';
        COMMIT;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0 
        ROLLBACK;

        PRINT 'ERROR: ' + ERROR_MESSAGE();
        
    END CATCH

END
GO

EXEC usp_agregar_venta 'BOLID', 70, 1;

SELECT * FROM tblVenta;
SELECT * FROM tblDetalleVenta;
SELECT * FROM CatCliente;
SELECT * FROM CatProducto;


SELECT DB_NAME()