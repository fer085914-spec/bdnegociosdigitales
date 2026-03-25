# ¿Qué es una subconsulta?

Una subconsulta (subquery) es un SELECT dentro de otro SELECT. Puede devolver:

1. Un solo valor (escalar)
1. Una lista de valores (una columna, varias filas)
1. Una tabla (varias columnas y/o varias filas)
1. Segun lo que devuelva, se elige el operador correcto (=, IN, EXITIS, etc.)

Una subconsulta es una consulta anidada dentro de otra consulta que 
permite resolver problemas en varios niveles de información.

```
Dependiendo de donde se coloque y que retorne cambia su comportamiento.
```

**5 GRANDES FORMAS DE USARLAS:**

1. Subconsultas escalares.
2. Subconsultas con IN, ANY, ALL.
3. Subconsultas correlacionadas.
4. Subconsultas en SELECT.
5. Subconsultas en FROM (Tablas derivadas).

---

## **1. Escalares**
Devuleven un único valor, por eso se pueden utilizar con operadores  =, >, <.

Ejemplo:

```sql
SELECT *
FROM Pedidos 
WHERE total = (
	SELECT MAX(total)
	FROM Pedidos
);
```

## **Subconsultas con IN, ANY, ALL.**
Devuelve varios valores con una sola columna (IN)
> Seleccionar todos los clientes que han hecho pedidos

```sql
SELECT *
FROM Clientes
WHERE id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
);
```

## Clausula ANY
- Compara un valor contra una lista
- La condicion se cumple si se cumple con AL MENOS UNO

```sql
valor > ANY (subconsulta)
```

> Es como decir: Mayor que al menos uno de los valores

- Seleccionar pedidos mayores que algun pedido de Luis(id_cliente = 2)

```sql
 --Operador ANY
-- Seleccionar pedidos mayores que algun pedido de Luis (id_cliente2)
	-- Primero la subconsulta

SELECT total
FROM pedidos 
WHERE id_cliente = 2;

	--Consulta principal

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos 
	WHERE id_cliente = 2); 

	SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	INNER JOIN 
	FROM pedidos 
	WHERE id_cliente = 2); 

--Seleccionar los pedidos mayores (total) de algun pedido de Ana
	--Subconsulta
SELECT total
FROM pedidos 
WHERE id_cliente = 1;

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos 
	WHERE id_cliente = 1); 

-- Seleccionar los pedidos mayores que algun pedido superior a 500
SELECT total
FROM pedidos 
WHERE total > 500

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos 
	WHERE total > 500);

```

## CLAUSULA ALL
Se cumple contra todos los valores 

```sql
valor > ALL (Subconsulta)
```

Significa:
- Mayor que todos los valores

```sql
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
```

## Subconsultas correlacionadas

> Una subconsulta correlacionada depende de la fila actual de la consulta principal y se ejecuta una vez por cada fila

---

1. Seleccionar los clientes cuyo total de compras sea mayor a 1000

