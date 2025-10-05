--Using Products, Suppliers table List all combinations of product names and supplier names.
SELECT 
    p.ProductName,
    s.SupplierName
FROM Products p
CROSS JOIN Suppliers s;

--Using Departments, Employees table Get all combinations of departments and employees.
SELECT 
    d.DepartmentName,
    e.EmployeeName
FROM Departments d
CROSS JOIN Employees e;

--Using Products, Suppliers table List only the combinations where the supplier actually supplies the product. Return supplier name and product name
SELECT 
    s.SupplierName,
    p.ProductName
FROM Products p
INNER JOIN Suppliers s 
    ON p.SupplierID = s.SupplierID;

--Using Orders, Customers table List customer names and their orders ID.
SELECT 
    c.CustomerName,
    o.OrderID
FROM Orders o
INNER JOIN Customers c 
    ON o.CustomerID = c.CustomerID;

--Using Courses, Students table Get all combinations of students and courses.
SELECT 
    s.StudentName,
    c.CourseName
FROM Students s
CROSS JOIN Courses c;

--Using Products, Orders table Get product names and orders where product IDs match.
SELECT 
    p.ProductName,
    o.OrderID
FROM Products p
JOIN Orders o
    ON p.ProductID = o.ProductID;

--Using Departments, Employees table List employees whose DepartmentID matches the department.
SELECT 
    e.EmployeeName,
    d.DepartmentName
FROM Employees e
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;

--Using Students, Enrollments table List student names and their enrolled course IDs.
SELECT 
    s.StudentName,
    e.CourseID
FROM Students s
JOIN Enrollments e
    ON s.StudentID = e.StudentID;

--Using Payments, Orders table List all orders that have matching payments.
SELECT 
    o.OrderID,
    p.PaymentID,
    p.Amount,
    p.PaymentDate
FROM Orders o
JOIN Payments p
    ON o.OrderID = p.OrderID;

--Using Orders, Products table Show orders where product price is more than 100.
SELECT 
    o.OrderID,
    p.PaymentID,
    p.Amount,
    p.PaymentDate
FROM Orders o
JOIN Payments p
    ON o.OrderID = p.OrderID;

	                               --Medium (10 puzzles)

--Using Employees, Departments table List employee names and department names where 
--department IDs are not equal. It means: Show all mismatched employee-department combinations.
SELECT 
    e.EmployeeName,
    d.DepartmentName
FROM Employees e
CROSS JOIN Departments d
WHERE e.DepartmentID <> d.DepartmentID;

--Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.
SELECT 
    o.OrderID,
    o.ProductID,
    p.ProductName,
    o.Quantity AS OrderedQuantity,
    p.StockQuantity AS AvailableStock
FROM Orders o
JOIN Products p
    ON o.ProductID = p.ProductID
WHERE o.Quantity > p.StockQuantity;

--Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.
SELECT 
    c.CustomerName,
    s.ProductID,
    s.SaleAmount
FROM Customers c
JOIN Sales s
    ON c.CustomerID = s.CustomerID
WHERE s.SaleAmount >= 500;

--Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.
SELECT 
    s.StudentName,
    c.CourseName
FROM Enrollments e
JOIN Students s
    ON e.StudentID = s.StudentID
JOIN Courses c
    ON e.CourseID = c.CourseID;

--Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.
SELECT 
    p.ProductName,
    s.SupplierName
FROM Products p
JOIN Suppliers s
    ON p.SupplierID = s.SupplierID
WHERE s.SupplierName LIKE '%Tech%';

--Using Orders, Payments table Show orders where payment amount is less than total amount.
SELECT 
    o.OrderID,
    o.TotalAmount,
    p.PaymentAmount
FROM Orders o
JOIN Payments p
    ON o.OrderID = p.OrderID
WHERE p.PaymentAmount < o.TotalAmount;

--Using Employees and Departments tables, get the Department Name for each employee.
SELECT 
    e.EmployeeName,
    d.DepartmentName
FROM Employees e
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;

--Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.
SELECT 
    p.ProductName,
    c.CategoryName
FROM Products p
JOIN Categories c
    ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Electronics', 'Furniture');

--Using Sales, Customers table Show all sales from customers who are from 'USA'.
SELECT 
    s.SaleID,
    s.ProductID,
    s.Amount,
    s.SaleDate,
    c.CustomerName,
    c.Country
FROM Sales s
JOIN Customers c
    ON s.CustomerID = c.CustomerID
WHERE c.Country = 'USA';

                                                --Hard

--Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.
SELECT 
    o.OrderID,
    o.CustomerID,
    c.CustomerName,
    c.Country,
    o.TotalAmount
FROM Orders o
JOIN Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.Country = 'Germany'
  AND o.TotalAmount > 100;

--Using Employees table List all pairs of employees from different departments.
SELECT 
    e1.EmployeeName AS Employee1,
    e1.DepartmentID AS Dept1,
    e2.EmployeeName AS Employee2,
    e2.DepartmentID AS Dept2
FROM Employees e1
JOIN Employees e2
    ON e1.EmployeeID < e2.EmployeeID
   AND e1.DepartmentID <> e2.DepartmentID;

 --Using Payments, Orders, Products table List payment details where the paid amount is not equal to (Quantity × Product Price).
 SELECT 
    p.PaymentID,
    p.OrderID,
    o.ProductID,
    o.Quantity,
    pr.Price AS ProductPrice,
    (o.Quantity * pr.Price) AS ExpectedAmount,
    p.AmountPaid
FROM Payments p
JOIN Orders o 
    ON p.OrderID = o.OrderID
JOIN Products pr 
    ON o.ProductID = pr.ProductID
WHERE p.AmountPaid <> (o.Quantity * pr.Price);

--Using Students, Enrollments, Courses table Find students who are not enrolled in any course.
SELECT 
    s.StudentID,
    s.StudentName
FROM Students s
LEFT JOIN Enrollments e 
    ON s.StudentID = e.StudentID
WHERE e.CourseID IS NULL;

--Using Employees table List employees who are managers of someone, but their salary is less than or equal to the person they manage.
SELECT 
    m.EmployeeID AS ManagerID,
    m.EmployeeName AS ManagerName,
    m.Salary AS ManagerSalary,
    e.EmployeeID AS EmployeeID,
    e.EmployeeName AS EmployeeName,
    e.Salary AS EmployeeSalary
FROM Employees m
JOIN Employees e 
    ON m.EmployeeID = e.ManagerID
WHERE m.Salary <= e.Salary;

--Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.
SELECT DISTINCT
    c.CustomerID,
    c.CustomerName,
    o.OrderID
FROM Orders o
JOIN Customers c
    ON o.CustomerID = c.CustomerID
LEFT JOIN Payments p
    ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL;






