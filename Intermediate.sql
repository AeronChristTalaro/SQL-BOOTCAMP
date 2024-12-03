USE `Parks_and_Recreation`;

#Intermediate Tutorials
# Tutorial 9 Joins
#Tips you can only join by using a column that both table has

#Inner Joins

Select emd.employee_id, age,occupation
From employee_demographics as emd
Inner Join employee_salary as ems
	on emd.employee_id= ems.employee_id;
    
Select emd.employee_id, emd.first_name, emd.last_name, emd.age, emd.gender, emd.birth_date, ems.occupation, ems.salary, ems.dept_id
From employee_demographics as emd
Inner Join employee_salary as ems
	on emd.employee_id= ems.employee_id;
    
    
    
#Outer Joins
#Left Join is the first table
	#Almost the same as top
#Right Join is the Second Table
	#Show all Data of Left Join but if it hasnt any similarities, then it will leave nulls.


Select *
From employee_demographics as emd
Right Join employee_salary as ems
	on emd.employee_id= ems.employee_id;
  

Select *
From employee_demographics as emd
INNER Join employee_salary as ems
	on emd.employee_id = ems.employee_id
INNER Join parks_departments as pd
	on ems.dept_id =pd.department_id;	
    
 
#END OF NO.9 Tutorial





# Tutorial 10 Union
#Tip: Combine tables in a single column
#Tip 2: So in most case we use them to combine tables that has the same column header otherwise they'll look like ex# 1
#Tip 3: Distinct is one of the best partner for this

Select *
From employee_demographics
Union
Select*
From employee_salary;

Select first_name, last_name
From employee_demographics
Union 
Select first_name, last_name
From employee_salary
Order by first_name;



Select first_name, last_name, 'Old Man' as Label 
From employee_demographics
Where age > 40 and Gender ='Male'
Union
Select first_name, last_name, 'Old Woman' as Label 
From employee_demographics
Where age > 40 and Gender ='Female'
Union
Select first_name, last_name, 'Highly Compensated' as Label
From employee_salary
Where salary > 70000
order by first_name, last_name;



SELECT  first_name, last_name, age, 'ELDERLY MAN' as LABEL
FROM employee_demographics
WHERE age >=50 and gender= 'MALE'
UNION
SELECT  first_name, last_name,age, 'ELDERLY WOMAN' as LABEL
FROM employee_demographics
WHERE age >=50 and gender= 'FEMALE'
union
SELECT  first_name, last_name,age, 'RETIRED ' as LABEL
FROM employee_demographics
WHERE age >=70 
ORDER BY first_name ASC
;



#END OF NO.10 Tutorial


# Tutorial 11 STRING
#Tip: Length is commonly use when looking for data that has long name etc.
#Note: When we order using No# it means the column #
#Tip:Upper is use to Uppercase 
#Tip:Lower is use to Lowercase 
#Tip:Trim is use to removes leading and trailing spaces from a string  theres also LTRIM AND RTRIM
#Tip: theres also LTRIM AND RTRIM
#TIP Substring is much easier It allows you to relocate the number of string then how many letters will it output

SELECT LENGTH('LALA');
SELECT upper('moshi');
Select trim('                tirla            ') as label;

Select first_name, Length (first_name) as  Length
From employee_demographics
Where Length (first_name) >=4
order by 2;


Select UPPER(first_name)as FirstName,UPPER(last_name)as LastName
From employee_demographics;

Select first_name, 
SUBSTRING(birth_date,6,2) as Birth_Month
From employee_demographics;

#END OF NO.11 Tutorial







# Tutorial 12 CASE
#TIP if where talking about salary percentage you can just use 1.1=10% 1.2=20% 1.3=30% and so on


USE `Parks_and_Recreation`;

Select first_name, last_name,AGE,
Case 
	When Age BETWEEN 30 AND 40 Then 'YOUNG Employee'
	When Age BETWEEN 41 AND 50 Then 'MIDDLE AGE Employee'
    	When Age BETWEEN 50 AND 60 Then 'ELDERLY Employee'
    Else 'RETIRED Employee'
End as Classification
From employee_demographics
ORDER BY AGE ASC;

SELECT first_name, last_name, salary,
       CASE 
           WHEN salary <= 50000 THEN salary * 1.1
           WHEN salary between 50000 and 60000 THEN salary * 1.2
           Else salary * 1.0
       END AS New_Salary,
       
		CASE 
           WHEN salary <= 50000 THEN '10%'
           WHEN salary between 50000 and 60000 THEN '20%'
           Else '0%'
       END AS Percentage_Increase

FROM employee_salary
Order by salary Asc;



#END OF NO.12 Tutorial




# Tutorial 13 Subqueries


Select*
From employee_demographics
Where employee_id IN
		(
        Select employee_id
		From employee_salary
        Where dept_id = 1
        );
        
Select *
From employee_demographics
Where employee_id in
		(
        Select employee_id
        FROM employee_salary
        Where occupation like '%manager%' 
        );




#END OF NO.13 Tutorial



# Tutorial 14 Window Function
#1st example without partition avg of all woman and men
#2nd example shows partition avg of woman then avg of men
#3rd example shows adding by salary by gender
#4th example RoW () will show numerically even if it has same value 1-2-3-4-5
#5th example Rank () will show you same value but then skip number base on similar so 1-2-3-4-5-5-7
#6th example DENSE_RANK () show you same value but then CONTINUE number base on similar so 1-2-3-4-5-5-6


Select gender, avg(salary) OVER()
From employee_demographics as emd
Join employee_salary as ems
on emd.employee_id = ems.employee_id
;


Select emd.first_name, emd.last_name, gender, avg(salary) OVER(PARTITION BY gender)
From employee_demographics as emd
Join employee_salary as ems
on emd.employee_id = ems.employee_id
;

Select emd.first_name, emd.last_name, gender, ems.salary, sum(salary) OVER(PARTITION BY gender Order By emd.employee_id) as 'Rolling Total'
From employee_demographics as emd
Join employee_salary as ems
on emd.employee_id = ems.employee_id
;

Select emd.employee_id, emd.first_name, emd.last_name, gender, ems.salary, 
row_number() OVER(Partition By gender Order By Salary Desc) as 'RowNumbers',
Rank() OVER(Partition By gender Order By Salary Desc) as 'RankNumbers'
From employee_demographics as emd
Join employee_salary as ems

on emd.employee_id = ems.employee_id
;

