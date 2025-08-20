SELECT e.last_name, e.first_name , j.function, d.name, e.salary
FROM EMPLOYEE e, DEPARTMENT d, JOB j
WHERE e.department_id = d.department_id and 
      e.job_id = j.job_id
ORDER BY e.last_name ASC ;
