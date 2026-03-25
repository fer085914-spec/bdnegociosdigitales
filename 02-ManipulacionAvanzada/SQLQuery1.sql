-- Lista todos los productos cuya descripción contenga la palabra "Art" en cualquier posición, pero que su precio sea mayor a 500.
SELECT *
FROM Productos
WHERE Descripcion LIKE '%art%' AND Precio > 500;

-- Encuentra a los representantes cuyo nombre comience con las letras entre la 'A' y la 'L', y que no pertenezcan a las oficinas de 'Valencia' o 'Madrid'.
SELECT *
FROM Representantes AS r
INNER JOIN Oficinas AS o
ON r.Num_Empl = o.Jef
WHERE r.Nombre LIKE '[A-L]%'
AND o.Ciudad NOT IN  ('Valencia', 'Madrid');

SELECT *
FROM Representantes AS r
INNER JOIN Oficinas AS o
ON r.Oficina_Rep = o.Oficina
WHERE r.Nombre LIKE '[A-L]%'
AND o.Ciudad NOT IN ('Valencia', 'Madrid');

-- Muestra los pedidos realizados en el último trimestre de cualquier año, usando operadores de comparación y AND.
SELECT *
FROM Pedidos
WHERE DATEPART(QUARTER, Fecha_Pedido) = 4;

-- Selecciona las oficinas de la región 'Este' o 'Oeste' donde el objetivo de ventas sea exactamente el doble de las ventas actuales (usa operadores aritméticos).
SELECT * 
FROM Oficinas
WHERE Region IN ('Este', 'Oeste')
AND Objetivo = (Ventas * 2);

-- Busca clientes cuya empresa termine con la letra 's' y que el ID de su representante sea un número par.
SELECT *
FROM Clientes
WHERE Empresa LIKE '%s'
AND Rep_Cli%2 = 0

-- Muestra el número de pedido y una columna calculada llamada Impuesto_IVA (16%) basada en el importe del pedido.
SELECT Num_Pedido,
(Importe * .16) AS [Impuesto IVA]
FROM Pedidos

-- Genera un reporte que concatene el nombre del representante con su cuota actual, por ejemplo: "Juan Perez tiene una cuota de 5000". Usa un alias para la columna.
SELECT CONCAT(Nombre, ' tiene una cuota de ', Cuota)
FROM Representantes

-- Obtén una lista de productos mostrando su nombre en mayúsculas y una columna que diga "Stock Crítico" si las existencias son menores a 10 (usa tu lógica de operadores).


-- Calcula la diferencia real entre las ventas de cada oficina y su objetivo, nombrando a la columna Diferencia_Rendimiento.

-- Calcula el promedio del límite de crédito de los clientes agrupados por representante, pero solo muestra aquellos representantes cuyo promedio sea superior a 15,000.

-- ¿Cuántos pedidos ha realizado cada cliente? Muestra el nombre de la empresa y el total de pedidos, ordenados de mayor a menor.

-- Encuentra el importe total vendido por cada producto, pero solo de aquellos productos donde se hayan hecho más de 3 pedidos en total.

-- Determina cuál es la cuota máxima y mínima por región de oficina.

-- Cuenta cuántos representantes hay en cada oficina, excluyendo aquellas oficinas que tengan menos de 2 representantes.

-- Suma el total de los importes de los pedidos por mes, sin importar el año (pista: usa funciones de fecha).

-- Lista todos los pedidos incluyendo el nombre de la empresa del cliente y el nombre del representante que atendió al cliente (requiere triple JOIN).

-- Muestra las oficinas que no tienen ningún representante asignado (usa un LEFT JOIN y busca los nulos).

-- Obtén el nombre de los productos que nunca han sido vendidos.

-- Encuentra a los representantes que ganan más que el promedio de todos los representantes de la empresa (Usa una subconsulta).

-- Muestra cada cliente y el total de dinero que ha gastado en pedidos, incluso si no ha realizado ningún pedido (debe aparecer 0 o NULL).

-- Lista los nombres de los representantes y el nombre de su jefe (la tabla se relaciona consigo misma).

-- Crea una consulta que muestre el nombre del representante, su ciudad de oficina y el total de sus ventas, pero solo para aquellos representantes cuyas ventas totales superen el objetivo de su oficina.
SELECT r.Nombre, o.Ciudad, r.Ventas
FROM Representantes AS r
INNER JOIN Oficinas AS o
ON r.Num_Empl = o.Jef
WHERE r.Ventas > o.Objetivo


-- Genera un reporte de "Rendimiento por Región": muestra la región, la suma de ventas de todas sus oficinas y el número total de clientes atendidos en esa región.

-- Selecciona los productos que han sido comprados por más de 2 empresas diferentes.
SELECT *
FROM Productos

-- Muestra el nombre de la empresa cliente que realizó el pedido con el importe más alto de toda la historia de la base de datos.

-- Crea una vista que resuma por cada producto: nombre, total de unidades vendidas y el ingreso total generado, ordenado por ingreso de mayor a menor.

-- Muestra el nombre de cada representante y el nombre de la ciudad donde está su oficina asignada.
SELECT r.Nombre, o.Ciudad
FROM Representantes AS R
INNER JOIN Oficinas AS o
ON o.Oficina = r.Oficina_Rep

SELECT *
FROM Representantes

SELECT *
FROM Oficinas

-- Muestra el nombre de la ciudad y el nombre del representante que es el jefe (director) de esa oficina.
SELECT o.Ciudad, r.Nombre
FROM Representantes AS R
INNER JOIN Oficinas AS o
ON o.Jef = r.Num_Empl