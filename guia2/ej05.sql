-- Crear un bloque anónimo para desplegar los primeros n números múltiplos de 3. El
-- valor de n debe ingresarse por pantalla usando una variable de sustitución del
-- SqlDeveloper. Si n >10 desplegar un mensaje de advertencia y terminar el bloque.

DECLARE 
    v_num NUMBER (2,0);
    n NUMBER default 1;

BEGIN

    v_num := :ingresa_un_nro;

    IF v_num <= 10 THEN
        LOOP
            DBMS_OUTPUT.PUT_LINE(n*3);
            n := n + 1;
            EXIT WHEN n > v_num ;
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('ADVERTENCIA! Nro mayor a 10. Apagando equipo...');
    END IF;
END;
