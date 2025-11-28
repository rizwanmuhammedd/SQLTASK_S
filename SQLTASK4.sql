------------------------------------------------------------
-- 1. CREATE DATABASE & USE IT
------------------------------------------------------------
CREATE DATABASE DemoDB;
USE DemoDB;

------------------------------------------------------------
-- 2. CREATE BOOK TABLE
------------------------------------------------------------
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(120),
    Author VARCHAR(100)
);

------------------------------------------------------------
-- 3. INSERT SAMPLE DATA
------------------------------------------------------------
INSERT INTO Books VALUES
(1,'The Alchemist','Paulo Coelho'),
(2,'Harry Potter','J.K. Rowling'),
(3,'Wings of Fire','A.P.J Abdul Kalam'),
(4,'The Pilgrimage','Paulo Coelho'),
(5,'Harry Potter - Chamber of Secrets','J.K. Rowling');

------------------------------------------------------------
-- 4. STORED PROCEDURE - Get All Book Titles
------------------------------------------------------------
CREATE PROCEDURE GetAllBookTitles
AS
BEGIN
    SELECT Title FROM Books;
END;

-- 🔸 Run this procedure
EXEC GetAllBookTitles;

------------------------------------------------------------
-- 5. STORED PROCEDURE - Get Books by Specific Author (with parameter)
------------------------------------------------------------
CREATE PROCEDURE GetBooksByAuthor(@AuthorName VARCHAR(100))
AS
BEGIN
    SELECT Title, Author
    FROM Books
    WHERE Author = @AuthorName;
END;

-- 🔸 Run Example
EXEC GetBooksByAuthor 'Paulo Coelho';
EXEC GetBooksByAuthor 'J.K. Rowling';

------------------------------------------------------------
-- 6. USER DEFINED FUNCTION - Return number of books by author
------------------------------------------------------------
CREATE FUNCTION CountBooksByAuthor(@Author VARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @TotalBooks INT;
    SELECT @TotalBooks = COUNT(*) FROM Books WHERE Author = @Author;
    RETURN @TotalBooks;
END;

-- 🔸 Call UDF Example
SELECT dbo.CountBooksByAuthor('Paulo Coelho') AS TotalBooks;
SELECT dbo.CountBooksByAuthor('J.K. Rowling') AS TotalBooks;
