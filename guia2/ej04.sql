-- Modificar el ejercicio 3 incluyendo dentro del ciclo un punto de control donde se
-- verifique si el numero que se esta por imprimir es mayor a 12, en cuyo caso imprimir un
-- cartel por consola que diga ‘El numero es mayor a 12’, de lo contrario sumarle al numero
-- el doble de si mismo menos 3 e imprimir el resultado

DECLARE
    v_num NUMBER(10,0);
    n NUMBER default 0;

BEGIN

    v_num := :pone_nro_max_10_digitos;

    LOOP 
        IF v_num > 12 AND n = 0 THEN
            DBMS_OUTPUT.PUT_LINE('El numero es mayor a 12');
        ELSIF n = 0 THEN
            v_num := v_num + (2*v_num - 3);
        END IF;
        
        
        DBMS_OUTPUT.PUT_LINE(n);
        n := n + 1;

        EXIT WHEN n > v_num;
    END LOOP;
END;
