/*------------------------------------ Stored Procedures ------------------------------------*/

USE bdStored;
-- Ejemplo Simple

CREATE PROCEDURE usp_Mensaje_Saludar
    -- No tendra parámetros
AS
BEGIN
    PRINT 'Hola Mundo Transact SQL desde SQL SERVER';
END;
GO

-- Ejecutar
EXECUTE usp_Mensaje_Saludar;
GO

CREATE PROC usp_Mensaje_Saludar2
    -- No tendra parámetros
AS
BEGIN
    PRINT 'Hola Mundo Ing en TI';
END;
GO

-- Ejecutar
EXEC usp_Mensaje_Saludar2;
GO

CREATE OR ALTER PROC usp_Mensaje_Saludar3
    -- No tendra parámetros
AS
BEGIN
    PRINT 'Hola Mundo ENTORNOS VIRTUALES Y NEGOCIOS DIGITALES';
END;
GO

-- Ejecutar
EXEC usp_Mensaje_Saludar3;
GO

-- Eliminar un sp
DROP PROCEDURE usp_Mensaje_Saludar3;
GO


-- Crear un SP que muestre la fecha actual del sistema
CREATE OR ALTER PROC  usp_Servidor_FechaActual

AS 
BEGIN
    SELECT CAST(GETDATE() AS DATE) AS [Fecha del Sistema]
END
GO

EXEC usp_Servidor_FechaActual;

-- Crear un SP que muestre el nombre de la base de datos (db_name())
CREATE OR ALTER PROC  usp_BdNombre_Get

AS 
BEGIN
    SELECT 
        HOST_NAME() AS [MACHINE],
        SUSER_SNAME() AS [SQLUSER],
        SYSTEM_USER AS [SYSTEMUSER],
        DB_NAME() AS [DATABASE NAME],
        APP_NAME() AS [APPLICATION]
END;
GO

EXEC usp_BdNombre_Get;

/*------------------------------------ Stored Procedures Con Parametros ------------------------------------*/

CREATE OR ALTER PROC usp_Persona_Saludar
    @nombre VARCHAR(50)  -- Parametro de entrada
AS 
BEGIN  
    PRINT 'Hola ' + @nombre;
END;
GO

EXEC usp_Persona_Saludar 'Israel';
EXEC usp_Persona_Saludar 'Artemio';
EXEC usp_Persona_Saludar 'Irais';
EXEC usp_Persona_Saludar @nombre ='Bryan';

DECLARE @name VARCHAR(50)
SET @name = 'Yael';

EXEC usp_Persona_Saludar @name;

-- TO DO: Ejemplo con cosultas, crear una tabla de clientes basada en la tabla de customers de NorthWind

SELECT 
    CustomerID,
    CompanyName
INTO Customers
FROM NORTHWND.dbo.Customers;
GO

-- Crear un SP que busque un cliente en especifico
CREATE OR ALTER PROC spu_Customer_Buscar
    @id NCHAR(10)
AS
BEGIN

    SET @id = TRIM(@id);

    IF LEN(@id) <= 0 OR LEN(@id) > 5
    BEGIN
        PRINT ('EL ID DEBE ESTAR EN EL RANGO DE 1 A 5 DE TAMAÑO');
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
    BEGIN
        PRINT 'El cliente no existe en la BD';
        RETURN;
    END
    
    SELECT CustomerID AS [Número], CompanyName AS [Cliente]
    FROM Customers
    WHERE CustomerID = @id;
END;
GO

/*
CREATE OR ALTER PROC spu_Customer_Buscar
    @id NCHAR(10)
AS
BEGIN
    IF LEN(@id) <= 0 OR LEN(@id) > 5
    BEGIN
        PRINT ('EL ID DEBE ESTAR EN EL RANGO DE 1 A 5 DE TAMAÑO');
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
    BEGIN
        
        RETURN;
        SELECT CustomerID AS [Número], CompanyName AS [Cliente]
        FROM Customers
        WHERE CustomerID = @id;

    END
    ELSE
        PRINT 'El cliente no existe en la BD';
END;
GO
*/

SELECT *
FROM Customers
WHERE CustomerID = 'ANTONjdodfbon';

EXEC spu_Customer_Buscar 'ANTON';

SELECT * 
FROM NORTHWND.dbo.Categories
WHERE NOT EXISTS(
SELECT 1
FROM Customers
WHERE CustomerID = 'ANTONi');

GO

-- Ejercicios:

-- 1. Crear un SP que reciba un numero y que verifique que no sea negativo, si es negativo imprimir valor no valido, y sino multiplicarlo por 5 y mostrarlo.
-- Para mostrarlo usar un SELECT.
CREATE OR ALTER PROCEDURE usp_numero_multiplicar
    @number INT
AS
BEGIN
    IF @number < 0 -- El ejercicio pide validar que no sea negativo
    BEGIN
        PRINT 'Valor no valido'
        RETURN
    END

    SELECT (@number * 5) AS [Operacion]
END -- <--- Sin punto y coma aquí
GO

-- 2. Crear un SP que reciba un nombre y lo imprima en Mayusculas 
CREATE OR ALTER PROCEDURE ups_nombre_mayusculas
    @name VARCHAR(15)
AS 
BEGIN
    SELECT UPPER(@name) AS [NAME]
END;
GO

EXEC ups_nombre_mayusculas 'Monico';
GO

/*------------------------------------ Parametros de salida ------------------------------------*/

CREATE OR ALTER PROC usp_numeros_sumar
    @a INT,
    @b INT, 
    @resultado INT OUTPUT
AS
BEGIN
    SET @resultado = @a + @b
END;
GO

DECLARE @res INT 
EXEC usp_numeros_sumar 5, 7, @res OUTPUT;
SELECT @res AS [Resultado];
GO


CREATE OR ALTER PROC usp_numeros_sumar2
    @a INT,
    @b INT, 
    @resultado INT OUTPUT
AS
BEGIN
    SELECT @resultado = @a + @b
END;
GO

DECLARE @res INT 
EXEC usp_numeros_sumar2 5, 7, @res OUTPUT;
SELECT @res AS [Resultado];
GO

-- Crear un área de un circulo
CREATE OR ALTER PROC usp_area_circulo
    @radio DECIMAL(10,2),
    @area DECIMAL(10,2) OUTPUT
AS 
BEGIN
    -- SET @area = PI() * (@radio * @radio);
    SET @area = PI() * POWER(@radio, 2);
END;
GO

DECLARE @r DECIMAL(10,2)
EXEC usp_area_circulo 2.4, @r OUTPUT;
SELECT @R AS [AREA];
GO

-- Crear un sp que reciba un id del cliente y devuelva el nombre 

CREATE OR ALTER PROCEDURE usp_cliente_obtener
    @id NCHAR(10),
    @name NVARCHAR(40) OUTPUT
AS
BEGIN
    IF LEN(@id) = 5
    BEGIN
        IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
        BEGIN
            SELECT @name = CompanyName
            FROM Customers
            WHERE CustomerID = @id;

            RETURN;
        END
        PRINT 'El customer no existe';
        RETURN;
    END
    PRINT 'El id debe ser de tamaño 5';
END;
GO

DECLARE @name NVARCHAR(40)
EXEC usp_cliente_obtener 'AJOUT', @name OUTPUT;
SELECT @name AS [Nombre del cliente];
GO

SELECT *
FROM Customers;
GO

/*------------------------------------ CASE ------------------------------------*/

CREATE OR ALTER PROC usp_evaluar_calificacion
    @calif INT
AS
BEGIN
    SELECT
     CASE
      WHEN @calif >= 90 THEN 'Excelente'
      WHEN @calif >= 70 THEN 'Aprobado'
      WHEN @calif >= 60 THEN 'Regular'
      ELSE 'No acredito'
     END AS [Resultado]
END
GO

EXEC usp_evaluar_calificacion 100;
EXEC usp_evaluar_calificacion 75;
EXEC usp_evaluar_calificacion 62;
EXEC usp_evaluar_calificacion 40;
GO

-- Case dentro de un select con caso real 
Use NORTHWND;

CREATE TABLE bdStored.dbo.Productos
(
    nombre VARCHAR(50),
    precio MONEY
);
GO

-- Inserta los datos basados en la consulta (SELECT)
INSERT INTO bdStored.dbo.Productos
SELECT 
    ProductName,
    UnitPrice
FROM NORTHWND.dbo.Products;
GO

SELECT *
FROM bdStored.dbo.Productos;
GO

-- Ejercicio con CASE 
SELECT 
    nombre, 
    precio,
    CASE 
        WHEN precio >= 200 THEN 'Caro'
        WHEN precio >= 100 THEN 'Medio'
        ELSE 'Barato'
    END AS [Categoria]
FROM bdStored.dbo.Productos;
GO

-- Selecciona los clientes con su nombre, pais, ciudad y region (los valores nulos visualizalos con la leyenda SIN REGION),
-- ademas quiero que todo el resultado este en mayusculas
SELECT 
    UPPER(c.CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) AS [City],
    UPPER(ISNULL(c.Region, 'Sin region')) AS [RegionLimpia],
    LTRIM(UPPER(CONCAT(e.FirstName, ' ', e.LastName))) AS [FullName],
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
    CASE
     WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND SUM(od.Quantity * od.UnitPrice) <= 60000 THEN 'GOLD'
     WHEN SUM(od.Quantity * od.UnitPrice) >= 10000 AND SUM(od.Quantity * od.UnitPrice) < 30000 THEN 'SILVER'
     ELSE 'BRONCE'
    END AS [Medallon]
FROM NORTHWND.dbo.Customers AS c
INNER JOIN NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
GROUP BY c.CompanyName, c.Country, c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName)
ORDER BY [FullName] ASC, [Total] DESC;
GO


SELECT 
    UPPER(c.CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) AS [City],
    UPPER(ISNULL(c.Region, 'Sin region')) AS [RegionLimpia],
    LTRIM(UPPER(CONCAT(e.FirstName, ' ', e.LastName))) AS [FullName],
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
    CASE
     WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND SUM(od.Quantity * od.UnitPrice) <= 60000 THEN 'GOLD'
     WHEN SUM(od.Quantity * od.UnitPrice) >= 10000 AND SUM(od.Quantity * od.UnitPrice) < 30000 THEN 'SILVER'
     ELSE 'BRONCE'
    END AS [Medallon]
FROM NORTHWND.dbo.Customers AS c
INNER JOIN NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE UPPER(CONCAT(e.FirstName, ' ', e.LastName)) = UPPER('ANDREW FULLER') AND UPPER(ISNULL(c.Region, 'Sin region')) = UPPER('Sin region')
GROUP BY c.CompanyName, c.Country, c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName)
ORDER BY [FullName] ASC, [Total] DESC;
GO

CREATE OR ALTER VIEW  vw_Vista_Buena
AS
SELECT 
    UPPER(c.CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) AS [City],
    UPPER(ISNULL(c.Region, 'Sin region')) AS [RegionLimpia],
    LTRIM(UPPER(CONCAT(e.FirstName, ' ', e.LastName))) AS [FullName],
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
    CASE
     WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND SUM(od.Quantity * od.UnitPrice) <= 60000 THEN 'GOLD'
     WHEN SUM(od.Quantity * od.UnitPrice) >= 10000 AND SUM(od.Quantity * od.UnitPrice) < 30000 THEN 'SILVER'
     ELSE 'BRONCE'
    END AS [Medallon]
FROM NORTHWND.dbo.Customers AS c
INNER JOIN NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
GROUP BY c.CompanyName, c.Country, c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName);
GO

CREATE OR ALTER PROCEDURE usp_informe_cliente_empleados
    @nombre VARCHAR(50),
    @region VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM vw_Vista_Buena
    WHERE FullName = @nombre
    AND RegionLimpia = @region;
END;
GO

EXEC usp_informe_cliente_empleados 'ANDREW FULLER', 'SIN REGION';


/*------------------------------------ Manejo de errores con TRY ... CATCH ------------------------------------*/

-- SIN TRY - CATCH
SELECT 10/0;

-- CON TRY .. CATCH

BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'Ocurrio un error';
END CATCH;
GO

-- Ejemplo de uso de funciones para obtener informacion del error
BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'Mensaje: ' + ERROR_MESSAGE();
    PRINT 'Numero de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Linea de error: ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT 'Estado del error: ' + CAST(ERROR_STATE() AS VARCHAR);
END CATCH;
GO

CREATE TABLE clientes(
    id INT PRIMARY KEY,
    nombre VARCHAR(35)
);
GO

INSERT INTO clientes
VALUES(
1, 'Panfilo');
GO

BEGIN TRY
    INSERT INTO clientes
    VALUES(1, 'Eustacio');
END TRY
BEGIN CATCH
    PRINT 'ERROR AL INSERTAR: ' + ERROR_MESSAGE();
    PRINT 'ERRROR EN LA LINEA: ' + CAST(ERROR_LINE() AS VARCHAR);
END CATCH;
GO

BEGIN TRANSACTION;

INSERT INTO clientes
VALUES(2, 'Americo Angel');

COMMIT;
ROLLBACK;
GO

-- Ejemplo de uso de transacciones junto con el TRY ... CATCH

BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO clientes 
    VALUES(3, 'Valderabano');
    INSERT INTO clientes 
    VALUES(4, 'Roles Alina');
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 1
    BEGIN
        ROLLBACK;
    END
    PRINT 'Se hizo ROLLBACK por error';
    PRINT 'ERROR: ' + ERROR_MESSAGE();
END CATCH
GO

SELECT *
FROM clientes;
GO

UPDATE clientes 
SET nombre = 'Americo Azul'
WHERE id = 10;

IF @@ROWCOUNT < 1
BEGIN
    PRINT @@ROWCOUNT
    PRINT 'No existe el cliente'
END
ELSE
    PRINT 'Cliente actualizado';
GO

-- Crear un SP que inserte un cliente, con las validaciones necesarias.

CREATE OR ALTER PROC usp_insertar_cliente
    @id INT,
    @nombre VARCHAR(35)
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        INSERT INTO clientes 
        VALUES(@id, @nombre);

        COMMIT;
        PRINT 'Cliente insertado';

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 1
        BEGIN
            ROLLBACK;
        END
        PRINT 'ERROR:' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC usp_insertar_cliente 5, 'jen';


CREATE TABLE teams
(
    id INT NOT NULL IDENTITY PRIMARY KEY,
    nombre NVARCHAR(15)
);

INSERT INTO teams(nombre)
VALUES('Cruz Azul');

-- Forma de obtener un IDENTITY insertado FORMA 1
DECLARE @id_insertado INT 
SET @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO: ' + CAST(@id_insertado AS VARCHAR);
SELECT @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO FORMA 2: ' + CAST(@id_insertado AS VARCHAR);

INSERT INTO teams(nombre)
VALUES('America');

-- Forma de obtener un IDENTITY insertado FORMA 2
DECLARE @id_insertado2 INT 
SET @id_insertado2 = SCOPE_IDENTITY();
PRINT 'ID INSERTADO: ' + CAST(@id_insertado2 AS VARCHAR);
SELECT @id_insertado2 = SCOPE_IDENTITY();
PRINT 'ID INSERTADO FORMA 2: ' + CAST(@id_insertado2 AS VARCHAR);

SELECT *
FROM teams;