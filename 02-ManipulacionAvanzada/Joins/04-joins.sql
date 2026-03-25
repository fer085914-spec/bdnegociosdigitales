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

-- Crear una tabla a partir de una consulta

SELECT TOP 0 CategoryID, CategoryName
INTO categoria
FROM Categories;

ALTER TABLE Categoria
ADD CONSTRAINT pk_categoria
PRIMARY KEY (categoryID);

INSERT INTO categoria
VALUES ('C1'), ('C2'), ('C3'), ('C4'), ('C5');

SELECT TOP 0
	ProductID AS [numero_producto],
	ProductName AS [nombre_producto],
	CategoryID AS [catego_id]
INTO producto
FROM Products;

ALTER TABLE producto
ADD CONSTRAINT pk_producto
PRIMARY KEY (numero_producto);

ALTER TABLE producto
ADD CONSTRAINT fk_producto_categoria
FOREIGN KEY (catego_id)
REFERENCES categoria(categoryID)
ON DELETE CASCADE;

INSERT INTO producto
VALUES 
	('P1', 1), 
	('P2', 1), 
	('P3', 2), 
	('P4', 2), 
	('P5', 3), 
	('P6', NULL);

-- INNER JOIN
SELECT *
FROM categoria AS c
INNER JOIN producto AS p
ON c.CategoryID = p.catego_id;

-- LEFT JOIN
SELECT *
FROM categoria AS c
LEFT JOIN producto AS p
ON c.CategoryID = p.catego_id;

-- RIGHT JOIN
SELECT *
FROM categoria AS c
RIGHT JOIN producto AS p
ON c.CategoryID = p.catego_id;

-- FULL JOIN
SELECT *
FROM categoria AS c
FULL JOIN producto AS p
ON c.CategoryID = p.catego_id;

-- Simular el rIght join del query anterior con un left join
SELECT c.CategoryID, c.CategoryName, p.numero_producto, p.nombre_producto, p.catego_id
FROM categoria AS c
RIGHT JOIN producto AS p
ON c.CategoryID = p.catego_id;

SELECT c.CategoryID, c.CategoryName, p.numero_producto, p.nombre_producto, p.catego_id
FROM producto  AS P
LEFT JOIN categoria AS c
ON p.catego_id = c.CategoryID;

-- Visualizar todas las categorias que no tienen producto
SELECT *
FROM categoria AS c
LEFT JOIN producto AS p
ON c.CategoryID = p.catego_id
WHERE p.numero_producto IS NULL;

-- Seleccionar todos los productos que no tienen categoria
SELECT *
FROM categoria AS c
RIGHT JOIN producto AS p
ON c.CategoryID = p.catego_id
WHERE c.CategoryID IS NULL;

SELECT *
FROM  producto  AS P 
LEFT JOIN categoria AS c 
ON  c.CategoryID= p.catego_id
WHERE c.CategoryID IS NULL;

-- Guardar en una tabla de productos nuevos, todos aquellos productos que fueron agregados recientemente y no estan en esta tabla de apoyo

SELECT * 
FROM Categoria;

SELECT *
FROM producto;


-------------------------------------------------------------------------------

-- Crear la tabla productsNew a partir de products, mediante una consulta
SELECT 
	TOP 0
	ProductID AS [product_number],
	ProductName AS [product_name],
	UnitPrice AS unit_price,
	UnitsInStock AS stock,
	(UnitPrice * UnitsInStock) AS total
INTO products_new
FROM Products;

SELECT * FROM products_new;

ALTER TABLE products_new
ADD CONSTRAINT pk_products_new
PRIMARY KEY ([product_number]);

SELECT 
	P.ProductID,
	P.ProductName,
	P.UnitPrice,
	P.UnitsInStock,
	(P.UnitPrice * P.UnitsInStock) AS [Total],
	pw.*
FROM Products AS p
LEFT JOIN products_new AS pw
ON p.ProductID = pw.product_number;

SELECT 
	P.ProductID,
	P.ProductName,
	P.UnitPrice,
	P.UnitsInStock,
	(P.UnitPrice * P.UnitsInStock) AS [Total],
	pw.*
FROM Products AS p
INNER JOIN products_new AS pw
ON p.ProductID = pw.product_number;

INSERT INTO products_new
SELECT 
	P.ProductName,
	P.UnitPrice,
	P.UnitsInStock,
	(P.UnitPrice * P.UnitsInStock) AS [Total]
FROM Products AS p
LEFT JOIN products_new AS pw
ON p.ProductID = pw.product_number
WHERE pw.product_number IS NULL;

