SELECT e.employee_id AS empleado_id, 
       e.last_name||', '||e.first_name AS empleado,
       emp.employee_id AS jefe_id,
       emp.last_name||', '||emp.first_name AS jefe
FROM EMPLOYEE e, EMPLOYEE emp
WHERE e.manager_id = emp.employee_id;
