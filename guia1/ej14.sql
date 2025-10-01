-- Mostrar toda la información del empleado más antiguo.

SELECT * 
FROM EMPLOYEE 
WHERE hire_date = (SELECT MIN(hire_date)
                   FROM EMPLOYEE)

-- Aparecen las SUBCONSULTAS!!
