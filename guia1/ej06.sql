SELECT e.last_name||', '||e.first_name empleado, NVL(TO_CHAR(e.commission),'Sin comision') AS comision
FROM EMPLOYEE e;

-- NVL estraído de Mod1, diapo 25
