--easy
--1)Define the following terms: data, database, relational database, and table.
--1. Data
--Data is raw facts, figures, or symbols that by themselves may not have meaning.
--Examples: a customer’s name, a phone number, a date of birth, or a sales amount.
--When processed or organized, data becomes information.

--2. Database
--A database is an organized collection of data that can be easily accessed, managed, and updated.
--Think of it as a structured storage system where related data is kept together.
--Example: a library catalog system that stores book titles, authors, and borrower information.

--3. Relational Database
--A relational database is a type of database that organizes data into related tables (rows and columns).
--Relationships between data are established using keys (primary keys and foreign keys).
--Example: a customer table (with customer IDs) linked to an orders table (where each order references a customer ID).

--4. Table
--A table is the basic structure in a relational database used to store data in rows and columns.
--Each row (record) represents a single entry, and each column (field/attribute) represents a type of data.
--Example: a “Students” table with columns: StudentID, Name, Age, Grade.


--2)List five key features of SQL Server.
--1.Relational Database Engine
--2.T-SQL (Transact-SQL)
--3.High Availability & Disaster Recovery (HA/DR)
--4.Security Features
--5.Integration & Business Intelligence Tools

--3)What are the different authentication modes available when connecting to SQL Server? (Give at least 2)
--SQL Server supports two main authentication modes when connecting:
--Windows Authentication
--Uses the Windows (Active Directory) credentials of the user.
--More secure because passwords aren’t sent over the network.
--Allows single sign-on (SSO), so if you’re logged into Windows, you can connect without re-entering credentials.
--SQL Server Authentication
--Uses a separate username and password stored inside SQL Server.
--Useful when users are not part of the Windows domain or when cross-platform access is needed.
--Example: logging in with a SQL Server login like sa (system administrator).

MEDIUM
create database SchoolDB
use SchoolDB

create table Students (StudentID int PRIMARY KEY,
name varchar (50),
Age int)
Select * from Students

--Describe the differences between SQL Server, SSMS, and SQL.
--SQL Server = the car engine (does the work of storing and processing data).
--SSMS = the dashboard/steering wheel (interface to control the engine).
--SQL = the driver’s commands (instructions telling the car where to go).


