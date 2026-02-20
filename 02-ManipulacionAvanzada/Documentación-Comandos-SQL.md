# Manual Maestro de SQL: Tipos de Datos, Lógica y Consultas

Este documento es una guía completa basada en scripts de SQL Server. Se centra en la definición precisa de tipos de datos, la lógica de filtrado avanzado y la estructura correcta de consultas.

---

## 1. DDL: Definición de Estructura y Tipos de Datos

Esta sección detalla los componentes básicos para construir tablas. Es fundamental elegir el tipo de dato correcto para optimizar el almacenamiento y evitar errores.

### 1.1 Tipos de Datos Comunes

A continuación se describen los tipos de datos utilizados en los scripts, sus características y cuándo usarlos.

| Tipo de Dato | Descripción Detallada | Uso Común | Ejemplo |
| :--- | :--- | :--- | :--- |
| **`INT`** | Números enteros (sin decimales). Rango aproximado de -2 mil millones a 2 mil millones. | Identificadores (IDs), edades, contadores, cantidades enteras. | `45`, `1024` |
| **`NVARCHAR(n)`** | Cadena de caracteres **variable** Unicode. La 'N' permite caracteres especiales (tildes, ñ, kanjis). La '(n)' es la longitud máxima. Si guardas "Hola" en un `NVARCHAR(50)`, solo ocupa el espacio de "Hola". | Nombres, apellidos, direcciones, correos electrónicos. | `'Goku'`, `'Av. Siempre Viva'` |
| **`NCHAR(n)`** | Cadena de caracteres **fija** Unicode. Si defines `NCHAR(10)` y guardas "Hola", el sistema rellena los 6 espacios restantes con blancos. | Códigos de estado, abreviaturas fijas, sexo (M/F). | `'F'`, `'MX'` |
| **`MONEY`** | Tipo numérico optimizado para dinero. Tiene una precisión fija de 4 decimales. Es más preciso que `FLOAT` para cálculos financieros. | Precios, salarios, límites de crédito, costos. | `500.00`, `19.99` |
| **`DATE`** | Almacena únicamente la fecha (Año-Mes-Dia), sin hora. Rango: 0001-01-01 a 9999-12-31. | Fechas de nacimiento, fechas de registro, fechas de vencimiento. | `'1999-05-06'` |
| **`CHAR(n)`** | Igual que `NCHAR` pero sin soporte Unicode (solo caracteres estándar ASCII). Ocupa menos espacio si no necesitas tildes o caracteres especiales. | Códigos internos, banderas booleanas simples ('S'/'N'). | `'A'`, `'B'` |

### 1.2 Restricciones y Propiedades de Columna

Reglas que se aplican a las columnas para garantizar la integridad de los datos.

#### IDENTITY(semilla, incremento)
Propiedad de automatización.
* **Semilla:** Valor inicial (ej. 1).
* **Incremento:** Cuánto suma por cada fila nueva (ej. 1).
* *Nota:* No se insertan datos aquí manualmente; el sistema lo llena solo.

#### NOT NULL vs NULL
* **`NOT NULL`**: Obliga a ingresar un dato. Si intentas dejarlo vacío, dará error.
* **`NULL`**: Permite la ausencia de valor (útil para datos opcionales como "segundo apellido").

#### DEFAULT
Inserta un valor predefinido si el usuario no envía nada.
* Ejemplo: `DEFAULT GETDATE()` inserta la fecha/hora actual automáticamente.

---

## 2. Lógica de Consultas: El Operador LIKE

El operador `LIKE` se usa en la cláusula `WHERE` para buscar patrones en cadenas de texto. Es mucho más flexible que el operador igual (`=`).

### Tabla de Comodines (Wildcards)

| Comodín | Descripción | Ejemplo de Patrón | Resultado |
| :--- | :--- | :--- | :--- |
| **`%`** (Porcentaje) | Representa **cero o más** caracteres. Es el más usado. | `'A%'` | Todo lo que empiece con A (Ana, Alberto). |
| | | `'%s'` | Todo lo que termine en s (Casas, Mes). |
| | | `'%mé%'` | Contiene "mé" en cualquier parte (México, América). |
| **`_`** (Guion bajo) | Representa **exactamente un** carácter cualquiera. | `'C_sa'` | Casa, Cosa (pero NO Causa). |
| | | `'_n%'` | La segunda letra es 'n' (Ana, Uno). |
| **`[]`** (Corchetes) | Representa **cualquier carácter individual** dentro del rango o lista especificada. | `'[abc]%'` | Empieza con a, b, O c. |
| | | `'[a-f]%'` | Empieza con cualquier letra de la 'a' a la 'f'. |
| **`[^]`** (Circunflejo) | **Negación**. Representa cualquier carácter que **NO** esté en la lista. | `'[^a-c]%'` | NO empieza ni con a, ni con b, ni con c. |

---

## 3. Teoría Avanzada: Agrupamiento y Filtrado

Esta es la parte más crítica para entender consultas complejas. La diferencia entre `WHERE` y `HAVING` suele ser confusa, pero es vital.

### 3.1 Comparación: WHERE vs HAVING

Ambos sirven para filtrar datos, pero actúan en momentos diferentes del procesamiento.

| Característica | **WHERE** | **HAVING** |
| :--- | :--- | :--- |
| **Cuándo actúa** | **ANTES** de agrupar (`GROUP BY`). | **DESPUÉS** de agrupar y calcular agregados. |
| **Qué filtra** | Filtra **filas individuales** (registro por registro). | Filtra **grupos completos** basándose en un resultado matemático. |
| **Uso de Agregados** | **PROHIBIDO**. No puedes usar `SUM()`, `COUNT()`, etc. aquí. | **OBLIGATORIO/PERMITIDO**. Se usa para condiciones como `SUM(ventas) > 1000`. |
| **Ejemplo Mental** | "Quiero solo las ventas de México". | "Quiero los países donde la suma total de ventas superó $10,000". |

### 3.2 La Regla de Oro del GROUP BY
Si en tu `SELECT` mezclas **columnas normales** (ej. `CategoryName`) con **funciones de agregado** (ej. `COUNT(*)`), **TODAS** las columnas normales deben ir obligatoriamente en la cláusula `GROUP BY`.

* *Incorrecto:* `SELECT CategoryID, COUNT(*) FROM Products` (Falta agrupar).
* *Correcto:* `SELECT CategoryID, COUNT(*) FROM Products GROUP BY CategoryID`.

---

## 4. Scripts y Ejercicios Prácticos

A continuación, se presentan los scripts originales organizados con la lógica descrita anteriormente.

### 4.1 Creación de Base de Datos y Tablas (DDL)

```sql
-- Crea una base de datos
CREATE DATABASE tienda;
GO

USE tienda;
GO

-- Tabla con tipos de datos básicos y restricciones NULL/NOT NULL
CREATE TABLE cliente(
    id INT not null,
    nombre NVARCHAR(30) not null,
    apaterno NVARCHAR(10) not null,
    amaterno NVARCHAR(10) null, -- Permite nulos
    sexo NCHAR(1) not null,     -- Longitud fija
    edad INT not null,
    direccion NVARCHAR(80) not null,
    rfc NVARCHAR(20) not null,
    limitecredito MONEY not null default 500.0 -- Valor por defecto
);
GO

-- Tabla con Primary Key definida
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

```

### 4.2 Inserción de Datos (DML)

Ejercicios mostrando las diferentes sintaxis de `INSERT`.

```sql
-- 1. Inserción de todos los campos en orden
INSERT INTO clientes 
VALUES(1, 'Goku', 'Linterna', 'Superman', 450, '1578-01-17', 100);

-- 2. Inserción especificando columnas (útil para saltar nulos o cambiar orden)
INSERT INTO clientes 
(nombre, cliente_id, limite_credito, fecha_nacimiento, apellido_paterno, edad)
VALUES('Arcadia', 3, 45800, '2000-01-22', 'Ramirez', 26);

-- 3. Inserción múltiple (varias filas a la vez)
INSERT INTO clientes 
VALUES
(5, 'Soyla', 'Vaca', 'del Corral', 42, '1983-04-06', 78955),
(6, 'Bad Bunny', 'Perez', 'sin Sentido', 22, '1999-05-06', 85858);

```

### 4.3 Uso de IDENTITY y Valores por Defecto

Uso de `IDENTITY(1,1)` para autoincrementar IDs y `GETDATE()` para fechas automáticas.

```sql
CREATE TABLE clientes_2(
    cliente_id INT not null IDENTITY(1,1), -- Empieza en 1, suma 1
    nombre NVARCHAR(50) not null,
    edad INT not null,
    fecha_registro DATE DEFAULT GETDATE(), -- Fecha del sistema
    limite_credito MONEY not null,
    CONSTRAINT pk_clientes_2 PRIMARY KEY (cliente_id)
);

-- Al insertar, se usa DEFAULT o se omite la columna
INSERT INTO clientes_2 VALUES ('Chespirito', 89, DEFAULT, 45500);

```

### 4.4 Restricciones Avanzadas (CHECK, UNIQUE)

Validación de integridad de datos.

```sql
CREATE TABLE suppliers (
    supplier_id INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(30) NOT NULL,
    tipo CHAR(1) NOT NULL,
    credit_limit MONEY NOT NULL,
    
    CONSTRAINT pk_suppliers PRIMARY KEY ( supplier_id ),
    CONSTRAINT unique_name UNIQUE ([name]), -- No permite nombres repetidos
    CONSTRAINT chk_credit_limit CHECK (credit_limit > 0 and credit_limit <= 50000), -- Valida rango
    CONSTRAINT chk_tipo CHECK (tipo in ('A', 'B', 'C')) -- Valida lista permitida
);

```

### 4.5 Consultas con LIKE (Patrones)

Ejercicios prácticos de los comodines explicados en la sección 2.

```sql
-- Comienza con 'a'
SELECT * FROM Customers WHERE CompanyName LIKE 'a%';

-- Contiene 'mé'
SELECT * FROM Customers WHERE City LIKE '%mé%';

-- Patrón específico: Segunda letra es 'n' (L_nd__)
SELECT * FROM Customers WHERE city LIKE 'L_nd__';

-- Rango: Comienza con a, b, c, d, e o f
SELECT * FROM Customers WHERE CustomerID LIKE '[a-f]%';

-- Negación: NO empieza con b, s, o p
SELECT * FROM Customers WHERE CompanyName LIKE '[^bsp]%';

```

### 4.6 Agregación, Group By y Having

Aplicación de la teoría de la sección 3.

**Ejemplo 1: GROUP BY Simple**
Contar cuántos productos hay por cada categoría.

```sql
SELECT 
    CategoryID, 
    COUNT(*) AS [Total de productos]
FROM Products
GROUP BY CategoryID
ORDER BY 2 DESC;

```

**Ejemplo 2: WHERE + GROUP BY + HAVING**
Este ejercicio combina todo:

1. Filtra filas con `WHERE` (Países específicos).
2. Agrupa con `GROUP BY` (Por cliente).
3. Filtra el grupo con `HAVING` (Más de 10 órdenes).

```sql
SELECT CustomerID, COUNT(*) AS [Numero de ordenes]
FROM Orders
WHERE ShipCountry IN ('Germany', 'France', 'Brazil') -- Filtro antes de agrupar
GROUP BY CustomerID                              -- Agrupamiento
HAVING COUNT(*) > 10                             -- Filtro después de agrupar
ORDER BY 2 DESC;

```

**Ejemplo 3: Cálculo Complejo con JOINS**
Seleccionar empleados que hayan vendido más de 100,000.

* Nota: Aquí se ve claramente que la condición `> 100000` aplica sobre la `SUMA`, por eso va en `HAVING`.

```sql
SELECT 
    CONCAT(e.FirstName, ' ', e.LastName) AS [Nombre completo], 
    ROUND(SUM(od.Quantity * od.UnitPrice * ( 1 - od.Discount)),2) AS [Importe]
FROM Employees AS e
INNER JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
GROUP BY e.FirstName, e.LastName
HAVING SUM(od.Quantity * od.UnitPrice * ( 1 - od.Discount)) > 100000
ORDER BY Importe DESC;

```

---

## 5. Nota Final: Flujo de Ejecución

Recuerda siempre este orden interno al diseñar tus consultas, ya que explica por qué no puedes usar un alias del SELECT en el WHERE:

1. **FROM / JOIN** (Carga datos)
2. **WHERE** (Filtra filas)
3. **GROUP BY** (Crea grupos)
4. **HAVING** (Filtra grupos)
5. **SELECT** (Muestra columnas y calcula)
6. **ORDER BY** (Ordena el resultado)
