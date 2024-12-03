USE `Parks_and_Recreation`;

# Tutorial 15 CTE (Common Table Expression)


#TIPS: Something like subqueries but more cleaner/proffessional I guess?
#TIPS this doesnt store something your just querying
#EXAMPLE 3 is more or less using CTE as using JOIN while FILTERING something on combined tables
#Example 4 is more or less adding a Parenthesis on the With, it will override your  header name on your ZTE 

Select emd.employee_id,emd.first_name, emd.last_name, gender, 
avg(salary)OVER(PARTITION BY gender)

From employee_demographics as emd
Join employee_salary as ems
	on emd.employee_id = ems.employee_id

 ORDER BY ems.first_name
;


WITH CTE_EXAMPLE AS(

Select gender, avg(salary) AVG_SAL, max(salary) MAX_SAL, min(salary)MIN_SAL, count(salary) COUNT_SAL
From employee_demographics as emd
Join employee_salary as ems
	on emd.employee_id = ems.employee_id
    
GROUP BY gender

)
SELECT avg(AVG_SAL)
FROM CTE_EXAMPLE
;

#2nd Example/Trial and Error

WITH GENDER_AVG AS 
(
SELECT AVG(SALARY) AVG_SAL
From employee_demographics as EMD
JOIN employee_salary as EMS
	on EMD.employee_id = ems.employee_id
GROUP BY GENDER
)

Select avg(AVG_SAL)
FROM GENDER_AVG;



#3rd Example

With CTE_EXAMPLE1 as 
(
Select employee_id, birth_date
from employee_demographics
Where birth_date <='1985-01-01'
),

CTE_EXAMPLE2 as 
(
Select employee_id , salary
From employee_salary
Where salary > 50000
)

Select *
From CTE_EXAMPLE1 as CTE1
JOIN CTE_EXAMPLE2 AS CTE2
	ON CTE1.employee_id = CTE2.employee_id;
;





#4th Example

With CTE_EXAMPLE1(Emp_ID, First_Name,Last_Name,Birth_Date) as 
(	
Select employee_id, first_name, last_name, birth_date
from employee_demographics
Where birth_date <='1985-01-01'
),

CTE_EXAMPLE2 as 
(
Select employee_id , salary Salary
From employee_salary
Where salary > 50000
)

Select Emp_ID, First_Name,Last_Name,Birth_Date Salary
From CTE_EXAMPLE1 as CTE1
JOIN CTE_EXAMPLE2 AS CTE2
	ON CTE1.Emp_ID = CTE2.employee_id;
    



# END Of Tutorial 15 CTE 




# Tutorial 16 Temp Tables
#TIP the good thing about temp table is that you can utilize that table over and over again at least until you close tthe system


Create TEMPORARY TABLE temp_table
(
first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(50)
);

INSERT INTO temp_table
VALUES ('Aeron Christ','Talaro', 'To Love Ru');

Select *
From temp_table;


Create TEMPORARY TABLE OVERCOMPENSATED_EMPLOYEE
SELECT *
FROM employee_salary
Where salary >=50000;

Select*
FROM OVERCOMPENSATED_EMPLOYEE;







# END Of Tutorial 16 TEMP TABLES








# Tutorial 17 Stored Procedure

#Example: 1
Create Procedure  Large_Salaries()
Select *
From employee_salary
Where salary > 50000;

Call Large_Salaries();


#Example:2


DELIMITER $$
Create Procedure Large_Salaries2()
BEGIN
	Select *
	From employee_salary
	Where salary >= 50000;
	Select *
	From employee_salary 
	Where salary >= 70000;
END $$
DELIMITER ;


CALL Large_Salaries2();



# END Of Tutorial 17 Stored Procedure








# Tutorial 18 Triggers and Events
#TIPS: TRIGGERS- HAPPENS WHEN AN EVENTS TAKES PLACE
#TIPS: EVENTS- TAKES PLACE WHEN ITS SCHEDULE



#TRIGGERS
UPDATE employee_demographics
SET age = '35', gender= 'FEMALE', birth_date= '1988-02-02'
WHERE employee_id = 13;

UPDATE employee_demographics
SET gender='MALE'
WHERE employee_id = 13;


DELIMITER $$
Create Trigger Employee_Insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
    
    BEGIN
		INSERT INTO employee_demographics(employee_id, first_name, last_name)
        VALUES(NEW.employee_id, NEW.first_name, NEW.last_name);
    END $$
    
    DELIMITER ;
    

    
    
    INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
    VALUES	('13', 'Kazuha', 'Kaedehara', 'Support', '80000', 2);


    INSERT INTO employee_demographics (employee_id, first_name, last_name, AGE, GENDER, birth_date)
    VALUES	('14', 'ITTO', 'ONI', '76', 'MALE', '1977-07-30');

Select *
From employee_demographics;



# EVENTS PART
DELIMITER $$
CREATE EVENT delete_retirees
	ON SCHEDULE  EVERY 30 SECOND
    DO 
		BEGIN
			DELETE
            FROM employee_demographics
            WHERE AGE >=75;
        END $$
        
DELIMITER ;

CREATE TABLE retired_employee (employee_id INT PRIMARY KEY, first_name varchar(50),last_name varchar(50),age INT, salary INT);


DELIMITER $$
CREATE EVENT remove_retired_employees
  ON SCHEDULE EVERY 1 YEAR
  STARTS '2024-11-30'
  DO
  BEGIN
    INSERT INTO retired_employee (SELECT * FROM employee_demograpics WHERE YEAR(CURDATE()) - YEAR(birth_date) = 75);
    DELETE FROM employees WHERE YEAR(CURDATE()) - YEAR(birth_date) = 75;
  END $$
  
  DELIMITER ;





SHOW VARIABLES LIKE 'event%';







INSERT INTO employee_demographics (employee_id, first_name, last_name, AGE, GENDER, birth_date)
VALUES	('16', 'ITTO', 'ONI', '76', 'MALE', '2000-07-30');




DELIMITER $$

CREATE TRIGGER before_insert_employee_demographics
BEFORE INSERT ON employee_demographics
FOR EACH ROW
BEGIN
    -- Calculate age based on birth_date and current date
    SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.birth_date, CURDATE()) -
                 (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(NEW.birth_date, '%m%d'));
END $$



DELIMITER ;






DELIMITER $$

CREATE EVENT update_age_event
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Update the age column based on the birth_date column
    UPDATE employee_demographics
    SET age = TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) -
              (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(birth_date, '%m%d'));
END $$

DELIMITER ;