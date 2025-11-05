-- Step 1: Create a temporary table
CREATE TABLE #MonthlySales (
    ProductID INT,
    TotalQuantity INT,
    TotalRevenue DECIMAL(10,2)
);

-- Step 2: Insert data into the temp table
INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT 
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE 
    YEAR(s.SaleDate) = YEAR(GETDATE())      -- current year
    AND MONTH(s.SaleDate) = MONTH(GETDATE()) -- current month
GROUP BY s.ProductID;

-- Step 3: View the result
SELECT * FROM #MonthlySales;


CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    COALESCE(SUM(s.Quantity), 0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s 
    ON p.ProductID = s.ProductID
GROUP BY 
    p.ProductID, 
    p.ProductName, 
    p.Category;


	CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10,2);

    SELECT @TotalRevenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID;

    RETURN ISNULL(@TotalRevenue, 0);
END;

CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.Category,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.Category
);

CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2;
    DECLARE @IsPrime BIT = 1;

    -- Numbers less than 2 are not prime
    IF @Number < 2
        RETURN 'No';

    -- Check divisibility from 2 up to sqrt(@Number)
    WHILE (@i * @i) <= @Number
    BEGIN
        IF (@Number % @i = 0)
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i += 1;
    END

    IF @IsPrime = 1 
        RETURN 'Yes';
    ELSE 
        RETURN 'No';
END;
GO

CREATE FUNCTION dbo.fn_GetNumbersBetween
(
    @Start INT,
    @End INT
)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @Start;

    WHILE @i <= @End
    BEGIN
        INSERT INTO @Numbers VALUES (@i);
        SET @i = @i + 1;
    END;

    RETURN;
END;
GO


CREATE FUNCTION dbo.getNthHighestSalary(@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    SELECT @Result = (
        SELECT DISTINCT Salary
        FROM Employee
        ORDER BY Salary DESC


		SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY COUNT(*) DESC;


CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    IFNULL(SUM(o.amount), 0) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o 
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, 
    c.name;


	SELECT 
    RowNumber,
    COALESCE(
        TestCase,
        LAST_VALUE(TestCase IGNORE NULLS) OVER (
            ORDER BY RowNumber 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    ) AS Workflow
FROM Gaps
ORDER BY RowNumber;
