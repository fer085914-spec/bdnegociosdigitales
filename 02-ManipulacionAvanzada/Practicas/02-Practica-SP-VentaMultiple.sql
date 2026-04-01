-- Como base el Stored ya hecho, 
-- Crear un Store que permita agregar N productos
-- La tabla type se envia como parametro al store
CREATE TYPE VentaMultiple AS TABLE
(
    id_produc INT NOT NULL,
    cant_vendida INT
);
GO

CREATE OR ALTER PROCEDURE usp_venta_multiple
    @id_cliente NCHAR(5),
    @venta VentaMultiple READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente = @id_cliente) 
            THROW 50001, 'El cliente no existe o no se encontró', 1;

        DECLARE @pedidos INT;
        DECLARE @existentes INT;

        SELECT @pedidos = COUNT(*) FROM @venta;
        SELECT @existentes = COUNT(*) FROM @venta v INNER JOIN CatProducto cp ON v.id_produc = cp.id_producto;

        PRINT 'Pedidos: ' + CAST(@pedidos AS VARCHAR);
        PRINT 'Existentes: ' + CAST(@existentes AS VARCHAR)

        IF (@pedidos <> @existentes)
            THROW 50002, 'Uno o más productos no existen o no fueron encontrados', 1;

        IF EXISTS (
            SELECT 1 
            FROM @venta AS v
            INNER JOIN CatProducto AS cp 
            ON v.id_produc = cp.id_producto
            WHERE v.cant_vendida > cp.existencia
        )
            THROW 50003, 'Uno o más productos no tienen stock suficiente', 1;
        
        DECLARE @id_venta INT;
        INSERT INTO tblVenta
        VALUES (GETDATE(), @id_cliente);

        SET @id_venta = SCOPE_IDENTITY();

        INSERT INTO tblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        SELECT @id_venta, v.id_produc, cp.precio, v.cant_vendida
        FROM @venta AS v
        INNER JOIN CatProducto AS cp
        ON v.id_produc = cp.id_producto;

        UPDATE cp
        SET cp.existencia = cp.existencia - v.cant_vendida
        FROM CatProducto AS cp
        INNER JOIN @venta AS v
        ON cp.id_producto = v.id_produc

        COMMIT;
        PRINT 'Venta completada y stock altualizado'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
            PRINT 'ERROR: ' + ERROR_MESSAGE();
        END
    END CATCH
END

DECLARE @Venta1 VentaMultiple;

INSERT INTO @Venta1 (id_produc, cant_vendida)
VALUES (1, 2), (408, 5), (10, 1);

EXEC usp_venta_multiple 'CACTU', @venta = @Venta1;


USE bdPracticas;

SELECT * FROM tblDetalleVenta;
SELECT * FROM tblVenta;