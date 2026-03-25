# Comandos de SQL

Este documento explica la definición de tipos de datos, filtrado, operadores y la estructura  de diversas consultas.

---

## 1. Lenguaje de Definición de Datos (DDL)

Comandos para construir la base de datos y si estructura principal.

### 1.1 Configuración Inicial

**CREATE DATABASE:** Reserva el espacio en el servidor para la base de datos.

**USE:** Establece que la base de datos se activará o estará en uso. Todos los comandos que se ejecuten después afectarán a la base seleccionada.

**GO:** Es un separador exclusivo de SQL Server. Indica que debe procesar y finalizar las instrucciones anteriores antes de continuar con las siguientes.


**EJEMPLO**:
```sql
CREATE DATABASE tienda;
GO

USE tienda;
GO
```

### 1.2 Tablas y Tipos de Datos

**CREATE TABLE:** Se usa para definir una nueva tabla dentro de una base de datos. Esta puede crearse de diferentes maneras, por ejemplo:

- **Tabla Estándar o Básica:** Estructura permanente y básica que solo define los nombres de las columnas y sus tipos de datos.

- **Tabla con Restricciones:** Tabla permanente a la que se le aplica integridad *(llaves primarias, llaves foráneas, validaciones, valores por defecto y autoincrementables)*.

A continuación se describen los tipos de datos usados en los diferentes scripts, previamente realizados:

| Tipo de Dato | Descripción | Uso Común |
| --- | --- | --- |
| **`INT`** | Números enteros.  | IDs, edades, cantidades enteras. |
| **`NVARCHAR(n)`** | Cadena de caracteres **variable**.  La '(n)' es la longitud máxima. | Nombres, apellidos, direcciones, correos electrónicos. |
| **`NCHAR(n)`** | Cadena de caracteres **fija**. Si defines `NCHAR(10)` y guardas "Hola", el sistema rellena los 6 espacios restantes con blancos. | Códigos, abreviaturas, sexo. |
| **`DATE`** | Fecha (Año-Mes-Dia).| Fechas de nacimiento, fechas de vencimiento. |
| **`CHAR(n)`** | Igual que `NCHAR` pero sin soporte Unicode. | Códigos internos. |

 ---

```
UNICODE es el estándar que permite representar caracteres de todos
 los idiomas. Es decir, la forma en que SQL Server entiende letras, símbolos y caracteres especiales además de los del alfabeto inglés.
```

### 1.3 Restricciones

Las restricciones son reglas que se aplican a las columnas para garantizar la integridad de los datos.

**IDENTITY:** Es un contador automático que maneja la base de datos. Se le indica en qué número empezar y de cuánto en cuánto ir sumando. El sistema toma el control, calcula el siguiente número de la secuencia y lo inserta.

**NOT NULL vs NULL:** Definir si un campo es obligatorio u opcional. Con `NOT NULL` se obliga a que siempre venga un dato; si intento guardar el registro con ese espacio vacío, el sistema me va a tirar un error. Si lo dejo como `NULL`, le digo a la base de datos que no hay problema si ese dato falta.

**DEFAULT:** Es mi valor de relleno automático. Si al guardar un registro simplemente no mando ningún dato para esa columna, el sistema se da cuenta y rellena el hueco por su cuenta con el valor por defecto que yo le haya configurado antes.

**Llave Primaria (PRIMARY KEY):** Es el identificador único y súper estricto de cada fila en la tabla. Funciona como el documento de identidad irrepetible de cada registro.

**Llave Foránea (FOREIGN KEY):** Es la regla para conectar dos tablas sin que se rompa la coherencia. Me garantiza que un dato que intento meter en mi tabla actual hace referencia a un registro que *realmente existe* en la otra tabla.

**Validaciones (CHECK):** Son filtros lógicos. Le digo al sistema que, antes de guardar cualquier cosa, revise que el dato cumpla con una condición específica. Si el dato no pasa esa prueba, la base de datos lo rechaza de inmediato.

---

## 2. Jerarquía  de Operadores

Cuando una consulta tiene varias condiciones, SQL sigue un orden de evaluación.

Lista los operadores por prioridad:

| Nivel | Categoría | Operador | Descripción |
| --- | --- | --- | --- |
| **1** | **Agrupación** | `( )` | **Paréntesis.** Rompen cualquier regla de precedencia. |
| **2** | **Aritméticos** | `*`, `/`, `%` | Multiplicación, División y Módulo. |
| **3** | **Aritméticos y Cadena** | `+`, `-`, ` |  |
| **4** | **Comparación** | `=`, `>`, `<`, `<>`, `>=`, `<=` | Comparan valores y devuelven Verdadero/Falso. |
| **5** | **Predicados** | `LIKE`, `IN`, `BETWEEN` | Operadores especiales de comparación (patrones, listas, etc.). |
| **6** | **Negación** | `NOT` | Invierte el valor de verdad. |
| **7** | **Conjunción** | `AND` |  |
| **8** | **Disyunción** | `OR` |  |

---

## 3. Lógica de Consultas: El Operador LIKE

El operador `LIKE` se usa en la cláusula `WHERE` para buscar patrones en texto.

### Wildcards

| Comodín | Descripción | Ejemplo de Patrón | Resultado |
| --- | --- | --- | --- |
| **`%`** | Representa **cero o más** caracteres. | `'A%'` | Todo lo que empiece con A. |
|  |  | `'%s'` | Todo lo que termine en s. |
|  |  | `'%is%'` | Contiene "is" en cualquier parte. |
| **`_`** | Representa **un** carácter . | `'C_sa'` | Casa, Cosa. |
| **`[]`** (Corchetes) | Representa **cualquier carácter individual** dentro del rango o lista especificada. | `'[abc]%'` | Empieza con **A**, **B**, o **C**. |
|  |  | `'[a-f]%'` | Empieza con cualquier letra de la 'a' a la 'f'. |
| **`[^]`** (Circunflejo) | **Negación**. Representa cualquier carácter que **NO** esté en la lista. | `'[^a-c]%'` | NO empieza ni con a, ni con b, ni con c. |

---

## 4.  Campos Calculados, Agregados y Alias

### 4.1 Campos Calculados

Un campo calculado es una columna que **no existe** en el disco duro de la base de datos. Se calcula en la memoria RAM del servidor cada vez que se ejecuta el `SELECT`.

Se utilizan para no guardar datos redundantes.

- **Cálculos Aritméticos:** Siguen las mismas reglas de precedencia matemática que se mencionaron anteriormente.

```sql
-- Cálculo simple
SELECT (UnitPrice * UnitsInStock) AS [Costo Inventario]
FROM Products;
```

- **Manipulación de Cadenas de Texto:** Alterar cómo se ven los textos desde la consulta usando funciones del sistema.

```sql
-- Concatenación: Unir varias columnas
SELECT FirstName + ' ' + LastName AS [Nombre Completo]
FROM Employees;

-- Transformación
SELECT UPPER(CompanyName) AS [Empresa en Mayusculas]
FROM Customers;
```

---

### 4.2 Funciones de Agregado

Las funciones de agregado toman múltiples filas de  y las colapsan en un único valor de salida. Si no se usa `GROUP BY`, aplicar una función de agregado convertirá toda la tabla en una sola fila de resultados.

#### Los Nulos (`NULL`)
**Todas las funciones de agregado ignoran los valores `NULL`, excepto `COUNT(*)`.**


| Función | Descripción |
| :--- | :--- |
| **`COUNT(*)`** | Cuenta el número total de filas en la tabla o grupo, sin importarle si las columnas tienen datos o están vacías. |
| **`COUNT(columna)`** | Cuenta solo las filas donde la columna especificada *NO* es `NULL`. |
| **`SUM(columna)`** | Suma todos los valores numéricos de una columna. Si encuentra un `NULL`, lo ignora como si fuera un cero. |
| **`AVG(columna)`** | Suma los valores y los divide entre la cantidad de filas *que tienen datos*.. |
| **`MAX(columna)`** | **El valor máximo.** Funciona con números (el más alto), fechas (la más reciente) y textos (el último en orden alfabético Z-A). |
| **`MIN(columna)`** | **El valor mínimo.** Funciona con números (el más bajo), fechas (la más antigua) y textos (el primero en orden alfabético A-Z). |

---

### 4.3 Alias (`AS`)

Un alias es un "apodo" temporal que se le da a una columna o a una tabla. Este apodo solo existe durante los milisegundos que tarda en ejecutarse la consulta.

#### 4.3.1 Alias de Columna

Sirven para dar nombres presentables a los resultados, especialmente cuando se usan campos calculados.

**Sintaxis permitidas en SQL Server:**
```sql
-- 1.
SELECT UnitPrice AS Precio FROM Products;

-- 2. Con espacios (Requiere corchetes)
SELECT UnitPrice AS [Precio Unitario] FROM Products;
```

---

#### 4.3.2 Alias de Tabla

Cuando se empiezan a cruzar tablas usando `INNER JOIN`, los nombres de las columnas pueden repetirse. Para evitar ambigüedad , le damos un alias de una o dos letras a las tablas en la cláusula `FROM`.

```sql
-- Sin Alias de tabla
SELECT Customers.CompanyName, Orders.OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- Con Alias de tabla
SELECT c.CompanyName, o.OrderDate
FROM Customers AS c
INNER JOIN Orders AS o 
ON c.CustomerID = o.CustomerID;
```
---

## 5. Agrupamiento y Filtrado (Mis reglas de oro)

### 5.1 Conceptos: WHERE, GROUP BY y HAVING

- **`WHERE`:** Usado para limpiar la tabla y descartar filas individuales que no me sirven. 

- **`GROUP BY`:** Una vez que el `WHERE` me deja solo las filas que me importan, se usa `GROUP BY` para "apilarlas" en grupos según alguna categoría. Esto es indispensable cuando se usan funciones de **agregado**. Por ejemplo si en mi instrucción `SELECT` pongo una columna  mezclada con una fórmula (ej. `COUNT(*)`), **estoy obligado** a poner esa columna normal dentro del `GROUP BY`.

- **`HAVING`:** Este es el segundo filtro, pero funciona muy distinto al primero. Este solo evalúa los grupos que el `GROUP BY` arma.

---

### 5.2 Tabla Comparativa: WHERE vs HAVING


| Característica | **WHERE** | **HAVING** |
| :--- | :--- | :--- |
| **Momento de acción** | Actúa **ANTES** de agrupar los datos (`GROUP BY`). | Actúa **DESPUÉS** de agrupar y calcular agregados. |
| **Qué evalúa** | Filtra **filas individuales**. | Filtra **grupos** basándose en un resultado matemático. |
| **Uso de Agregados** | **PROHIBIDO**. Dará error si se intenta usar `SUM()`, `COUNT()`, `MAX()`, etc. aquí. | **PERMITIDO Y NECESARIO**. Su propósito principal es evaluar condiciones como `SUM(ventas) > 1000`. |

---

### 6. El flujo de ejecución interno (Por qué SQL es tan estricto)

La base de datos no lee el código de arriba hacia abajo (como esta escrito), sino que lo procesa internamente en este orden:

1. **`FROM` / `JOIN`:** Primero va y busca las tablas de donde sacará la información.
2. **`WHERE`:** Aplica mi primer filtro y "tira a la basura" las filas que no cumplen la condición.
3. **`GROUP BY`:** Agarra lo que sobrevivió y arma los grupos.
4. **`HAVING`:** Revisa los grupos, hace las matemáticas y desecha los grupos que no cumplen la condición.
5. **`SELECT`:** Se fija qué columnas quiero mostrar le pone los "Alias" (los nombres temporales)
6. **`ORDER BY`:** Al final, toma el resultado y lo ordena alfabéticamente o de mayor a menor.