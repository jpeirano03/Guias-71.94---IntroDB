-- Crear un bloque anónimo donde se le solicite al usuario que ingrese una letra (de entre
-- la A y la E). A continuación construir la estructura de control que permita según la letra
-- que el usuario haya ingresado, indicarle con un mensaje que debe ingresar el nombre de
-- un animal que empiece con dicha letra. Imprimir el nombre del animal por consola.

DECLARE
        v_letra CHAR(1);
        v_animal VARCHAR2(50);
BEGIN
    v_letra := UPPER(:ingrese_letra_entre_A_y_E);
    v_animal := UPPER(:ingrese_animal_con_esa);
    IF (v_letra IN ('A', 'B', 'C', 'D', 'E')) AND (v_animal LIKE v_letra || '%') THEN
        DBMS_OUTPUT.PUT_LINE('El nombre del animal es: ' || v_animal);
    ELSIF (v_letra IN ('A', 'B', 'C', 'D', 'E')) AND (v_animal NOT LIKE v_letra || '%') THEN
        DBMS_OUTPUT.PUT_LINE('Nombre de animal incorrecto, vuelva a ingresarlo.');
    ELSIF (v_letra NOT IN ('A', 'B', 'C', 'D', 'E')) AND (v_animal LIKE v_letra || '%') THEN
        DBMS_OUTPUT.PUT_LINE('Dale, pone una letra entre la A y la E :(');
        DBMS_OUTPUT.PUT_LINE('El nombre del animal está correcto y es: ' || v_animal);
    ELSE
                DBMS_OUTPUT.PUT_LINE('No entendiste nada pibe.');
    END IF;
END;
