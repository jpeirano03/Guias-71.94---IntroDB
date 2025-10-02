-- Para todas las localidades mostrar sus datos, la cantidad de empleados que tiene y el
-- total de salarios de sus empleados. Ordenar por cantidad de empleados.

SELECT loc.location_id,
       loc.regional_group,
       COUNT(e.employee_id) AS cantidad_de_empleados,
       SUM(e.salary) AS salario_total
FROM LOCATION loc
JOIN DEPARTMENT d
    ON loc.location_id = d.location_id
JOIN EMPLOYEE e
    ON d.department_id = e.department_id
GROUP BY loc.location_id,
         loc.regional_group
ORDER BY cantidad_de_empleados

-- Cuando no tengo solo funciones que me devuelven un valor necesito un GROUP BY
-- Si agrupo algo de una tabla tengo que agrupar por todos las columnas que muestro de la tabla
