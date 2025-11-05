SELECT DISTINCT CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND s2.SaleDate >= '2024-03-01'
      AND s2.SaleDate < '2024-04-01'
);


SELECT Product, TotalRevenue
FROM (
    SELECT Product, SUM(Quantity * Price) AS TotalRevenue
    FROM #Sales
    GROUP BY Product
) AS RevenuePerProduct
WHERE TotalRevenue = (
    SELECT MAX(SUM(Quantity * Price)) 
    FROM #Sales
    GROUP BY Product
);


SELECT MAX(Price) AS SecondHighestPrice
FROM #Sales
WHERE Price < (
    SELECT MAX(Price) 
    FROM #Sales
);


SELECT 
    YEAR(SaleDate) AS SaleYear,
    MONTH(SaleDate) AS SaleMonth,
    (
        SELECT SUM(Quantity) 
        FROM #Sales AS S2
        WHERE YEAR(S2.SaleDate) = YEAR(S1.SaleDate)
          AND MONTH(S2.SaleDate) = MONTH(S1.SaleDate)
    ) AS TotalQuantity
FROM #Sales AS S1
GROUP BY YEAR(SaleDate), MONTH(SaleDate)
ORDER BY SaleYear, SaleMonth;


SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.Product = s2.Product
      AND s1.CustomerName <> s2.CustomerName
);

SELECT
    Name,
    SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name
ORDER BY Name;


WITH RecursiveFamily AS (
    -- Base case: direct parent-child relationships
    SELECT ParentId AS PID, ChildID AS CHID
    FROM Family
    UNION ALL
    -- Recursive case: find descendants
    SELECT rf.PID, f.ChildID
    FROM RecursiveFamily rf
    JOIN Family f
      ON rf.CHID = f.ParentID
)
SELECT *
FROM RecursiveFamily
ORDER BY PID, CHID;


SELECT o.CustomerID, o.OrderID, o.DeliveryState, o.Amount
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1
      FROM #Orders o2
      WHERE o2.CustomerID = o.CustomerID
        AND o2.DeliveryState = 'CA'
  )
ORDER BY o.CustomerID, o.OrderID;


UPDATE #residents
SET fullname = 
    CASE 
        WHEN fullname IS NULL OR fullname = '' THEN
            -- Extract name from address if it exists
            LTRIM(RTRIM(
                SUBSTRING(
                    address,
                    CHARINDEX('name=', address) + 5,
                    CHARINDEX(' ', address + ' ', CHARINDEX('name=', address) + 5) 
                        - (CHARINDEX('name=', address) + 5)
                )
            ))
        ELSE fullname
    END
WHERE fullname IS NULL
   OR fullname = '';


   WITH RecursiveRoutes AS (
    SELECT 
        DepartureCity,
        ArrivalCity,
        CAST(DepartureCity + ' - ' + ArrivalCity AS NVARCHAR(MAX)) AS RoutePath,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    SELECT 
        r.DepartureCity,
        rt.ArrivalCity,
        CAST(rt.RoutePath + ' - ' + r.ArrivalCity AS NVARCHAR(MAX)),
        rt.Cost + r.Cost
    FROM RecursiveRoutes rt
    INNER JOIN #Routes r
        ON rt.ArrivalCity = r.DepartureCity
    WHERE rt.RoutePath NOT LIKE '%' + r.ArrivalCity + '%'
),
RankedRoutes AS (
    SELECT *,
        ROW_NUMBER() OVER(ORDER BY Cost ASC) AS RN_Asc,
        ROW_NUMBER() OVER(ORDER BY Cost DESC) AS RN_Desc
    FROM RecursiveRoutes
    WHERE ArrivalCity = 'Khorezm'
)
SELECT RoutePath AS [Route], Cost
FROM RankedRoutes
WHERE RN_Asc = 1 OR RN_Desc = 1;


WITH CTE AS (
    SELECT *,
        -- Flag 1 when a new "Product" appears
        CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END AS IsProduct
    FROM #RankingPuzzle
),
Grouped AS (
    SELECT *,
        -- Running sum of Product flags to create groups
        SUM(IsProduct) OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS ProductGroup
    FROM CTE
)
SELECT ID, Vals, ProductGroup AS ProductRank
FROM Grouped
ORDER BY ID;


SELECT EmployeeID, EmployeeName, Department, SalesAmount, SalesMonth, SalesYear
FROM (
    SELECT *,
        AVG(SalesAmount) OVER (PARTITION BY Department) AS AvgDeptSales
    FROM #EmployeeSales
) AS t
WHERE SalesAmount > AvgDeptSales
ORDER BY Department, EmployeeName;


SELECT e.EmployeeID, e.EmployeeName, e.Department, e.SalesAmount, e.SalesMonth, e.SalesYear
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.Department = e.Department
      AND e2.SalesMonth = e.SalesMonth
      AND e2.SalesYear = e.SalesYear
      AND e2.SalesAmount > e.SalesAmount
)
ORDER BY e.SalesYear, e.SalesMonth, e.Department;


-- Find all months in the data
WITH Months AS (
    SELECT DISTINCT SalesMonth
    FROM #EmployeeSales
)

SELECT e.EmployeeID, e.EmployeeName
FROM (SELECT DISTINCT EmployeeID, EmployeeName FROM #EmployeeSales) e
WHERE NOT EXISTS (
    SELECT 1
    FROM Months m
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales s
        WHERE s.EmployeeID = e.EmployeeID
          AND s.SalesMonth = m.SalesMonth
    )
);


SELECT Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);


SELECT Name, Stock
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);


SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name = 'Laptop');


SELECT Name, Price
FROM Products
WHERE Category = 'Electronics'
  AND Price > (SELECT MIN(Price) 
               FROM Products 
               WHERE Category = 'Electronics');


SELECT p.ProductID, p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(p2.Price)
    FROM Products p2
    WHERE p2.Category = p.Category
);


SELECT p.ProductID, p.Name, p.Category, p.Price
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);


SELECT p.ProductID, p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(TotalQuantity)
    FROM (
        SELECT SUM(Quantity) AS TotalQuantity
        FROM Orders
        GROUP BY ProductID
    ) AS ProductTotals
);


SELECT p.ProductID, p.Name
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.ProductID IS NULL;


SELECT p.ProductID, p.Name, SUM(o.Quantity) AS TotalQuantity
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY SUM(o.Quantity) DESC
OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY;
