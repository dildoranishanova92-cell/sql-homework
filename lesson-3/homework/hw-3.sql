--Easy-Level Tasks (10)

--Define and explain the purpose of BULK INSERT in SQL Server.
--BULK INSERT is used in SQL Server to import massive amounts of data from external files into tables efficiently, 
--making it a go-to choice for data migration, ETL, and integration tasks.
--BULK INSERT is a high-performance command that reads data from a data file (such as .txt or .csv) and inserts it directly into a table. 
--It is optimized for bulk loading, meaning it can handle millions of rows faster than using multiple INSERT statements.

--List four file formats that can be imported into SQL Server.
--CSV (Comma-Separated Values)
--TXT (Plain Text / Delimited Text)
--XML (Extensible Markup Language)
--JSON (JavaScript Object Notation)

--Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

--Insert three records into the Products table using INSERT INTO.
INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
(1, 'Laptop', 899.99),
(2, 'Smartphone', 499.50),
(3, 'Headphones', 79.95);

--Explain the difference between NULL and NOT NULL.
--NULL
--In SQL, NULL means no value, unknown, or missing data.
--It is not the same as 0 or an empty string ''.
--A column that allows NULL can remain empty when a new row is inserted.
--NOT NULL
--Means the column must always have a value.
--SQL Server will reject any INSERT or UPDATE if the column is left empty.
--Example (same table):
--Name is defined as NOT NULL, so every employee must have a name.

--Add a UNIQUE constraint to the ProductName column in the Products table.
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

--Write a comment in a SQL query explaining its purpose.
-- Insert three sample products into the Products table
INSERT INTO Products (ProductID, ProductName, Price)
VALUES (4, 'Tablet', 299.99);
--They help explain the logic, purpose, or special notes about the SQL query so others (or your future self) can understand it quickly.

--Add CategoryID column to the Products table.
ALTER TABLE Products
ADD CategoryID INT;

--Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

--Explain the purpose of the IDENTITY column in SQL Server.
--The IDENTITY column in SQL Server is used to make a column automatically generate sequential numeric values whenever a new row is inserted. 
--It is most often applied to a primary key column.
--Purpose of IDENTITY
--Auto-generate IDs
--Saves you from manually entering unique IDs for each row.
--Example: 1, 2, 3, 4... are automatically created.
--Ensure uniqueness
--Often used with a PRIMARY KEY to make sure each row can be uniquely identified.
--Simplify data entry
--Developers and users don’t need to track or calculate the next ID number.
--Improve performance in inserts
--SQL Server handles numbering internally, which is faster and more reliable than managing it manually.

--Medium-Level Tasks 

BULK INSERT Products
FROM 'C:\Data\Products.txt'
WITH (
    FIELDTERMINATOR = ',',   -- columns are separated by commas
    ROWTERMINATOR = '\n',    -- rows end with newline
    FIRSTROW = 1             -- start from the first row (no header in this file)
);

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);


--PRIMARY KEY
--Ensures uniqueness of values in a column (or set of columns).
--Does not allow NULL values.
--A table can have only one PRIMARY KEY (though it can cover multiple columns → composite key).
--Automatically creates a clustered index (if none exists).
--UNIQUE KEY
--Ensures uniqueness of values, just like PRIMARY KEY.
--Allows one NULL value (in SQL Server).
--A table can have multiple UNIQUE constraints.
--Creates a non-clustered index by default.

ALTER TABLE Products
ADD CONSTRAINT CHK_Products_Price
CHECK (Price > 0);

ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

SELECT 
    ProductID,
    ProductName,
    ISNULL(Price, 0) AS Price,
    CategoryID,
    Stock
FROM Products;

--Purpose of FOREIGN KEY
--Maintain Data Consistency
--Ensures values in one table (child) must exist in another table (parent).
--Example: You can’t assign a product to a category that doesn’t exist.
--Prevent Orphan Records
--Stops insertion of rows that reference non-existing parent records.
--Stops deletion of parent rows that are still being referenced (unless cascading rules are set).
--Data Integrity
--Guarantees valid and reliable relationships between tables (e.g., Orders → Customers).

--Hard-Level Tasks 

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    CONSTRAINT CHK_Customers_Age CHECK (Age >= 18)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(100,10) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerName VARCHAR(100) NOT NULL
);

CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID)
);

--ISNULL Function
--Replaces a NULL value with a specified replacement value.
--Takes exactly 2 arguments.
--COALESCE Function
--Returns the first non-NULL value from a list of expressions.
--Can take two or more arguments (more flexible than ISNULL).


CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,               -- Primary Key (unique & not null)
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,           -- Unique Key (no duplicate emails)
    HireDate DATE NOT NULL
);


ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (OrderID)
REFERENCES Orders(OrderID)
ON DELETE CASCADE
ON UPDATE CASCADE;
