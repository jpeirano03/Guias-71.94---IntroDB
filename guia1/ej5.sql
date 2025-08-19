SELECT e.first_name, e.last_name, e.salary
FROM EMPLOYEE e
WHERE e.manager_id IS NULL;
