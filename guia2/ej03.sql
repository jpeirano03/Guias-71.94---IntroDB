-- Crear un bloque anónimo en el cual se le pida al usuario que ingrese un numero por
-- consola. A continuación construir un ciclo que itere desde 1 hasta el numero ingresado
-- por el usuario, imprimiendo por pantalla el numero por el que va.

DECLARE
    v_num NUMBER(10,0);

BEGIN

v_num := :pone_nro_max_10_digitos;

    FOR i IN 1..v_num LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;

END;
