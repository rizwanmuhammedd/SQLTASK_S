-- 📍 1. Create Database
CREATE DATABASE DemoDB;
USE DemoDB;

------------------------------------------------------------
-- 📍 2. Create Tables With Constraints (DDL)
------------------------------------------------------------

CREATE TABLE Fruits (
    FruitID INT PRIMARY KEY,
    FruitName VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

-- CHILD TABLE with FOREIGN KEYS + CASCADE
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    FruitID INT,
    SupplierID INT,
    Quantity INT CHECK (Quantity > 0),

    FOREIGN KEY (FruitID) REFERENCES Fruits(FruitID)
        ON UPDATE CASCADE ON DELETE CASCADE,

    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

------------------------------------------------------------
-- 📍 3. Insert Data (DML)
------------------------------------------------------------

INSERT INTO Fruits VALUES
(1,'Apple',120),
(2,'Banana',50),
(3,'Mango',150),
(4,'Orange',80);

INSERT INTO Suppliers VALUES
(10,'FreshFarms','Delhi'),
(11,'Green Valley','Mumbai'),
(12,'Natural Harvest','Chennai');

INSERT INTO Orders VALUES
(101,1,10,50),
(102,2,11,120),
(103,3,12,70),
(104,1,10,40),
(105,4,11,25);

------------------------------------------------------------
-- 📍 4. JOINS
------------------------------------------------------------

-- ⭐ INNER JOIN (Matching rows only)
SELECT O.OrderID,F.FruitName,S.SupplierName,O.Quantity
FROM Orders O
INNER JOIN Fruits F ON O.FruitID = F.FruitID
INNER JOIN Suppliers S ON O.SupplierID = S.SupplierID;

-- ⭐ LEFT JOIN (All Orders + Related Supplier/Fruit)
SELECT F.FruitName,S.SupplierName,O.Quantity
FROM Orders O
LEFT JOIN Fruits F ON O.FruitID = F.FruitID
LEFT JOIN Suppliers S ON O.SupplierID = S.SupplierID;

-- ⭐ RIGHT JOIN (Show all Suppliers even if no orders)
SELECT S.SupplierName,F.FruitName,O.Quantity
FROM Orders O
RIGHT JOIN Suppliers S ON O.SupplierID = S.SupplierID;


SELECT F.FruitName,S.SupplierName,O.Quantity
FROM Orders O
FULL OUTER JOIN Fruits F ON O.FruitID = F.FruitID
FULL OUTER JOIN Suppliers S ON O.SupplierID = S.SupplierID;



SELECT FruitName AS Name,'Fruit' AS Category FROM Fruits
UNION
SELECT SupplierName,'Supplier' FROM Suppliers;

SELECT FruitName AS Name,'Fruit' AS Category FROM Fruits
UNION ALL
SELECT SupplierName,'Supplier' FROM Suppliers;



UPDATE Fruits SET FruitID = 9 WHERE FruitID = 1;


DELETE FROM Suppliers WHERE SupplierID = 10;
