------------------------------------------------------------
-- 1. Create Database & Use It
------------------------------------------------------------
CREATE DATABASE DemoDB;
USE DemoDB;

------------------------------------------------------------
-- 2. Create Author Table
------------------------------------------------------------
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100),
    Country VARCHAR(50)
);

------------------------------------------------------------
-- 3. Create Book Table
------------------------------------------------------------
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(150),
    AuthorID INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

------------------------------------------------------------
-- 4. Insert Sample Data
------------------------------------------------------------
INSERT INTO Authors VALUES
(1,'Paulo Coelho','Brazil'),
(2,'J.K. Rowling','United Kingdom'),
(3,'A.P.J Abdul Kalam','India');

INSERT INTO Books VALUES
(101,'The Alchemist',1,450),
(102,'Wings of Fire',3,550),
(103,'Harry Potter',2,700),
(104,'The Pilgrimage',1,400);

------------------------------------------------------------
-- 5. CREATE VIEW (Join Book + Author Table)
------------------------------------------------------------
CREATE VIEW vw_BookAuthorDetails AS
SELECT B.BookID, B.Title, B.Price,
       A.AuthorName, A.Country
FROM Books B
INNER JOIN Authors A ON B.AuthorID = A.AuthorID;

------------------------------------------------------------
-- 6. Retrieve Data From View
------------------------------------------------------------
SELECT * FROM vw_BookAuthorDetails;
