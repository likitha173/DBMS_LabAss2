-- a. Calculating bonus for teachers:

SELECT *, salary * 0.05 AS bonus
FROM teacher;







-- b. Deleting rows where salary is less than Rs. 5000:

DELETE
FROM teacher
WHERE salary < 5000;






-- c. Inserting supervisor information to another table:

CREATE TABLE supervisor (
  t_no INT PRIMARY KEY,
  f_name VARCHAR(255),
  l_name VARCHAR(255),
  supervisor VARCHAR(255)
);

INSERT INTO supervisor (t_no, f_name, l_name, supervisor)
SELECT t_no, f_name, l_name, supervisor
FROM teacher
WHERE title = 'supervisor';






-- d. Deleting rows where teacher was hired for more than 10 years:

DELETE FROM teacher
WHERE (YEAR(CURDATE()) - YEAR(joiningdate)) > 10;

