-- Mostrar los empleados que ganan más que su jefe. El reporte debe mostrar el nombre
-- completo del empleado, su salario, el nombre del departamento al que pertenece y la
-- función que ejerce.

SELECT e.last_name||', '||e.first_name AS empleado,
       e.salary AS salario,
       d.name AS departamento,
       j.function AS funcion
FROM EMPLOYEE e
JOIN DEPARTMENT d
    ON e.department_id = d.department_id
JOIN JOB j
    ON e.job_id = j.job_id
JOIN EMPLOYEE boss
    ON (e.manager_id = boss.employee_id) AND (e.salary > boss.salary)
