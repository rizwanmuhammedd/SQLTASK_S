------------------------------------------------------------
-- 1. CREATE DATABASE & USE IT
------------------------------------------------------------
CREATE DATABASE DemoDB;
USE DemoDB;

------------------------------------------------------------
-- 2. CREATE TABLES (DDL)
------------------------------------------------------------
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100)
);

CREATE TABLE BookSales (
    SaleID INT PRIMARY KEY,
    BookID INT,
    SaleDate DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

------------------------------------------------------------
-- 3. INSERT DATA (DML)
------------------------------------------------------------
INSERT INTO Books VALUES
(1,'The Alchemist','Paulo Coelho'),
(2,'Harry Potter','J.K. Rowling'),
(3,'Wings of Fire','A.P.J Abdul Kalam');

INSERT INTO BookSales VALUES
(1001,1,'2024-01-10',500),
(1002,1,'2024-02-11',650),
(1003,2,'2024-02-15',800),
(1004,2,'2023-11-12',1200),
(1005,3,'2024-03-05',700),
(1006,3,'2023-06-18',900);

------------------------------------------------------------
-- 4. TOTAL SALES OF EACH BOOK (SUM)
------------------------------------------------------------
SELECT B.Title, SUM(S.Amount) AS TotalSales
FROM BookSales S
JOIN Books B ON S.BookID = B.BookID
GROUP BY B.Title;

------------------------------------------------------------
-- 5. GROUP BY BOOK AND YEAR
------------------------------------------------------------
SELECT B.Title,
       YEAR(S.SaleDate) AS SaleYear,
       SUM(S.Amount) AS TotalSales
FROM BookSales S
JOIN Books B ON S.BookID = B.BookID
GROUP BY B.Title, YEAR(S.SaleDate);

------------------------------------------------------------
-- 6. FILTER USING HAVING – ONLY BOOKS WITH SALES > 1200
------------------------------------------------------------
SELECT B.Title, SUM(S.Amount) AS TotalSales
FROM BookSales S
JOIN Books B ON S.BookID = B.BookID
GROUP BY B.Title
HAVING SUM(S.Amount) > 1200;

------------------------------------------------------------
-- 7. STORED PROCEDURE – INPUT BOOK TITLE → RETURNS TOTAL SALES
------------------------------------------------------------
CREATE PROCEDURE GetBookSales(@Title VARCHAR(100))
AS
BEGIN
    SELECT B.Title, SUM(S.Amount) AS TotalSales
    FROM BookSales S
    JOIN Books B ON S.BookID = B.BookID
    WHERE B.Title = @Title
    GROUP BY B.Title;
END;

-- Run Procedure
EXEC GetBookSales 'Harry Potter';
EXEC GetBookSales 'The Alchemist';

------------------------------------------------------------
-- 8. USER-DEFINED FUNCTION UDF – AVERAGE SALE AMOUNT
------------------------------------------------------------
CREATE FUNCTION AvgSalesAmount()
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Avg DECIMAL(10,2);
    SELECT @Avg = AVG(Amount) FROM BookSales;
    RETURN @Avg;
END;

-- Call UDF
SELECT dbo.AvgSalesAmount() AS AverageSaleAmount;
