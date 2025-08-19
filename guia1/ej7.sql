SELECT e.last_name||', '||e.first_name empleado, d.department_id, d.name
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.department_id (+)= d.department_id;

-- El (+) se pone donde puede existir valores nulos
-- Uso d.department_id xq sino en el depto que no haya nadie tampoco me va a aparecer el id, pues el empleado no existe y no existiría e.department_id
