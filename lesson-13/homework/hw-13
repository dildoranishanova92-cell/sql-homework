SELECT CONCAT(emp_id, '-', first_name, ' ', last_name) AS EmployeeInfo
FROM employees;

UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

SELECT 
    first_name AS "First Name",
    LENGTH(first_name) AS "Name Length"
FROM employees
WHERE first_name LIKE 'A%' 
   OR first_name LIKE 'J%' 
   OR first_name LIKE 'M%'
ORDER BY first_name;

SELECT 
    manager_id,
    SUM(salary) AS total_salary
FROM employees
GROUP BY manager_id;

SELECT 
    year,
    GREATEST(Max1, Max2, Max3) AS HighestValue
FROM TestMax;


SELECT *
FROM cinema
WHERE movie_id % 2 = 1       -- odd-numbered movies
  AND description <> 'boring' -- description not equal to 'boring'
ORDER BY rating DESC;         -- optional: highest-rated first

SELECT *
FROM SingleOrder
ORDER BY (Id = 0), Id;

SELECT 
    COALESCE(column1, column2, column3, column4) AS first_non_null
FROM person;


--Medium Tasks

SELECT 
    SUBSTRING_INDEX(FullName, ' ', 1) AS FirstName,
    CASE 
        WHEN LENGTH(FullName) - LENGTH(REPLACE(FullName, ' ', '')) >= 2 
             THEN SUBSTRING_INDEX(SUBSTRING_INDEX(FullName, ' ', 2), ' ', -1)
        ELSE NULL 
    END AS MiddleName,
    SUBSTRING_INDEX(FullName, ' ', -1) AS LastName
FROM Students;

SELECT *
FROM Orders
WHERE state = 'Texas'
  AND customer_id IN (
      SELECT DISTINCT customer_id
      FROM Orders
      WHERE state = 'California'
  );

  SELECT 
    Category,
    GROUP_CONCAT(Value ORDER BY Value SEPARATOR ', ') AS ConcatenatedValues
FROM DMLTable
GROUP BY Category;

SELECT *
FROM Employees
WHERE 
    LENGTH(CONCAT(FirstName, LastName))
    - LENGTH(REPLACE(LOWER(CONCAT(FirstName, LastName)), 'a', '')) >= 3;

	SELECT 
    DepartmentID,
    COUNT(*) AS TotalEmployees,
    ROUND(
        100.0 * SUM(
            CASE 
                WHEN DATEDIFF(CURDATE(), HireDate) > 365*3 THEN 1 
                ELSE 0 
            END
        ) / COUNT(*),
    2) AS PercentOver3Years
FROM Employees
GROUP BY DepartmentID;

--Difficult Tasks
UPDATE Students s
JOIN (
    SELECT 
        StudentID,
        SUM(Marks) OVER (ORDER BY StudentID) AS RunningTotal
    FROM Students
) r ON s.StudentID = r.StudentID
SET s.Marks = r.RunningTotal;

SELECT 
    s1.StudentName,
    s1.BirthDate
FROM Student s1
JOIN Student s2 
    ON s1.StudentID <> s2.StudentID
   AND MONTH(s1.BirthDate) = MONTH(s2.BirthDate)
   AND DAY(s1.BirthDate) = DAY(s2.BirthDate)
ORDER BY MONTH(s1.BirthDate), DAY(s1.BirthDate), s1.StudentName;

SELECT 
    LEAST(PlayerA, PlayerB) AS Player1,
    GREATEST(PlayerA, PlayerB) AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
    LEAST(PlayerA, PlayerB),
    GREATEST(PlayerA, PlayerB);

	SELECT
    REGEXP_REPLACE('tf56sd#%OqH', '[^A-Z]', '') AS Uppercase_Letters,
    REGEXP_REPLACE('tf56sd#%OqH', '[^a-z]', '') AS Lowercase_Letters,
    REGEXP_REPLACE('tf56sd#%OqH', '[^0-9]', '') AS Numbers,
    REGEXP_REPLACE('tf56sd#%OqH', '[A-Za-z0-9]', '') AS Other_Chars;
