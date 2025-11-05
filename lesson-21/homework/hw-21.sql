SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    Quantity,
    CustomerID,
    ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales
ORDER BY SaleDate;


SELECT
    ProductName,
    SUM(Quantity) AS TotalQuantitySold,
    DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS ProductRank
FROM ProductSales
GROUP BY ProductName
ORDER BY ProductRank;


SELECT
    CustomerID,
    ProductName,
    SaleAmount,
    SaleDate
FROM (
    SELECT
        CustomerID,
        ProductName,
        SaleAmount,
        SaleDate,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) AS ranked_sales
WHERE rn = 1
ORDER BY CustomerID;


SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount AS CurrentSaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales
ORDER BY SaleDate;


SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount AS CurrentSaleAmount,
    LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales
ORDER BY SaleDate;


SELECT
    curr.SaleID,
    curr.ProductName,
    curr.SaleDate,
    curr.SaleAmount AS CurrentSaleAmount,
    prev.SaleAmount AS PreviousSaleAmount
FROM ProductSales curr
JOIN ProductSales prev
    ON prev.SaleDate = (
        SELECT MAX(SaleDate)
        FROM ProductSales
        WHERE SaleDate < curr.SaleDate
    )
WHERE curr.SaleAmount > prev.SaleAmount
ORDER BY curr.SaleDate;


SELECT
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - LAG(SaleAmount) OVER (
        PARTITION BY ProductName
        ORDER BY SaleDate
    ) AS DiffFromPrevious
FROM ProductSales
ORDER BY ProductName, SaleDate;


SELECT
    ProductName,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (
        PARTITION BY ProductName
        ORDER BY SaleDate
    ) AS NextSaleAmount,
    CASE 
        WHEN LEAD(SaleAmount) OVER (
            PARTITION BY ProductName
            ORDER BY SaleDate
        ) IS NULL THEN NULL
        ELSE 
            ((LEAD(SaleAmount) OVER (
                PARTITION BY ProductName
                ORDER BY SaleDate
            ) - SaleAmount) / SaleAmount) * 100
    END AS PercentChange
FROM ProductSales
ORDER BY ProductName, SaleDate;


SELECT
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (
        PARTITION BY ProductName
        ORDER BY SaleDate
    ) AS PreviousSaleAmount,
    CASE
        WHEN LAG(SaleAmount) OVER (
            PARTITION BY ProductName
            ORDER BY SaleDate
        ) IS NULL THEN NULL
        ELSE CAST(SaleAmount AS DECIMAL(10,2)) / LAG(SaleAmount) OVER (
            PARTITION BY ProductName
            ORDER BY SaleDate
        )
    END AS SaleRatio
FROM ProductSales
ORDER BY ProductName, SaleDate;


SELECT
    ProductName,
    SaleDate,
    SaleAmount,
    FIRST_VALUE(SaleAmount) OVER (
        PARTITION BY ProductName
        ORDER BY SaleDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS FirstSaleAmount,
    SaleAmount - FIRST_VALUE(SaleAmount) OVER (
        PARTITION BY ProductName
        ORDER BY SaleDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS DiffFromFirstSale
FROM ProductSales
ORDER BY ProductName, SaleDate;


SELECT
    ProductName,
    SaleDate,
    SaleAmount
FROM (
    SELECT
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSaleAmount
    FROM ProductSales
) AS t
WHERE PrevSaleAmount IS NOT NULL
  AND SaleAmount > PrevSaleAmount
ORDER BY ProductName, SaleDate;


SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS ClosingBalance
FROM ProductSales
ORDER BY SaleDate;


SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    AVG(SaleAmount) OVER (
        ORDER BY SaleDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAverage3
FROM ProductSales
ORDER BY SaleDate;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    Salary - AVG(Salary) OVER () AS DifferenceFromAvg
FROM Employees1
ORDER BY EmployeeID;


WITH SalaryRanks AS (
    SELECT
        EmployeeID,
        Name,
        Department,
        Salary,
        RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
)
SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    SalaryRank
FROM SalaryRanks
WHERE SalaryRank IN (
    SELECT SalaryRank
    FROM SalaryRanks
    GROUP BY SalaryRank
    HAVING COUNT(*) > 1
)
ORDER BY SalaryRank, EmployeeID;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary
FROM (
    SELECT
        EmployeeID,
        Name,
        Department,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rn
    FROM Employees1
) AS ranked
WHERE rn <= 2
ORDER BY Department, Salary DESC;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary
FROM (
    SELECT
        EmployeeID,
        Name,
        Department,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rn
    FROM Employees1
) AS ranked
WHERE rn = 1
ORDER BY Department;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department
        ORDER BY HireDate ASC, EmployeeID ASC
        ROWS UNBOUNDED PRECEDING
    ) AS RunningTotalSalary
FROM Employees1
ORDER BY Department, HireDate, EmployeeID;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalDepartmentSalary
FROM Employees1
ORDER BY Department, EmployeeID;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgDepartmentSalary
FROM Employees1
ORDER BY Department, EmployeeID;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS DeptAvgSalary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS SalaryDifference
FROM Employees1
ORDER BY Department, EmployeeID;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (
        ORDER BY EmployeeID
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS MovingAvgSalary
FROM Employees1
ORDER BY EmployeeID;


SELECT SUM(Salary) AS SumLast3Hired
FROM (
    SELECT Salary,
           ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS rn
    FROM Employees1
) AS t
WHERE rn <= 3;
