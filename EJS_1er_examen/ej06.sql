-- Escribir una función que recibe como parámetro un nombre de producto y retorna su ID o 
-- cancela con excepciones propias indicando el error en el mensaje del error. 
-- Contemplar todo error posible.

CREATE OR REPLACE FUNCTION product_index(
    p_prod_name IN product.description%TYPE
) RETURN product.product_id%TYPE IS
        v_prod_id product.product_id%TYPE;
BEGIN
    SELECT product_id INTO v_prod_id
    FROM PRODUCT
    WHERE UPPER(description) = UPPER(p_prod_name);

    RETURN v_prod_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Producto no encontrado: ' || p_prod_name);
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Existe mas de un prodcuto con el siguiente nombre:' || p_prod_name);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error inesperado al buscar el producto: ' || SQLERRM);
END;

DECLARE
    v_id NUMBER;
BEGIN
    v_id := product_index('ACE TENNIS RACKET I');  -- Suponiendo que hay varios productos con ese nombre
    DBMS_OUTPUT.PUT_LINE('ID del producto: ' || v_id);
END;
