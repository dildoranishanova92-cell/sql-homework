SELECT Category, SUM(StockQuantity) AS TotalStock
FROM Products
GROUP BY Category;

SELECT AVG(Price) AS AveragePrice
FROM Products
WHERE Category = 'Electronics';

SELECT CustomerID, FirstName, LastName, City, Country
FROM Customers
WHERE City LIKE 'L%';

SELECT ProductName
FROM Products
WHERE ProductName LIKE '%er';

SELECT CustomerID, FirstName, LastName, Country
FROM Customers
WHERE Country LIKE '%a';

SELECT MAX(Price) AS HighestPrice
FROM Products;

SELECT 
    ProductID,
    ProductName,
    Quantity,
    CASE 
        WHEN Quantity < 30 THEN 'Low Stock'
        ELSE 'Sufficient'
    END AS StockStatus
FROM Products;


SELECT 
    Country,
    COUNT(CustomerID) AS TotalCustomers
FROM Customers
GROUP BY Country;

SELECT 
    MIN(Quantity) AS MinQuantity,
    MAX(Quantity) AS MaxQuantity
FROM Orders;

SELECT DISTINCT o.CustomerID
FROM Orders o
LEFT JOIN Invoices i 
    ON o.OrderID = i.OrderID
WHERE 
    o.OrderDate BETWEEN '2023-01-01' AND '2023-01-31'
    AND i.InvoiceID IS NULL;

SELECT ProductName
FROM Products
UNION ALL
SELECT ProductName
FROM Products_Discounted;


SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;

SELECT 
    YEAR(OrderDate) AS OrderYear,
    AVG(TotalAmount) AS AverageOrderAmount
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

SELECT 
    ProductName,
    CASE 
        WHEN Price < 100 THEN 'Low'
        WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
        WHEN Price > 500 THEN 'High'
    END AS PriceGroup
FROM Products;

SELECT *
INTO Population_Each_Year
FROM
(
    SELECT 
        CityName,
        Year,
        Population
    FROM City_Population
) AS SourceTable
PIVOT
(
    SUM(Population)
    FOR Year IN ([2012], [2013])
) AS PivotTable;

SELECT 
    ProductID,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

SELECT 
    ProductName
FROM Products
WHERE ProductName LIKE '%oo%';

-- Create new table with pivoted data
SELECT *
INTO Population_Each_City
FROM 
(
    -- Step 1: Select base data
    SELECT 
        Year,
        City,
        Population
    FROM City_Population
) AS SourceTable
PIVOT
(
    -- Step 2: Pivot population values by city
    SUM(Population)
    FOR City IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS PivotTable;


SELECT 
    CustomerID,
    SUM(InvoiceAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 3;     

-- Create the original table again from the pivoted one
SELECT 
    City,
    Year,
    Population
INTO City_Population
FROM 
(
    -- Step 1: Convert wide table into unpivotable structure
    SELECT 
        CityName, 
        [2012], 
        [2013]
    FROM Population_Each_Year
) AS SourceTable
UNPIVOT
(
    Population FOR Year IN ([2012], [2013])
) AS UnpivotTable;


SELECT 
    p.ProductName,
    COUNT(s.SaleID) AS TimesSold
FROM Products p
JOIN Sales s 
    ON p.ProductID = s.ProductID
GROUP BY p.ProductName;


SELECT 
    Year,
    City,
    Population
INTO City_Population
FROM Population_Each_City
UNPIVOT (
    Population FOR City IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS Unpvt;



