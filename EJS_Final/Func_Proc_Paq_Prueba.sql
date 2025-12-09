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

-- ============================================
-- 1.1 - FUNCIÓN INDEPENDIENTE
-- ============================================
CREATE OR REPLACE FUNCTION obtener_id_localidad(
    p_nombre_region LOCATION.regional_group%TYPE
) RETURN LOCATION.location_id%TYPE IS
    
    v_location_id LOCATION.location_id%TYPE;
    
BEGIN
    -- 1. Validar parámetro NULL (esto SÍ hay que hacerlo manual)
    IF p_nombre_region IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Error: El nombre de región no puede ser NULL');
    END IF;
    
    -- 2. Intentar obtener el ID directamente
    --    Oracle lanzará excepciones si no encuentra o encuentra múltiples
    SELECT location_id INTO v_location_id
    FROM LOCATION
    WHERE UPPER(regional_group) = UPPER(p_nombre_region);
    
    -- 3. Si llegamos aquí, todo bien
    RETURN v_location_id;
    
EXCEPTION
    -- 4. Manejar errores conocidos de Oracle
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'Error: La región "' || p_nombre_region || '" no existe');
            
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Error: Existen múltiples regiones con el nombre "' || 
            p_nombre_region || '"');
            
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Error inesperado: ' || SQLERRM);
END obtener_id_localidad;
/

-- ============================================
-- 1.2 - PROCEDIMIENTO
-- ============================================
CREATE OR REPLACE PROCEDURE eliminar_departamentos_localidad(
    p_nombre_localidad LOCATION.regional_group%TYPE
) IS
    v_location_id LOCATION.location_id%TYPE;
    v_departamentos_eliminados NUMBER;   
BEGIN
    DBMS_OUTPUT.PUT_LINE('Proceso: Eliminar departamentos de "' || 
                        p_nombre_localidad || '"');
    
    -- 1. Saca ID con la función 1.1
    BEGIN
        v_location_id := obtener_id_localidad(p_nombre_localidad);
        DBMS_OUTPUT.PUT_LINE(' ID de la Localidad: ' || v_location_id);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' No se pudo obtener ID de la localidad');
            DBMS_OUTPUT.PUT_LINE(' Motivo: ' || SQLERRM);
            RETURN;
    END;
    
    -- 2. Eliminar departamentos
    DELETE FROM DEPARTMENT
    WHERE location_id = v_location_id;
    
    v_departamentos_eliminados := SQL%ROWCOUNT;
    IF v_departamentos_eliminados = 0 THEN
        DBMS_OUTPUT.PUT_LINE(' No hay departamentos en esta localidad');
    END IF;

    -- 3. Dice Resultados
    DBMS_OUTPUT.PUT_LINE(' Se eliminaron ' || v_departamentos_eliminados || 
                        ' departamento/s');
    DBMS_OUTPUT.PUT_LINE('Listo!');
    
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Error durante la eliminación');
        DBMS_OUTPUT.PUT_LINE(' Motivo: ' || SQLERRM);
        ROLLBACK; -- Deshace los cambios si hay alguna macana
END eliminar_departamentos_localidad;
/

-- ============================================
-- 1.3 - PAQUETE
-- ============================================
CREATE OR REPLACE PACKAGE INCREMENTO_SALARIAL IS
    
    FUNCTION SALARIO_MINIMO RETURN NUMBER;
    PROCEDURE EMPLE_BENEFICIADO(p_department_id DEPARTMENT.department_id%TYPE);
    PROCEDURE EMPLE_BENEFICIADO;
    
END INCREMENTO_SALARIAL;
/

CREATE OR REPLACE PACKAGE BODY INCREMENTO_SALARIAL IS
    
    -- ============================================
    -- FUNCIÓN PRIVADA
    -- ============================================
    FUNCTION VALIDA_DEPARTAMENTO(
        p_department_id DEPARTMENT.department_id%TYPE
    ) RETURN DEPARTMENT.department_id%TYPE IS
        v_existe NUMBER;
    BEGIN
        -- Verificar si el departamento existe
        SELECT COUNT(*) INTO v_existe
        FROM DEPARTMENT
        WHERE department_id = p_department_id;
        
        IF v_existe = 0 THEN -- CANCELA con error propio
            RAISE_APPLICATION_ERROR(-20010, 
                'El departamento ID ' || p_department_id || ' no existe');
        END IF;
        
        RETURN p_department_id;
        
    END VALIDA_DEPARTAMENTO;
    
    -- ============================================
    -- FUNCIÓN PÚBLICA: Salario mínimo
    -- ============================================
    FUNCTION SALARIO_MINIMO RETURN NUMBER IS       
        v_min_salary NUMBER;        
    BEGIN
        SELECT MIN(salary) INTO v_min_salary
        FROM EMPLOYEE;
        
        -- Si no hay empleados o todos tienen NULL
        RETURN NVL(v_min_salary, 0);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RETURN 0;
    END SALARIO_MINIMO;
    
    -- ============================================
    -- PROCEDIMIENTO PÚBLICO (sobrecarga 1)
    -- ============================================
    PROCEDURE EMPLE_BENEFICIADO(
        p_department_id DEPARTMENT.department_id%TYPE
    ) IS        
        v_department_id_validado DEPARTMENT.department_id%TYPE;
        v_salario_minimo NUMBER;
        v_emp_beneficiados NUMBER := 0;
        -- Cursor salario < 1500
        CURSOR c_empleados IS
            SELECT employee_id, last_name, salary
            FROM EMPLOYEE
            WHERE department_id = p_department_id
              AND salary < 1500;
            
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== INCREMENTO SALARIAL - DEPARTAMENTO ' || 
                            p_department_id || ' ===');
        
        -- a. Validar departamento usando función privada
        BEGIN
            v_department_id_validado := VALIDA_DEPARTAMENTO(p_department_id);
            DBMS_OUTPUT.PUT_LINE(' Departamento validado: ID ' || 
                                v_department_id_validado);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(' Departamento Inválido');
                DBMS_OUTPUT.PUT_LINE('  Motivo: ' || SQLERRM);
                RETURN;
        END;
        
        -- b. Obtener salario mínimo usando función pública
        v_salario_minimo := SALARIO_MINIMO();
        DBMS_OUTPUT.PUT_LINE(' Salario mínimo general: $' || v_salario_minimo);
        
        IF v_salario_minimo = 0 THEN
            DBMS_OUTPUT.PUT_LINE(' No hay salarios para incrementar porque es $0');
            RETURN;
        END IF;
        
        -- c. Procesar empleados con cursor
        DBMS_OUTPUT.PUT_LINE('--- Empleados con aumento ---');
        
        FOR r_empleado IN c_empleados LOOP
            -- Calcular nuevo salario
            UPDATE EMPLOYEE
            SET salary = salary + v_salario_minimo
            WHERE employee_id = r_empleado.employee_id;
            
            v_emp_beneficiados := v_emp_beneficiados + 1;
            -- Mostrar información
            DBMS_OUTPUT.PUT_LINE( r_empleado.last_name || 
                ' - Nuevo salario: $' || (r_empleado.salary + v_salario_minimo) ||
                ' (antes: $' || r_empleado.salary || ')'
            );
        END LOOP;
        
        -- Resultado final
        IF v_emp_beneficiados = 0 THEN
            DBMS_OUTPUT.PUT_LINE(' No hay empleados con salario < $1500 en este departamento');
        ELSE
            DBMS_OUTPUT.PUT_LINE(' Total empleados beneficiados: ' || v_emp_beneficiados );
        END IF;
        
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE(' Error en el proceso');
            DBMS_OUTPUT.PUT_LINE(' Motivo: ' || SQLERRM);
    END EMPLE_BENEFICIADO;
    
    -- ============================================
    -- PROCEDIMIENTO PÚBLICO (sobrecarga 2)
    -- ============================================
    PROCEDURE EMPLE_BENEFICIADO IS
    BEGIN
        -- Llama a la primera versión con departamento por defecto 10
        EMPLE_BENEFICIADO(10);
    END EMPLE_BENEFICIADO;
    
END INCREMENTO_SALARIAL;
/
-----------------------------------------------------------------------------------------------------------------------------------------
-- HABILITAR SALIDA
BEGIN
    DBMS_OUTPUT.ENABLE(NULL);
END;
/

-- ============================================
-- PRUEBA 1.1 - FUNCIÓN INDEPENDIENTE
-- ============================================
DECLARE
    v_location_id LOCATION.location_id%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA 1.1: Función obtener_id_localidad ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 1: Región existente
    DBMS_OUTPUT.PUT_LINE('Prueba 1: Región existente "DALLAS"');
    BEGIN
        v_location_id := obtener_id_localidad('DALLAS');
        DBMS_OUTPUT.PUT_LINE(' Resultado: ID = ' || v_location_id);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Error: ' || SQLERRM);
    END;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 2: Región inexistente (debe CANCELAR)
    DBMS_OUTPUT.PUT_LINE('Prueba 2: Región inexistente "NO_EXISTE"');
    BEGIN
        v_location_id := obtener_id_localidad('NO_EXISTE');
        DBMS_OUTPUT.PUT_LINE(' Resultado: ID = ' || v_location_id);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Error esperado: ' || SQLERRM);
    END;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 3: Parámetro NULL (debe CANCELAR)
    DBMS_OUTPUT.PUT_LINE('Prueba 3: Parámetro NULL');
    BEGIN
        v_location_id := obtener_id_localidad(NULL);
        DBMS_OUTPUT.PUT_LINE(' Resultado: ID = ' || v_location_id);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Error esperado: ' || SQLERRM);
    END;
    
END;
/

-- ============================================
-- PRUEBA 1.2 - PROCEDIMIENTO INDEPENDIENTE
-- ============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '================================');
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA 1.2: Procedimiento eliminar_departamentos_localidad ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 1: Localidad existente
    DBMS_OUTPUT.PUT_LINE('Prueba 1: Localidad "DALLAS"');
    eliminar_departamentos_localidad('DALLAS');
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 2: Localidad inexistente (NO debe cancelar)
    DBMS_OUTPUT.PUT_LINE('Prueba 2: Localidad inexistente "NO_EXISTE"');
    eliminar_departamentos_localidad('NO_EXISTE');
    
END;
/

-- ============================================
-- PRUEBA 1.3 - PAQUETE INCREMENTO_SALARIAL
-- ============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '================================');
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA 1.3: Paquete INCREMENTO_SALARIAL ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 1: Función pública SALARIO_MINIMO
    DBMS_OUTPUT.PUT_LINE('Prueba 1: Función SALARIO_MINIMO');
    DBMS_OUTPUT.PUT_LINE('  Salario mínimo: $' || INCREMENTO_SALARIAL.SALARIO_MINIMO());
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 2: Procedimiento con departamento específico
    DBMS_OUTPUT.PUT_LINE('Prueba 2: EMPLE_BENEFICIADO con departamento 20');
    INCREMENTO_SALARIAL.EMPLE_BENEFICIADO(20);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 3: Procedimiento con departamento inexistente (NO debe cancelar)
    DBMS_OUTPUT.PUT_LINE('Prueba 3: EMPLE_BENEFICIADO con departamento 999 (inexistente)');
    INCREMENTO_SALARIAL.EMPLE_BENEFICIADO(999);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Prueba 4: Sobrecarga (sin parámetros, usa departamento 10)
    DBMS_OUTPUT.PUT_LINE('Prueba 4: Sobrecarga EMPLE_BENEFICIADO() sin parámetros');
    INCREMENTO_SALARIAL.EMPLE_BENEFICIADO();
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '================================');
    DBMS_OUTPUT.PUT_LINE('=== TODAS LAS PRUEBAS COMPLETADAS ===');
    
END;
/
