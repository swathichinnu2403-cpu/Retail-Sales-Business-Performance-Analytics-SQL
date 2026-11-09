-- Create your database
CREATE DATABASE RetailSalesDB;
USE RetailSalesDB;
USE RetailSalesDB;

-- regions
CREATE TABLE regions (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL UNIQUE
);
-- categories
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);
-- customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    city VARCHAR(100),
    region_id INT,
    signup_date DATE,
    customer_segment VARCHAR(30) DEFAULT 'Regular',
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);
-- products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT,
    cost DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CHECK (cost >= 0),
    CHECK (selling_price >= 0),
    CHECK (stock_quantity >= 0)
);
-- employees
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    job_title VARCHAR(100),
    region_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);
-- orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    employee_id INT,
    order_date DATE NOT NULL,
    order_status VARCHAR(30) DEFAULT 'Pending',
    sales_channel VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CHECK (order_status IN
    ('Delivered', 'Pending', 'Processing', 'Cancelled', 'Returned')),
    CHECK (sales_channel IN ('Online', 'Store', 'Phone'))
);
-- order_items
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    CHECK (quantity > 0),
    CHECK (price >= 0),
    CHECK (discount BETWEEN 0 AND 100)
);
-- payments
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CHECK (amount >= 0),
    CHECK (payment_method IN
    ('Cash', 'Card', 'UPI', 'Net Banking')),
    CHECK (payment_status IN
    ('Paid', 'Pending', 'Failed', 'Refunded'))
);
-- returns
CREATE TABLE returns (
    return_id INT AUTO_INCREMENT PRIMARY KEY,
    order_item_id INT NOT NULL,
    return_date DATE,
    quantity INT NOT NULL,
    reason VARCHAR(255),
    refund_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id),
    CHECK (quantity > 0),
    CHECK (refund_amount >= 0)
);


SHOW TABLES;

-- checking the number of tables
SELECT COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema = 'RetailSalesDB';

-- Inserting values to the tables
INSERT INTO regions (region_name)
VALUES
('North'),
('South'),
('East'),
('West'),
('Central');

INSERT INTO categories (category_name)
VALUES
('Electronics'),
('Furniture'),
('Accessories'),
('Stationery'),
('Home Appliances');

SELECT * FROM regions;
SELECT * FROM categories;
USE RetailSalesDB;

INSERT INTO customers
(customer_name, email, city, region_id, signup_date, customer_segment)
VALUES
('Anu Thomas', 'anu@gmail.com', 'Kochi', 2, '2025-01-10', 'Regular'),
('Rahul Nair', 'rahul@gmail.com', 'Kannur', 2, '2025-02-15', 'Premium'),
('Meera Das', 'meera@gmail.com', 'Chennai', 3, '2025-03-20', 'Regular'),
('Arjun Kumar', 'arjun@gmail.com', 'Mumbai', 4, '2025-04-05', 'Corporate'),
('Priya Menon', 'priya@gmail.com', 'Delhi', 1, '2025-04-18', 'Premium'),
('Vishnu Raj', 'vishnu@gmail.com', 'Kozhikode', 2, '2025-05-12', 'Regular'),
('Sneha Paul', 'sneha@gmail.com', 'Bengaluru', 5, '2025-06-01', 'Corporate'),
('Akhil Mohan', 'akhil@gmail.com', 'Hyderabad', 3, '2025-06-22', 'Regular'),
('Divya Suresh', 'divya@gmail.com', 'Thrissur', 2, '2025-07-09', 'Premium'),
('Nikhil Varma', 'nikhil@gmail.com', 'Pune', 4, '2025-08-14', 'Regular');
SELECT * FROM customers;

INSERT INTO products
(product_name, category_id, cost, selling_price, stock_quantity)
VALUES
('Laptop', 1, 40000, 50000, 20),
('Smartphone', 1, 15000, 20000, 35),
('Monitor', 1, 7000, 10000, 18),
('Keyboard', 3, 500, 900, 50),
('Mouse', 3, 250, 500, 60),
('Office Chair', 2, 3000, 4500, 15),
('Office Desk', 2, 5000, 7500, 12),
('Notebook Pack', 4, 100, 180, 80),
('Printer', 1, 6000, 8500, 22),
('Headphones', 3, 1200, 2000, 28),
('Mixer Grinder', 5, 2500, 3500, 16),
('Electric Kettle', 5, 900, 1400, 30),
('Tablet', 1, 12000, 16000, 14),
('Pen Set', 4, 150, 250, 100),
('Webcam', 3, 1800, 2800, 10);
SELECT * FROM products;

-- This displays products from the highest selling price to the lowest
SELECT product_name, selling_price, stock_quantity
FROM products
ORDER BY selling_price DESC;

INSERT INTO employees
(employee_name, job_title, region_id, salary)
VALUES
('Asha Nair', 'Sales Manager', 2, 45000),
('Rohit Sharma', 'Sales Executive', 1, 28000),
('Neha Das', 'Sales Executive', 3, 30000),
('Kiran Joseph', 'Regional Manager', 4, 50000),
('Manu Raj', 'Sales Executive', 5, 27000);
SELECT * FROM employees;

SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_products FROM products;

SELECT COUNT(*) AS total_employees FROM employees;

SELECT COUNT(*) AS total_regions FROM regions;

SELECT COUNT(*) AS total_categories FROM categories;

INSERT INTO orders
(customer_id, employee_id, order_date, order_status, sales_channel)
VALUES
(1, 1, '2025-01-05', 'Delivered', 'Online'),
(2, 2, '2025-01-10', 'Delivered', 'Store'),
(3, 3, '2025-01-15', 'Pending', 'Online'),
(4, 4, '2025-01-20', 'Delivered', 'Phone'),
(5, 5, '2025-02-02', 'Cancelled', 'Online'),
(6, 1, '2025-02-08', 'Delivered', 'Store'),
(7, 2, '2025-02-12', 'Processing', 'Online'),
(8, 3, '2025-02-18', 'Delivered', 'Phone'),
(9, 4, '2025-03-03', 'Returned', 'Store'),
(10, 5, '2025-03-09', 'Delivered', 'Online'),
(1, 2, '2025-03-15', 'Delivered', 'Online'),
(2, 3, '2025-03-20', 'Pending', 'Phone'),
(3, 4, '2025-04-01', 'Delivered', 'Store'),
(4, 5, '2025-04-07', 'Delivered', 'Online'),
(5, 1, '2025-04-12', 'Processing', 'Phone'),
(6, 2, '2025-04-18', 'Delivered', 'Online'),
(7, 3, '2025-05-02', 'Delivered', 'Store'),
(8, 4, '2025-05-08', 'Cancelled', 'Phone'),
(9, 5, '2025-05-14', 'Delivered', 'Online'),
(10, 1, '2025-05-20', 'Delivered', 'Store'),
(1, 3, '2025-06-04', 'Pending', 'Online'),
(2, 4, '2025-06-10', 'Delivered', 'Phone'),
(3, 5, '2025-06-16', 'Delivered', 'Store'),
(4, 1, '2025-06-22', 'Returned', 'Online'),
(5, 2, '2025-06-28', 'Delivered', 'Online');
SELECT * FROM orders;

SELECT COUNT(*) AS total_orders
FROM orders;

INSERT INTO order_items
(order_id, product_id, quantity, price, discount)
VALUES
(1, 1, 1, 50000, 5),
(1, 4, 2, 900, 0),
(2, 5, 1, 500, 0),
(3, 2, 1, 20000, 10),
(4, 3, 2, 10000, 5),
(5, 8, 3, 180, 0),
(6, 6, 1, 4500, 0),
(7, 10, 2, 2000, 5),
(8, 9, 1, 8500, 0),
(9, 7, 1, 7500, 10),
(10, 14, 5, 250, 0),
(11, 1, 1, 50000, 0),
(12, 11, 1, 3500, 0),
(13, 12, 2, 1400, 5),
(14, 13, 1, 16000, 10),
(15, 15, 1, 2800, 0),
(16, 2, 2, 20000, 5),
(17, 4, 3, 900, 0),
(18, 5, 2, 500, 0),
(19, 6, 2, 4500, 5),
(20, 7, 1, 7500, 0),
(21, 8, 10, 180, 0),
(22, 9, 1, 8500, 5),
(23, 10, 1, 2000, 0),
(24, 3, 1, 10000, 0),
(25, 13, 1, 16000, 5),
(2, 4, 1, 900, 0),
(4, 5, 2, 500, 0),
(6, 8, 4, 180, 0),
(10, 14, 2, 250, 0);
SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT * FROM order_items;
INSERT INTO payments
(order_id, payment_date, payment_method, payment_status, amount)
VALUES
(1, '2025-01-05', 'UPI', 'Paid', 52600),
(2, '2025-01-10', 'Card', 'Paid', 1400),
(3, NULL, 'UPI', 'Pending', 18000),
(4, '2025-01-20', 'Card', 'Paid', 20000),
(5, NULL, 'UPI', 'Failed', 540),
(6, '2025-02-08', 'Cash', 'Paid', 5220),
(7, NULL, 'Card', 'Pending', 3800),
(8, '2025-02-18', 'Net Banking', 'Paid', 8500),
(9, '2025-03-03', 'Card', 'Refunded', 6750),
(10, '2025-03-09', 'UPI', 'Paid', 1700),
(11, '2025-03-15', 'Card', 'Paid', 50000),
(12, NULL, 'UPI', 'Pending', 3500),
(13, '2025-04-01', 'Cash', 'Paid', 2660),
(14, '2025-04-07', 'Card', 'Paid', 14400),
(15, NULL, 'UPI', 'Pending', 2800),
(16, '2025-04-18', 'UPI', 'Paid', 38000),
(17, '2025-05-02', 'Cash', 'Paid', 2700),
(18, NULL, 'Card', 'Failed', 1000),
(19, '2025-05-14', 'Card', 'Paid', 8550),
(20, '2025-05-20', 'UPI', 'Paid', 7500),
(21, NULL, 'UPI', 'Pending', 1800),
(22, '2025-06-10', 'Net Banking', 'Paid', 8075),
(23, '2025-06-16', 'Cash', 'Paid', 2000),
(24, '2025-06-22', 'Card', 'Refunded', 10000),
(25, '2025-06-28', 'UPI', 'Paid', 15200);
SELECT payment_status, COUNT(*) AS total
FROM payments
GROUP BY payment_status;

-- check everything
SELECT COUNT(*) AS customers FROM customers;
SELECT COUNT(*) AS products FROM products;
SELECT COUNT(*) AS employees FROM employees;
SELECT COUNT(*) AS orders_count FROM orders;
SELECT COUNT(*) AS order_items_count FROM order_items;
SELECT COUNT(*) AS payments_count FROM payments;

-- Display customers from a selected city
SELECT *
FROM customers
WHERE city = 'Kochi';

-- Find products priced above ₹1,000
SELECT product_name, selling_price
FROM products
WHERE selling_price > 1000;

--  Find orders within a date range
SELECT *
FROM orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-03-31';

-- Find products with stock below 25
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 25;

-- Display the five most expensive products
SELECT product_name, selling_price
FROM products
ORDER BY selling_price DESC
LIMIT 5;

-- Find customers whose names start with 'A'
SELECT *
FROM customers
WHERE customer_name LIKE 'A%';

-- Find Pending or Processing orders
SELECT *
FROM orders
WHERE order_status IN ('Pending', 'Processing');

-- Display products from highest price to lowest
SELECT product_name, selling_price
FROM products
ORDER BY selling_price DESC;

-- Display the first five customers
SELECT *
FROM customers
ORDER BY customer_id
LIMIT 5;

-- Count customers, products, and orders
SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_orders
FROM orders;

-- Calculate total sales value for each month
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.quantity * oi.price * (1 - oi.discount / 100)), 2)
        AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- Top five products based on sales value
SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * oi.price * (1 - oi.discount / 100)), 2)
        AS total_sales
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC
LIMIT 5;

-- Calculate the average order value
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.price * (1 - oi.discount / 100))
            AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
) AS order_totals;

-- Total units sold for each product category
SELECT
    c.category_name,
    SUM(oi.quantity) AS total_units_sold
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.category_id, c.category_name
ORDER BY total_units_sold DESC;

-- Total sales by region and sales channel
SELECT
    r.region_name,
    o.sales_channel,
    ROUND(SUM(oi.quantity * oi.price * (1 - oi.discount / 100)), 2)
        AS total_sales
FROM regions r
JOIN customers c ON r.region_id = c.region_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY r.region_name, o.sales_channel
ORDER BY total_sales DESC;

-- Identify customers who placed multiple orders
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Find the highest-value order
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    ROUND(SUM(oi.quantity * oi.price * (1 - oi.discount / 100)), 2)
        AS order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.order_id, c.customer_name, o.order_date
ORDER BY order_value DESC
LIMIT 1;

-- Total sales handled by each employee
SELECT
    e.employee_id,
    e.employee_name,
    ROUND(SUM(oi.quantity * oi.price * (1 - oi.discount / 100)), 2)
        AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY e.employee_id, e.employee_name
ORDER BY total_sales DESC;

-- Compare the number of orders across statuses
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Identify the most frequently purchased product
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_units_purchased
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_units_purchased DESC
LIMIT 1;

-- Display each order with customer name, order date, and status
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.order_status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- Display product names with their category names
SELECT
    p.product_name,
    c.category_name
FROM products p
JOIN categories c
    ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- Find customers who have never placed an order
SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Identify products that have never been sold
SELECT
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- Find products priced above the average product price
SELECT
    product_name,
    selling_price
FROM products
WHERE selling_price > (
    SELECT AVG(selling_price)
    FROM products
)
ORDER BY selling_price DESC;

-- Calculate sales value by customer
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(oi.quantity * oi.price * (1 - oi.discount / 100)),
        2
    ) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_sales DESC;

-- Find customers whose total purchases exceed the average customer purchase value
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(
        CASE
            WHEN o.order_status = 'Delivered'
            THEN oi.quantity * oi.price * (1 - oi.discount / 100)
            ELSE 0
        END
    ), 0) AS total_purchases
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
HAVING total_purchases > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            c2.customer_id,
            COALESCE(SUM(
                CASE
                    WHEN o2.order_status = 'Delivered'
                    THEN oi2.quantity * oi2.price *
                         (1 - oi2.discount / 100)
                    ELSE 0
                END
            ), 0) AS customer_total
        FROM customers c2
        LEFT JOIN orders o2
            ON c2.customer_id = o2.customer_id
        LEFT JOIN order_items oi2
            ON o2.order_id = oi2.order_id
        GROUP BY c2.customer_id
    ) AS customer_totals
)
ORDER BY total_purchases DESC;

-- Display payment details with order and customer information
SELECT
    p.payment_id,
    o.order_id,
    c.customer_name,
    o.order_date,
    p.payment_date,
    p.payment_method,
    p.payment_status,
    p.amount
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- Find employees who have not handled any orders
SELECT
    e.employee_id,
    e.employee_name,
    e.job_title
FROM employees e
LEFT JOIN orders o
    ON e.employee_id = o.employee_id
WHERE o.order_id IS NULL;

-- Analyse returned products and their refund amounts
SELECT
    r.return_id,
    p.product_name,
    o.order_id,
    r.return_date,
    r.quantity AS returned_quantity,
    r.reason,
    r.refund_amount
FROM returns r
JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
ORDER BY r.return_date;

-- Categorise orders into Low, Medium and High value
WITH OrderValues AS (
    SELECT
        o.order_id,
        o.order_date,
        o.order_status,
        COALESCE(
            SUM(oi.quantity * oi.price * (1 - oi.discount / 100)),
            0
        ) AS order_value
    FROM orders o
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.order_date,
        o.order_status
)
SELECT
    order_id,
    order_date,
    order_status,
    ROUND(order_value, 2) AS order_value,
    CASE
        WHEN order_value < 10000 THEN 'Low'
        WHEN order_value < 50000 THEN 'Medium'
        ELSE 'High'
    END AS value_category
FROM OrderValues
ORDER BY order_value DESC;

-- Rank products by sales value using RANK()
WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        COALESCE(
            SUM(oi.quantity * oi.price * (1 - oi.discount / 100)),
            0
        ) AS total_sales
    FROM products p
    LEFT JOIN order_items oi
        ON p.product_id = oi.product_id
    LEFT JOIN orders o
        ON oi.order_id = o.order_id
        AND o.order_status = 'Delivered'
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM ProductSales
ORDER BY sales_rank;

-- Find each customer's first and most recent order
SELECT
    c.customer_id,
    c.customer_name,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS most_recent_order_date,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;

-- Calculate cumulative monthly sales
WITH MonthlySales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(
            oi.quantity * oi.price * (1 - oi.discount / 100)
        ) AS monthly_sales
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(monthly_sales, 2) AS monthly_sales,
    ROUND(
        SUM(monthly_sales) OVER (
            ORDER BY sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2
    ) AS cumulative_sales
FROM MonthlySales
ORDER BY sales_month;

-- Compare monthly sales with the previous month using LAG()
WITH MonthlySales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(
            oi.quantity * oi.price * (1 - oi.discount / 100)
        ) AS monthly_sales
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(monthly_sales, 2) AS monthly_sales,
    ROUND(
        LAG(monthly_sales) OVER (ORDER BY sales_month), 2
    ) AS previous_month_sales,
    ROUND(
        monthly_sales -
        LAG(monthly_sales) OVER (ORDER BY sales_month), 2
    ) AS sales_difference
FROM MonthlySales
ORDER BY sales_month;

-- Calculate percentage change in monthly sales
WITH MonthlySales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(
            oi.quantity * oi.price * (1 - oi.discount / 100)
        ) AS monthly_sales
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),
SalesComparison AS (
    SELECT
        sales_month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM MonthlySales
)
SELECT
    sales_month,
    ROUND(monthly_sales, 2) AS monthly_sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(
        100.0 * (monthly_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0),
        2
    ) AS percentage_change
FROM SalesComparison
ORDER BY sales_month;

-- Identify the top-selling product within each category
WITH ProductQuantity AS (
    SELECT
        c.category_id,
        c.category_name,
        p.product_id,
        p.product_name,
        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Delivered'
                    THEN oi.quantity
                    ELSE 0
                END
            ), 0
        ) AS total_quantity
    FROM categories c
    JOIN products p
        ON c.category_id = p.category_id
    LEFT JOIN order_items oi
        ON p.product_id = oi.product_id
    LEFT JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY
        c.category_id,
        c.category_name,
        p.product_id,
        p.product_name
),
ProductRanks AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS category_rank
    FROM ProductQuantity
)
SELECT
    category_name,
    product_name,
    total_quantity,
    category_rank
FROM ProductRanks
WHERE category_rank = 1
ORDER BY category_name;

-- Find customers whose spending is above the overall average
WITH CustomerSpending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Delivered'
                    THEN oi.quantity * oi.price
                         * (1 - oi.discount / 100)
                    ELSE 0
                END
            ), 0
        ) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending
FROM CustomerSpending
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM CustomerSpending
)
ORDER BY total_spending DESC;

-- Calculate each product's contribution to total sales
WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Delivered'
                    THEN oi.quantity * oi.price
                         * (1 - oi.discount / 100)
                    ELSE 0
                END
            ), 0
        ) AS total_sales
    FROM products p
    LEFT JOIN order_items oi
        ON p.product_id = oi.product_id
    LEFT JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        100.0 * total_sales
        / NULLIF(SUM(total_sales) OVER (), 0),
        2
    ) AS sales_contribution_percentage
FROM ProductSales
ORDER BY sales_contribution_percentage DESC;

-- Segment customers based on purchase frequency and total spending
WITH CustomerMetrics AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(
            DISTINCT CASE
                WHEN o.order_status = 'Delivered'
                THEN o.order_id
            END
        ) AS purchase_frequency,
        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Delivered'
                    THEN oi.quantity * oi.price
                         * (1 - oi.discount / 100)
                    ELSE 0
                END
            ), 0
        ) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    purchase_frequency,
    ROUND(total_spending, 2) AS total_spending,
    CASE
        WHEN purchase_frequency >= 3
             AND total_spending >= 30000
            THEN 'VIP Customer'
        WHEN purchase_frequency >= 2
            THEN 'Regular Customer'
        WHEN purchase_frequency = 1
            THEN 'Occasional Customer'
        ELSE 'No Delivered Purchases'
    END AS customer_segment
FROM CustomerMetrics
ORDER BY total_spending DESC;

-- Check for missing or invalid data
SELECT 'Customers' AS table_name,
       COUNT(*) AS issue_count
FROM customers
WHERE customer_name IS NULL
   OR TRIM(customer_name) = ''
   OR city IS NULL
   OR TRIM(city) = ''
   OR email IS NULL
   OR TRIM(email) = ''

UNION ALL

SELECT 'Products', COUNT(*)
FROM products
WHERE product_name IS NULL
   OR TRIM(product_name) = ''
   OR cost IS NULL
   OR selling_price IS NULL
   OR stock_quantity IS NULL

UNION ALL

SELECT 'Orders', COUNT(*)
FROM orders
WHERE customer_id IS NULL
   OR order_date IS NULL
   OR order_status IS NULL
   OR sales_channel IS NULL

UNION ALL

SELECT 'Order Items', COUNT(*)
FROM order_items
WHERE order_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL
   OR price IS NULL
   OR discount IS NULL

UNION ALL

SELECT 'Payments', COUNT(*)
FROM payments
WHERE order_id IS NULL
   OR payment_method IS NULL
   OR payment_status IS NULL
   OR amount IS NULL;
   
   -- check invalid numeric values
SELECT *
FROM products
WHERE cost < 0
   OR selling_price < 0
   OR stock_quantity < 0;

SELECT *
FROM order_items
WHERE quantity <= 0
   OR price < 0
   OR discount < 0
   OR discount > 100;

SELECT *
FROM payments
WHERE amount < 0;

SELECT *
FROM returns
WHERE quantity <= 0
   OR refund_amount < 0;
   
-- Identify duplicate customer emails
SELECT
    LOWER(TRIM(email)) AS normalized_email,
    COUNT(*) AS duplicate_count
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
GROUP BY LOWER(TRIM(email))
HAVING COUNT(*) > 1;

-- Find products with a selling price below their cost
SELECT
    product_id,
    product_name,
    cost,
    selling_price,
    ROUND(selling_price - cost, 2) AS price_difference
FROM products
WHERE selling_price < cost
ORDER BY price_difference;

-- Verify order quantities and payment amounts
SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    price,
    discount
FROM order_items
WHERE quantity IS NULL
   OR quantity <= 0
   OR price IS NULL
   OR price < 0
   OR discount IS NULL
   OR discount < 0
   OR discount > 100;
   SELECT
    payment_id,
    order_id,
    payment_method,
    payment_status,
    amount
FROM payments
WHERE amount IS NULL
   OR amount < 0
   OR payment_method IS NULL
   OR payment_status IS NULL;
SELECT
    payment_id,
    order_id,
    payment_status,
    amount
FROM payments
WHERE (payment_status = 'Paid' AND amount <= 0)
   OR (payment_status IN ('Pending', 'Failed') AND amount > 0);
   
-- Check foreign-key relationships
-- Orders with missing customers or employees:
   SELECT o.order_id, o.customer_id, o.employee_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN employees e
    ON o.employee_id = e.employee_id
WHERE c.customer_id IS NULL
   OR (
       o.employee_id IS NOT NULL
       AND e.employee_id IS NULL
   );
   
-- Order items with missing orders or products:
   SELECT oi.*
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_id IS NULL
   OR p.product_id IS NULL;
   
   -- Payments with missing orders:
   SELECT p.*
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Products, customers, and employees with missing related regions or categories:
SELECT p.product_id, p.product_name, p.category_id
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

SELECT c.customer_id, c.customer_name, c.region_id
FROM customers c
LEFT JOIN regions r
    ON c.region_id = r.region_id
WHERE c.region_id IS NOT NULL
  AND r.region_id IS NULL;

SELECT e.employee_id, e.employee_name, e.region_id
FROM employees e
LEFT JOIN regions r
    ON e.region_id = r.region_id
WHERE e.region_id IS NOT NULL
  AND r.region_id IS NULL;
  
  -- Investigate orders with missing payment records
  SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.order_status,
    o.sales_channel
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN payments p
    ON o.order_id = p.order_id
WHERE p.payment_id IS NULL
ORDER BY o.order_date;

-- Compare order totals with payment records
WITH OrderTotals AS (
    SELECT
        o.order_id,
        o.order_status,
        COALESCE(
            SUM(
                oi.quantity * oi.price
                * (1 - oi.discount / 100)
            ), 0
        ) AS order_total
    FROM orders o
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.order_status
),
PaymentTotals AS (
    SELECT
        order_id,
        SUM(
            CASE
                WHEN payment_status = 'Paid'
                THEN amount
                ELSE 0
            END
        ) AS paid_total,
        COUNT(*) AS payment_record_count
    FROM payments
    GROUP BY order_id
)
SELECT
    ot.order_id,
    ot.order_status,
    ROUND(ot.order_total, 2) AS order_total,
    ROUND(COALESCE(pt.paid_total, 0), 2) AS paid_total,
    ROUND(
        ot.order_total - COALESCE(pt.paid_total, 0), 2
    ) AS difference,
    COALESCE(pt.payment_record_count, 0) AS payment_record_count
FROM OrderTotals ot
LEFT JOIN PaymentTotals pt
    ON ot.order_id = pt.order_id
WHERE ABS(
    ot.order_total - COALESCE(pt.paid_total, 0)
) > 0.01
ORDER BY ot.order_id;

-- Check whether returned quantities exceed the quantities purchased
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    oi.quantity AS purchased_quantity,
    SUM(r.quantity) AS total_returned_quantity
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN returns r
    ON oi.order_item_id = r.order_item_id
GROUP BY
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    oi.quantity
HAVING SUM(r.quantity) > oi.quantity;
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    oi.quantity AS purchased_quantity,
    COALESCE(SUM(r.quantity), 0) AS returned_quantity,
    oi.quantity - COALESCE(SUM(r.quantity), 0)
        AS remaining_quantity
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN returns r
    ON oi.order_item_id = r.order_item_id
GROUP BY
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    oi.quantity
ORDER BY oi.order_id, oi.order_item_id;

-- Create a reusable sales summary view
CREATE OR REPLACE VIEW vw_sales_summary AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(oi.quantity * oi.price * (1 - oi.discount / 100)),
        2
    ) AS order_total
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_date,
    o.order_status,
    c.customer_id,
    c.customer_name;
    
    -- Test the view:
    SELECT *
FROM vw_sales_summary
ORDER BY order_date;
SELECT *
FROM vw_sales_summary
WHERE order_status = 'Delivered';
DROP PROCEDURE IF EXISTS sp_sales_report;

DELIMITER $$

-- Create a stored procedure for a date-range sales report
CREATE PROCEDURE sp_sales_report(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT
        o.order_id,
        o.order_date,
        c.customer_name,
        ROUND(
            SUM(
                oi.quantity * oi.price
                * (1 - oi.discount / 100)
            ), 2
        ) AS order_total
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
      AND o.order_date >= start_date
      AND o.order_date < DATE_ADD(end_date, INTERVAL 1 DAY)
    GROUP BY
        o.order_id,
        o.order_date,
        c.customer_name
    ORDER BY o.order_date;
END $$

DELIMITER ;
CALL sp_sales_report('2025-01-01', '2025-06-30');

-- Create a function to calculate the discounted value of an order item
DROP FUNCTION IF EXISTS fn_discounted_item_value;

DELIMITER $$

CREATE FUNCTION fn_discounted_item_value(
    p_quantity INT,
    p_price DECIMAL(10,2),
    p_discount DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN ROUND(
        p_quantity * p_price * (1 - p_discount / 100),
        2
    );
END $$

DELIMITER ;
SELECT fn_discounted_item_value(2, 1000.00, 10.00)
    AS discounted_value;
    SELECT
    order_item_id,
    quantity,
    price,
    discount,
    fn_discounted_item_value(quantity, price, discount)
        AS discounted_value
FROM order_items;

-- Create a trigger and audit table for product price changes
-- First, create an audit table:
CREATE TABLE IF NOT EXISTS product_price_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    old_price DECIMAL(10,2) NOT NULL,
    new_price DECIMAL(10,2) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(255)
);

-- Now create the trigger:
DROP TRIGGER IF EXISTS trg_product_price_audit;

DELIMITER $$

CREATE TRIGGER trg_product_price_audit
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF NOT (OLD.selling_price <=> NEW.selling_price) THEN
        INSERT INTO product_price_audit (
            product_id,
            old_price,
            new_price,
            changed_by
        )
        VALUES (
            OLD.product_id,
            OLD.selling_price,
            NEW.selling_price,
            CURRENT_USER()
        );
    END IF;
END $$

DELIMITER ;
SELECT product_id, product_name, selling_price
FROM products
WHERE product_id = 1;
SELECT *
FROM product_price_audit
ORDER BY changed_at DESC;

-- Demonstrate START TRANSACTION, COMMIT, and ROLLBACK
CREATE TABLE IF NOT EXISTS transaction_demo (
    demo_id INT AUTO_INCREMENT PRIMARY KEY,
    demo_note VARCHAR(100) NOT NULL
);

-- Use COMMIT to save a change
START TRANSACTION;

INSERT INTO transaction_demo (demo_note)
VALUES ('Committed transaction example');

COMMIT;

SELECT * FROM transaction_demo;

-- Use ROLLBACK to cancel a change
START TRANSACTION;

INSERT INTO transaction_demo (demo_note)
VALUES ('Rolled back transaction example');

ROLLBACK;

SELECT * FROM transaction_demo;

-- Create suitable indexes
CREATE INDEX idx_orders_status_date
ON orders (order_status, order_date);

CREATE INDEX idx_products_category_price
ON products (category_id, selling_price);

CREATE INDEX idx_payments_status_order
ON payments (payment_status, order_id);

-- Use EXPLAIN to inspect two queries
-- Filter orders by status and date
EXPLAIN
SELECT order_id, order_date
FROM orders
WHERE order_status = 'Delivered'
  AND order_date >= '2025-01-01'
  AND order_date < '2025-07-01';
  
  -- Find products within a category and price range
  EXPLAIN
SELECT product_id, product_name, selling_price
FROM products
WHERE category_id = 1
  AND selling_price > 1000;
  
  
  -- Explain how indexes improve performance
  -- ### Indexing and Query Performance Optimization

-- Indexes were created on frequently filtered and joined columns to improve query performance in the RetailSalesDB database.

-- 1. The index on `orders(order_status, order_date)` helps retrieve orders matching a particular status and date range.
-- 2. The index on `products(category_id, selling_price)` supports product searches filtered by category and selling price.
-- 3. The index on `payments(payment_status, order_id)` may improve queries that filter payments by status and match them with orders.

-- The `EXPLAIN` statement was used to inspect the execution plans of selected SQL queries and determine whether appropriate indexes were considered or used.

-- Indexes can reduce the number of rows MySQL needs to examine and improve filtering, joining, and sorting performance. However, indexes require additional storage and may slow down insert, update, and delete operations because the indexes must also be maintained. Therefore, indexes should be selected according to actual query patterns and performance requirements.
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM returns;
SELECT * FROM categories;
USE retailsalesdb;

SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.sales_channel,
    c.customer_name,
    r.region_name,
    p.product_name,
    cat.category_name,
    oi.quantity,
    oi.price,
    oi.discount,
    (oi.quantity * oi.price * (1 - oi.discount / 100)) AS sales_amount
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN regions r
    ON c.region_id = r.region_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories cat
    ON p.category_id = cat.category_id;
    
-- 1. Which products and categories generate the highest sales?
-- laptop and electronics are the products  that generate highest sales.


-- 2. Which regions perform best and worst?
-- south is the best region and central is the worst region


-- Which customers contribute the most to sales?
-- The customer Anu thomas contribute the most to sales.


-- 4. Which products require restocking?
-- The products like Webcam,office desk should restock.


-- 5. What is the monthly sales trend?
-- monthly sales fluctuate , with the highest sales in january  and the lowest in february.


-- 6. Which sales channels perform best?
-- online sales channel performs best.


-- 7. What proportion of orders are cancelled or returned?
-- out of 25 total orders, 2 orders were cancelled (8%) and 2 orders were returned (8%).


-- 8. Which products have the highest estimated gross profit?
-- Laptop has the highest estimated gross profit.


-- 9. Are there payment discrepancies requiring investigation?
-- yes there are payment discrepancies requiring investigation. some orders have differences between the order total and the paid total . for example, order id has a difference of 3300 while order id 3 has an unpaid amount of 18000. these discrepancies should be investigated. 

-- 10. What three actions would you recommend to management?
-- 1. Improve inventory management
-- 2. Strengthen the online sales channel
-- 3. Reduce order cancellations and returns

