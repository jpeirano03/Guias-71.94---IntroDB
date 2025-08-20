SELECT e.last_name||', '||e.first_name empleado, d.name nombre_depto, l.regional_group
FROM EMPLOYEE e, DEPARTMENT d, LOCATION l
WHERE e.commission > (:val_com) and 
      e.department_id = d.department_id and 
      d.location_id = l.location_id;
