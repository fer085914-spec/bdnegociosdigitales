-- Subconsulta escalar (un valor)

-- Escalar en SELECT 
SELECT 
	o.OrderID, 
	(od.Quantity * od.UnitPrice) AS TOTAL,
	(SELECT AVG(od.Quantity * od.UnitPrice) FROM [Order Details] AS od) AS [AVGTOTAL]
FROM Orders AS o
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID;

-- Mostrar el nombre del producto y el precio promedio de todos los productos
SELECT
	ProductName,
	(SELECT AVG(UnitPrice) FROM Products) AS [Precio promedio]
FROM Products;

SELECT *
FROM Products;

-- Mostrar cada empleado y la cantidad total de pedidos que tiene 
SELECT 
    CONCAT(e.FirstName, ' ', e.LastName) AS [Nombre completo],
    (SELECT COUNT(o.OrderID) FROM Orders AS o 
     WHERE e.EmployeeID = o.EmployeeID) AS [Total de pedidos]
FROM Employees AS e
ORDER BY 2 DESC;

SELECT *
FROM Employees;


--EJEMPLO DEL PROFEE
SELECT e.EmployeeID, e.FirstName, e.LastName,
(
	SELECT COUNT(*)
	FROM Orders
) AS [NUMERO DE PEDIDOS]
FROM Employees AS e;

SELECT e.EmployeeID, e.FirstName, e.LastName,
(
	SELECT COUNT(*)
	FROM Orders AS o
	WHERE e.EmployeeID = o.EmployeeID
) AS [NUMERO DE PEDIDOS]
FROM Employees AS e;

SELECT e.EmployeeID, e.FirstName, e.LastName, COUNT(o.OrderID) AS [NUMERO DE ORDENES]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

SELECT *
FROM Employees;


-- Mostrar cada cliente y la fecha de su ultimo pedido
SELECT * FROM Customers;

SELECT CompanyName,
	(SELECT MAX(OrderDate) FROM Orders AS o
	WHERE o.CustomerID = c.CustomerID) AS [Ultima fecha]
FROM Customers AS c;

-- Consulta ESCALAR:

SELECT 
FROM [Order Details]


-- DATOS DE EJEMPLO
CREATE DATABASE bdSubconsultas;
GO

USE bdSubconsultas;
GO


CREATE TABLE Clientes(
	id_cliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(50) NOT NULL,
	ciudad NCHAR(20) NOT NULL
);


CREATE TABLE Pedidos(
	id_pedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,
	total MONEY NOT NULL,
	fecha DATE NOT NULL,
	CONSTRAINT fk_pedidos_clientes
	FOREIGN KEY (id_cliente)
	references Clientes(id_cliente)
);

INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

-- Seleccionar los pedidoos en donde el total sea igual 
-- al total maximo de ellos

SELECT MAX(total)
FROM Pedidos;

SELECT *
FROM Pedidos 
WHERE total = (
	SELECT MAX(total)
	FROM Pedidos
);


-- Sin subconsultas
SELECT TOP 1 p.id_pedido, c.nombre, p.fecha, p.total
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
ORDER BY p.total DESC;

-- Con
SELECT p.id_pedido, c.nombre, p.fecha, p.total
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.total = (
	SELECT MAX(total)
	FROM Pedidos
);

-- Seleccionar los pedidos mayores al promedio
SELECT AVG(total)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE total > (
	SELECT AVG(total)
	FROM Pedidos
);

-- Seleccionar todos los pedidos del cliente que tenga el menos id
SELECT MIN(id_cliente)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE id_cliente = (
	SELECT MIN(id_cliente)
	FROM Pedidos
);

SELECT id_cliente, COUNT(*) AS [Numero de pedidos]
FROM Pedidos
WHERE id_cliente = (
	SELECT MIN(id_cliente)
	FROM Pedidos
)
GROUP BY id_cliente;

-- Mostrar los datos del pedido de la ultima orden
SELECT MAX(fecha)
FROM Pedidos;

SELECT p.id_pedido, c.nombre, p.fecha, p.total
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.fecha =(
	SELECT MAX(fecha)
	FROM Pedidos
);


-- Mostrar todos los pedidos con un total que sea el mas bajo
SELECT MIN(total)
FROM Pedidos

SELECT *
FROM Pedidos
WHERE total = (
	SELECT MIN(total)
	FROM Pedidos
);


-- Seleccionar los pedidos con el nombre del cliente cuyo total
-- (freight) sea mayor al promedio general de freight

USE NORTHWND

SELECT AVG(Freight)
FROM Orders

SELECT o.OrderID, c.CompanyName, o.Freight
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
WHERE o.Freight > (
	SELECT AVG(Freight)
	FROM Orders
);

SELECT o.OrderID, c.CompanyName, CONCAT(e.FirstName, ' ', e.LastName), o.Freight
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE o.Freight > (
	SELECT AVG(Freight)
	FROM Orders
);

-- SUBQUERYS CON IN, ANY, OR (llevan una sola columna)

-- La clausula IN 

-- Clientes que han hecho pedidos
USE bdSubconsultas;

SELECT id_cliente
FROM Pedidos;

SELECT *
FROM Clientes
WHERE id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
);

SELECT DISTINCT c.id_cliente, c.nombre, c.ciudad
FROM Clientes AS c
INNER JOIN Pedidos AS p
ON c.id_cliente = p.id_cliente;

-- Clientes que han hecho pedidos mayores a 800
-- Subconsulta
SELECT DISTINCT id_cliente
FROM Pedidos
WHERE total > 800;


--Consulta principal
SELECT *
FROM Pedidos
WHERE id_cliente IN(
	SELECT id_cliente
	FROM Pedidos
	WHERE total > 800);

-- Seleccionar todos los clientes de la ciudad de mexico que han hecho pedidos
SELECT id_cliente
FROM Pedidos;

SELECT *
FROM Clientes
WHERE ciudad = 'CDMX' AND id_cliente IN(
	SELECT id_cliente
	FROM Pedidos
);

-- Seleccionar clientes que no han hecho pedidos
SELECT *
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.id_cliente = c.id_cliente;

SELECT C.id_cliente, C.nombre, C.ciudad
FROM Pedidos AS p
RIGHT JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente IS NULL;

SELECT *
FROM Clientes
WHERE id_cliente NOT IN(
	SELECT id_cliente
	FROM Pedidos
);

-- Seleccione los pedidos de clientes de Monterrey
SELECT id_cliente
FROM Clientes
WHERE ciudad = 'Monterrey'

SELECT *
FROM Pedidos
WHERE id_cliente IN(
	SELECT id_cliente
	FROM Clientes
	WHERE ciudad = 'Monterrey'
);

-- CLAUSULA ANY 

-- Seleccionar pedidos mayores que algun pedido de Luis(id_cliente = 2)

-- Subconsullta
SELECT total
FROM Pedidos
WHERE id_cliente = 2;

-- Consulta principal
SELECT *
FROM Pedidos
WHERE total > ANY (
	SELECT total
	FROM Pedidos
	WHERE id_cliente = 2
);

-- Seleccionar los pedidos mayores (total) de algun pedido de Ana
SELECT *
FROM Pedidos
WHERE total > ANY(
	SELECT total
	FROM Pedidos
	WHERE id_cliente = 1
);

-- Seleccionar los pedidos mayores que algun pedido superior a 500
SELECT *
FROM Pedidos
WHERE total > ANY(
	SELECT total
	FROM Pedidos
	WHERE total > 500
);


-- CLAUSULA ALL

-- Seleccionar los pedidos donde el total sea mayor a todos los totales de los pedidos de Luis
SELECT total
FROM Pedidos
WHERE id_cliente = 2;

SELECT total
FROM Pedidos

SELECT *
FROM Pedidos
WHERE total > ALL(
	SELECT total
	FROM Pedidos
	WHERE id_cliente = 2
);

-- Seleccionar todos los clientes donde su id sea menor que todos los clientes de la ciudad de mexico
SELECT id_cliente
FROM Clientes
WHERE ciudad = 'CDMX';

SELECT *
FROM Clientes
WHERE id_cliente < ALL(
	SELECT id_cliente
	FROM Clientes
	WHERE ciudad = 'CDMX'
);

--CONSULTAS CORRELACIONADAS

-- Seleccionar los clientes cuyo total de compras sea mayor a 1000
SELECT SUM(total)
FROM Pedidos AS p;

SELECT *
FROM Clientes AS c
WHERE (
	SELECT SUM(total)
	FROM Pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1000 ;

SELECT SUM(total)
FROM Pedidos AS p
WHERE p.id_cliente = 4

-- Seleccionar todos los clientes que han hecho mas de un pedido
SELECT COUNT(*)
FROM Pedidos AS p
WHERE p.id_cliente = 1;

SELECT *
FROM Clientes AS c
WHERE (
	SELECT COUNT(*)
	FROM Pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1;

-- Seleccionar todos los pedidos en donde su total debe ser mayor al promedio de los totales hechos por los clientes
-- Seleccionar el total de pedidos que son mayores al promedio de su cliente
SELECT AVG(total)
FROM Pedidos 
WHERE id_cliente = 3

SELECT *
FROM Pedidos AS p
WHERE total > (
	SELECT AVG(total)
	FROM Pedidos AS pe
	WHERE pe.id_cliente = p.id_cliente
);

-- Seleccionar todos los clientes cuyo pedido maximo sea mayor a 1200
SELECT MAX(total)
FROM Pedidos AS p
WHERE p.id_cliente = 3

SELECT * 
FROM Clientes AS c
WHERE (
	SELECT MAX(total)
	FROM Pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1200;



SELECT * FROM Clientes;
SELECT * FROM Pedidos;