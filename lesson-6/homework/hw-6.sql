--Puzzle 1: Finding Distinct Values
SELECT DISTINCT
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;

--Result 
col1 | col2
-----+-----
a    | b
c    | d
m    | n

SELECT DISTINCT
    LEAST(col1, col2) AS col1,
    GREATEST(col1, col2) AS col2
FROM InputTbl;

--Puzzle 2: Removing Rows with All Zeroes

SELECT *
FROM TestMultipleZero
WHERE (A + B + C + D) > 0;

--Puzzle 3: Find those with odd ids

SELECT *
FROM section1
WHERE id % 2 = 1;

--Person with the smallest id 

SELECT TOP 1 *
FROM section1
ORDER BY id ASC;

 --Person with the highest id 
 SELECT TOP 1 *
FROM section1
ORDER BY id DESC;

--People whose name starts with b
SELECT *
FROM section1
WHERE name LIKE 'B%';

--Write a query to return only the rows where the code contains the literal underscore _ (not as a wildcard).
SELECT *
FROM ProductCodes
WHERE Code LIKE '%\_%' ESCAPE '\';



