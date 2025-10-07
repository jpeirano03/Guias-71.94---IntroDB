-- Escribir un procedimiento que permite dar de alta un nuevo producto. 
-- El procedimiento recibe como parámetro el nombre del producto y el nuevo ID. 
-- Validar que no haya en la base un producto con el mismo nombre utilizando la función anterior. 
-- Manejar las excepciones correspondientes.

-- Informar si pudo realizar su propósito correctamente

-- Utilizar la función del punto anterior

-- Si no se pudo realizar, informar el motivo correcto. No cancelar.

CREATE OR REPLACE FUNCTION product_index(
    p_prod_name IN product.description%TYPE
) RETURN product.product_id%TYPE IS
        v_prod_id product.product_id%TYPE;
BEGIN
    SELECT product_id INTO v_prod_id
    FROM PRODUCT
    WHERE UPPER(description) = UPPER(p_prod_name);

    RETURN v_prod_id;

EXCEPTION -- Podria devolver otras cosas, y en base a eso que me de otra respuesta en el procedimiento
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN TOO_MANY_ROWS THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN 0;
END;
/

CREATE OR REPLACE PROCEDURE alta_producto(
    p_nuevo_id IN product.product_id%TYPE,
    p_nombre IN product.description%TYPE
) IS
       v_existe_id product.product_id%TYPE;
       e_producto_duplicado EXCEPTION;
       e_id_duplicado EXCEPTION;
BEGIN

    SELECT product_id INTO v_existe_id
    FROM product
    WHERE product_id = p_nuevo_id;
    IF v_existe_id IS NOT NULL THEN
        RAISE e_id_duplicado;
        RETURN;
    END IF;

    
    IF product_index(p_nombre) != 0 THEN
        RAISE e_producto_duplicado;
        RETURN;
    END IF;

    -- Insertar el nuevo producto
    INSERT INTO product (product_id, description)
    VALUES (p_nuevo_id, p_nombre);

    -- Informar éxito
    DBMS_OUTPUT.PUT_LINE('Producto "' || p_nombre || '" dado de alta correctamente con ID ' || p_nuevo_id);
EXCEPTION
    WHEN e_producto_duplicado THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un producto con el nombre: ' || p_nombre);
    WHEN e_id_duplicado THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un producto con el id: ' || p_nuevo_id);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('El valor ingresado no tiene el tipo esperado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado al dar de alta el producto: ' || SQLERRM);

-- Acá agregás tu bloque EXCEPTION como prefieras
END;
/

DECLARE
    v_id    product.product_id%TYPE := 3;         -- Cambiá este valor para probar distintos IDs
    v_nombre product.description%TYPE := 'ACE TENNIS RACKET I';  -- Cambiá este valor para probar nombres duplicados o nuevos
BEGIN
    alta_producto(v_id, v_nombre);
END;
/
