--Easy-Level Tasks (10)
SELECT MIN(Price) AS MinPrice
FROM Products;

SELECT MAX(Salary) AS MaxSalary
FROM Employees;

SELECT COUNT(*) AS TotalCustomers
FROM Customers;

SELECT COUNT(DISTINCT Category) AS UniqueCategories
FROM Products;

SELECT 
    ProductID,
    SUM(Quantity * Price) AS TotalSalesAmount
FROM Sales
WHERE ProductID = 7
GROUP BY ProductID;

SELECT AVG(Age) AS AverageAge
FROM Employees;

SELECT 
    DepartmentName,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

SELECT 
    Category,
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

SELECT 
    CustomerID,
    SUM(Quantity * Price) AS TotalSales
FROM Sales
GROUP BY CustomerID;

SELECT DeptID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DeptID
HAVING COUNT(*) > 5;

 --Medium-Level Tasks (9)

 SELECT 
    Category,
    SUM(SaleAmount) AS TotalSales,
    AVG(SaleAmount) AS AverageSales
FROM Sales
GROUP BY Category;


SELECT COUNT(*) AS HR_EmployeesCount
FROM Employees
WHERE DepartmentName = 'HR';

SELECT DeptID, 
       MIN(Salary) AS LowestSalary, 
       MAX(Salary) AS HighestSalary
FROM Employees
GROUP BY DeptID;

SELECT DeptID, 
       AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DeptID;

SELECT DeptID, 
       AVG(Salary) AS AverageSalary, 
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DeptID;

SELECT Category, 
       AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;

SELECT YEAR(SaleDate) AS SalesYear,
       SUM(Amount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate)
ORDER BY SalesYear;

SELECT CustomerID, 
       COUNT(OrderID) AS OrderCount
FROM Sales
GROUP BY CustomerID
HAVING COUNT(OrderID) >= 3;

SELECT DeptID, 
       AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DeptID
HAVING AVG(Salary) > 60000;

--Hard-Level Tasks (6)

SELECT Category, 
       AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 150;

SELECT CustomerID, 
       SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;

SELECT DepartmentID, 
       SUM(Salary) AS TotalSalary,
       AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 65000;

SELECT 
    CustomerID,
    SUM(Freight) AS TotalFreightOver50,
    MIN(Freight) AS LeastPurchase
FROM Sales.Orders
WHERE Freight > 50
GROUP BY CustomerID;

SELECT 
    YEAR(o.OrderDate) AS OrderYear,
    MONTH(o.OrderDate) AS OrderMonth,
    SUM(od.UnitPrice * od.Quantity) AS TotalSales,
    COUNT(DISTINCT od.ProductID) AS UniqueProducts
FROM Sales.Orders o
JOIN Sales.OrderDetails od 
    ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
HAVING COUNT(DISTINCT od.ProductID) >= 2
ORDER BY OrderYear, OrderMonth;


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,                 -- Unique ID for each order
    CustomerID INT,                          -- Links to Customers table
    ProductID INT,                           -- Links to Products table
    OrderDate DATE,                          -- When the order was placed
    Quantity INT,                            -- How many products ordered
    TotalAmount DECIMAL(10, 2),              -- Total order value
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

