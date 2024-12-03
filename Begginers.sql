#TUTORIAL 4 



SELECT *  
FROM employee_demographics
Limit 5;

Select employee_id first_name, last_name, age, 
#	this allow me to add
age+10,
(age+12)* 10
From employee_demographics
Limit 10;

SELECT Distinct gender
FROM employee_demographics;



#END OF NO.4 Tutorial






#TUTORIAL #5 WHERE CLAUSE

SELECT * 
FROM employee_demographics 
Where gender = "Male"
AND AGE<40;

SELECT * 
FROM employee_demographics 
WHERE birth_date <= '1981-03-04'  or AGE <44;


#Looks for someone that starts with C
SELECT * 
FROM employee_demographics 
WHERE (AGE >30 or Gender= "Male") and first_name Like 'C%';

#Looks for someone that ENDS with N
SELECT * 
FROM employee_demographics 
WHERE first_name Like '%N';


#Looks for someone that has with '1980%'
SELECT * 
FROM employee_demographics 
WHERE birth_date like '1980%';

#END OF NO.5 Tutorial





#TUTORIAL #6 GROUP BY and Order By
#Note Aggregate functions are Count, Avg, Sum, Min, Max


SELECT *
FROM employee_salary ;

SELECT occupation, salary
FROM employee_salary 
group by occupation, salary;

SELECT occupation, AVG(salary)
FROM employee_salary
GROUP BY occupation;	

SELECT occupation, COUNT(*) AS COUNT
FROM employee_salary
GROUP BY occupation;

SELECT occupation, COUNT(*), Max(salary), Min(salary), avg(salary), sum(salary)
FROM employee_salary
GROUP BY occupation;

SELECT *
FROM employee_salary 
Order By salary ASC;

SELECT *
FROM employee_demographics
Order By gender ASC, age Desc;

#END OF NO.6 Tutorial





#TUTORIAL #7 Where and Having
#TIP HAVING IS COMMONLY USE WHEN USING AGGREGATE FUNCTION

SELECT *
FROM employee_salary ;


SELECT occupation, AVG(salary) AS average_salary
FROM employee_salary
GROUP BY occupation
HAVING AVG(salary) > 55000
ORDER BY average_salary ASC;


Select occupation, avg(salary)
from employee_salary
Where occupation like '%manager%'
group by occupation
having avg(salary) >50000
order by avg(salary);

#END OF NO.7 Tutorial

#TUTORIAL #7 LIMIT AND ALIASING
#TIP 

SELECT *  
FROM employee_demographics
Limit 5;

#Basically this means skip all the first 3 then show the next 2
SELECT *
FROM employee_demographics 
ORDER BY AGE DESC
LIMIT 3,2;

Select gender, avg(age) as Average_Age
FROM employee_demographics
group by gender	
Having Average_Age >35
Order By Average_Age Desc;

SELECT first_name as FirstName, max(age)as HighestAge
From employee_demographics
Group By FirstName 
Limit 3,2