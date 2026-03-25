-- Consultas Simples con SQL-LMD

SELECT *
FROM Categories;

SELECT *
FROM Products;

SELECT *
FROM Orders;

SELECT *
FROM [Order Details];

-- Proyección (seleccionar algunos campos)

SELECT *
FROM Products;

SELECT 
	ProductID, 
	ProductName, 
	UnitPrice, 
	UnitsInStock
FROM Products;

-- Alias de Columnas 
SELECT 
	ProductID AS [NUMERO DE PRODUCTO], 
	ProductName 'NOMBRE DE PRODUCTO', 
	UnitPrice AS [PRECIO UNITARIO], 
	UnitsInStock AS STOCK
FROM Products;

SELECT 
	CompanyName AS CLIENTE,
	City AS CIUDAD,
	Country AS PAIS
FROM Customers;

-- Campos calculados

-- Seleccionar los productos y calcular el valor del inventario

SELECT *, (UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

SELECT 
	ProductID, 
	ProductName, 
	UnitPrice, 
	UnitsInStock, 
	(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

-- Calcular el importe de venta

SELECT *
FROM [Order Details];

SELECT 
	OrderID,
	ProductID,
	UnitPrice, 
	Quantity, 
	(UnitPrice * Quantity) AS Subtotal
FROM [Order Details];

-- Seleccionar la venta con el calculo del importe con descuento
SELECT
	OrderID,
	UnitPrice, 
	Quantity, 
	Discount,
	(UnitPrice * Quantity) AS Importe
FROM [Order Details];

SELECT
	OrderID,
	UnitPrice, 
	Quantity, 
	Discount,
	(UnitPrice * Quantity) AS Importe,
	(UnitPrice * Quantity) - ((UnitPrice * Quantity) * Discount) AS [Importe con Descuento 1],
	(UnitPrice * Quantity) * (1 - Discount) AS [Importe con descuento 2]
FROM [Order Details];

SELECT 
    OrderID, 
    ProductID, 
    UnitPrice, 
    Quantity, 
    Discount,
    (UnitPrice * Quantity * (1 - Discount)) AS [Total Con Descuento]
FROM [Order Details];

-- Operadores Relacionales (<, >, <=, >=, =, != o <>)

/*
	Seleccionar los productos con precio mayor a 30
	Seleccionar los productos con stock menor o igual a 20
	Seleccionar los pedidos posteriores a 1997
*/

SELECT 
	ProductID AS [Número de Producto],
	ProductName AS [Nombre Producto],
	UnitPrice AS [Precio Unitario],
	UnitsInStock AS Stock
FROM Products
WHERE UnitPrice > 30
ORDER BY UnitPrice DESC;

SELECT 
	ProductID AS [Número de Producto],
	ProductName AS [Nombre Producto],
	UnitPrice AS [Precio Unitario],
	UnitsInStock AS [Stock]
FROM Products
WHERE UnitsInStock <= 20;

SELECT * 
FROM Orders;

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Dia
FROM Orders
WHERE YEAR(OrderDate) > '1997';

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Dia,
	DATEPART(YEAR, OrderDate) AS AÑO2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate),
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders;

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Dia,
	DATEPART(YEAR, OrderDate) AS AÑO2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate),
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997;

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Dia,
	DATEPART(YEAR, OrderDate) AS AÑO2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate),
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE DATEPART(YEAR,OrderDate) > 1997;

SET LANGUAGE SPANISH;
SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Dia,
	DATEPART(YEAR, OrderDate) AS AÑO2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate),
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997;

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	ShipCountry
FROM Orders
WHERE YEAR(OrderDate) > 1997;

SELECT 
	OrderID,
	OrderDate,
	ShipName
FROM Orders
WHERE OrderDate >= '1998-01-01';

-- Operadores Lógicos (NOT, AND, OR)

/*
	Seleccionar los productos que tengan un precio mayor a 20 y menos de 100 unidades en stock
*/

SELECT *
FROM Products

SELECT 
	ProductName AS [Nombre del producto], 
	UnitPrice AS [Precio unitario], 
	UnitsInStock AS Stock
FROM Products
WHERE (UnitPrice > 20) AND (UnitsInStock<100);

-- Mostrar los clientes que sean de estados unidos o de canada

SELECT *
FROM Customers;

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE Country IN ('USA', 'Canada');

-- Obtener los pedidos que no tengan region
SELECT *
FROM Orders

SELECT 
	CustomerID,
	OrderDate,
	ShipRegion
FROM Orders
WHERE ShipRegion IS NOT NULL;

-- Operador IN

/*
	Mostrar los clientes de Alemania, Francia y UK
	Obtener los productos donde la categoria sea 1, 3 o 5
*/

SELECT * 
FROM Customers
WHERE Country IN ('Germany', 'France', 'UK')
ORDER BY Country DESC;

SELECT 
	ProductName,
	CategoryID,
	QuantityPerUnit
FROM Products
WHERE CategoryID IN (1, 3, 5)
ORDER BY CategoryID

-- Operador BETWEEN

/*
	Mostrar los productos cuyo precio esta entre 20 y 40
*/

SELECT *
FROM Products
WHERE UnitPrice BETWEEN 20 AND 40
ORDER BY UnitPrice;

SELECT *
FROM Products
WHERE UnitPrice>= 20 AND UnitPrice<=40
ORDER BY UnitPrice;

-- Operador LIKE

-- Seleccuionar todos los customers que comiencen con la letra a
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE 'a%';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE 'an%';

SELECT * 
FROM Customers
WHERE city LIKE 'L_nd__';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '%as';

-- Seleccionar los clientes donde la ciudad contenga la letra L
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE City LIKE '%mé%';

--Seleccionar todos los clientes que su nombre comience con a o con b
SELECT * 
FROM Customers
WHERE NOT CompanyName LIKE 'a%' OR CompanyName LIKE 'b%';

SELECT * 
FROM Customers
WHERE NOT (CompanyName LIKE 'a%' OR CompanyName LIKE 'b%');

-- Seleccionar todos los clientes que comience con B y que termine con S
SELECT * 
FROM Customers
WHERE CompanyName LIKE 'b%s';

SELECT
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE 'a__%';

-- Seleccionar todos los clientes (Nombre) que comiencen con 'b', 's', 'p'
SELECT
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CustomerID LIKE '[bsp]%';


-- Seleccionar todos los customers que comiencen con 'a', 'b', 'c', 'd', 'e' o 'f'
SELECT
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CustomerID LIKE '[abcdef]%';

SELECT
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CustomerID LIKE '[a-f]%'
ORDER BY 2 ASC;

SELECT
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '[^bsp]%';

SELECT
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '[^a-f]%'
ORDER BY 2 ASC;

/*
	Seleccionar todos lo clientes de estados unidos o canada que inicien con b
*/

SELECT *
FROM Customers

SELECT
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE Country IN ('USA','Canada') AND CompanyName LIKE 'B%'
ORDER BY 5;

SELECT
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE Country IN ('USA','Canada') OR CompanyName LIKE 'B%'
ORDER BY 5;