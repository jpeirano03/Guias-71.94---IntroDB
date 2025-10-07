-- Escribir un procedimiento que permita actualizar el salario de un empleado.
-- Recibirá como parámetros el id del empleado y el nuevo salario.

-- El nuevo salario debe superar el salario promedio de todos los empleados del 
-- departamento al que pertenece el empleado y no puede superar el máximo salario de ese departamento. 

-- La validación se realiza mediante una función.

-- Informar si el salario se actualizó correctamente y si no se pudo realizar informar el motivo. No cancelar.



CREATE OR REPLACE FUNCTION salario_check( 
    p_salario IN employee.salary%TYPE, p_emp_id IN employee.employee_id%TYPE 
    ) RETURN boolean IS 
    v_depto_id employee.department_id%TYPE; 
    v_avg_salary employee.salary%TYPE; 
    v_max_salary employee.salary%TYPE;

    e_empleado_no_encontrado EXCEPTION;
    e_datos_departamento_invalidos EXCEPTION;
BEGIN 
    SELECT department_id INTO v_depto_id 
    FROM employee 
    WHERE employee_id = p_emp_id;

    SELECT AVG(salary), MAX(salary)
    INTO v_avg_salary, v_max_salary
    FROM employee
    WHERE department_id = v_depto_id;

    IF (p_salario > v_avg_salary) AND (p_salario <= v_max_salary) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;    
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        RETURN FALSE; 
    WHEN OTHERS THEN 
    RETURN FALSE; 
END;

CREATE OR REPLACE PROCEDURE nuevo_salario (
    p_emp_id IN employee.employee_id%TYPE,
    p_salario_n IN employee.salary%TYPE
) IS
    v_valido BOOLEAN;
    v_existe NUMBER;

    e_empleado_no_encontrado EXCEPTION;
    e_salario_invalido EXCEPTION;
BEGIN
    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO v_existe
    FROM employee
    WHERE employee_id = p_emp_id;

    IF v_existe = 0 THEN
        RAISE e_empleado_no_encontrado;
    END IF;

    -- Validar salario
    v_valido := salario_check(p_salario_n, p_emp_id);

    IF NOT v_valido THEN
        RAISE e_salario_invalido;
    END IF;

    -- Actualizar salario
    UPDATE employee
    SET salary = p_salario_n
    WHERE employee_id = p_emp_id;

    DBMS_OUTPUT.PUT_LINE('Salario actualizado correctamente.');

EXCEPTION
    WHEN e_empleado_no_encontrado THEN
        RAISE_APPLICATION_ERROR(-20001, 'El empleado no existe.');
    WHEN e_salario_invalido THEN
        RAISE_APPLICATION_ERROR(-20002, 'El nuevo salario no cumple las condiciones del departamento.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error inesperado: ' || SQLERRM);
END;
/



DECLARE
    v_id NUMBER := 101;         -- Cambiá por un ID válido
    v_salario NUMBER := 5000;   -- Cambiá por el nuevo salario
BEGIN
    nuevo_salario(v_id, v_salario);
END;
