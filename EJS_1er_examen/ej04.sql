-- Escribir una función que reciba el CUSTOMER_ID y devuelva el total de ventas asociadas 
-- (SALES_ORDER). Si no se puede informar, indicar el motivo mediante excepción personalizada. 
-- Invocar la función desde un bloque anónimo y catchee la excepción personalizada.

-- =======================================================
-- Definición de la función
-- =======================================================
CREATE OR REPLACE FUNCTION total_ventas_cliente (
    p_customer_id IN customer.customer_id%TYPE
) RETURN NUMBER IS
    v_total NUMBER;
    v_existe NUMBER;
    e_cliente_invalido EXCEPTION;      -- excepción personalizada
    e_sin_ventas EXCEPTION;            -- excepción personalizada
BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*) INTO v_existe
    FROM customer
    WHERE customer_id = p_customer_id;

    IF v_existe = 0 THEN
        RAISE e_cliente_invalido;
    END IF;

    -- Calcular el total de ventas
    SELECT NVL(SUM(total), 0)
    INTO v_total
    FROM sales_order
    WHERE customer_id = p_customer_id;

    -- Si no tiene ventas, lanzar otra excepción
    IF v_total = 0 THEN
        RAISE e_sin_ventas;
    END IF;

    RETURN v_total;

EXCEPTION
    WHEN e_cliente_invalido THEN
        RAISE_APPLICATION_ERROR(-20001, 'El cliente no existe.');
    WHEN e_sin_ventas THEN
        RAISE_APPLICATION_ERROR(-20002, 'El cliente no tiene ventas registradas.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error inesperado al calcular ventas: ' || SQLERRM);
END;
/
-- ← ESTE SLASH es obligatorio: compila la función


-- =======================================================
-- Bloque anónimo para probar la función
-- =======================================================
DECLARE
    v_customer_id customer.customer_id%TYPE;  -- cambiá según tus datos
    v_total NUMBER;
BEGIN
    v_customer_id := :ingrese_id_cliente;
    v_total := total_ventas_cliente(v_customer_id);
    DBMS_OUTPUT.PUT_LINE('Total de ventas del cliente ' || v_customer_id || ': $' || v_total);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
-- ← ESTE SLASH ejecuta el bloque anónimo

