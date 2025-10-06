-- Realice una consulta SQL que muestre el id de localidad, regional_group, 
-- nombre de departamento y cantidad de empleados de aquellos departamentos 
-- que cuentan con menos de 3 empleados. Ordenados por nombre de región y luego nombre de departamento.

SELECT l.location_id,
       l.regional_group,
       d.name,
       COUNT(e.department_id) AS cant_empleados
FROM LOCATION l
JOIN DEPARTMENT d
    ON l.location_id = d.location_id
JOIN EMPLOYEE e
    ON d.department_id = e.department_id
GROUP BY l.location_id,
         l.regional_group,
         d.name
HAVING COUNT(e.department_id) < 3
ORDER BY l.regional_group,
         d.name
