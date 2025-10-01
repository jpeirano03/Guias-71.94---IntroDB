SELECT e.employee_id AS empleado_id, 
       e.last_name||', '||e.first_name AS empleado,
       emp.employee_id AS jefe_id,
       emp.last_name||', '||emp.first_name AS jefe
FROM EMPLOYEE e JOIN EMPLOYEE emp
ON e.manager_id = emp.employee_id (+)

-- No hay un id nulo para matchear con el casillero de manager_id
