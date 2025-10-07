-- Escribir un bloque anónimo que permita ingresar como variable de sustitución 
-- un código de producto y liste para este todo su historial de precios. Listar 
-- ordenados por fecha de vigencia. Si el producto no existe, informarlo.

DECLARE
    v_cod_prod product.product_id%TYPE;
    v_existe product.product_id%TYPE;

    CURSOR c_prec_prod (cod_prod product.product_id%TYPE) IS
        SELECT list_price,
               min_price,
               start_date,
               end_date
        FROM PRICE
        WHERE product_id = cod_prod
        ORDER BY start_date;

BEGIN
    v_cod_prod := :ingrese_codigo_del_producto;

    -- BLOQUE MUY IMPORTNTE CHEQUEAR QUE EXISTE!!!
    SELECT COUNT(*) INTO v_existe
    FROM product
    WHERE product_id = v_cod_prod;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Producto no encontrado: ' || v_cod_prod);
    END IF;

    DBMS_OUTPUT.PUT_LINE('Historial de precios del producto '||v_cod_prod);
    FOR r_prec_prod IN c_prec_prod(v_cod_prod) LOOP
        IF r_prec_prod.end_date IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Precio de lista: '|| r_prec_prod.list_price ||
                                 '   Precio mínimo: '|| r_prec_prod.min_price ||
                                 '   Vale desde '|| r_prec_prod.start_date ||
                                 ' hasta el día de la fecha');      
        ELSE          
            DBMS_OUTPUT.PUT_LINE('Precio de lista: '|| r_prec_prod.list_price ||
                                 '   Precio mínimo: '|| r_prec_prod.min_price ||
                                 '   Vale desde '|| r_prec_prod.start_date ||
                                 ' hasta '|| r_prec_prod.end_date);
        END IF;
    END LOOP;

EXCEPTION
    WHEN VALUE_ERROR THEN
        RAISE_APPLICATION_ERROR(-20002,'El valor ingresado no tiene el tipo esperado.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Ha ocurrido un error: ' || SQLERRM);
END;
