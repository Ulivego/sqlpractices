SELECT school_name, first_name 
ORDER BY school_name ASC, last_name ASC;

SELECT *
FROM teacher
WHERE first_name LIKE "S%" AND salary > 40000;

SELECT *
FROM teacher
WHERE hire_date >= "2010-01-01"
ORDER BY salary DESC;
