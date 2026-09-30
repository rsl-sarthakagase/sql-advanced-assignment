-- ============================================================
-- DATABASE SETUP
-- ============================================================

DROP DATABASE IF EXISTS online_shopping_advanced;
CREATE DATABASE online_shopping_advanced;
USE online_shopping_advanced;

-- ============================================================
-- TABLE CREATION
-- ============================================================

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- At least 10 customers.
INSERT INTO Customers (customer_id, customer_name, city, email) VALUES
(1, 'Aarav Sharma', 'Pune', 'aarav.sharma@example.com'),
(2, 'Priya Patel', 'Mumbai', 'priya.patel@example.com'),
(3, 'Rohan Deshmukh', 'Latur', 'rohan.deshmukh@example.com'),
(4, 'Sneha Kulkarni', 'Nashik', 'sneha.kulkarni@example.com'),
(5, 'Aditya Joshi', 'Nagpur', 'aditya.joshi@example.com'),
(6, 'Neha Shah', 'Ahmedabad', 'neha.shah@example.com'),
(7, 'Vikram Singh', 'Delhi', 'vikram.singh@example.com'),
(8, 'Ananya Rao', 'Bengaluru', 'ananya.rao@example.com'),
(9, 'Karan Mehta', 'Hyderabad', 'karan.mehta@example.com'),
(10, 'Isha Verma', 'Jaipur', 'isha.verma@example.com');

-- At least 10 products.
INSERT INTO Products (product_id, product_name, category, price) VALUES
(1, 'Wireless Mouse', 'Electronics', 750.00),
(2, 'Mechanical Keyboard', 'Electronics', 1800.00),
(3, 'USB-C Hub', 'Electronics', 1200.00),
(4, 'Laptop Stand', 'Accessories', 950.00),
(5, 'Office Chair', 'Furniture', 5500.00),
(6, 'Desk Lamp', 'Furniture', 1400.00),
(7, 'Noise Cancelling Headphones', 'Electronics', 3200.00),
(8, 'Notebook Set', 'Stationery', 450.00),
(9, 'Water Bottle', 'Lifestyle', 800.00),
(10, 'Backpack', 'Lifestyle', 1600.00),
(11, 'Smart Watch', 'Electronics', 4500.00),
(12, 'Standing Desk', 'Furniture', 12500.00);

-- At least 20 orders.
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date) VALUES
(1, 1, 1, 2, '2026-01-05'),
(2, 1, 5, 1, '2026-01-08'),
(3, 2, 2, 1, '2026-01-10'),
(4, 2, 8, 3, '2026-01-15'),
(5, 3, 3, 2, '2026-02-01'),
(6, 3, 9, 1, '2026-02-04'),
(7, 4, 7, 1, '2026-02-10'),
(8, 4, 4, 2, '2026-02-14'),
(9, 5, 12, 1, '2026-02-20'),
(10, 5, 6, 2, '2026-02-25'),
(11, 6, 11, 1, '2026-03-01'),
(12, 6, 10, 2, '2026-03-05'),
(13, 7, 2, 2, '2026-03-10'),
(14, 7, 1, 1, '2026-03-12'),
(15, 8, 5, 1, '2026-03-18'),
(16, 8, 3, 1, '2026-03-20'),
(17, 9, 7, 2, '2026-03-22'),
(18, 9, 8, 4, '2026-03-25'),
(19, 1, 11, 1, '2026-04-01'),
(20, 3, 10, 1, '2026-04-05');

-- ============================================================
-- SECTION 1: ADVANCED JOINS
-- ============================================================

-- Task 1: Display each customer along with the products they ordered.
SELECT c.customer_id, c.customer_name,
       p.product_id, p.product_name, o.quantity, o.order_date
FROM Customers AS c
INNER JOIN Orders AS o ON c.customer_id = o.customer_id
INNER JOIN Products AS p ON o.product_id = p.product_id
ORDER BY c.customer_id, o.order_id;

-- Task 2: Display all possible combinations of customers and products.
SELECT c.customer_id, c.customer_name,
       p.product_id, p.product_name, p.category, p.price
FROM Customers AS c
CROSS JOIN Products AS p
ORDER BY c.customer_id, p.product_id;

-- Task 3: Display all customers and their orders, including customers who have not placed any orders.
SELECT c.customer_id, c.customer_name, c.city,
       o.order_id, o.product_id, o.quantity, o.order_date
FROM Customers AS c
LEFT JOIN Orders AS o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_id;

-- ============================================================
-- SECTION 2: SUBQUERIES
-- ============================================================

-- Task 4: Find products priced above the average product price.
SELECT product_id, product_name, category, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
ORDER BY price DESC;

-- Task 5: Display customers whose total purchase amount is greater than the average customer purchase amount.
SELECT c.customer_id, c.customer_name,
       SUM(p.price * o.quantity) AS total_purchase_amount
FROM Customers AS c
INNER JOIN Orders AS o ON c.customer_id = o.customer_id
INNER JOIN Products AS p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(p.price * o.quantity) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT o2.customer_id,
               SUM(p2.price * o2.quantity) AS customer_total
        FROM Orders AS o2
        INNER JOIN Products AS p2 ON o2.product_id = p2.product_id
        GROUP BY o2.customer_id
    ) AS customer_totals
)
ORDER BY total_purchase_amount DESC;

-- Task 6: Find the highest-priced product in each category using a correlated subquery.
SELECT p.product_id, p.product_name, p.category, p.price
FROM Products AS p
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM Products AS p2
    WHERE p2.category = p.category
)
ORDER BY p.category, p.price DESC;

-- ============================================================
-- SECTION 3: SET OPERATIONS
-- ============================================================

-- Task 7: Combine products from two different categories using UNION.
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Electronics'
UNION
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Furniture'
ORDER BY category, product_id;

-- Task 8-A: MySQL alternative for INTERSECT using INNER JOIN.
-- Customers who ordered both Electronics and Furniture products.
SELECT DISTINCT c.customer_id, c.customer_name
FROM Customers AS c
INNER JOIN Orders AS oe ON c.customer_id = oe.customer_id
INNER JOIN Products AS pe ON oe.product_id = pe.product_id
INNER JOIN Orders AS ofu ON c.customer_id = ofu.customer_id
INNER JOIN Products AS pf ON ofu.product_id = pf.product_id
WHERE pe.category = 'Electronics'
  AND pf.category = 'Furniture'
ORDER BY c.customer_id;

-- Task 8-B: MySQL alternative for EXCEPT using LEFT JOIN.
-- Customers who ordered Electronics but never ordered Furniture.
SELECT DISTINCT c.customer_id, c.customer_name
FROM Customers AS c
INNER JOIN Orders AS oe ON c.customer_id = oe.customer_id
INNER JOIN Products AS pe ON oe.product_id = pe.product_id
LEFT JOIN (
    SELECT DISTINCT o.customer_id
    FROM Orders AS o
    INNER JOIN Products AS p ON o.product_id = p.product_id
    WHERE p.category = 'Furniture'
) AS furniture_customers
    ON c.customer_id = furniture_customers.customer_id
WHERE pe.category = 'Electronics'
  AND furniture_customers.customer_id IS NULL
ORDER BY c.customer_id;

-- ============================================================
-- SECTION 4: WINDOW FUNCTIONS
-- ============================================================

-- Task 9: Rank products by price within each category.
SELECT product_id, product_name, category, price,
       RANK() OVER (
           PARTITION BY category
           ORDER BY price DESC
       ) AS price_rank
FROM Products
ORDER BY category, price_rank;

-- Task 10: Display previous product price using LAG and a running total of product prices using window functions.
SELECT product_id, product_name, category, price,
       LAG(price) OVER (
           PARTITION BY category
           ORDER BY price
       ) AS previous_product_price,
       SUM(price) OVER (
           PARTITION BY category
           ORDER BY price
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total_price
FROM Products
ORDER BY category, price;

-- ============================================================
-- SECTION 5: COMMON TABLE EXPRESSIONS (CTEs)
-- ============================================================

-- Task 11: CTE to display customers whose total purchase amount is above the average.
WITH CustomerTotals AS (
    SELECT c.customer_id, c.customer_name,
           SUM(p.price * o.quantity) AS total_purchase_amount
    FROM Customers AS c
    INNER JOIN Orders AS o ON c.customer_id = o.customer_id
    INNER JOIN Products AS p ON o.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
),
AverageCustomerTotal AS (
    SELECT AVG(total_purchase_amount) AS average_purchase_amount
    FROM CustomerTotals
)
SELECT ct.customer_id, ct.customer_name, ct.total_purchase_amount
FROM CustomerTotals AS ct
CROSS JOIN AverageCustomerTotal AS act
WHERE ct.total_purchase_amount > act.average_purchase_amount
ORDER BY ct.total_purchase_amount DESC;

-- Task 12: Recursive CTE to generate numbers from 1 to 10.
WITH RECURSIVE NumberSequence AS (
    SELECT 1 AS number
    UNION ALL
    SELECT number + 1
    FROM NumberSequence
    WHERE number < 10
)
SELECT number
FROM NumberSequence
ORDER BY number;

-- ============================================================
-- SECTION 6: VIEWS
-- ============================================================

-- Task 13: Create a view for products priced above ₹1,000 and retrieve data from the view.
CREATE OR REPLACE VIEW Products_Above_1000 AS
SELECT product_id, product_name, category, price
FROM Products
WHERE price > 1000;

SELECT product_id, product_name, category, price
FROM Products_Above_1000
ORDER BY price DESC;

-- ============================================================
-- SECTION 7: INDEXES AND QUERY PERFORMANCE
-- ============================================================

-- Task 14: Create an index on Products.category.
CREATE INDEX idx_products_category
ON Products(category);

-- Task 15: Use EXPLAIN to analyze a query filtering products by category.
EXPLAIN
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Electronics';

-- ============================================================
-- SECTION 8: STORED PROCEDURES AND FUNCTIONS
-- ============================================================

-- Task 16: Stored procedure to retrieve products by category.
DROP PROCEDURE IF EXISTS GetProductsByCategory;

DELIMITER $$

CREATE PROCEDURE GetProductsByCategory(IN p_category VARCHAR(50))
BEGIN
    SELECT product_id, product_name, category, price
    FROM Products
    WHERE category = p_category
    ORDER BY price DESC;
END$$

DELIMITER ;

-- Execute the stored procedure.
CALL GetProductsByCategory('Electronics');

-- Task 17: Function to calculate total price of an order (price × quantity).
DROP FUNCTION IF EXISTS CalculateOrderTotal;

DELIMITER $$

CREATE FUNCTION CalculateOrderTotal(p_order_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12,2);

    SELECT p.price * o.quantity
    INTO v_total
    FROM Orders AS o
    INNER JOIN Products AS p ON o.product_id = p.product_id
    WHERE o.order_id = p_order_id;

    RETURN COALESCE(v_total, 0.00);
END$$

DELIMITER ;

-- Execute the function.
SELECT order_id, customer_id, product_id, quantity,
       CalculateOrderTotal(order_id) AS order_total
FROM Orders
ORDER BY order_id;

-- ============================================================
-- SECTION 9: TRANSACTIONS
-- ============================================================

-- Task 18-A: Demonstrate ROLLBACK.
START TRANSACTION;

UPDATE Products
SET price = 999.00
WHERE product_id = 1;

SELECT product_id, product_name, price
FROM Products
WHERE product_id = 1;

ROLLBACK;

SELECT product_id, product_name, price
FROM Products
WHERE product_id = 1;

-- Task 18-B: Demonstrate COMMIT.
START TRANSACTION;

UPDATE Products
SET price = 800.00
WHERE product_id = 1;

SELECT product_id, product_name, price
FROM Products
WHERE product_id = 1;

COMMIT;

SELECT product_id, product_name, price
FROM Products
WHERE product_id = 1;

-- ============================================================
-- SECTION 10: SQL TRIGGERS
-- ============================================================

-- Task 19: Create a trigger that records new orders in Order_Audit.
CREATE TABLE Order_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    customer_id INT,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    action VARCHAR(20) NOT NULL,
    audit_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_order_after_insert;

DELIMITER $$

CREATE TRIGGER trg_order_after_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Audit (
        order_id,
        customer_id,
        product_id,
        quantity,
        order_date,
        action
    )
    VALUES (
        NEW.order_id,
        NEW.customer_id,
        NEW.product_id,
        NEW.quantity,
        NEW.order_date,
        'INSERT'
    );
END$$

DELIMITER ;

-- Demonstrate the trigger.
INSERT INTO Orders (
    order_id, customer_id, product_id, quantity, order_date
)
VALUES (
    21, 10, 4, 1, '2026-04-10'
);

-- Verify the automatically generated audit record.
SELECT audit_id, order_id, customer_id, product_id, quantity,
       order_date, action, audit_timestamp
FROM Order_Audit
WHERE order_id = 21;

-- ============================================================
-- SECTION 11: PERFORMANCE TUNING
-- ============================================================

-- Task 20: Optimize the query using SQL performance best practices.
--
-- Assignment example:
-- SELECT DISTINCT *
-- FROM Products
-- WHERE YEAR(created_date) = 2024
-- AND category = 'Electronics';
--
-- Improvements:
-- 1. Avoid SELECT *.
-- 2. Remove unnecessary DISTINCT because product_id is unique.
-- 3. Avoid functions on indexed columns.
-- 4. Use an index-friendly WHERE condition.

-- Optimized query:
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Electronics';

-- Verify the execution plan of the optimized query.
EXPLAIN
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Electronics';
