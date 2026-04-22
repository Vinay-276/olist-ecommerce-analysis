DATABASE

CREATE DATABASE olist;
USE olist;

-- Customers
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- Orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

-- Products
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100)
);

-- Order Items
CREATE TABLE order_items (
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    price DECIMAL(10,2)
);

-- Payments
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_value DECIMAL(10,2)
);

-- Reviews
CREATE TABLE reviews (
    order_id VARCHAR(50),
    review_score INT
);

DATA CLEANING & TRANSFORMATION


-- Convert dates
ALTER TABLE orders ADD order_purchase_dt DATETIME;
ALTER TABLE orders ADD order_delivered_dt DATETIME;
ALTER TABLE orders ADD order_estimated_dt DATETIME;

UPDATE orders
SET 
order_purchase_dt = STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'),
order_delivered_dt = STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s'),
order_estimated_dt = STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s');

-- Delivery delay
ALTER TABLE orders ADD delivery_delay INT;

UPDATE orders
SET delivery_delay = DATEDIFF(order_delivered_dt, order_estimated_dt);


DATA VALIDATION

-- Missing customers
SELECT COUNT(*) 
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Missing products
SELECT COUNT(*) 
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


CORE KPIs


-- Total Orders
SELECT COUNT(*) AS total_orders FROM orders;

-- Average Order Value
SELECT 
SUM(p.payment_value) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id;

-- Cancellation Rate
SELECT 
COUNT(*) AS total_orders,
SUM(order_status = 'canceled') AS canceled_orders,
(SUM(order_status = 'canceled') / COUNT(*)) * 100 AS cancellation_rate
FROM orders;

-- Repeat Customers
SELECT 
COUNT(*) AS total_customers,
SUM(total_orders > 1) AS repeat_customers,
(SUM(total_orders > 1) / COUNT(*)) * 100 AS repeat_rate
FROM (
    SELECT customer_id, COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) t;


REVENUE & TREND ANALYSIS

-- Monthly Revenue
SELECT 
DATE_FORMAT(order_purchase_dt, '%Y-%m') AS month,
SUM(p.payment_value) AS revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY month;

-- Month-over-Month Growth
WITH monthly AS (
    SELECT 
        DATE_FORMAT(order_purchase_dt, '%Y-%m') AS month,
        COUNT(*) AS orders
    FROM orders
    GROUP BY month
)
SELECT 
month,
orders,
LAG(orders) OVER (ORDER BY month) AS prev_orders,
ROUND(
((orders - LAG(orders) OVER (ORDER BY month)) 
/ LAG(orders) OVER (ORDER BY month)) * 100, 2
) AS growth_percentage
FROM monthly;

PRODUCT PERFORMANCE 

-- Revenue by Category + Ranking
SELECT 
p.product_category_name,
SUM(oi.price) AS revenue,
RANK() OVER (ORDER BY SUM(oi.price) DESC) AS rank_position
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name;

TOP CUSTOMERS

SELECT *
FROM (
    SELECT 
        o.customer_id,
        SUM(p.payment_value) AS revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(p.payment_value) DESC) AS rank_num
    FROM orders o
    JOIN payments p ON o.order_id = p.order_id
    GROUP BY o.customer_id
) t
WHERE rank_num <= 10;

FUNNEL ANALYSIS

SELECT 
COUNT(DISTINCT o.order_id) AS total_orders,
COUNT(DISTINCT p.order_id) AS paid_orders,
COUNT(DISTINCT CASE WHEN o.order_status = 'delivered' THEN o.order_id END) AS delivered_orders
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id;


COHORT ANALYSIS

WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(order_purchase_dt) AS first_order
    FROM orders
    GROUP BY customer_id
),
cohort AS (
    SELECT 
        o.customer_id,
        DATE_FORMAT(f.first_order, '%Y-%m') AS cohort_month,
        DATE_FORMAT(o.order_purchase_dt, '%Y-%m') AS order_month
    FROM orders o
    JOIN first_purchase f ON o.customer_id = f.customer_id
)
SELECT 
cohort_month,
order_month,
COUNT(DISTINCT customer_id) AS customers
FROM cohort
GROUP BY cohort_month, order_month;

RFM SEGMENTATION

SELECT
o.customer_id,
DATEDIFF(CURDATE(), MAX(o.order_purchase_dt)) AS recency,
COUNT(o.order_id) AS frequency,
SUM(p.payment_value) AS monetary
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.customer_id;


DELIVERY PERFORMANCE & CUSTOMER EXPERIENCE


-- Avg Delay
SELECT AVG(delivery_delay) AS avg_delay FROM orders;

-- Delay vs Rating
SELECT 
r.review_score,
AVG(o.delivery_delay) AS avg_delay
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
GROUP BY r.review_score;

KEY BUSINESS INSIGHTS
Revenue concentrated in top categories
Drop-off in payment stage (conversion loss)
High-value customers drive majority revenue
Delivery delays impact customer ratings
Retention drops after first purchase



