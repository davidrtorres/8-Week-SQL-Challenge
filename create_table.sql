-- Date 8/9/22

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