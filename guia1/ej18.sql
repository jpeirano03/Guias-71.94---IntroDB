-- Mostrar el promedio de salarios de los empleados de los departamentos de
-- investigación (Research). Redondear el promedio a dos decimales.

SELECT department_id, ROUND(AVG(salary),2)
FROM EMPLOYEE
WHERE department_id IN (SELECT department_id
                          FROM DEPARTMENT
                          WHERE name = :depto)
GROUP BY department_id
