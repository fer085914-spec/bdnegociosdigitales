# Documentación Ventas de múltiples productos

Este documento describe la evolución del sistema de ventas en la base de datos `bdPracticas`, pasando de un modelo de inserción de un producto a uno de varios productos

## 1. User-Defined Table Type

Para que un **Stored Procedure** pueda recibir múltiples registros en una sola ejecución, necesitamos un contenedor. En SQL Server, esto se logra mediante un `TYPE` definido como `TABLE`.

Al usar un `TYPE`, enviamos toda la información en un solo bloque, garantizando que la venta sea un todo o nada.

![Diagrama de base de datos](/img/code.png)

---

## 2. Lógica del Stored Procedure `usp_venta_multiple`

A continuación, se desglosa el procedimiento almacenado por secciones funcionales.

### Firma del Procedimiento
El parámetro `@venta` utiliza la palabra clave `READONLY`. Esto es obligatorio en SQL Server para parámetros de tipo tabla; no se pueden modificar los datos dentro del parámetro, solo leerlos para operar con ellos.

![Diagrama de base de datos](/img/1code.png)


### Validación del Cliente
Lo primero es asegurar que el cliente que intenta realizar la compra existe en nuestro catálogo. Si no existe, no tiene sentido procesar los productos.

![Diagrama de base de datos](/img/2code.png)


### Comprobación de Integridad de Productos
Aquí aplicamos lógica matemática:
1. Contamos cuántos productos envió el usuario en el parámetro `@venta` (`@pedidos`).
2. Contamos cuántos de esos IDs realmente coinciden con nuestro catálogo `CatProducto` (`@existentes`).
3. Si los números no coinciden, significa que el usuario envió al menos un ID de producto que no existe.

![Diagrama de base de datos](/img/111.png)


### Validación de Stock
En lugar de usar un bucle (loop) para revisar producto por producto, usamos `IF EXISTS`. El motor de búsqueda recorre el carrito y lo cruza con el catálogo. Si encuentra **una sola fila** donde la cantidad pedida supere la existencia, detiene todo el proceso.

![Diagrama de base de datos](/img/4code.png)


### Registro de la Venta
Una vez superadas las validaciones, generamos el registro principal en `tblVenta`. Usamos `SCOPE_IDENTITY()` para capturar el ID de venta que se acaba de generar y así poder usarlo en los detalles.

![Diagrama de base de datos](/img/5code.png)


### Inserción Masiva de Detalles e Inventario
Para el detalle, hacemos un `INSERT INTO ... SELECT`. Vincula los precios del catálogo con las cantidades del parámetro en un solo paso. Finalmente, el `UPDATE` resta el stock de todos los productos involucrados simultáneamente.

![Diagrama de base de datos](/img/6code.png)


### Manejo de Excepciones
Si ocurre un error en cualquier punto (incluyendo los `THROW` personalizados), el bloque `CATCH` asegura que no se guarde nada a medias mediante el `ROLLBACK`.

![Diagrama de base de datos](/img/7code.png)


---

## 3. Guía de Uso y Pruebas

Para ejecutar este proceso, se debe instanciar la variable de tabla, llenarla y pasarla al procedimiento.


![Diagrama de base de datos](/img/8code.png)


### Pruebas de uso y ejecucion 

- Caso exitoso

![Diagrama de base de datos](/img/8code.png)

- Caso con error de cliente

![Diagrama de base de datos](/img/9code.png)
![Diagrama de base de datos](/img/c1.png)

- Caso con error de producto

![Diagrama de base de datos](/img/5464.png)
![Diagrama de base de datos](/img/c4.png)

- Caso con error de stock

![Diagrama de base de datos](/img/11code.png)
![Diagrama de base de datos](/img/c2.png)

## Tablas con ventas exitosas

![Diagrama de base de datos](/img/cf.png)