SELECT e.employee_id AS id, e.last_name||', '||e.first_name AS empleado, e.salary AS salario, s.grade_id AS grado_salario
FROM EMPLOYEE e
JOIN SALARY_GRADE s
    ON e.salary BETWEEN s.lower_bound AND s.upper_bound

-- Con JOIN agregas la columna que seleccionas previamente a la "tabla genérica" con tal característica
-- Por ejemplo compara los salarios con cada caso de grade_id y mete el que cumple con la característica
