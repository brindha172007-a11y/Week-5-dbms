CREATE DATABASE IF NOT EXISTS OrderManagementDB;
USE OrderManagementDB;
CREATE TABLE IF NOT EXISTS Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Total_Amount DECIMAL(10,2) NOT NULL CHECK (Total_Amount > 0),
    Order_Status VARCHAR(20) NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);
CREATE TABLE IF NOT EXISTS Payment (
    Payment_ID INT PRIMARY KEY,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Date DATE NOT NULL,
    Payment_Mode VARCHAR(30) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    Transaction_Amount DECIMAL(10,2) NOT NULL
        CHECK (Transaction_Amount > 0),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    CHECK (Payment_Mode IN (
        'UPI', 'Credit Card', 'Debit Card',
        'Net Banking', 'Cash on Delivery'
    )),
    CHECK (Payment_Status IN (
        'Pending', 'Success', 'Failed'
    ))
);
INSERT INTO Customers VALUES
(1, 'Arun', 'arun@gmail.com'),
(2, 'Priya', 'priya@gmail.com'),
(3, 'Kumar', 'kumar@gmail.com'),
(4, 'Divya', 'divya@gmail.com'),
(5, 'Ravi', 'ravi@gmail.com');
INSERT INTO Orders VALUES
(101, 1, '2026-10-20', 1500.00, 'Delivered'),
(102, 2, '2026-10-21', 2500.00, 'Processing'),
(103, 3, '2026-10-22', 1000.00, 'Pending'),
(104, 4, '2026-10-23', 3000.00, 'Processing'),
(105, 5, '2026-10-24', 2000.00, 'Pending');
INSERT INTO Payment VALUES
(1, 101, '2026-10-20', 'UPI', 'Success', 1500.00),
(2, 102, '2026-10-21', 'Credit Card', 'Failed', 2500.00),
(3, 103, '2026-10-22', 'Debit Card', 'Pending', 1000.00),
(4, 104, '2026-10-23', 'Net Banking', 'Success', 3000.00),
(5, 105, '2026-10-24', 'Cash on Delivery', 'Pending', 2000.00);
SELECT * FROM Payment;
SELECT * FROM Payment
WHERE Payment_Status = 'Success';
SELECT * FROM Payment
WHERE Payment_Status = 'Failed';
SELECT * FROM Payment
WHERE Payment_Status = 'Pending';

-- 11. RETRIEVE PAYMENT FOR A SPECIFIC ORDER
SELECT * FROM Payment
WHERE Order_ID = 101;

-- 12. UPDATE PAYMENT STATUS AFTER RETRY
UPDATE Payment
SET Payment_Status = 'Success'
WHERE Payment_ID = 2;

-- 13. UPDATE PAYMENT MODE
UPDATE Payment
SET Payment_Mode = 'UPI'
WHERE Payment_ID = 3;

-- 14. COUNT SUCCESSFUL AND FAILED PAYMENTS
SELECT Payment_Status, COUNT(*) AS Total_Transactions
FROM Payment
WHERE Payment_Status IN ('Success', 'Failed')
GROUP BY Payment_Status;

-- 15. COUNT TRANSACTIONS BY PAYMENT MODE
SELECT Payment_Mode, COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode;

-- 16. MOST PREFERRED PAYMENT METHOD
SELECT Payment_Mode, COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode
ORDER BY Total_Transactions DESC
LIMIT 1;

-- 17. TOTAL SUCCESSFUL PAYMENT REVENUE
SELECT SUM(Transaction_Amount) AS Total_Revenue
FROM Payment
WHERE Payment_Status = 'Success';

-- 18. REVENUE BY PAYMENT METHOD
SELECT Payment_Mode,
       SUM(Transaction_Amount) AS Revenue
FROM Payment
WHERE Payment_Status = 'Success'
GROUP BY Payment_Mode;

-- 19. AVERAGE TRANSACTION AMOUNT
SELECT AVG(Transaction_Amount) AS Average_Amount
FROM Payment;

-- 20. CUSTOMER PAYMENT HISTORY
SELECT C.Customer_ID, C.Customer_Name,
       O.Order_ID, O.Order_Date,
       P.Payment_Mode, P.Payment_Status,
       P.Transaction_Amount
FROM Customers C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
JOIN Payment P ON O.Order_ID = P.Order_ID
ORDER BY C.Customer_ID;

-- 21. COMPLETE PAYMENT, CUSTOMER AND ORDER DETAILS
SELECT C.Customer_Name, C.Email,
       O.Order_ID, O.Order_Date, O.Order_Status,
       P.Payment_ID, P.Payment_Date,
       P.Payment_Mode, P.Payment_Status,
       P.Transaction_Amount
FROM Customers C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
JOIN Payment P ON O.Order_ID = P.Order_ID;

-- 22. TOTAL SUCCESSFUL, FAILED AND PENDING PAYMENTS
SELECT Payment_Status, COUNT(*) AS Total
FROM Payment
GROUP BY Payment_Status;

-- 23. ORDERS WITH FAILED OR PENDING PAYMENTS
SELECT O.Order_ID, C.Customer_Name,
       P.Payment_Mode, P.Payment_Status,
       P.Transaction_Amount
FROM Orders O
JOIN Customers C ON O.Customer_ID = C.Customer_ID
JOIN Payment P ON O.Order_ID = P.Order_ID
WHERE P.Payment_Status IN ('Failed', 'Pending');

-- 24. DISPLAY ORDERS WITHOUT PAYMENT RECORDS
SELECT O.Order_ID, C.Customer_Name, O.Total_Amount
FROM Orders O
JOIN Customers C ON O.Customer_ID = C.Customer_ID
LEFT JOIN Payment P ON O.Order_ID = P.Order_ID
WHERE P.Payment_ID IS NULL;

-- 25. DELETE A PAYMENT RECORD (OPTIONAL)
-- Use only when deletion is required.
-- DELETE FROM Payment WHERE Payment_ID = 5;

-- 26. VERIFY PAYMENT TABLE STRUCTURE
DESCRIBE Payment;
