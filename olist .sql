-- =============================
-- CREATE DATABASE
-- =============================
CREATE DATABASE olist;
USE olist;

-- =============================
-- CUSTOMERS
-- =============================
CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- =============================
-- ORDERS
-- =============================
CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

-- =============================
-- PRODUCTS
-- =============================
CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- =============================
-- SELLERS
-- =============================
CREATE TABLE sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-- =============================
-- ORDER ITEMS
-- =============================
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TEXT,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- =============================
-- PAYMENTS
-- =============================
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- =============================
-- REVIEWS
-- =============================
CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);

-- =============================
-- GEOLOCATION (OPTIONAL)
-- =============================
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

-- =============================
-- INDEXES
-- =============================
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_order_items_seller ON order_items(seller_id);
CREATE INDEX idx_reviews_order ON reviews(order_id);



SET FOREIGN_KEY_CHECKS = 0;
SET GLOBAL sql_mode = '';


select * from customers;


SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;


SELECT 
    o.order_id,
    o.customer_id,
    oi.product_id,
    oi.price
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
LIMIT 20;


SELECT COUNT(*)
FROM orders o
LEFT JOIN customers c 
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


SELECT COUNT(*)
FROM order_items oi
LEFT JOIN orders o 
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT COUNT(*)
FROM order_items oi
LEFT JOIN products p 
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*)
FROM order_items oi
LEFT JOIN sellers s 
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


DELETE oi
FROM order_items oi
LEFT JOIN products p 
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT 
    COUNT(*) AS total_orders,
    SUM(order_delivered_customer_date > order_estimated_delivery_date) AS late_orders
FROM orders;



-- Customers → Orders
CREATE INDEX idx_orders_customer_id 
ON orders(customer_id);

-- Orders → Order_Items
CREATE INDEX idx_order_items_order_id 
ON order_items(order_id);

-- Order_Items → Products
CREATE INDEX idx_order_items_product_id 
ON order_items(product_id);

-- Order_Items → Sellers
CREATE INDEX idx_order_items_seller_id 
ON order_items(seller_id);

-- Orders → Reviews
CREATE INDEX idx_reviews_order_id 
ON reviews(order_id);

-- Orders → Payments
CREATE INDEX idx_payments_order_id 
ON payments(order_id);

SHOW INDEX FROM orders;



-- Customers → Orders
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Orders → Order_Items
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- Order_Items → Products
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Order_Items → Sellers
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_seller
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

-- Orders → Reviews
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- Orders → Payments
ALTER TABLE payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);



-- Customers
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- Orders
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- Products
ALTER TABLE products
ADD PRIMARY KEY (product_id);

-- Sellers
ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);


CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_order_items_seller ON order_items(seller_id);
CREATE INDEX idx_reviews_order ON reviews(order_id);
CREATE INDEX idx_payments_order ON payments(order_id);



ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);


ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);



ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);


ALTER TABLE payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);


ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_product
FOREIGN KEY (product_id) REFERENCES products(product_id);


ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_seller
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);



UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date = '';

UPDATE orders
SET order_estimated_delivery_date = NULL
WHERE order_estimated_delivery_date = '';

ALTER TABLE orders
ADD order_purchase_dt DATETIME,
ADD order_delivered_dt DATETIME,
ADD order_estimated_dt DATETIME;



UPDATE orders
SET 
order_purchase_dt = STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'),
order_delivered_dt = STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s'),
order_estimated_dt = STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s');



ALTER TABLE orders
ADD delivery_delay INT;


UPDATE orders
SET delivery_delay = DATEDIFF(order_delivered_dt, order_estimated_dt);


SELECT delivery_delay
FROM orders
LIMIT 10;


SELECT 
    r.review_score,
    AVG(o.delivery_delay) AS avg_delay
FROM orders o
JOIN reviews r 
ON o.order_id = r.order_id
GROUP BY r.review_score;


select  p.product_category_name,  count(p.product_category_name) as total_orders   ,avg(rs.review_score) avg_rating  from  products p inner join order_items o on p.product_id = o.product_id join 
 orders s on o. order_id = s.order_id join  reviews rs  on s.order_id = rs.order_id  group by 
p.product_category_name ;


SELECT COUNT(*) FROM products;

SELECT COUNT(*)
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id;


TRUNCATE TABLE products;


SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE products;


SET FOREIGN_KEY_CHECKS = 1;

SELECT COUNT(*) FROM products;


SELECT COUNT(*)
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id;


SELECT product_id FROM products LIMIT 5;


SELECT product_id FROM order_items LIMIT 5;


SELECT COUNT(*) FROM order_items;


SELECT COUNT(*)
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id;


SELECT product_id 
FROM order_items 
WHERE product_id IS NOT NULL
LIMIT 5;


SELECT *
FROM products
WHERE product_id = '00066f42aeeb9f3007548bb9d3f33c38';


SELECT LENGTH(product_id) 
FROM order_items 
LIMIT 5;

SELECT LENGTH(product_id) 
FROM products 
LIMIT 5;


SELECT 
    oi.product_id AS oi_id,
    p.product_id AS p_id
FROM order_items oi
LEFT JOIN products p 
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL
LIMIT 5;


SELECT COUNT(*)
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id;




SELECT COUNT(*) FROM order_items;

select * from sellers;



SELECT DATABASE();

SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;


SELECT COUNT(*)
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id;

ALTER TABLE orders ADD delivery_delay INT;

UPDATE orders
SET delivery_delay = DATEDIFF(order_delivered_dt, order_estimated_dt);


SELECT  
p.product_category_name,  
COUNT(*) AS total_orders, AVG(s.delivery_delay) AS avg_delay,
AVG(rs.review_score) AS avg_rating  
FROM products p 
JOIN order_items o ON p.product_id = o.product_id 
JOIN orders s ON o.order_id = s.order_id 
JOIN reviews rs ON s.order_id = rs.order_id WHERE p.product_category_name = 'utilidades_domesticas' 
GROUP BY p.product_category_name;


SELECT  
    o.seller_id,
    COUNT(*) AS total_orders,
    AVG(rs.review_score) AS avg_rating,AVG(s.delivery_delay) AS avg_delay
FROM order_items o
JOIN orders s ON o.order_id = s.order_id 
JOIN reviews rs ON s.order_id = rs.order_id WHERE o.seller_id = '955fee9216a65b617aa5c0531780ce60'
GROUP BY o.seller_id
HAVING COUNT(*) >= 5
ORDER BY avg_rating ASC;




SELECT  
    o.seller_id,
    COUNT(*) AS total_orders,
    AVG(rs.review_score) AS avg_rating,
    AVG(s.delivery_delay) AS avg_delay
FROM order_items o
JOIN orders s ON o.order_id = s.order_id 
JOIN reviews rs ON s.order_id = rs.order_id 
WHERE o.seller_id = '955fee9216a65b617aa5c0531780ce60'
GROUP BY o.seller_id;



CREATE VIEW dataset_orders AS
SELECT 
    o.order_id,
    o.customer_id,
    o.delivery_delay,
    r.review_score
FROM orders o
JOIN reviews r 
ON o.order_id = r.order_id;



CREATE VIEW dataset_category AS
SELECT
    p.product_category_name,
    COUNT(*) AS total_orders,
    AVG(rs.review_score) AS avg_rating,
    SUM(oi.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN reviews rs ON o.order_id = rs.order_id
GROUP BY p.product_category_name;



CREATE VIEW dataset_seller AS
SELECT
    o.seller_id,
    COUNT(*) AS total_orders,
    AVG(rs.review_score) AS avg_rating,
    AVG(ord.delivery_delay) AS avg_delay,
    SUM(o.price) AS revenue
FROM order_items o
JOIN orders ord ON o.order_id = ord.order_id
JOIN reviews rs ON ord.order_id = rs.order_id
GROUP BY o.seller_id;


CREATE VIEW dataset_customer AS
SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue,
    AVG(p.payment_value) AS avg_order_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.customer_id;


SELECT COUNT(*) AS total_orders FROM orders;


SELECT 
    COUNT(*) AS total_orders,
    SUM(delivery_delay > 0) AS late_orders,
    (SUM(delivery_delay > 0) / COUNT(*)) * 100 AS late_percentage
FROM orders;


SELECT AVG(review_score) AS avg_rating 
FROM reviews;


SELECT AVG(delivery_delay) AS avg_delay
FROM orders;



SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue,
    MAX(o.order_purchase_dt) AS last_order_date
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.customer_id;


SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue,
    MAX(o.order_purchase_dt) AS last_order_date,
    CASE 
        WHEN SUM(p.payment_value) > 10000 THEN 'High Value'
        WHEN SUM(p.payment_value) BETWEEN 5000 AND 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.customer_id;


SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue,
    MAX(o.order_purchase_dt) AS last_order_date,
    CASE 
        WHEN SUM(p.payment_value) > 10000 THEN 'High Value'
        WHEN SUM(p.payment_value) BETWEEN 5000 AND 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.customer_id;

SELECT 
    DATE(order_purchase_dt) AS order_date,
    COUNT(*) AS total_orders,
    AVG(delivery_delay) AS avg_delay
FROM orders
GROUP BY order_date;


SELECT 
    c.customer_state,
    COUNT(o.order_id) AS total_orders,
    AVG(o.delivery_delay) AS avg_delay
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state;



CREATE VIEW dataset_customer_segment AS
SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue,
    MAX(o.order_purchase_dt) AS last_order_date,
    CASE 
        WHEN SUM(p.payment_value) > 10000 THEN 'High Value'
        WHEN SUM(p.payment_value) BETWEEN 5000 AND 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.customer_id;

SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


SELECT 
    COUNT(*) AS total_orders,
    SUM(order_status = 'canceled') AS canceled_orders,
    (SUM(order_status = 'canceled') / COUNT(*)) * 100 AS cancellation_rate
FROM orders;


SELECT 
    COUNT(*) AS total_customers,
    SUM(total_orders > 1) AS repeat_customers,
    (SUM(total_orders > 1) / COUNT(*)) * 100 AS repeat_customer_percentage
FROM (
    SELECT 
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) t;


SELECT 
    COUNT(*) AS total_customers,
    SUM(total_orders > 1) AS repeat_customers,
    (SUM(total_orders > 1) / COUNT(*)) * 100 AS repeat_customer_percentage
FROM (
    SELECT 
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) t;


SELECT 
    SUM(p.payment_value) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id;



SELECT 
    p.product_category_name,
    COUNT(*) AS total_orders,
    SUM(o.order_status = 'canceled') AS canceled_orders,
    (SUM(o.order_status = 'canceled') / COUNT(*)) * 100 AS cancellation_rate
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY cancellation_rate DESC;



SELECT 
    COUNT(*) AS total,
    SUM(product_category_name IS NULL) AS null_categories
FROM products;

SELECT 
    COALESCE(product_category_name, 'Unknown') AS category,
    COUNT(*)
FROM products
GROUP BY category;