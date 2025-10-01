-- Desplegar el nombre del empleado más antiguo y del empleado más nuevo, (según su
-- fecha de ingreso).

SELECT last_name||', '||first_name AS nombre
FROM EMPLOYEE
WHERE hire_date = (SELECT MIN(hire_date)
                      FROM EMPLOYEE)
      OR hire_date = (SELECT MAX(hire_date)
                      FROM EMPLOYEE)
