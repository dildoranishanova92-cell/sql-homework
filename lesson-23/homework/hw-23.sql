SELECT
    Id,
    Dt,
    DATE_FORMAT(Dt, '%m') AS MonthPrefixedWithZero
FROM Dates
ORDER BY Id;


SELECT
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVals) AS TotalOfMaxVals
FROM (
    SELECT
        Id,
        rID,
        MAX(Vals) AS MaxVals
    FROM MyTabel
    GROUP BY Id, rID
) AS sub
GROUP BY rID;


SELECT Id, Vals
FROM TestFixLengths
WHERE Vals IS NOT NULL
  AND CHAR_LENGTH(Vals) BETWEEN 6 AND 10;


  SELECT t.ID, t.Item, t.Vals
FROM TestMaximum t
INNER JOIN (
    SELECT ID, MAX(Vals) AS MaxVals
    FROM TestMaximum
    GROUP BY ID
) m ON t.ID = m.ID AND t.Vals = m.MaxVals
ORDER BY t.ID;


SELECT
    Id,
    SUM(MaxVals) AS SumofMax
FROM (
    SELECT
        Id,
        DetailedNumber,
        MAX(Vals) AS MaxVals
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) AS sub
GROUP BY Id
ORDER BY Id;

SELECT
    Id,
    a,
    b,
    CASE 
        WHEN a - b = 0 THEN ''
        ELSE CAST(a - b AS CHAR)
    END AS OUTPUT
FROM TheZeroPuzzle
ORDER BY Id;


SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;


SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales;


SELECT COUNT(*) AS TotalSales
FROM Sales;


SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales;


SELECT
    Category,
    SUM(QuantitySold) AS TotalUnitsSold
FROM Sales
GROUP BY Category
ORDER BY Category;

SELECT
    Region,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region
ORDER BY Region;


SELECT
    Product,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC
LIMIT 1;


SELECT
    SaleID,
    Product,
    SaleDate,
    QuantitySold * UnitPrice AS Revenue,
    SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales
ORDER BY SaleDate;


SELECT
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    ROUND(SUM(QuantitySold * UnitPrice) / SUM(SUM(QuantitySold * UnitPrice)) OVER () * 100, 2) AS RevenuePercentage
FROM Sales
GROUP BY Category
ORDER BY RevenuePercentage DESC;


SELECT
    s.SaleID,
    s.Product,
    s.Category,
    s.QuantitySold,
    s.UnitPrice,
    s.SaleDate,
    s.Region AS SaleRegion,
    c.CustomerName,
    c.Region AS CustomerRegion
FROM Sales s
JOIN Customers c
    ON s.CustomerID = c.CustomerID
ORDER BY s.SaleID;


SELECT
    c.CustomerID,
    c.CustomerName,
    c.Region,
    c.JoinDate
FROM Customers c
LEFT JOIN Sales s
    ON c.CustomerID = s.CustomerID
WHERE s.SaleID IS NULL
ORDER BY c.CustomerID;


SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
JOIN Sales s
    ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;


SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
JOIN Sales s
    ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC
LIMIT 1;


SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold) AS TotalUnitsSold
FROM Customers c
JOIN Sales s
    ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalUnitsSold DESC;


SELECT DISTINCT p.ProductID, p.ProductName, p.Category
FROM Products p
JOIN Sales s
    ON p.ProductName = s.Product;


	SELECT ProductID, ProductName, Category, SellingPrice
FROM Products
ORDER BY SellingPrice DESC
LIMIT 1;

SELECT p.ProductID, p.ProductName, p.Category, p.SellingPrice
FROM Products p
WHERE p.SellingPrice > (
    SELECT AVG(p2.SellingPrice)
    FROM Products p2
    WHERE p2.Category = p.Category
);
