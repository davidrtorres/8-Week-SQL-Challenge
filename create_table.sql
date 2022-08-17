<<<<<<< HEAD
-- Date 8/9/22

=======
>>>>>>> b08e062d48ae154754331fe43194780e6bbc69ee
CREATE DATABASE employee_data;
USE employee_data;
-- create tables
CREATE TABLE EmployeeDemographics
(EmployeeID INT,
	FirstName VARCHAR(50),
	LastNamr VARCHAR(50),
	Age INT,
    Gender VARCHAR(50)
)

CREATE TABLE EmployeeSalary (
 EmployeeID INT,
	JobTitle VARCHAR(50),
	Salary INT
)

-- insert data into tables
INSERT INTO EmployeeDemographics VALUES
(1001, 'Jim','Halpert',30, 'Male')

SELECT * FROM EmployeeDemographics;

INSERT INTO EmployeeDemographics VALUES
(1002, 'Pam','Beasley',30, 'Female'),
(1003, 'Dwight','Schrute',29, 'Male'),
(1004, 'Angela','Martin',32, 'Male'),
(1005, 'Toby','Flenderson',30, 'Male'),
(1006, 'Michael','Scott',35, 'Male'),
(1007, 'Meredith','Palmer',32, 'Female'),
(1008, 'Stanley','Hudson',38, 'Male'),
(1009, 'Kevin','Malone',31, 'Male')

INSERT INTO EmployeeSalary VALUES
(1001, 'Salesman',45000),
(1002,'Receptionist',36000),
(1003,'Salesman',63000),
(1004,'Accountant',47000),
(1005,'HR',50000),
(1006,'Regional Manager', 65000),
(1007,'Supplier Relations', 41000),
(1008,'Salesman', 48000),
(1009,'Accountant', 42000)

SELECT FirstName FROM EmployeeDemographics;
SELECT * FROM EmployeeSalary;

-- DISTINCT, we only want distine values in rows
SELECT DISTINCT(EmployeeID) FROM EmployeeDemographics;

SELECT DISTINCT(Gender) FROM EmployeeDemographics; -- only 2 results. Only 2 distinct values in column

-- COUNT - shows all the non-Null values in a column
-- there are 9, if someone's last name was left out it would have returned 8. 
SELECT COUNT(LastNamr) AS count_lastname
FROM EmployeeDemographics;

SELECT
	MAX(Salary) AS max_salary,
    MIN(Salary) AS min_salary,
    AVG(Salary) AS avg_salary
FROM EmployeeSalary;  

-- WHERE-helps limit the amount of data you want returned
SELECT *
FROM employee_data.EmployeeDemographics
WHERE FirstName='Jim';

SELECT *
FROM employee_data.EmployeeDemographics
WHERE FirstName !='Jim';

SELECT *
FROM employee_data.EmployeeDemographics
WHERE Age >= 30;

SELECT *
FROM employee_data.EmployeeDemographics
WHERE Age >= 30 AND Gender='Male';

-- only 1 of the criteria has to be correct
-- anyone who is 32 of your or male
SELECT *
FROM employee_data.EmployeeDemographics
WHERE Age >= 32 OR Gender='Male';

-- LIKE- using this for text information
-- want everyone who's last name starts with S
-- % is called a wild card
SELECT *
FROM employee_data.EmployeeDemographics
WHERE LastNamr LIKE 'S%';

-- %S%
-- where there's an s in anybody's name
SELECT *
FROM employee_data.EmployeeDemographics
WHERE LastNamr LIKE '%S%';

-- where there's an s in the beginning and somewhere in name there's an o
SELECT *
FROM employee_data.EmployeeDemographics
WHERE LastNamr LIKE 'S%o%';

SELECT *
FROM employee_data.EmployeeDemographics
WHERE FirstName IS NOT NULL;

-- IN, looking for mutliple things
SELECT *
FROM employee_data.EmployeeDemographics
WHERE FirstName IN  ('Jim','Michael','Kevin');

-- Group BY, ORDER BY
-- group by shows unique values in a column
SELECT
	Gender,
    COUNT(*) AS row_count
FROM employee_data.EmployeeDemographics
GROUP BY GENDER
ORDER BY row_count DESC;  

-- we have 2 males that are 30
-- we have 1 male that is 38
-- 1 male that is 32
SELECT
	Gender,
    Age,
    COUNT(Gender) AS row_count
FROM employee_data.EmployeeDemographics
GROUP BY Gender, Age
ORDER BY row_count DESC;  

SELECT
	Gender,
    Age,
    COUNT(Gender) AS row_count
FROM employee_data.EmployeeDemographics
WHERE Age >= 31
GROUP BY Gender, Age
ORDER BY row_count DESC;   

/*
Intermediate
Join
Unions
Case Statements
Updating Deleting Data
Partition By
Data types
Aliasing
Creating Views
Having vs. Group By Statement
GETDATE()
Primary key vs. Foreign key

Advanced
CTEs
SYS tables
Subqueries
Temp Tables
String Functions (TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower)
Regular Expression
Stored Procedures
Importing data from diffrerent FILE types/sources

*/
-- Join- is a way to combine multiple tables into a single output
-- have to join based on a similar column. Want it to be a unique field
-- JOIN to create 1 output
-- shows what's common between table A and table B
SELECT * FROM EmployeeDemographics;
-- INNER JOIN
SELECT *
FROM employee_data.EmployeeDemographics
JOIN employee_data.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;
    
-- Full outer Join   
SELECT *
FROM employee_data.EmployeeDemographics
LEFT OUTER JOIN employee_data.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
UNION
SELECT *
FROM employee_data.EmployeeDemographics
RIGHT OUTER JOIN employee_data.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
ORDER BY Salary DESC;    
      
-- Left outer join
-- we want everything in the left table and everything overlapping, but if it's only in the right table we don't want it 
INSERT INTO EmployeeDemographics VALUES
(1013,'John','Perdue',42, 'Male')

SELECT * FROM EmployeeSalary;
SELECT * FROM EmployeeDemographics;

INSERT INTO EmployeeSalary VALUES
(NULL, 'Human Resources',52000)

-- there's no EmployeeID 1010,1011,1012 in EmployeeDemographics so the're exclude and all info related
SELECT 
	*
FROM employee_data.EmployeeDemographics
LEFT JOIN employee_data.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;    

-- RIGHT JOIN
-- There's no EmployeeID 1010,1011, 1012 in EmployeeDemographics so it's Null
SELECT 
	*
FROM employee_data.EmployeeDemographics
RIGHT JOIN employee_data.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;  
    
SELECT 
	EmployeeSalary.EmployeeID,
	EmployeeDemographics.FirstName,
    EmployeeDemographics.LastNamr,
    EmployeeSalary.Salary
FROM employee_data.EmployeeDemographics
RIGHT JOIN employee_data.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;    

SELECT * FROM EmployeeDemographics;
-- 1001-1009, NULL,NULL,1013    
SELECT 
	EmployeeDemographics.EmployeeID,
	EmployeeDemographics.FirstName,
    EmployeeDemographics.LastNamr,
    EmployeeSalary.Salary
FROM employee_data.EmployeeDemographics
LEFT JOIN employee_data.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;   
    
-- pressure Michael Scott t oreach his quarterly quote  
-- deduct pay for highest paid employee at his branch and himself
-- idenitfy person that makes the most $
SELECT 
	EmployeeDemographics.EmployeeID,
	EmployeeDemographics.FirstName,
    EmployeeDemographics.LastNamr,
    EmployeeSalary.Salary
FROM employee_data.EmployeeDemographics
INNER JOIN employee_data.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID 
WHERE EmployeeDemographics.LastNamr != 'Scott'    
ORDER BY EmployeeSalary.Salary DESC;    

-- mistake when looking at the average salary for salesman
-- calcuale average salary for salesman
-- 'Salesman','52000.0000'

SELECT
	*
FROM employee_data.EmployeeDemographics
INNER JOIN employee_data.EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

SELECT
		EmployeeSalary.JobTitle,
        AVG(EmployeeSalary.Salary) AS average_salary
FROM employee_data.EmployeeDemographics
INNER JOIN employee_data.EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE JobTitle = 'Salesman'
GROUP BY EmployeeSalary.JobTitle;

Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')


/*
UNION and JOIN are closely related
THey're joining 2 tables to create 1 output
JOIN-combines 2 tables off a common column

UNION- able to select all the data from both tables and put into 1 output
     you don't have to choose which table you're chossing it from.
*/
SELECT * FROM WareHouseEmployeeDemographics;
SELECT *
FROM employee_data.EmployeeDemographics
RIGHT JOIN employee_data.WareHouseEmployeeDemographics
ON EmployeeDemographics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID; 	

--
-- UNION removes duplicates, like a DISTINCT statement
SELECT *
FROM employee_data.EmployeeDemographics
UNION
SELECT *
FROM employee_data.WareHouseEmployeeDemographics;	

SELECT *
FROM employee_data.EmployeeDemographics
UNION ALL
SELECT *
FROM employee_data.WareHouseEmployeeDemographics;	

-- CASE Statements
-- allows you to specify condition, specify what you want returned when the condition is met
-- it creates a new column
SELECT * FROM employee_data.EmployeeDemographics;
SELECT
	FirstName,
    LastNamr,
    Age,
CASE 
	WHEN Age > 30 THEN 'Old'
    WHEN Age BETWEEN 27 AND 30 THEN 'Young'
    ELSE 'Baby'
END    
FROM employee_data.EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;


SELECT
	FirstName,
    LastNamr,
    Age,
CASE 
	WHEN Age > 30 THEN 'Old'
    WHEN Age = 38 THEN 'Stanley'
    ELSE 'Baby'
END    
FROM employee_data.EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;

SELECT
	FirstName,
    LastNamr,
    Age,
CASE 
	WHEN Age = 38 THEN 'Stanley' #need to put this condition here
    WHEN Age > 30 THEN 'Old'
    ELSE 'Baby'
END    
FROM employee_data.EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;
--
-- not everyone is going to get the same raise
-- Salesman get biggest raises 
-- use when you want to categorize things or label things
SELECT 
		EmployeeDemographics.FirstName,
        EmployeeDemographics.LastNamr,
        EmployeeSalary.JobTitle,
        EmployeeSalary.Salary,
CASE 
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10) -- 10% raise
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05) -- 5% raise
	WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001) -- 5% raise
    ELSE Salary + (Salary * .03) 
END AS salary_after_raise
FROM employee_data.EmployeeDemographics
JOIN employee_data.EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;

--
-- CASE Statement
SELECT * FROM employee_data.EmployeeDemographics;
SELECT 
	EmployeeDemographics.FirstName,
    EmployeeDemographics.LastNamr,
    EmployeeDemographics.Age,
    EmployeeSalary.Salary,
CASE 
	WHEN EmployeeDemographics.Age <= 15 THEN 'Baby'
    WHEN EmployeeDemographics.Age BETWEEN 16 AND 30 THEN 'Middle'
    ELSE 'Elderly'
END AS age_category   
FROM employee_data.EmployeeDemographics
LEFT JOIN employee_data.EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;

-- Common Table Expression (CTE)
-- Once you get out of query it doesn't exist
-- CTE acts like a subquery
SELECT * FROM employee_data.EmployeeDemographics;

WITH my_cte AS (
SELECT *
FROM employee_data.EmployeeDemographics
)
SELECT 
	FirstName
FROM my_cte;    




SELECT *
	-- EmployeeDemographics.FirstName,
	-- EmployeeDemographics.LastNamr,
	-- EmployeeDemographics.Age
	-- EmployeeSalary.Salary
FROM employee_data.EmployeeDemographics
)
SELECT * FROM my_cte;

WITH CTE_Employee AS (
SELECT
	EmployeeDemographics.FirstName,
    EmployeeDemographics.LastNamr,
    EmployeeDemographics.Gender,
    EmployeeSalary.Salary
    -- COUNT(Gender) OVER(PARTITION BY Gender) AS TotalGender,
    -- AVG(Salary) OVER(PARTITION BY Gender) AS AvgSalary
    
FROM employee_data.EmployeeDemographics
JOIN employee_data.EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
-- WHERE Salary < '45000'
) 
SELECT * FROM CTE_Employee;


-- Temporary Table
-- can select all the data from a table and put it into a temp table.
-- This reduces run time
SELECT * FROM EmployeeSalary;

DROP TABLE IF EXISTS temp_employee2
CREATE TEMPORARY TABLE temp_employee2 (
	JobTitle VARCHAR(50),
    EmployeesPerJob INT,
    AvgAge INT,
    AvgSalary INT)
    
INSERT INTO temp_employee2
SELECT
	JobTitle,
    COUNT(JobTitle),
    AVG(Age),
    AVG(Salary)
FROM employee_data.EmployeeDemographics
JOIN employee_data.EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle;

SELECT * FROM temp_employee2;

/*


*/









