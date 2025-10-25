--Easy Tasks

SELECT 
    LEFT(Name, CHARINDEX(',', Name) - 1) AS FirstName,
    RIGHT(Name, LEN(Name) - CHARINDEX(',', Name)) AS LastName
FROM TestMultipleColumns;

SELECT *
FROM TestPercent
WHERE TextValue LIKE '%\%%' ESCAPE '\';

SELECT 
    ID,
    SUBSTRING_INDEX(FullString, '.', 1) AS Part1,
    SUBSTRING_INDEX(SUBSTRING_INDEX(FullString, '.', 2), '.', -1) AS Part2,
    SUBSTRING_INDEX(FullString, '.', -1) AS Part3
FROM Splitter;

SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

SELECT 
    ID,
    TextValue,
    LENGTH(TextValue) - LENGTH(REPLACE(TextValue, ' ', '')) AS SpaceCount
FROM CountSpaces;

SELECT 
    e.Name AS Employee,
    e.Salary AS EmployeeSalary,
    m.Name AS Manager,
    m.Salary AS ManagerSalary
FROM Employee e
JOIN Employee m 
    ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;

SELECT 
    EmployeeID,
    FirstName,
    LastName,
    HireDate,
    TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) AS YearsOfService
FROM Employees
WHERE TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) > 10
  AND TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) < 15;


--Medium Tasks
SELECT 
    w1.id,
    w1.recordDate,
    w1.temperature
FROM Weather w1
JOIN Weather w2 
    ON DATE_SUB(w1.recordDate, INTERVAL 1 DAY) = w2.recordDate
WHERE w1.temperature > w2.temperature;

SELECT 
    player_id,
    MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;

SELECT fruit_name
FROM fruits
LIMIT 1 OFFSET 2;

SELECT 
    EmpID,
    EmpName,
    HireDate,
    TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) AS YearsWorked,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) < 1 THEN 'New Hire'
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;

SELECT 
    Vals,
    CAST(SUBSTRING_INDEX(Vals, ' ', 1) AS UNSIGNED) AS IntegerValue
FROM GetIntegers
WHERE Vals REGEXP '^[0-9]';

--Difficult Tasks
SELECT 
    Vals,
    CONCAT(
        SUBSTRING(Vals, 2, 1),
        SUBSTRING(Vals, 1, 1),
        SUBSTRING(Vals, 3)
    ) AS Swapped
FROM MultipleVals;

WITH RECURSIVE chars AS (
    SELECT 1 AS n,
           SUBSTRING('sdgfhsdgfhs@121313131', 1, 1) AS ch
    UNION ALL
    SELECT n + 1,
           SUBSTRING('sdgfhsdgfhs@121313131', n + 1, 1)
    FROM chars
    WHERE n < LENGTH('sdgfhsdgfhs@121313131')
)
SELECT ch AS Character
FROM chars;

SELECT 
    player_id,
    device_id
FROM Activity a
WHERE event_date = (
    SELECT MIN(event_date)
    FROM Activity
    WHERE player_id = a.player_id
);

SELECT
    'rtcfvty34redt' AS OriginalValue,
    REGEXP_REPLACE('rtcfvty34redt', '[0-9]', '') AS LettersOnly,
    REGEXP_REPLACE('rtcfvty34redt', '[^0-9]', '') AS NumbersOnly;

