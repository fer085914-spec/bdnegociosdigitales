# Lenguaje Transact-SQL (MSServer)

## 🤷‍♀️ Fundamentos Programables

1. ¿Qué es la parte programable de T-SQL?

Es todo lo que permite:

- Usar variables
- Controlar el flujo (if/else, while)
- Crear procedimientos almacenados (Store Procedures)
- Disparadores (Triggers)
- Manejar errores 
- Crear funciones 
- Usar transacciones

Es convertir SQL en un lenguaje casi como C/Java pero dentro del motor de base de datos.

2. Variables 

📌 Una variable almacena un valor temporal

```sql
    /* ========================================= Variables en Transact-SQL ========================================= */
    DECLARE @edad INT;
    SET @edad = 21;

    PRINT @edad;
    SELECT @edad AS [EDAD];

    DECLARE @nombre AS VARCHAR(30) = 'San Gallardo';
    SELECT @nombre AS [Nombre];
    SET @nombre = 'San Adonai';
    SELECT @nombre AS [Nombre];

    /* ========================================= Ejercicio ========================================= */

    /* 
    Ejercicio 1.

        - Declarar una variable que se llame @precio
        - Asignar el valor 150
        - Calcular el IVA (16)
        - Mostar el total 

    */

    DECLARE @precio AS MONEY = 150.00;
    SELECT 
        @precio AS [Precio], 
        @precio * 0.16 AS [IVA (16%)],
        @precio * 1.16 AS [Total]
    ;


    -- Ejemplo
    DECLARE @pprecio MONEY = 150;
    DECLARE @iva DECIMAL(10,2);
    DECLARE @total MONEY;

    SET @iva = @pprecio * 0.16;
    SET @total = @pprecio + @iva;

    SELECT 
        CONCAT('$',@pprecio) AS [Precio], 
        CONCAT('$',@iva) AS [IVA (16%)],
        CONCAT('$',@total) AS [Total]
    ;
```

3. IF/ELSE

📌Definición

Permite ejecutar código segun condición.
```sql
    /* ========================================= IF / ELSE ========================================= */

    /* 
    Ejercicio 1.

        - Declarar una variable que se llame @precio
        - Asignar el valor 150
        - Calcular el IVA (16)
        - Mostar el total 

    */

    DECLARE @edad INT  = 18

    IF @edad >= 18
        PRINT 'Eres mayor de edad';
    ELSE 
        PRINT 'Eres menor de edad';


    -- De una calificación si es mayor a 7 es aprobado, si es menor a 7 es reprobado
    DECLARE @calificacion DECIMAL(10,2);
    SET @calificacion = 9.2;

    IF @calificacion >= 7
        PRINT 'Aprobado';
    ELSE 
        PRINT 'Reprobado';

    GO


    DECLARE @calificacion DECIMAL(10,2);
    SET @calificacion = 12;

    IF @calificacion<0 OR @calificacion>10
        PRINT 'Calificacion no valida'
    ELSE IF @calificacion>= 7
        PRINT 'Aprobado'
    ELSE
        PRINT 'Reprobado'
    ;

    ---------------
    DECLARE @calif DECIMAL(10,2) = 9.5

    IF @calif >= 0 AND @calif <= 10
        BEGIN 
            IF @calif >= 7.0
            BEGIN
                PRINT 'Aprobado'
            END
        ELSE
            BEGIN 
                PRINT 'Reprobado'
            END
        END
    ELSE
        BEGIN
            SELECT CONCAT(@calif, 'Esta fuera de rango') AS [Respuesta]
        END
    ;
```

4. WHILE (CICLOS)


