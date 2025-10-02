-- Mostrar la cantidad de empleados que tiene los departamentos 20 y 30.

SELECT department_id, COUNT(*) AS cantidad_de_empleados
FROM EMPLOYEE
WHERE department_id IN (20, 30)
GROUP BY  department_id
