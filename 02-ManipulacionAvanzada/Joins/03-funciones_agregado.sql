/*
	Funciones agragado:

	1. sum()
	2. max()
	3. min()
	4. avg()
	5. count(*)
	6. count (campo)

	NOTA: Estas funciones solamente regresa un solo registro
*/

-- Seleccionar los paises de donde son los clientes
SELECT DISTINCT country
FROM Customers;

-- Agregacion count(*) cuenta el numero de registros que tiene una tabla
SELECT COUNT(*) AS [Total de ordenes]
FROM Orders

-- Seleccionar el total de ordenes que fueron enviadas a Alemania
SELECT COUNT(*) AS [Total de ordenes Alemania]
FROM Orders
WHERE ShipCountry='Germany'

SELECT ShipCountry, COUNT(*) AS [Total de ordenes Alemania]
FROM Orders
GROUP BY ShipCountry

SELECT * 
FROM Orders;

SELECT *
FROM Customers;

SELECT COUNT(CustomerID)
FROM Customers;

SELECT COUNT(Region)
FROM Customers; -- COUNT con un campo, cuenta cuantos registros de ese campo pero no cuenta los nulos

-- Seleccione de cuantas ciudades son las ciudades de los clientes
SELECT City
FROM Customers
ORDER BY City ASC;

SELECT DISTINCT City
FROM Customers;

SELECT COUNT(DISTINCT City) AS [Ciudades clientes]
FROM Customers;

-- Selecciona el precio maximo de los productos
SELECT *
FROM Products
ORDER BY UnitPrice DESC;

SELECT MAX(UnitPrice) AS [Precio mas alto]
FROM Products

-- Seleccionar la fecha de compra mas actual
SELECT MAX(OrderDate) AS [Fecha mas reciente]
FROM Orders

-- Seleccionar el año de la fecha de compra mas reciente
SELECT MAX(YEAR(OrderDate)) AS [Año mas reciente]
FROM Orders

SELECT YEAR(MAX(OrderDate)) AS [Año mas reciente]
FROM Orders

SELECT MAX(DATEPART(YEAR, OrderDate)) AS [Año mas reciente]
FROM Orders;

SELECT DATEPART(YEAR, MAX(OrderDate)) AS [Año mas reciente]
FROM Orders;

-- Cual es la minima cantidad de los pedidos
SELECT *
FROM [Order Details];

SELECT MIN(Quantity)
FROM [Order Details];

-- Cual es el importe mas bajo de las compras

SELECT (UnitPrice * Quantity) * (1 - Discount) AS Importe
FROM [Order Details]
ORDER BY Importe ASC;

SELECT (UnitPrice * Quantity) * (1 - Discount) AS Importe
FROM [Order Details]
ORDER BY (UnitPrice * Quantity) * (1 - Discount) ASC;

SELECT MIN((UnitPrice * Quantity) * (1 - Discount)) AS [Importe mas bajo]
FROM [Order Details];

-- El total de los precios de los productos
SELECT *
FROM Products;

SELECT SUM(UnitPrice)
FROM Products

-- Obtener el total de dinero percibido por las ventas
SELECT *
FROM [Order Details];

SELECT SUM((UnitPrice * Quantity) * (1 - Discount)) AS [Total de ventas]
FROM [Order Details]

-- Seleccionar las ventas totales de los productos 4, 10, 20
SELECT ProductID, SUM(Quantity) AS [Ventas de productos]
FROM [Order Details]
WHERE ProductID IN(4,10,20)
GROUP BY ProductID

--Seleccionar el numero de ordenes hechas por los siguientes clientes
/*
	Around the Horn
	Bolido Comidas preparadas
	Chop-sueyChinese
*/
SELECT *
FROM Orders
ORDER BY OrderDate ASC

SELECT ShipName, SUM(OrderID) AS [Ordenes por cliente]
FROM Orders
WHERE ShipName IN('Around the Horn','Bólido Comidas preparadas','Chop-suey Chinese')
GROUP BY ShipName

-- Seleccionar el total de ordenes del segundo trimestre de 1996
SELECT COUNT(*) AS [Total Ordenes]
FROM Orders
WHERE DATEPART (YEAR, OrderDate) = 1996 AND DATEPART(QUARTER, OrderDate) = 2;

-- Seleccionar el numero de ordenes entre 1996 a 1997
SELECT COUNT(*) AS [Total de ordenes]
FROM Orders
WHERE DATEPART(YEAR, OrderDate) BETWEEN 1996 AND 1997

-- Seleccionar el numero de clientes que comienzan con  a o que comienzan con b
SELECT *
FROM Customers
ORDER BY CompanyName ASC

SELECT COUNT(*) AS [Total de clientes con A o B]
FROM Customers
WHERE CompanyName LIKE('A%') OR CompanyName LIKE('B%')

SELECT COUNT(*) AS [Total de clientes con A o B]
FROM Customers
WHERE CompanyName LIKE('[a-B]%')

SELECT COUNT(*) AS [Número de clientes]
FROM Customers
WHERE CompanyName LIKE 'B%S'

-- Seleccionar el numero de ordenes realizadas por el cliente Chop-suey Chinese en 1996
SELECT *
FROM Customers
WHERE CompanyName = 'Chop-suey Chinese'

SELECT COUNT(*) AS [Ordenes por el cliente], SUM(OrderID) AS [Numero de ordenes]
FROM Orders
WHERE CustomerID = 'CHOPS' AND YEAR(OrderDate) = 1996
GROUP BY CustomerID

SELECT CustomerID, COUNT(*) AS [Ordenes por el cliente]
FROM Orders
WHERE CustomerID = 'CHOPS' AND YEAR(OrderDate) = 1996
GROUP BY CustomerID

/*
	GROUP BY Y HAVING
*/

SELECT *
FROM Orders

SELECT CustomerID, COUNT(*) AS [Ordenes por cliente]
FROM Orders
GROUP BY CustomerID
ORDER BY 2 DESC;

SELECT Customers.CompanyName, COUNT(*) AS [Ordenes por cliente]
FROM Orders
INNER JOIN 
Customers
ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.CompanyName
ORDER BY 2 DESC;


SELECT c.CompanyName, COUNT(*) AS [Ordenes por cliente]
FROM Orders AS o
INNER JOIN 
Customers AS c
ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY 2 DESC;

-- Seleccionar el numero de productos (conteo) por categoria, mostrar categoriaID, el totaldeproductos, ordenarlos de mayor a menor por el total de productos
SELECT *
FROM Products

SELECT * 
FROM Categories

SELECT 
	CategoryID, 
	COUNT(*) AS [Total de productos]
FROM Products
GROUP BY CategoryID
ORDER BY 2 DESC;

SELECT 
	CategoryID, 
	COUNT(*) AS [Total de productos]
FROM Products
GROUP BY CategoryID
ORDER BY COUNT(*) DESC;

SELECT 
	CategoryID, 
	COUNT(*) AS [Total de productos]
FROM Products
GROUP BY CategoryID
ORDER BY [Total de productos] DESC;


-- Seleccionar el precio promedio por proveedor de los productos redondear a dos decimales el resultado y ordenar de forma descendente por el precio promedio
SELECT *
FROM Products

SELECT 
	SupplierID, 
	ROUND(AVG(UnitPrice), 2) AS [Precio promedio]
FROM Products
GROUP BY SupplierID
ORDER BY 2 DESC

-- Seleccionar el numero de clientes por pais y ordenarlos por pais alfabeticamente
SELECT *
FROM Customers

SELECT 
	City, 
	COUNT(*) AS [Clientes por pais]
FROM Customers
GROUP BY City
ORDER BY 1;

-- Obtener la cantidad total vendida por producto y por pedido
SELECT * 
FROM [Order Details];

SELECT *, (UnitPrice * Quantity) AS [Total]
FROM [Order Details]

SELECT SUM(UnitPrice * Quantity) AS [Total]
FROM [Order Details]

SELECT ProductID, SUM(UnitPrice * Quantity) AS [Total]
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID;

SELECT ProductID, OrderID, SUM(UnitPrice * Quantity) AS [Total]
FROM [Order Details]
GROUP BY ProductID, OrderID
ORDER BY ProductID, [Total] DESC;

SELECT *, (UnitPrice * Quantity) AS [Total]
FROM [Order Details]
WHERE OrderID = 10847
AND ProductID = 1;

-- Seleccionar la cantidad maxima vendida por producto en cada pedido
SELECT *
FROM [Order Details];

SELECT ProductID, OrderID, MAX(Quantity) AS [Cantidad maxima por pedido]
FROM [Order Details]
GROUP BY ProductID, OrderID
ORDER BY ProductID, OrderID;

-- HAVING (filtro de grupos)

-- Seleccionar los clientes que hayan realizado mas de 10 pedidos
SELECT CustomerID, COUNT(*) AS [Numero de ordenes]
FROM Orders
GROUP BY CustomerID
ORDER BY 2 DESC;

SELECT CustomerID, COUNT(*) AS [Numero de ordenes]
FROM Orders
WHERE ShipCountry IN ('Germany', 'France', 'Brazil')
GROUP BY CustomerID
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

SELECT CustomerID, ShipCountry, COUNT(*) AS [Numero de ordenes]
FROM Orders
WHERE ShipCountry IN ('Germany', 'France', 'Brazil')
GROUP BY CustomerID, ShipCountry
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

SELECT c.CompanyName, COUNT(*) AS [Numero de ordenes]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
GROUP BY CompanyName
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

-- Seleccionar los empleados que hayan gestionado pedidos por un total superior a 100,000 en ventas (mostrar el id del empleado y el nombre, y el total de compras)
SELECT * 
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID;

SELECT 
	e.EmployeeID AS [ID de empleado],
	e.FirstName,
	e.LastName, 
	(od.Quantity * od.UnitPrice * ( 1 - od.Discount)) AS [Importe]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
ORDER BY e.FirstName;

SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) AS [Nombre completo], 
	ROUND(SUM(od.Quantity * od.UnitPrice * ( 1 - od.Discount)),2) AS [Importe]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
GROUP BY e.FirstName, e.LastName
HAVING SUM(od.Quantity * od.UnitPrice * ( 1 - od.Discount)) > 100000
ORDER BY Importe DESC;

-- Seleccionar el numero de productos vendidos de mas de 20 pedidos distintos, mostrar el id del producto, el nombre del producto, el numero de ordenes
SELECT p.ProductID, p.ProductName, COUNT(DISTINCT o.OrderID) AS [Numero de pedidos]
FROM Products AS p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID
INNER JOIN Orders AS o
ON od.OrderID = o.OrderID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(DISTINCT o.OrderID) > 20 
ORDER BY 3;

-- Seleccionar los productos no descontinuados, calcular el precio promedio vendido y mostrar solo aquellos que se hayan vendido  en menos de 15 pedidos
SELECT p.ProductName, ROUND(AVG(od.UnitPrice),2) AS [Precio promedio vendido]
FROM Products AS p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID
WHERE p.Discontinued = 0
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(od.OrderID) < 15
ORDER BY 2 DESC;

-- Seleccionar el precio maximo de productos por categoria pero solo si la suma de unidades es menor a 200 y ademas que no esten descontinuados
SELECT c.CategoryID, c.CategoryName, p.ProductName, MAX(p.UnitPrice) AS [Precio maximo por categoria]
FROM Products as p
INNER JOIN Categories AS c
ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0
GROUP BY c.CategoryID, c.CategoryName, p.ProductName
HAVING SUM(p.UnitsInStock) < 200
ORDER BY CategoryName, p.ProductName DESC;


-- En un SELECT NO pueden ir campos normales y campos agregados juntos SIN el GROUP BY
-- AVG es para sacar el promedio

/*
FLUJO LOGICO DE EJECUCION EN SQL
	1. FROM
	2. JOIN
	3. WHERE
	4. GROUP BY
	5. HAVING
	6. SELECT
	7. DISTINCT
	8. ORDER BY
*/