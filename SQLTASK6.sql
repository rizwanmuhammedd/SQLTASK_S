------------------------------------------------------------
-- 1. Create Database
------------------------------------------------------------
CREATE DATABASE LibraryDB;
USE LibraryDB;

------------------------------------------------------------
-- 2. Create Tables
------------------------------------------------------------

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100)
);

-- Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(150),
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- BookCopies Table (Tracks physical copies)
CREATE TABLE BookCopies (
    CopyID INT PRIMARY KEY,
    BookID INT,
    IsAvailable BIT DEFAULT 1,  -- 1 = Available, 0 = Borrowed
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Users Table (Library Members)
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100)
);

-- Borrowing Table (Tracks Borrow Records)
CREATE TABLE Borrowing (
    BorrowID INT PRIMARY KEY,
    UserID INT,
    CopyID INT,
    BorrowDate DATE,
    ReturnDate DATE NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CopyID) REFERENCES BookCopies(CopyID)
);

------------------------------------------------------------
-- 3. Insert Sample Data
------------------------------------------------------------
INSERT INTO Authors VALUES
(1,'Paulo Coelho'),
(2,'J.K. Rowling');

INSERT INTO Books VALUES
(101,'The Alchemist',1),
(102,'Harry Potter',2),
(103,'The Pilgrimage',1);

INSERT INTO BookCopies VALUES
(1,101,1),
(2,101,1),
(3,102,1),
(4,103,1);

INSERT INTO Users VALUES
(201,'Rahul'),
(202,'Aisha'),
(203,'Salman');

------------------------------------------------------------
-- 4. STORED PROCEDURE: CHECKOUT BOOK FOR RENT
-- Updates availability & creates borrow record
------------------------------------------------------------
CREATE PROCEDURE CheckoutBook
    @UserID INT,
    @CopyID INT
AS
BEGIN
    -- Check if book is available
    IF EXISTS (SELECT 1 FROM BookCopies WHERE CopyID=@CopyID AND IsAvailable=1)
    BEGIN
        -- Insert into Borrowing table
        INSERT INTO Borrowing (BorrowID,UserID,CopyID,BorrowDate)
        VALUES ((SELECT ISNULL(MAX(BorrowID),0)+1 FROM Borrowing),
                @UserID,@CopyID,GETDATE());

        -- Update status → Not Available
        UPDATE BookCopies SET IsAvailable=0 WHERE CopyID=@CopyID;

        PRINT 'Book Successfully Checked Out!';
    END
    ELSE
        PRINT 'Book Copy is Not Available!';
END;
GO

-- Test Checkout
EXEC CheckoutBook 201,1;


------------------------------------------------------------
-- 5. STORED PROCEDURE: RETURN BOOK
-- Updates ReturnDate and makes copy available again
------------------------------------------------------------
CREATE PROCEDURE ReturnBook
    @UserID INT,
    @CopyID INT
AS
BEGIN
    UPDATE Borrowing
    SET ReturnDate = GETDATE()
    WHERE UserID=@UserID AND CopyID=@CopyID AND ReturnDate IS NULL;

    UPDATE BookCopies SET IsAvailable=1 WHERE CopyID=@CopyID;

    PRINT 'Book Returned Successfully!';
END;
GO

-- Test Return
-- EXEC ReturnBook 201,1;


------------------------------------------------------------
-- 6. FUNCTION: GET NUMBER OF BOOKS BY AUTHOR
------------------------------------------------------------
CREATE FUNCTION CountBooksByAuthor(@AuthorID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalBooks INT;
    SELECT @TotalBooks = COUNT(*) FROM Books WHERE AuthorID=@AuthorID;
    RETURN @TotalBooks;
END;
GO

-- Test
-- SELECT dbo.CountBooksByAuthor(1) AS BooksByAuthor;


------------------------------------------------------------
-- 7. FUNCTION: GET LIST OF OVERDUE BOOKS (> 7 DAYS)
------------------------------------------------------------
CREATE FUNCTION GetOverdueBooks()
RETURNS TABLE
AS
RETURN
(
    SELECT B.BorrowID, U.UserName, BC.CopyID, BS.Title, B.BorrowDate
    FROM Borrowing B
    JOIN Users U ON B.UserID=U.UserID
    JOIN BookCopies BC ON B.CopyID=BC.CopyID
    JOIN Books BS ON BC.BookID=BS.BookID
    WHERE B.ReturnDate IS NULL
      AND B.BorrowDate <= DATEADD(DAY,-7,GETDATE())
);
GO

-- Test
-- SELECT * FROM dbo.GetOverdueBooks();
