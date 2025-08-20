SELECT e.first_name, e.last_name, e.salary
FROM EMPLOYEE e
WHERE e.manager_id IS NULL;


-- Concatenando el nombre
SELECT e.last_name||', '||e.first_name empleado, e.salary
FROM EMPLOYEE e
WHERE e.manager_id IS NULL;
