-- Generar un listado con el nombre completo de los empleados, el salario, y el nombre
-- de su departamento para todos los empleados que tengan el mismo cargo que John
-- Smith. Ordenar la salida por salario y apellido.

SELECT e.last_name||', '||e.first_name AS nombre,
       e.salary AS salario,
       dep.name AS departamento
FROM EMPLOYEE e
JOIN DEPARTMENT dep
    ON e.department_id = dep.department_id
WHERE e.job_id = (SELECT job_id
                   FROM EMPLOYEE
                   WHERE last_name = 'SMITH' AND first_name = 'JOHN')
ORDER BY e.salary ASC,
         e.last_name ASC

-- El ORDER BY es como el SELECT
