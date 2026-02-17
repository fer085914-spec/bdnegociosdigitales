/*
	JOINS

	1. INNER JOIN
	2. LEFT JOIN
	3. RIGTH JOIN
	4. FULL JOIN

*/

-- SELECCIONAR LAS CATEGORIAS Y SUS PRODUCTOS
SELECT 
	c.CategoryID,
	c.CategoryName,
	p.ProductID,
	p.ProductName,
	p.UnitPrice,
	p.UnitsInStock,
	(p.UnitPrice * p.UnitsInStock) AS [Precio inventario]
FROM Categories AS c
INNER JOIN Products AS p
ON c.CategoryID = p.CategoryID
WHERE c.CategoryID = 9;

