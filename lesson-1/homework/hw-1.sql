create database class35
use class35

create schema edu

CREATE TABLE Edu.Students (
StudentID INT IDENTITY(1,1) PRIMARY KEY, 
FirstName VARCHAR (50) NOT NULL,
LAstNAme VARCHAR (50) NULL,
BirthDate DATE NOT NULL,
Grade INT NOT NULL);

select * from Edu.Students

INSERT INTO Edu.Students Values ('Dildora', 'Ermatova', '1992-07-03', 5),

('Laziz', 'Kazimov', '1997-05-27', 6 )

INSERT INTO Edu.Students (FirstName, BirthDate, Grade)
VALUES ('Laylo', '1998-02-26', 5);
DELETE from Edu.Students
WHERE StudentID = 4;

ALTER TABLE Edu.Students
ADD  Email VARCHAR(100);

UPDATE Edu.Students
SET Email = 'dildoranishanova92@gmail.com'
WHERE StudentID =1;
