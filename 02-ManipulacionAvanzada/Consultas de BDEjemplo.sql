SELECT * FROM Clientes;
SELECT * FROM Representantes;
SELECT * FROM Oficinas;
SELECT * FROM Productos;
SELECT * FROM Pedidos;

-- Crear una vista que visualice el total de los importes agrupados por productos 

CREATE OR ALTER VIEW vw_importes_producto AS
SELECT 
	pr.Descripcion AS [Nombre del producto],
	SUM(p.Importe) AS [Total],
	SUM(P.Importe * 1.15) AS [Importe Descuento]
FROM Pedidos AS p
INNER JOIN Productos AS pr
ON p.Fab = pr.Id_fab
AND p.Producto = pr.Id_producto
GROUP BY pr.Descripcion;

SELECT *
FROM vw_importes_producto
WHERE [Nombre del producto] LIKE '%brazo%'
AND [Importe Descuento] > 34000;

SELECT *
FROM Productos;


-- Seleccionar los nombres de los representantes y las oficinas en donde trabajan
SELECT r.Nombre, r.Ventas, o.Oficina, o.Ciudad, o.Region, o.Ventas
FROM Representantes AS r
INNER JOIN Oficinas AS o
ON o.Oficina = r.Oficina_Rep
ORDER BY o.Ciudad;

SELECT * FROM Representantes
WHERE Nombre = 'Daniel Ruidrobo';

CREATE OR ALTER VIEW vw_oficinas_representantes
AS
SELECT 
	r.Nombre, 
	r.Ventas AS [Ventas_representantes], 
	o.Oficina, 
	o.Ciudad, 
	o.Region, 
	o.Ventas AS [Ventas_oficinas]
FROM Representantes AS r
INNER JOIN Oficinas AS o
ON o.Oficina = r.Oficina_Rep;

SELECT Nombre, Ciudad
FROM vw_oficinas_representantes
ORDER BY Nombre DESC;

-- Seleccionar los pedidos con fecha e importe, el nombre del representante 
-- que lo realizo y al cliente que lo solicito

SELECT 
	p.Num_Pedido,
	p.Fecha_Pedido,
	p.Importe,
	c.Empresa,
	r.Nombre
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = p.Rep


-- Seleccionar los pedidos con fecha e importe, el nombre del representante 
-- que atendio al cliente y al cliente que lo solicito
SELECT 
	p.Num_Pedido,
	p.Fecha_Pedido,
	p.Importe,
	r.Nombre,
	c.Empresa
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON c.Rep_Cli = r.Num_Empl