-- Code for creating tables and inserting values in SQL (Structured Query Language) based on the three schemas provided:

CREATE TABLE Teacher (
  t_no INT PRIMARY KEY,
  f_name VARCHAR(50),
  l_name VARCHAR(50),
  salary INT,
  supervisor INT,
  joiningdate DATE,
  birthdate DATE,
  title VARCHAR(50)
);

CREATE TABLE Class (
  class_no INT PRIMARY KEY,
  t_no INT,
  room_no INT,
  FOREIGN KEY (t_no) REFERENCES Teacher(t_no)
);

CREATE TABLE Payscale (
  Min_limit INT PRIMARY KEY,
  Max_limit INT,
  grade VARCHAR(50)
);

INSERT INTO Teacher (t_no, f_name, l_name, salary, supervisor, joiningdate, birthdate, title)
VALUES (1, 'John', 'Doe', 50000, 2, '2020-01-01', '1980-01-01', 'Professor'),
       (2, 'Jane', 'Doe', 60000, NULL, '2019-01-01', '1981-01-01', 'Associate Professor');

INSERT INTO Class (class_no, t_no, room_no)
VALUES (1, 1, 101),
       (2, 2, 102);

INSERT INTO Payscale (Min_limit, Max_limit, grade)
VALUES (30000, 50000, 'A'),
       (50000, 70000, 'B'),
       (70000, 90000, 'C');






/*
(a) write code to Calculate the bonus amount to be given to a teacher depending on the following conditions:

        I. if salary > 10000 then bonus is 10% of the salary.

        II. if salary is between 10000 and 20000 then bonus is 20% of the salary.

        III. if salary is between 20000 and 25000 then bonus is 25% of the salary.

        IV. if salary exceeds 25000 then bonus is 30% of the salary.
 */


-- code in SQL to calculate the bonus amount for a teacher based on the conditions specified:

SELECT t_no, f_name, l_name, salary,
       CASE
           WHEN salary > 25000 THEN salary * 0.3
           WHEN salary BETWEEN 20000 AND 25000 THEN salary * 0.25
           WHEN salary BETWEEN 10000 AND 20000 THEN salary * 0.2
           WHEN salary > 10000 THEN salary * 0.1
       END AS bonus_amount
FROM Teacher;





-- (b) Using a simple LOOP structure, list the first 10 records of the ‘teachers’ table.

-- Code to list the first 10 records of the 'teachers' table using a simple loop structure in MySQL:

DELIMITER $$
CREATE PROCEDURE list_teachers()
BEGIN
  DECLARE counter INT DEFAULT 0;
  
  SELECT t_no, f_name, l_name, salary INTO @t_no, @f_name, @l_name, @salary
  FROM Teacher
  LIMIT 1;
  
  WHILE counter < 10 DO
    SELECT @t_no, @f_name, @l_name, @salary;
    
    SET counter = counter + 1;
    
    SELECT t_no, f_name, l_name, salary INTO @t_no, @f_name, @l_name, @salary
    FROM Teacher
    WHERE t_no > @t_no
    LIMIT 1;
  END WHILE;
END$$
DELIMITER ;

-- Run this procedure by executing the following statement:

CALL list_teachers();





-- (c) Create a procedure that selects all teachers who get a salary of Rs.20, 000 and if less than 5 teachers are getting Rs.20, 000 then give an increment of 5%. 51 Lab Manual.

-- Code to create a procedure in MySQL that selects all teachers who receive a salary of Rs. 20,000 and gives a 5% salary increase if less than 5 teachers receive this salary:

DELIMITER $$
CREATE PROCEDURE give_increment()
BEGIN
  DECLARE total_teachers INT DEFAULT 0;
  
  SELECT COUNT(*) INTO total_teachers
  FROM Teacher
  WHERE salary = 20000;
  
  IF total_teachers < 5 THEN
    UPDATE Teacher
    SET salary = salary * 1.05
    WHERE salary = 20000;
  END IF;
  
  SELECT *
  FROM Teacher
  WHERE salary = 20000;
END$$
DELIMITER ;

-- Run this procedure by executing the following statement:

CALL give_increment();





-- (d) Create a procedure that finds whether a teacher given by user exists or not and if not then display “teacher id not exists”.

-- Code to create a procedure in MySQL that finds whether a teacher given by the user exists or not and displays a message if the teacher doesn't exist:

DELIMITER $$
CREATE PROCEDURE find_teacher(IN teacher_id INT)
BEGIN
  DECLARE teacher_exists INT DEFAULT 0;
  
  SELECT COUNT(*) INTO teacher_exists
  FROM Teacher
  WHERE t_no = teacher_id;
  
  IF teacher_exists = 0 THEN
    SELECT 'Teacher ID not exists';
  ELSE
    SELECT *
    FROM Teacher
    WHERE t_no = teacher_id;
  END IF;
END$$
DELIMITER ;

-- Run this procedure by executing the following statement, where 'teacher_id' is the ID of the teacher you want to find:

CALL find_teacher(teacher_id);

CALL find_teacher(2);






-- (e) Using FOR loop, display name and id of all those teachers who are more than 58 years old.

-- Code to display the name and ID of all teachers who are more than 58 years old using a FOR loop in MySQL:

DELIMITER $$
CREATE PROCEDURE find_old_teachers()
BEGIN
  DECLARE teacher_birthdate DATE;
  DECLARE teacher_id INT;
  DECLARE teacher_name VARCHAR(100);
  DECLARE teacher_age INT;
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT t_no, CONCAT(f_name, ' ', l_name) AS name, birthdate
    FROM Teacher;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
  OPEN cur;
  REPEAT
    FETCH cur INTO teacher_id, teacher_name, teacher_birthdate;
    
    IF NOT done THEN
      SET teacher_age = YEAR(CURDATE()) - YEAR(teacher_birthdate);
      
      IF teacher_age > 58 THEN
        SELECT teacher_id, teacher_name;
      END IF;
    END IF;
  UNTIL done END REPEAT;
  
  CLOSE cur;
END$$
DELIMITER ;

-- Run this procedure by executing the following statement:

CALL find_old_teachers();







-- (f) Using while loop, display details of all those teachers who are in grade ‘A’. 

-- Code to display the details of all teachers who are in grade 'A' using a WHILE loop in MySQL:

DELIMITER $$
CREATE PROCEDURE find_teachers_in_grade_A()
BEGIN
  DECLARE teacher_id INT;
  DECLARE teacher_name VARCHAR(100);
  DECLARE teacher_salary INT;
  DECLARE teacher_grade CHAR(1);
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT t.t_no, CONCAT(t.f_name, ' ', t.l_name) AS name, t.salary, p.grade
    FROM Teacher t
    INNER JOIN Payscale p ON t.salary BETWEEN p.Min_limit AND p.Max_limit;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
  OPEN cur;
  REPEAT
    FETCH cur INTO teacher_id, teacher_name, teacher_salary, teacher_grade;
    
    IF NOT done THEN
      IF teacher_grade = 'A' THEN
        SELECT teacher_id, teacher_name, teacher_salary, teacher_grade;
      END IF;
    END IF;
  UNTIL done END REPEAT;
  
  CLOSE cur;
END$$
DELIMITER ;

-- Run this procedure by executing the following statement:

CALL find_teachers_in_grade_A();






-- (g) Create a procedure that displays the names of all those teachers whose supervisor is ‘Suman’

-- Code to create a procedure that displays the names of all teachers whose supervisor is 'Suman' in MySQL:

DELIMITER $$
CREATE PROCEDURE find_teachers_under_suman()
BEGIN
  SELECT CONCAT(f_name, ' ', l_name) AS name
  FROM Teacher
  WHERE supervisor = 'Suman';
END$$
DELIMITER ;

-- Run this procedure by executing the following statement:

CALL find_teachers_under_suman();


