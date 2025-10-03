-- Crear un bloque anónimo para desplegar los siguientes mensajes:
-- ‘Hola , soy ‘ username
-- ‘Hoy es: ‘ dd – Mon – yyyy’. (mostrar la fecha del día)

DECLARE
    v_nom VARCHAR2(30);
    v_date DATE := sysdate;

BEGIN
v_nom := :nombre;
DBMS_OUTPUT.PUT_LINE('Hola, soy ' || v_nom);
DBMS_OUTPUT.PUT_LINE('Hoy es: ' || TO_CHAR(v_date,'DD-Mon-YYYY'));

END;
