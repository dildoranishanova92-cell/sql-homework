CREATE PROCEDURE dbo.usp_CalculateEmployeeBonus
AS
BEGIN
    -- Create temporary table
    CREATE TABLE #EmployeeBonus
    (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    -- Insert data into temp table
    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.Department,
        e.Salary,
        e.Salary * db.BonusPercentage / 100 AS BonusAmount
    FROM Employees e
    JOIN DepartmentBonus db
        ON e.Department = db.Department;

    -- Select data from temp table
    SELECT * FROM #EmployeeBonus;
END;
GO

CREATE PROCEDURE dbo.usp_UpdateDepartmentSalary
    @DeptName NVARCHAR(50),
    @IncreasePercent DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update salaries for the given department
    UPDATE Employees
    SET Salary = Salary + (Salary * @IncreasePercent / 100)
    WHERE Department = @DeptName;

    -- Return the updated employees
    SELECT EmployeeID, FirstName, LastName, Department, Salary
    FROM Employees
    WHERE Department = @DeptName;
END;
GO


MERGE INTO Products_Current AS target
USING Products_New AS source
ON target.ProductID = source.ProductID

-- Update existing products
WHEN MATCHED THEN
    UPDATE SET
        target.ProductName = source.ProductName,
        target.Price = source.Price

-- Insert new products
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)

-- Delete products missing in source
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

-- Optional: output action taken for each row
OUTPUT 
    $action AS ActionT


	MERGE INTO Products_Current AS target
USING Products_New AS source
ON target.ProductID = source.ProductID

-- Update existing products
WHEN MATCHED THEN
    UPDATE SET
        target.ProductName = source.ProductName,
        target.Price = source.Price

-- Insert new products
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)

-- Delete products missing in source
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

-- Output action taken for each row
OUTPUT 
    $action AS ActionTaken,
    inserted.ProductID,
    inserted.ProductName,
    inserted.Price;


	SELECT 
    s.user_id,
    COALESCE(
        SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) / 
        NULLIF(COUNT(c.action), 0), 
        0
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY s.user_id;


SELECT id, name, salary
FROM employees
WHERE salary = (
    SELECT MIN(salary) FROM employees
);


CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantitySold,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s
        ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;
GO
