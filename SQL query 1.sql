-- 1. Customers Table
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    City VARCHAR(50)
);

-- 2. Restaurants Table
CREATE TABLE Restaurants (
    Restaurant_ID INT PRIMARY KEY,
    Restaurant_Name VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Rating DECIMAL(2,1)
);
-- 3. Food Items Table
CREATE TABLE Food_Items (
    Food_ID INT PRIMARY KEY,
    Food_Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Restaurant_ID INT,
    FOREIGN KEY (Restaurant_ID)
        REFERENCES Restaurants(Restaurant_ID)
);

-- 4. Orders Table
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    Order_Status VARCHAR(30),
    Total_Amount DECIMAL(10,2),
    FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID)
);

-- 5. Order Items Table
CREATE TABLE Order_Items (
    Order_Item_ID INT PRIMARY KEY,
    Order_ID INT,
    Food_ID INT,
    Quantity INT,
    Item_Price DECIMAL(10,2),
    FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID),
    FOREIGN KEY (Food_ID)
        REFERENCES Food_Items(Food_ID)
);

INSERT INTO Customers VALUES
(1, 'Arun', '9876543210', 'arun@gmail.com', 'Chennai'),
(2, 'Priya', '9876543211', 'priya@gmail.com', 'Coimbatore'),
(3, 'Kumar', '9876543212', 'kumar@gmail.com', 'Madurai'),
(4, 'Divya', '9876543213', 'divya@gmail.com', 'Salem'),
(5, 'Ravi', '9876543214', 'ravi@gmail.com', 'Trichy');

INSERT INTO Restaurants VALUES
(101, 'Annapoorna', 'Coimbatore', 4.5),
(102, 'A2B', 'Chennai', 4.2),
(103, 'SS Hyderabad Biryani', 'Chennai', 4.3),
(104, 'Dindigul Thalappakatti', 'Madurai', 4.4);

INSERT INTO Food_Items VALUES
(201, 'Idli', 40.00, 101),
(202, 'Dosa', 80.00, 101),
(203, 'Veg Meals', 120.00, 102),
(204, 'Chicken Biryani', 220.00, 103),
(205, 'Parotta', 60.00, 104),
(206, 'Fried Rice', 150.00, 103);

INSERT INTO Orders VALUES
(1001, 1, '2026-10-10', 'Delivered', 300.00),
(1002, 2, '2026-10-11', 'Delivered', 220.00),
(1003, 3, '2026-10-12', 'Preparing', 180.00),
(1004, 4, '2026-10-13', 'Cancelled', 120.00),
(1005, 5, '2026-10-14', 'Delivered', 440.00);

INSERT INTO Order_Items VALUES
(1, 1001, 204, 1, 220.00),
(2, 1001, 201, 2, 40.00),
(3, 1002, 204, 1, 220.00),
(4, 1003, 206, 1, 150.00),
(5, 1004, 203, 1, 120.00),
(6, 1005, 204, 2, 220.00);

SELECT * FROM Customers;

SELECT * FROM Restaurants;

SELECT * FROM Food_Items;

SELECT * FROM Orders;

SELECT * FROM Order_Items;

-- Business Analysis Queries for food_delivery data base
-- 1. Total number of orders
select count(*) as total_orders
FROM Orders;

-- What is the total revenue from delivered orders?
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders
WHERE Order_Status = 'Delivered';

--3. Which food items are the most popular?

SELECT
    F.Food_Name,
    SUM(OI.Quantity) AS Total_Quantity
FROM Order_Items AS OI
JOIN Food_Items AS F
    ON OI.Food_ID = F.Food_ID
JOIN Orders AS O
    ON OI.Order_ID = O.Order_ID
WHERE O.Order_Status = 'Delivered'
GROUP BY F.Food_Name
ORDER BY Total_Quantity DESC;

--Which customers place the most orders?
SELECT
    C.Customer_Name,
    COUNT(O.Order_ID) AS Total_Orders
FROM Customers AS C
LEFT JOIN Orders AS O
    ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name
ORDER BY Total_Orders DESC;

--Which restaurants offer the most food items?
SELECT
    R.Restaurant_Name,
    COUNT(F.Food_ID) AS Total_Food_Items
FROM Restaurants AS R
LEFT JOIN Food_Items AS F
    ON R.Restaurant_ID = F.Restaurant_ID
GROUP BY R.Restaurant_ID, R.Restaurant_Name
ORDER BY Total_Food_Items DESC;

--What is the order count for each order status?
SELECT
    Order_Status,
    COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Order_Status
ORDER BY Total_Orders DESC;

--Which order has the highest total amount?
SELECT TOP 1
    Order_ID,
    Customer_ID,
    Total_Amount,
    Order_Status
FROM Orders
ORDER BY Total_Amount DESC;

--Which restaurants have the highest average rating?
SELECT
    Restaurant_Name,
    City,
    Rating
FROM Restaurants
WHERE Rating IS NOT NULL
ORDER BY Rating DESC;