
--Crea una base de datos
CREATE DATABASE tienda;
GO

USE tienda;
GO

CREATE TABLE cliente(
	id INT not null,
	nombre NVARCHAR(30) not null,
	apaterno NVARCHAR(10) not null,
	amaterno NVARCHAR(10) null,
	sexo NCHAR(1) not null,
	edad INT not null,
	direccion NVARCHAR(80) not null,
	rfc NVARCHAR(20) not null,
	limitecredito MONEY not null default 500.0
);
GO

-- Restricciones

CREATE TABLE clientes(
	cliente_id INT NOT NULL PRIMARY KEY,
	nombre NVARCHAR(30) NOT NULL,
	apellido_paterno NVARCHAR(20) NOT NULL,
	apellido_materno NVARCHAR(20),
	edad INT NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	limite_credito MONEY NOT NULL
);
GO

INSERT INTO clientes 
VALUES(1, 'Goku', 'Linterna', 'Superman', 450, '1578-01-17', 100);

INSERT INTO clientes 
VALUES(2, 'Pancracio', 'Rivero', 'Patroclo', 20, '2005-01-17', 10000);

INSERT INTO clientes 
(nombre, cliente_id, limite_credito, fecha_nacimiento, apellido_paterno, edad)
VALUES('Arcadia', 3, 45800, '2000-01-22', 'Ramirez', 26);

INSERT INTO clientes 
VALUES(4, 'Vanesa', 'Buena Vista', NULL, 26, '2000-04-25', 3000);

INSERT INTO clientes 
VALUES
(5, 'Soyla', 'Vaca', 'del Corral', 42, '1983-04-06', 78955),
(6, 'Bad Bunny', 'Perez', 'sin Sentido', 22, '1999-05-06', 85858),
(7, 'Jose Luis', 'Herrera', 'Gallardo', 42, '1983-04-06', 14000)
;


SELECT GETDATE(); -- obtiene la fecha del sistema

SELECT * FROM clientes;

SELECT cliente_id, nombre, edad, limite_credito
FROM clientes;

SELECT GETDATE(); -- obtiene la fecha del sistema

CREATE TABLE clientes_2(
cliente_id INT not null IDENTITY(1,1),
nombre NVARCHAR(50) not null,
edad INT not null,
fecha_registro DATE DEFAULT GETDATE(),
limite_credito MONEY not null,
CONSTRAINT pk_clientes_2
PRIMARY KEY (cliente_id)
);

SELECT *
FROM clientes_2;

INSERT INTO clientes_2
VALUES ('Chespirito', 89, DEFAULT, 45500);

INSERT INTO clientes_2 (nombre, edad, limite_credito)
VALUES ('Batman', 45, 8900);

INSERT INTO clientes_2
VALUES ('Robin', 35, '2026-01-19', 89.32);

INSERT INTO clientes_2 (limite_credito, edad, nombre, fecha_registro)
VALUES (12.33, 24, 'Flash reverso', '2026-01-21');

CREATE TABLE suppliers (
	supplier_id INT NOT NULL IDENTITY(1,1),
	[name] NVARCHAR(30) NOT NULL,
	date_register DATE NOT NULL DEFAULT GETDATE(),
	tipo CHAR(1) NOT NULL,
	credit_limit MONEY NOT NULL,
	CONSTRAINT pk_suppliers
	PRIMARY KEY ( supplier_id ),
	CONSTRAINT unique_name
	UNIQUE ([name]),
	CONSTRAINT chk_credit_limit
	CHECK (credit_limit > 0.0 and credit_limit <= 50000),
	CONSTRAINT chk_tipo
	CHECK (tipo in ('A', 'B', 'C'))
);

SELECT *
FROM suppliers;

INSERT INTO suppliers
VALUES (UPPER('bimbo'), DEFAULT, UPPER('c'), 45000);

INSERT INTO suppliers
VALUES (UPPER('tia rosa'), '2026-01-21', UPPER('a'), 49999.9999);

INSERT INTO suppliers ([name], tipo, credit_limit)
VALUES (UPPER('tia mensa'), UPPER('a'), 49999.9999);


-- Crear Base de Datos dborders
CREATE DATABASE dborders;
GO

USE dborders;
GO

-- Crear tabla customers
CREATE TABLE customers (
	customer_id INT NOT NULL IDENTITY(1,1),
	first_name NVARCHAR(20) NOT NULL,
	last_name NVARCHAR(30),
	[address] NVARCHAR(80) NOT NULL,
	number INT,
	CONSTRAINT pk_customers
	PRIMARY KEY (customer_id)
);
GO

CREATE TABLE suppliers (
	supplier_id INT NOT NULL,
	[name] NVARCHAR(30) NOT NULL,
	date_register DATE NOT NULL DEFAULT GETDATE(),
	tipo CHAR(1) NOT NULL,
	credit_limit MONEY NOT NULL,
	CONSTRAINT pk_suppliers
	PRIMARY KEY ( supplier_id ),
	CONSTRAINT unique_name
	UNIQUE ([name]),
	CONSTRAINT chk_credit_limit
	CHECK (credit_limit > 0.0 and credit_limit <= 50000),
	CONSTRAINT chk_tipo
	CHECK (tipo in ('A', 'B', 'C'))
);
GO

ALTER TABLE suppliers
DROP CONSTRAINT pk_suppliers;

DROP TABLE suppliers;

CREATE TABLE products (
	product_id INT NOT NULL IDENTITY(1,1),
	[name] NVARCHAR(40) NOT NULL,
	quantity INT NOT NULL,
	unit_price MONEY NOT NULL,
	supplier_id INT
	CONSTRAINT pk_products
	PRIMARY KEY (product_id),
	CONSTRAINT unique_name_products
	UNIQUE ([name]),
	CONSTRAINT chk_quantity
	CHECK (quantity BETWEEN 1 AND 100),
	CONSTRAINT chk_unitprice
	CHECK (unit_price > 0 AND unit_price <= 100000),
	CONSTRAINT fk_products_suppliers
	FOREIGN KEY (supplier_id)
	REFERENCES suppliers (supplier_id)
	ON DELETE NO ACTION 
	ON UPDATE NO ACTION
);
GO

DROP TABLE products;
DROP TABLE suppliers;

ALTER TABLE products
DROP CONSTRAINT fk_products_suppliers;

-- Permite cambiar la estructura de una columna en la tabla
ALTER TABLE products
ALTER COLUMN supplier_id INT NULL;

UPDATE products
SET supplier_id = NULL;

-- DROP TABLE products;

INSERT INTO suppliers
VALUES (1, UPPER('CHINO S.A.'), DEFAULT, UPPER('c'), 45000);

INSERT INTO suppliers
VALUES (2, UPPER('chanclotas'), '2026-01-21', UPPER('a'), 49999.9999);

INSERT INTO suppliers (supplier_id, [name], tipo, credit_limit)
VALUES (3, UPPER('rama ma'), UPPER('a'), 49999.9999);

INSERT INTO products
VALUES ('Papas', 10, 5.3, 1);

INSERT INTO products
VALUES ('Rollos Primavera', 20, 100, 1);

INSERT INTO products
VALUES ('Chanclas pata de gallo', 50, 20, 10);

INSERT INTO products
VALUES ('Chanclaas buenas', 30, 56.7, 10),
	   ('Ramita chiquita', 56, 78.23, 3);

INSERT INTO products
VALUES ('Azulito', 100, 15.3, NULL);

-- Compronación ON DELETE NO ACTION
	-- Eliminar los hijos
DELETE FROM products
WHERE supplier_id = 1;

	-- Eliminar el padre
DELETE FROM suppliers
WHERE supplier_id = 1;



-- Comprobar el UPDATE NO ACTION
UPDATE products 
SET supplier_id = NULL
WHERE supplier_id = 2; 

UPDATE suppliers
SET supplier_id = 10
WHERE supplier_id = 2;

UPDATE products
SET supplier_id = 10
WHERE product_id IN(3,4);

-- NO SIRVEN
DELETE FROM products
WHERE supplier_id = 1;

UPDATE products
SET supplier_id = 2
WHERE product_id = 5 OR product_id = 6 ;

UPDATE products
SET supplier_id = 2
WHERE product_id IN (5, 6);

UPDATE products
SET supplier_id = 3
WHERE product_id = 7;

-- CAMBIAR EL SUPLIER CHANCLOTAS SUPPLIER ID = 10
UPDATE suppliers
SET supplier_id = 10
WHERE supplier_id = 2;

UPDATE products
SET supplier_id = 20
WHERE supplier_id is NULL;

------------------------------------------------------------ SET NULL --------------------------------------------------------------------------------------
DROP TABLE products;

CREATE TABLE products (
	product_id INT NOT NULL IDENTITY(1,1),
	[name] NVARCHAR(40) NOT NULL,
	quantity INT NOT NULL,
	unit_price MONEY NOT NULL,
	supplier_id INT
	CONSTRAINT pk_products
	PRIMARY KEY (product_id),
	CONSTRAINT unique_name_products
	UNIQUE ([name]),
	CONSTRAINT chk_quantity
	CHECK (quantity BETWEEN 1 AND 100),
	CONSTRAINT chk_unitprice
	CHECK (unit_price > 0 AND unit_price <= 100000),
	CONSTRAINT fk_products_suppliers
	FOREIGN KEY (supplier_id)
	REFERENCES suppliers (supplier_id)
	ON DELETE SET NULL 
	ON UPDATE SET NULL
);
GO

-- Comprobar ON DELETE SET NULL
DELETE suppliers
WHERE supplier_id = 10;

-- Comprobar ON UPDATE SET NULL
UPDATE suppliers
SET supplier_id = 20
WHERE supplier_id = 1;



-- Consultar datos
SELECT *
FROM suppliers;

SELECT *
FROM products;