-- Realizar un bloque anónimo que muestre todos los productos (PRODUCT) con sus precios (PRICE) y los ítems correspondientes (ITEM).
        -- En caso de que no haya ítems para un producto, mostrar el mensaje correspondiente.
        -- Ordenar por el PRODUCT_ID. Los ítems deben estar ordenados por ACTUAL_PRICE de mayor a menor.

-- El formato de salida debe ser el siguiente:
-- Producto 1: Laptop - Precio de lista $1500 - Precio mínimo $1200  
-- ID Item Precio Actual Cantidad Total  
-- 101 1400 2 2800  
-- 102 1350 1 1350  
-- 103 1300 3 3900  
-- Cantidad total de ítems: 6  

-- Producto 2: Smartphone - Precio de lista $800 - Precio mínimo $700  
-- No hay ítems para este producto  

-- Producto 3: TV - Precio de lista $2000 - Precio mínimo $1800  
-- ID Item Precio Actual Cantidad Total  
-- 201 1900 1 1900  
-- 202 1850 2 3700  
-- Cantidad total de ítems: 3  

--ACALRACIONES:
    -- Manejar todos los errores adecuadamente
    -- Evitar accesos innecesarios a la base

DECLARE
    -- Cursor principal: productos con su precio de lista y mínimo
    CURSOR c_productos IS
        SELECT p.product_id,
               p.description,
               pr.list_price,
               pr.min_price
        FROM product p
        JOIN price pr
            ON p.product_id = pr.product_id
        WHERE pr.end_date IS NULL  -- suponemos que el precio actual no tiene fecha de fin
        ORDER BY p.product_id;

    -- Cursor secundario: ítems de cada producto
    CURSOR c_items (v_product_id product.product_id%TYPE) IS
        SELECT item_id,
               actual_price,
               quantity,
               total
        FROM item
        WHERE product_id = v_product_id
        ORDER BY actual_price DESC;

    -- Variables de uso interno
    v_total_items NUMBER := 0;

BEGIN
    FOR r_prod IN c_productos LOOP
        DBMS_OUTPUT.PUT_LINE('Producto ' || r_prod.product_id || ': ' ||
                             r_prod.description ||
                             ' - Precio de lista $' || r_prod.list_price ||
                             ' - Precio mínimo $' || r_prod.min_price);

        v_total_items := 0;

        -- Bandera para saber si hay ítems
        DECLARE
            v_hay_items BOOLEAN := FALSE;
        BEGIN
            FOR r_item IN c_items(r_prod.product_id) LOOP
                IF v_hay_items = FALSE THEN
                    DBMS_OUTPUT.PUT_LINE('ID Item  |  Precio Actual  |  Cantidad  |  Total');
                    v_hay_items := TRUE;
                END IF;

                DBMS_OUTPUT.PUT_LINE(
                    r_item.item_id || '   ' ||
                    r_item.actual_price || '   ' ||
                    r_item.quantity || '   ' ||
                    r_item.total
                );

                v_total_items := v_total_items + r_item.quantity;
            END LOOP;

            IF v_hay_items THEN
                DBMS_OUTPUT.PUT_LINE('Cantidad total de ítems: ' || v_total_items);
            ELSE
                DBMS_OUTPUT.PUT_LINE('No hay ítems para este producto');
            END IF;
        END;

        DBMS_OUTPUT.PUT_LINE(''); -- línea en blanco para separar productos
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron productos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
