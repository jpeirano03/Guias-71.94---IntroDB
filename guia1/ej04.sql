-- Oracle Apex
SELECT d.department_id, d.name 
FROM DEPARTMENT d
WHERE d.location_id = (:location_id);
