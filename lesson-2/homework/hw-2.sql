
--Basic-Level Tasks 

create table Employees(
EmpID INT PRIMARY KEY,
Name VARCHAR (50),
Salary DECIMAL (10,2));

Select * from Employees

INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Alice Johnson', 55000.00);

INSERT INTO Employees (EmpID, Name, Salary)
VALUES
    (3, 'Charlie Brown', 72000.75),
    (4, 'Diana Evans', 68000.00),
    (5, 'Ethan Miller', 50000.25);

	UPDATE Employees
SET salary = '7000'
WHERE EmpID = 1;

DELETE FROM Employees
WHERE EmpID = 2;

--DELETE
--Removes specific rows from a table using a WHERE condition.

--TRUNCATE
--Removes all rows from a table (faster than DELETE), table structure remains

--DROP
--Removes the entire table (data + structure).

ALTER TABLE Employees
ADD Name VARCHAR(100);

ALTER TABLE Employees
ADD Department VARCHAR(50);

UPDATE Employees
SET salary = 'FLOAT'

CREATE TABLE Department (
DepartmentID INT, PRIMARY KEY, 
DepartmentName (VARCHAR(50));

TRUNCATE table Employees;


--Intermediate-Level Tasks (6)
INSERT INTO Departments (DeptID, DeptName)
SELECT 1, 'Human Resources'
UNION ALL
SELECT 2, 'Finance'
UNION ALL
SELECT 3, 'IT'
UNION ALL
SELECT 4, 'Marketing'
UNION ALL
SELECT 5, 'Operations';

UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

TRUNCATE TABLE Employees;

ALTER TABLE Employees
DROP COLUMN Department;

ALTER TABLE Employees
RENAME TO StaffMembers;

DROP table Department

--Advanced-Level Tasks (9)

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT
);

ALTER TABLE Products
ADD CONSTRAINT chk_price_positive
CHECK (Price > 0);

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

ALTER TABLE Products
CHANGE COLUMN Category ProductCategory VARCHAR(50);

-- Insert 5 records into Products
INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (1, 'Laptop', 'Electronics', 1200.00, 30);

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (2, 'Office Chair', 'Furniture', 150.00, 75);

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (3, 'Headphones', 'Electronics', 85.50, 100);

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (4, 'Coffee Maker', 'Appliances', 99.99, 40);

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (5, 'Running Shoes', 'Sportswear', 65.00, 60);


-- Create backup table and copy all data
SELECT *
INTO Products_Backup
FROM Products;

ALTER TABLE Products
RENAME TO Inventory;

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);

TRUNCATE table Employees;
