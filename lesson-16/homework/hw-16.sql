SELECT COUNT(*) AS TotalRows FROM Numbers;
SELECT Number FROM Numbers ORDER BY Number LIMIT 10;


SELECT 
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    S.TotalSales
FROM Employees E
JOIN (
    SELECT 
        EmployeeID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) AS S
ON E.EmployeeID = S.EmployeeID;

WITH AvgCTE AS (
    SELECT 
        AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT AvgSalary
FROM AvgCTE;

SELECT 
    p.ProductName,
    s.MaxSalesAmount
FROM Products p
JOIN (
    SELECT 
        ProductID,
        MAX(SalesAmount) AS MaxSalesAmount
    FROM Sales
    GROUP BY ProductID
) s ON p.ProductID = s.ProductID;

WITH RECURSIVE DoubleNumbers AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num * 2
    FROM DoubleNumbers
    WHERE Num * 2 < 1000000
)
SELECT * FROM DoubleNumbers;

WITH SalesCountCTE AS (
    SELECT 
        EmployeeID,
        COUNT(*) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
)
SELECT 
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    S.TotalSales
FROM SalesCountCTE S
JOIN Employees E ON E.EmployeeID = S.EmployeeID
WHERE S.TotalSales > 5;

WITH ProductSalesCTE AS (
    SELECT 
        s.ProductID,
        SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    GROUP BY s.ProductID
)
SELECT 
    p.ProductID,
    p.ProductName,
    ps.TotalSales
FROM ProductSalesCTE ps
JOIN Products p ON p.ProductID = ps.ProductID
WHERE ps.TotalSales > 500;

WITH AvgSalaryCTE AS (
    SELECT 
        AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Salary
FROM Employees e
CROSS JOIN AvgSalaryCTE a
WHERE e.Salary > a.AvgSalary;

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    t.TotalOrders
FROM (
    SELECT 
        EmployeeID,
        COUNT(*) AS TotalOrders
    FROM Sales
    GROUP BY EmployeeID
) AS t
JOIN Employees e ON e.EmployeeID = t.EmployeeID
ORDER BY t.TotalOrders DESC
LIMIT 5;   

SELECT 
    p.category,
    SUM(dt.total_sales) AS total_sales_per_category
FROM (
    SELECT 
        s.product_id,
        SUM(s.amount) AS total_sales
    FROM Sales s
    GROUP BY s.product_id
) AS dt
JOIN Products p ON dt.product_id = p.id
GROUP BY p.category;

CREATE TABLE Numbers1 (
    num INT
);

INSERT INTO Numbers1 VALUES (3), (4), (5);

WITH RECURSIVE SplitString AS (
    SELECT 
        1 AS position,
        SUBSTRING('HELLO', 1, 1) AS character,
        LENGTH('HELLO') AS str_length,
        'HELLO' AS full_string
    UNION ALL
    SELECT
        position + 1,
        SUBSTRING(full_string, position + 1, 1),
        str_length,
        full_string
    FROM SplitString
    WHERE position < str_length
)
SELECT position, character
FROM SplitString;


CREATE TABLE Sales (
    sale_month DATE,
    total_sales DECIMAL(10,2)
);

INSERT INTO Sales VALUES
('2025-01-01', 1000),
('2025-02-01', 1200),
('2025-03-01', 900),
('2025-04-01', 1500);
WITH MonthlySales AS (
    SELECT 
        sale_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sale_month) AS prev_month_sales
    FROM Sales
)
SELECT 
    sale_month,
    total_sales,
    prev_month_sales,
    (total_sales - prev_month_sales) AS sales_difference
FROM MonthlySales;

SELECT 
    e.employee_id,
    e.employee_name,
    dt.quarter,
    dt.total_sales
FROM (
    SELECT 
        employee_id,
        QUARTER(sale_date) AS quarter,
        SUM(sale_amount) AS total_sales
    FROM Sales
    GROUP BY employee_id, QUARTER(sale_date)
) AS dt
JOIN Employees e 
    ON e.employee_id = dt.employee_id
WHERE dt.total_sales > 45000;WITH RECURSIVE Fibonacci AS (
    SELECT 
        1 AS n,
        0 AS fib_prev,
        1 AS fib_curr
    UNION ALL
    SELECT 
        n + 1,
        fib_curr,
        fib_prev + fib_curr
    FROM Fibonacci
    WHERE n < 10   -- number of Fibonacci terms you want
)
SELECT 
    n AS position,
    fib_curr AS fibonacci_number
FROM Fibonacci;


SELECT str
FROM FindSameCharacters
WHERE LENGTH(str) > 1
  AND str = REPEAT(LEFT(str, 1), LENGTH(str));

  WITH RECURSIVE Numbers AS (
    SELECT 1 AS n, '1' AS num_str
    UNION ALL
    SELECT n + 1, CONCAT(num_str, n + 1)
    FROM Numbers
    WHERE n < 5   -- change this value for n
)
SELECT * FROM Numbers;

SELECT 
    e.employee_id,
    e.employee_name,
    dt.total_sales
FROM (
    SELECT 
        employee_id,
        SUM(sale_amount) AS total_sales
    FROM Sales
    WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    GROUP BY employee_id
) AS dt
JOIN Employees e 
    ON e.employee_id = dt.employee_id
WHERE dt.total_sales = (
    SELECT MAX(total_sales)
    FROM (
        SELECT 
            employee_id,
            SUM(sale_amount) AS total_sales
        FROM Sales
        WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
        GROUP BY employee_id
    ) AS inner_dt
);

WITH SplitClean AS (
    SELECT 
        name_str,
        value AS part
    FROM RemoveDuplicateIntsFromNames
    CROSS APPLY STRING_SPLIT(name_str, ' ')
),
Filtered AS (
    SELECT 
        name_str,
        part
    FROM SplitClean
    WHERE TRY_CAST(part AS INT) IS NULL  -- keep non-numeric parts (names)
          OR LEN(part) > 1               -- keep multi-digit numbers (e.g. 12)
),
Deduped AS (
    SELECT 
        name_str,
        part,
        ROW_NUMBER() OVER (PARTITION BY name_str, part ORDER BY (SELECT NULL)) AS rn
    FROM Filtered
)
SELECT 
    name_str AS original_value,
    STRING_AGG(part, ' ') AS cleaned_value
FROM Deduped
WHERE rn = 1
GROUP BY name_str;





