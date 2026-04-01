# Triggers en SQL Server

## 1. ¿Qué es un Triggers?

Un trigger (disparador) es un bloque dde código SQL que se ejecuta automaticamente cuando ocurre un evento en una tabla.

▫️Eventos principales:
- INSERT
- DELETE
- UPDATE

Nota: No se ejecutan manualmente, se ejecutan solos

## 2. ¿Para que sirven?
 - Validaciones
 - Auditoría (guardar historial)
 - Reglas de negocio
 - Automatización

## 3. Tipos de Triggers en SQL Server

Se ejecuta despues del evento
- INSTEAD OF TRIGGER

Reemplaza la operación original

## 4. Sintaxis basica

``` sql
    CREATE OR ALTER TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT
    AS
    BEGIN
    END;
```

## 5. Tablas especiales

| Tabla | Contenido |
| :--- | :--- |
| INSERTED | Nuevos datos |
| DELETED | Datos anteriores |