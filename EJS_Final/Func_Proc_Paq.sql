/*
1.1 - Escribir una función que recibe como parámetro un nombre de una región 
(regional_group) y retorna su ID (location_id) o cancela con excepciones 
propias indicando el error en el mensaje del error. Contemplar todo error posible.

1.2 - Escribir un procedimiento que permite eliminar todos los departamentos 
de una localidad.
El procedimiento recibe como parámetro el nombre de la localidad y obtiene su 
ID utilizando la función del punto 1.1
Manejar las excepciones correspondientes:
* Informar si pudo realizar su propósito correctamente
* Si no se pudo realizar informar el motivo correcto. No Cancelar

1.3 Crear un paquete INCREMENTO_SALARIAL que permita incrementar el salario del 
personal de un departamento siempre que el empleado tenga un salario inferior a 
$1500.
El package debe contener:

* Una función privada, VALIDA_DEPARTAMENTO que recibe como parámetro el id del 
departamento (department_id) y un error propio si el departamento no 
existe, y si existe devuelve el id del departamento (department_id).

* Una función pública SALARIO_MINIMO para obtener el mínimo salario de todos 
los empleados.

* Un procedimiento público: EMPLE_BENEFICIADO que recibe como parámetro el id del 
departamento correspondiente a los empleados que recibirán el incremento salarial.
    Este procedimiento debe:
    a. Usar la función VALIDA_DEPARTAMENTO para verificar que el departamento existe; si 
    el departamento no existe informar 'Departamento Inválido'. No Cancelar.
    b. Usar la función SALARIO_MINIMO para obtener el salario mínimo.
    c. Usar un cursor para seleccionar todos los empleados del departamento ingresado que 
    ganan menos de $1500. Luego recorriendo el cursor, a cada empleado, aumentarle el 
    salario sumándole el salario mínimo obtenido en el punto b). Mostrar el Apellido 
    (last_name) y nuevo salario del empleado.

* Un segundo procedimiento público utilizando sobrecarga de EMPLE_BENEFICIADO pero que no 
recibe parámetros. En cuyo caso se utilizará como departamento por defecto el 10 
(no repetir código).
*/

-- EJERCICIO 1.1-------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION encontrar_id_region(
    p_regional_group IN VARCHAR2
) RETURN NUMBER IS
    v_location_id NUMBER;
    v_contador NUMBER;
    
    -- Excepciones propias
    region_nula_exception EXCEPTION;
    region_no_existe_exception EXCEPTION;
    region_duplicada_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT(region_nula_exception, -20001);
    PRAGMA EXCEPTION_INIT(region_no_existe_exception, -20002);
    PRAGMA EXCEPTION_INIT(region_duplicada_exception, -20003);
BEGIN
    -- Verificar que el parámetro no sea nulo
    IF p_regional_group IS NULL THEN
        RAISE region_nula_exception;
    END IF;
    
    -- Verificar si existe la región
    SELECT COUNT(*) INTO v_contador
    FROM location
    WHERE UPPER(regional_group) = UPPER(p_regional_group);
    
    IF v_contador = 0 THEN
        RAISE region_no_existe_exception;
    ELSIF v_contador > 1 THEN
        RAISE region_duplicada_exception;
    END IF;
    
    -- Obtener el location_id
    SELECT location_id INTO v_location_id
    FROM location
    WHERE UPPER(regional_group) = UPPER(p_regional_group);
    
    RETURN v_location_id;
    
EXCEPTION
    WHEN region_nula_exception THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: El nombre de la región no puede ser nulo');
    WHEN region_no_existe_exception THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: La región ' || p_regional_group || ' no existe');
    WHEN region_duplicada_exception THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: Existe más de una región con el nombre ' || p_regional_group);
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'ERROR: No se encontró la región ' || p_regional_group);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20099, 'ERROR inesperado: ' || SQLERRM);
END encontrar_id_region;
/

-- EJERCICIO 1.2----------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE eliminar_departamentos_localidad(
    p_nombre_localidad IN VARCHAR2
) IS
    v_location_id NUMBER;
    v_departamentos_eliminados NUMBER := 0;
    v_error_ocurrido BOOLEAN := FALSE;
    v_mensaje_error VARCHAR2(4000);
    
    -- Excepciones específicas
    ex_no_existe_localidad EXCEPTION;
    ex_restriccion_integridad EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_restriccion_integridad, -2292);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== INICIANDO ELIMINACIÓN ===');
    DBMS_OUTPUT.PUT_LINE('Localidad solicitada: ' || p_nombre_localidad);
    
    -- Paso 1: Obtener el ID usando la función del punto 1.1
    BEGIN
        v_location_id := encontrar_id_region(p_nombre_localidad);
        DBMS_OUTPUT.PUT_LINE('✓ ID Localidad encontrado: ' || v_location_id);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('✗ ERROR obteniendo ID: ' || SQLERRM);
            v_error_ocurrido := TRUE;
            v_mensaje_error := 'No se pudo obtener ID de localidad: ' || SQLERRM;
    END;
    
    -- Si no hubo error, proceder con eliminación
    IF NOT v_error_ocurrido THEN
        -- Verificar si hay departamentos en esa localidad
        SELECT COUNT(*) INTO v_departamentos_eliminados
        FROM department
        WHERE location_id = v_location_id;
        
        DBMS_OUTPUT.PUT_LINE('Departamentos encontrados: ' || v_departamentos_eliminados);
        
        IF v_departamentos_eliminados = 0 THEN
            DBMS_OUTPUT.PUT_LINE('ℹ No hay departamentos para eliminar');
        ELSE
            BEGIN
                -- Intentar eliminar departamentos
                DELETE FROM department
                WHERE location_id = v_location_id;
                
                v_departamentos_eliminados := SQL%ROWCOUNT;
                
                IF v_departamentos_eliminados > 0 THEN
                    COMMIT;
                    DBMS_OUTPUT.PUT_LINE('✓ ÉXITO: ' || v_departamentos_eliminados || ' departamento(s) eliminado(s)');
                END IF;
                
            EXCEPTION
                WHEN ex_restriccion_integridad THEN
                    -- Integridad referencial (FK constraint)
                    v_error_ocurrido := TRUE;
                    v_mensaje_error := 'No se pueden eliminar departamentos con empleados asignados';
                    DBMS_OUTPUT.PUT_LINE('✗ ' || v_mensaje_error);
                    
                WHEN OTHERS THEN
                    v_error_ocurrido := TRUE;
                    v_mensaje_error := SQLERRM;
                    DBMS_OUTPUT.PUT_LINE('✗ ERROR inesperado: ' || v_mensaje_error);
            END;
        END IF;
    END IF;
    
    -- Informe final (NO CANCELAR, solo informar)
    DBMS_OUTPUT.PUT_LINE('=== INFORME FINAL ===');
    IF v_error_ocurrido THEN
        DBMS_OUTPUT.PUT_LINE('RESULTADO: FALLIDO');
        DBMS_OUTPUT.PUT_LINE('MOTIVO: ' || v_mensaje_error);
    ELSE
        DBMS_OUTPUT.PUT_LINE('RESULTADO: EXITOSO');
        DBMS_OUTPUT.PUT_LINE('DEPARTAMENTOS ELIMINADOS: ' || v_departamentos_eliminados);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('====================');
    
EXCEPTION
    -- Captura global para asegurar que NO CANCELA
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ ERROR NO CONTROLADO: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('RESULTADO: FALLIDO');
        DBMS_OUTPUT.PUT_LINE('MOTIVO: Error no controlado en el procedimiento');
END eliminar_departamentos_localidad;
/

--EJERCICIO 1.3-------------------------------------------------------------------------------------------------------------------------
-- ESPECIFICACIÓN DEL PAQUETE
CREATE OR REPLACE PACKAGE incremento_salarial IS
    FUNCTION salario_minimo RETURN NUMBER;     -- Función pública para obtener el mínimo salario
    
    PROCEDURE emple_beneficiado(p_department_id IN NUMBER);    -- Procedimiento público con parámetro
    
    PROCEDURE emple_beneficiado;    -- Sobrecarga del procedimiento sin parámetros
    
    LIMITE_SALARIO CONSTANT NUMBER := 1500;    -- Constante para el límite salarial
    
END incremento_salarial;
/

-- CUERPO DEL PAQUETE (CORREGIDO según diseño de tablas)
CREATE OR REPLACE PACKAGE BODY incremento_salarial IS
    -- Variable para cachear salario mínimo
    g_salario_minimo NUMBER := NULL;
    
    -- EXCEPCIÓN PROPIA para departamento inválido
    departamento_invalido_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT(departamento_invalido_exception, -20101);
    
    -- Función privada VALIDA_DEPARTAMENTO (debe LANZAR error propio)
    FUNCTION valida_departamento(
        p_department_id IN NUMBER
    ) RETURN NUMBER IS
        v_dept_id NUMBER;
        v_nombre_dept department.name%TYPE;
    BEGIN
        -- Buscar el departamento
        SELECT department_id, name 
        INTO v_dept_id, v_nombre_dept
        FROM department
        WHERE department_id = p_department_id;
        
        DBMS_OUTPUT.PUT_LINE('Departamento validado: ' || v_nombre_dept || ' (ID: ' || v_dept_id || ')');
        RETURN v_dept_id;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- LANZAR error propio como indica la consigna
            RAISE departamento_invalido_exception;
        WHEN OTHERS THEN
            RAISE;
    END valida_departamento;
    
    -- Función pública SALARIO_MINIMO
    FUNCTION salario_minimo RETURN NUMBER IS
        v_min_salary NUMBER;
    BEGIN
        -- Si ya se calculó, usar valor cacheado
        IF g_salario_minimo IS NOT NULL THEN
            RETURN g_salario_minimo;
        END IF;
        
        -- Calcular salario mínimo de TODOS los empleados
        SELECT MIN(salary) INTO v_min_salary
        FROM employee;
        
        -- Manejar caso sin empleados
        IF v_min_salary IS NULL THEN
            v_min_salary := 0;
        END IF;
        
        -- Cachear resultado
        g_salario_minimo := v_min_salary;
        
        RETURN v_min_salary;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_salario_minimo := 0;
            RETURN 0;
        WHEN OTHERS THEN
            RAISE;
    END salario_minimo;
    
    -- Procedimiento principal EMPLE_BENEFICIADO
    PROCEDURE emple_beneficiado(p_department_id IN NUMBER) IS
        v_dept_valido NUMBER;
        v_salario_min NUMBER;
        v_contador_empleados NUMBER := 0;
        v_empleados_actualizados NUMBER := 0;
        
        -- Cursor EXPLÍCITO como indica la consigna
        CURSOR c_empleados_baja_salario IS
            SELECT employee_id, last_name, salary
            FROM employee
            WHERE department_id = p_department_id
              AND salary < LIMITE_SALARIO
            ORDER BY last_name;
            
        r_empleado c_empleados_baja_salario%ROWTYPE;
        
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PROCESANDO DEPARTAMENTO ID: ' || p_department_id || ' ===');
        
        -- a. Validar departamento usando función privada
        BEGIN
            v_dept_valido := valida_departamento(p_department_id);
        EXCEPTION
            WHEN departamento_invalido_exception THEN
                -- NO CANCELAR, solo informar
                DBMS_OUTPUT.PUT_LINE('Departamento Inválido');
                RETURN;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error validando departamento: ' || SQLERRM);
                RETURN;
        END;
        
        -- b. Obtener salario mínimo usando función pública
        v_salario_min := salario_minimo();
        DBMS_OUTPUT.PUT_LINE('Salario mínimo global: $' || v_salario_min);
        
        IF v_salario_min <= 0 THEN
            DBMS_OUTPUT.PUT_LINE('No se puede aplicar incremento. Salario mínimo es 0 o no hay empleados.');
            RETURN;
        END IF;
        
        -- Contar empleados que cumplen condiciones
        SELECT COUNT(*) INTO v_contador_empleados
        FROM employee
        WHERE department_id = p_department_id
          AND salary < LIMITE_SALARIO;
        
        DBMS_OUTPUT.PUT_LINE('Empleados candidatos: ' || v_contador_empleados);
        
        -- c. Usar cursor para procesar empleados
        IF v_contador_empleados > 0 THEN
            DBMS_OUTPUT.PUT_LINE('--- LISTA DE EMPLEADOS BENEFICIADOS ---');
            
            OPEN c_empleados_baja_salario;
            LOOP
                FETCH c_empleados_baja_salario INTO r_empleado;
                EXIT WHEN c_empleados_baja_salario%NOTFOUND;
                
                -- Calcular nuevo salario
                DECLARE
                    v_nuevo_salario employee.salary%TYPE;
                BEGIN
                    v_nuevo_salario := r_empleado.salary + v_salario_min;
                    
                    -- Actualizar empleado
                    UPDATE employee
                    SET salary = v_nuevo_salario
                    WHERE employee_id = r_empleado.employee_id;
                    
                    v_empleados_actualizados := v_empleados_actualizados + 1;
                    
                    -- Mostrar información como indica la consigna
                    DBMS_OUTPUT.PUT_LINE(
                        'Empleado: ' || RPAD(r_empleado.last_name, 15) ||
                        ' | Nuevo Salario: $' || TO_CHAR(v_nuevo_salario, '999,990.00')
                    );
                    
                END;
            END LOOP;
            CLOSE c_empleados_baja_salario;
            
            -- Confirmar cambios
            IF v_empleados_actualizados > 0 THEN
                COMMIT;
                DBMS_OUTPUT.PUT_LINE('--- RESUMEN ---');
                DBMS_OUTPUT.PUT_LINE('Total actualizado: ' || v_empleados_actualizados || ' empleado(s)');
                DBMS_OUTPUT.PUT_LINE('Incremento aplicado: $' || v_salario_min || ' por empleado');
            END IF;
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('No hay empleados con salario menor a $' || LIMITE_SALARIO);
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('======================================');
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Asegurar que el cursor se cierra
            IF c_empleados_baja_salario%ISOPEN THEN
                CLOSE c_empleados_baja_salario;
            END IF;
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR en el procesamiento: ' || SQLERRM);
    END emple_beneficiado;
    
    -- Sobrecarga sin parámetros (departamento 10 por defecto)
    PROCEDURE emple_beneficiado IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Ejecutando versión sin parámetros (Departamento 10 por defecto)');
        DBMS_OUTPUT.PUT_LINE('======================================');
        emple_beneficiado(10);  -- Reutiliza código, no se repite
    END emple_beneficiado;
    
    -- Bloque de inicialización
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Paquete INCREMENTO_SALARIAL cargado correctamente');
        DBMS_OUTPUT.PUT_LINE('Límite salarial establecido en: $' || LIMITE_SALARIO);
        
END incremento_salarial;
/


-- PRUEBAS DE LOS INCISOS------------------------------------------------------------------------------------------


BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA FUNCIÓN 1.1 ===');
    
    DECLARE
        v_id NUMBER;
    BEGIN
        -- Caso correcto
        v_id := encontrar_id_region('NORTE');
        DBMS_OUTPUT.PUT_LINE('NORTE → ID: ' || v_id);
        
        -- Caso con error (debe cancelar)
        BEGIN
            v_id := encontrar_id_region('NOEXISTE');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error controlado: ' || SQLERRM);
        END;
        
        -- Caso nulo (debe cancelar)
        BEGIN
            v_id := encontrar_id_region(NULL);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error controlado: ' || SQLERRM);
        END;
    END;
END;
/

-- 4. Prueba del procedimiento 1.2
BEGIN
    DBMS_OUTPUT.PUT_LINE(chr(10) || '=== PRUEBA PROCEDIMIENTO 1.2 ===');
    
    -- Prueba con localidad que tiene departamentos
    DBMS_OUTPUT.PUT_LINE('--- Prueba 1: Localidad NORTE ---');
    eliminar_departamentos_localidad('NORTE');
    
    -- Prueba con localidad sin departamentos
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- Prueba 2: Localidad ESTE ---');
    eliminar_departamentos_localidad('ESTE');
    
    -- Prueba con localidad inexistente
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- Prueba 3: Localidad OESTE (no existe) ---');
    eliminar_departamentos_localidad('OESTE');
END;
/

-- 5. Prueba del paquete 1.3
BEGIN
    DBMS_OUTPUT.PUT_LINE(chr(10) || '=== PRUEBA PAQUETE 1.3 ===');
    
    -- Ver salarios antes
    DBMS_OUTPUT.PUT_LINE('--- SALARIOS ANTES ---');
    FOR r IN (SELECT department_id, last_name, salary 
              FROM employee 
              ORDER BY department_id, last_name) LOOP
        DBMS_OUTPUT.PUT_LINE('Dept ' || NVL(r.department_id, 'NULL') || ': ' || 
                            r.last_name || ' - $' || r.salary);
    END LOOP;
    
    -- Probar función salario_minimo
    DECLARE
        v_minimo NUMBER;
    BEGIN
        v_minimo := incremento_salarial.salario_minimo();
        DBMS_OUTPUT.PUT_LINE(chr(10) || 'Salario mínimo calculado: $' || v_minimo);
    END;
    
    -- Probar con departamento válido (20)
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- Prueba Dept 20 (IT) ---');
    incremento_salarial.emple_beneficiado(20);
    
    -- Probar con departamento inválido (debe informar sin cancelar)
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- Prueba Dept 99 (no existe) ---');
    incremento_salarial.emple_beneficiado(99);
    
    -- Probar sobrecarga sin parámetros (dept 10)
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- Prueba sin parámetros (default 10) ---');
    incremento_salarial.emple_beneficiado;
    
    -- Ver salarios después
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- SALARIOS DESPUÉS ---');
    FOR r IN (SELECT department_id, last_name, salary 
              FROM employee 
              ORDER BY department_id, last_name) LOOP
        DBMS_OUTPUT.PUT_LINE('Dept ' || NVL(r.department_id, 'NULL') || ': ' || 
                            r.last_name || ' - $' || r.salary);
    END LOOP;
    
END;
/

-- Consulta final para verificar
SELECT d.department_id, d.name, 
       COUNT(e.employee_id) as num_empleados,
       MIN(e.salary) as min_salario,
       MAX(e.salary) as max_salario
FROM department d
LEFT JOIN employee e ON d.department_id = e.department_id
GROUP BY d.department_id, d.name
ORDER BY d.department_id;
