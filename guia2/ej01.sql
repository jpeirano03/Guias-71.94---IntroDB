-- Determinar si estas declaraciones son correctas. (se puede crear bloques anónimos con
-- la parte ejecutable con null;)

DECLARE
    V_var  NUMBER(8,3); -- BIEN, max 8 nros con 3 dnros decimales obligatorios, te limita hasta el nro 99999.9994 (Ej: 123456.3555 MAL ; 12345,3269 --> 12345,327)
    V_a, V-b number; -- MAL, no podes poner guión medio (-) y tampoco poner dos variables asi, se deberian separar y por ';', no por ','
        V_a NUMBER;
        V_b NUMBER;
    V_fec_ingreso Date := sysdate +2; -- BIEN, te muestra el día de hoy + 2 días
    V_nombre VARCHAR2(30) NOT NULL; -- MAL, si queremos que sea 'not null' debemos ahora darle un valor de entrada (inicializarla) para que compile bien
        V_nombre VARCHAR2(30) NOT NULL := 'Juan';
    V_logico boolean default ‘TRUE’; -- MAL, las comillas no van
        V_logico boolean default TRUE;

BEGIN

NULL;

END;
