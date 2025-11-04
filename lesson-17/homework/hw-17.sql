-- Get distinct distributors and regions
WITH Distributors AS (
    SELECT DISTINCT Distributor FROM #RegionSales
),
Regions AS (
    SELECT DISTINCT Region FROM #RegionSales
),
AllCombinations AS (
    SELECT 
        r.Region,
        d.Distributor
    FROM Regions r
    CROSS JOIN Distributors d
)
SELECT 
    ac.Region,
    ac.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM AllCombinations ac
LEFT JOIN #RegionSales rs
    ON rs.Region = ac.Region
    AND rs.Distributor = ac.Distributor
ORDER BY ac.Distributor, ac.Region;


SELECT e.name
FROM Employee e
JOIN (
    SELECT managerId
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
) AS mgr
ON e.id = mgr.managerId;

SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM Products p
JOIN Orders o
    ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01'
  AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;


WITH VendorOrders AS (
    SELECT
        CustomerID,
        Vendor,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY CustomerID, Vendor
),
RankedVendors AS (
    SELECT
        CustomerID,
        Vendor,
        order_count,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY order_count DESC) AS rn
    FROM VendorOrders
)
SELECT
    CustomerID,
    Vendor
FROM RankedVendors
WHERE rn = 1;


DECLARE @Check_Prime INT = 91;  -- Change this number to test
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1; -- Assume prime initially

IF @Check_Prime <= 1
    SET @IsPrime = 0;
ELSE
BEGIN
    WHILE @i * @i <= @Check_Prime
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END
END

-- Return result
SELECT CASE 
         WHEN @IsPrime = 1 THEN 'This number is prime'
         ELSE 'This number is not prime'
       END AS Result;


	   WITH DeviceSignals AS (
    -- Count signals per device per location
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS signals_per_location
    FROM Device
    GROUP BY Device_id, Locations
),
MaxLocation AS (
    -- Get the location with max signals per device
    SELECT 
        ds.Device_id,
        ds.Locations AS max_signal_location
    FROM DeviceSignals ds
    INNER JOIN (
        SELECT 
            Device_id,
            MAX(signals_per_location) AS max_signals
        FROM DeviceSignals
        GROUP BY Device_id
    ) AS t
    ON ds.Device_id = t.Device_id AND ds.signals_per_location = t.max_signals
),
DeviceSummary AS (
    -- Summarize per device
    SELECT 
        Device_id,
        COUNT(DISTINCT Locations) AS no_of_location,
        SUM(signals_per_location) AS no_of_signals
    FROM DeviceSignals
    GROUP BY Device_id
)
SELECT 
    ds.Device_id,
    ds.no_of_location,
    ml.max_signal_location,
    ds.no_of_signals
FROM DeviceSummary ds
JOIN MaxLocation ml
    ON ds.Device_id = ml.Device_id
ORDER BY ds.Device_id;

SELECT 
    EmpID,
    EmpName,
    Salary
FROM Employee e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
);


WITH TicketMatches AS (
    SELECT
        t.TicketID,
        COUNT(*) AS matched_count
    FROM Tickets t
    INNER JOIN Numbers n
        ON t.Number = n.Number
    GROUP BY t.TicketID
),
TicketWinnings AS (
    SELECT
        TicketID,
        CASE 
            WHEN matched_count = (SELECT COUNT(*) FROM Numbers) THEN 100
            WHEN matched_count > 0 THEN 10
            ELSE 0
        END AS winnings
    FROM TicketMatches
)
SELECT SUM(winnings) AS total_winnings
FROM TicketWinnings;


WITH DailyUserSpending AS (
    SELECT
        Spend_date,
        User_id,
        SUM(CASE WHEN Platform = 'Mobile' THEN Amount ELSE 0 END) AS MobileAmount,
        SUM(CASE WHEN Platform = 'Desktop' THEN Amount ELSE 0 END) AS DesktopAmount
    FROM Spending
    GROUP BY Spend_date, User_id
),
Aggregated AS (
    SELECT
        Spend_date,
        SUM(MobileAmount) AS MobileAmount,
        SUM(DesktopAmount) AS DesktopAmount,
        COUNT(DISTINCT CASE WHEN MobileAmount > 0 THEN User_id END) AS MobileUsers,
        COUNT(DISTINCT CASE WHEN DesktopAmount > 0 THEN User_id END) AS DesktopUsers,
        COUNT(DISTINCT User_id) AS BothUsers,
        SUM(MobileAmount + DesktopAmount) AS BothAmount
    FROM DailyUserSpending
    GROUP BY Spend_date
)
SELECT Spend_date, 'Mobile' AS Platform, MobileAmount AS Total_Amount, MobileUsers AS Total_users
FROM Aggregated
UNION ALL
SELECT Spend_date, 'Desktop', DesktopAmount, DesktopUsers
FROM Aggregated
UNION ALL
SELECT Spend_date, 'Both', BothAmount, BothUsers
FROM Aggregated
ORDE


-- Create a numbers CTE
WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < 100  -- maximum quantity expected
)
SELECT 
    g.Product,
    1 AS Quantity
FROM Grouped g
JOIN Numbers n
    ON n.n <= g.Quantity
ORDER BY g.Product
OPTION (MAXRECURSION 0);
