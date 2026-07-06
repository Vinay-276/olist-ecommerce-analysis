DATABASE

CREATE DATABASE olist;
USE olist;



1. Customers
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
2. Orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),

    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    delivery_delay INT,

    CONSTRAINT fk_orders_customer
    FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
);
3. Products
CREATE TABLE products (

    product_id VARCHAR(50) PRIMARY KEY,

    product_category_name VARCHAR(100),

    product_name_lenght INT,

    product_description_lenght INT,

    product_photos_qty INT,

    product_weight_g INT,

    product_length_cm INT,

    product_height_cm INT,

    product_width_cm INT

);
4. Sellers
CREATE TABLE sellers (

    seller_id VARCHAR(50) PRIMARY KEY,

    seller_zip_code_prefix INT,

    seller_city VARCHAR(100),

    seller_state VARCHAR(10)

);
5. Order Items
CREATE TABLE order_items (

    order_id VARCHAR(50),

    order_item_id INT,

    product_id VARCHAR(50),

    seller_id VARCHAR(50),

    shipping_limit_date DATETIME,

    price DECIMAL(10,2),

    freight_value DECIMAL(10,2),

    PRIMARY KEY(order_id,order_item_id),

    CONSTRAINT fk_orderitems_orders
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id),

    CONSTRAINT fk_orderitems_products
    FOREIGN KEY(product_id)
    REFERENCES products(product_id),

    CONSTRAINT fk_orderitems_sellers
    FOREIGN KEY(seller_id)
    REFERENCES sellers(seller_id)

);
6. Payments
CREATE TABLE payments (

    order_id VARCHAR(50),

    payment_sequential INT,

    payment_type VARCHAR(50),

    payment_installments INT,

    payment_value DECIMAL(10,2),

    PRIMARY KEY(order_id,payment_sequential),

    CONSTRAINT fk_payments_orders
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)

);
 Reviews
CREATE TABLE reviews (

    review_id VARCHAR(50) PRIMARY KEY,

    order_id VARCHAR(50),

    review_score INT,

    review_comment_title TEXT,

    review_comment_message TEXT,

    review_creation_date DATETIME,

    review_answer_timestamp DATETIME,

    CONSTRAINT fk_reviews_orders
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)

);



Step 2 — Check Row Counts
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM reviews;
SELECT COUNT(*) FROM geolocation;
SELECT COUNT(*) FROM category_translation;


Step 3 — Check Table Structure
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE products;
DESCRIBE sellers;
DESCRIBE payments;
DESCRIBE reviews;
DESCRIBE geolocation;
DESCRIBE category_translation;



Check column names.
Check data types.

Step 4 — Data Profiling
SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;




Step 5 — Check Missing Values

Example:

SELECT *
FROM customers
WHERE customer_id IS NULL;

Repeat for every important column in every table.

Also count NULLs:


SELECT
SUM(customer_id IS NULL) AS customer_id_null,
SUM(customer_unique_id IS NULL) AS customer_unique_id_null,
SUM(customer_zip_code_prefix IS NULL) AS zip_code_null,
SUM(customer_city IS NULL) AS customer_city_null,
SUM(customer_state IS NULL) AS customer_state_null
FROM customers;


SELECT
SUM(order_id IS NULL) AS order_id_null,
SUM(customer_id IS NULL) AS customer_id_null,
SUM(order_status IS NULL) AS order_status_null,
SUM(order_purchase_timestamp IS NULL) AS purchase_date_null,
SUM(order_approved_at IS NULL) AS approved_date_null,
SUM(order_delivered_carrier_date IS NULL) AS carrier_date_null,
SUM(order_delivered_customer_date IS NULL) AS delivered_date_null,
SUM(order_estimated_delivery_date IS NULL) AS estimated_date_null,
SUM(delivery_delay IS NULL) AS delivery_delay_null
FROM orders;


SELECT
SUM(product_id IS NULL) AS product_id_null,
SUM(product_category_name IS NULL) AS category_null,
SUM(product_photos_qty IS NULL) AS photos_null,
SUM(product_weight_g IS NULL) AS weight_null,
SUM(product_height_cm IS NULL) AS height_null,
SUM(product_width_cm IS NULL) AS width_null
FROM products;



SELECT
SUM(order_id IS NULL) AS order_id_null,
SUM(order_item_id IS NULL) AS order_item_id_null,
SUM(product_id IS NULL) AS product_id_null,
SUM(seller_id IS NULL) AS seller_id_null,
SUM(shipping_limit_date IS NULL) AS shipping_date_null,
SUM(price IS NULL) AS price_null,
SUM(freight_value IS NULL) AS freight_null
FROM order_items;


SELECT
SUM(seller_id IS NULL) AS seller_id_null,
SUM(seller_zip_code_prefix IS NULL) AS zip_null,
SUM(seller_city IS NULL) AS city_null,
SUM(seller_state IS NULL) AS state_null
FROM sellers;


SELECT
SUM(order_id IS NULL) AS order_id_null,
SUM(payment_sequential IS NULL) AS payment_seq_null,
SUM(payment_type IS NULL) AS payment_type_null,
SUM(payment_installments IS NULL) AS installments_null,
SUM(payment_value IS NULL) AS payment_value_null
FROM payments;


SELECT
SUM(order_id IS NULL) AS order_id_null,
SUM(payment_sequential IS NULL) AS payment_seq_null,
SUM(payment_type IS NULL) AS payment_type_null,
SUM(payment_installments IS NULL) AS installments_null,
SUM(payment_value IS NULL) AS payment_value_null
FROM payments;


SELECT
SUM(review_id IS NULL) AS review_id_null,
SUM(order_id IS NULL) AS order_id_null,
SUM(review_score IS NULL) AS review_score_null,
SUM(review_comment_title IS NULL) AS review_title_null,
SUM(review_comment_message IS NULL) AS review_message_null,
SUM(review_creation_date IS NULL) AS creation_date_null,
SUM(review_answer_timestamp IS NULL) AS answer_date_null
FROM reviews;



SELECT
SUM(geolocation_zip_code_prefix IS NULL) AS zip_null,
SUM(geolocation_lat IS NULL) AS latitude_null,
SUM(geolocation_lng IS NULL) AS longitude_null,
SUM(geolocation_city IS NULL) AS city_null,
SUM(geolocation_state IS NULL) AS state_null
FROM geolocation;
Check empty date values:
SELECT DISTINCT order_delivered_carrier_date
FROM orders
WHERE order_delivered_carrier_date = ''
   OR order_delivered_carrier_date IS NULL;
Convert empty strings to NULL:
UPDATE orders
SET order_purchase_timestamp = NULL
WHERE TRIM(order_purchase_timestamp) = '';

UPDATE orders
SET order_approved_at = NULL
WHERE TRIM(order_approved_at) = '';

UPDATE orders
SET order_delivered_carrier_date = NULL
WHERE TRIM(order_delivered_carrier_date) = '';

UPDATE orders
SET order_delivered_customer_date = NULL
WHERE TRIM(order_delivered_customer_date) = '';

UPDATE orders
SET order_estimated_delivery_date = NULL
WHERE TRIM(order_estimated_delivery_date) = '';
Convert columns to DATETIME:
ALTER TABLE orders
MODIFY order_purchase_timestamp DATETIME NULL,
MODIFY order_approved_at DATETIME NULL,
MODIFY order_delivered_carrier_date DATETIME NULL,
MODIFY order_delivered_customer_date DATETIME NULL,
MODIFY order_estimated_delivery_date DATETIME NULL;
Verify the data type:
DESCRIBE orders;
Convert shipping_limit_date:
ALTER TABLE order_items
MODIFY shipping_limit_date DATETIME;
Drop the duplicate *_dt columns:
ALTER TABLE orders
DROP COLUMN order_purchase_dt,
DROP COLUMN order_delivered_dt,
DROP COLUMN order_estimated_dt;





Step 6 — Duplicate Check
SELECT
customer_id,
COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


SELECT
order_id,
COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
product_id,
COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
seller_id,
COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


SELECT
order_id,
order_item_id,
COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT
order_id,
payment_sequential,
COUNT(*) AS duplicate_count
FROM payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;


SELECT
order_id,
payment_sequential,
COUNT(*) AS duplicate_count
FROM payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;


Orders
Products
Sellers
Payments
Reviews
Geolocation
Step 7 — Trim Spaces
UPDATE customers
SET customer_city=TRIM(customer_city);

UPDATE sellers
SET seller_city=TRIM(seller_city);

UPDATE products
SET product_category_name=TRIM(product_category_name);
Step 8 — Standardize Text
UPDATE customers
SET customer_city=LOWER(customer_city);

UPDATE sellers
SET seller_city=LOWER(seller_city);

UPDATE customers
SET customer_state=UPPER(customer_state);

starrized text 

    Customers

Convert city names to lowercase and state codes to uppercase.

UPDATE customers
SET
customer_city = LOWER(customer_city),
customer_state = UPPER(customer_state);
Sellers
UPDATE sellers
SET
seller_city = LOWER(seller_city),
seller_state = UPPER(seller_state);
Products
UPDATE products
SET
product_category_name = LOWER(product_category_name);
Payments
UPDATE payments
SET
payment_type = LOWER(payment_type);
Orders
UPDATE orders
SET
order_status = LOWER(order_status);



Step 9 — Remove Blank Categories
SELECT *
FROM products
WHERE product_category_name IS NULL;


UPDATE products
SET product_category_name='Unknown'
WHERE product_category_name IS NULL;
Step 10 — Date Conversion

Convert

order_purchase_timestamp



DATE
ALTER TABLE orders
ADD COLUMN order_purchase_dt DATE;

UPDATE orders
SET order_purchase_dt=
DATE(order_purchase_timestamp);

Repeat for

order_approved_at
order_delivered_customer_date
order_estimated_delivery_date
review_creation_date
review_answer_timestamp
Step 11 — Invalid Dates
SELECT *
FROM orders
WHERE order_purchase_dt IS NULL;

Also

SELECT *
FROM orders
WHERE order_delivered_customer_date <
order_purchase_timestamp;
Step 12 — Delivery Delay
ALTER TABLE orders
ADD COLUMN delivery_days INT;

UPDATE orders
SET delivery_days=
DATEDIFF(order_delivered_customer_date,
order_purchase_timestamp);
Step 13 — Validate Delivery Delay

Negative

SELECT *
FROM orders
WHERE delivery_days<0;

Zero

SELECT *
FROM orders
WHERE delivery_days=0;

Positive

SELECT *
FROM orders
WHERE delivery_days>0;
Step 14 — Referential Integrity

Customers → Orders

SELECT *
FROM orders o
LEFT JOIN customers c
ON o.customer_id=c.customer_id
WHERE c.customer_id IS NULL;

Orders → Payments

SELECT *
FROM payments p
LEFT JOIN orders o
ON p.order_id=o.order_id
WHERE o.order_id IS NULL;

Orders → Reviews

SELECT *
FROM reviews r
LEFT JOIN orders o
ON r.order_id=o.order_id
WHERE o.order_id IS NULL;

Orders → Order Items

SELECT *
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id=o.order_id
WHERE o.order_id IS NULL;

Products → Order Items

SELECT *
FROM order_items oi
LEFT JOIN products p
ON oi.product_id=p.product_id
WHERE p.product_id IS NULL;

Sellers → Order Items

SELECT *
FROM order_items oi
LEFT JOIN sellers s
ON oi.seller_id=s.seller_id
WHERE s.seller_id IS NULL;
Step 15 — Outlier Check

Payment

SELECT MIN(payment_value),
MAX(payment_value),
AVG(payment_value)
FROM payments;

Price

SELECT MIN(price),
MAX(price),
AVG(price)
FROM order_items;

Freight

SELECT MIN(freight_value),
MAX(freight_value),
AVG(freight_value)
FROM order_items;
Step 16 — Negative Values

Payment

SELECT *
FROM payments
WHERE payment_value<0;

Price

SELECT *
FROM order_items
WHERE price<0;

Freight

SELECT *
FROM order_items
WHERE freight_value<0;
Step 17 — Business Rule Validation

Cancelled orders delivered?

SELECT *
FROM orders
WHERE order_status='canceled'
AND order_delivered_customer_date IS NOT NULL;

Review without Order?

SELECT *
FROM reviews r
LEFT JOIN orders o
ON r.order_id=o.order_id
WHERE o.order_id IS NULL;

Payment without Order?

SELECT *
FROM payments p
LEFT JOIN orders o
ON p.order_id=o.order_id
WHERE o.order_id IS NULL;
 Final Validation
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM reviews;

Executive Dashboard Business Questions
Q1. How many total orders were placed?

Visual: KPI Card

SELECT
COUNT(DISTINCT order_id) AS Total_Orders
FROM orders;
Q2. How many unique customers purchased?

Visual: KPI Card

SELECT
COUNT(DISTINCT customer_id) AS Total_Customers
FROM customers;
Q3. What is the total revenue?

Visual: KPI Card

SELECT
ROUND(SUM(payment_value),2) AS Total_Revenue
FROM payments;
Q4. What is the Average Order Value (AOV)?

Visual: KPI Card

SELECT
ROUND(
SUM(payment_value)
/ COUNT(DISTINCT order_id),2
) AS Average_Order_Value
FROM payments;
Q5. What percentage of orders were delivered on time?

Visual: KPI Card

SELECT

ROUND(

SUM(
CASE
WHEN delivery_delay<=0
THEN 1
ELSE 0
END
)

*100.0

/

COUNT(*)

,2)

AS On_Time_Delivery_Percentage

FROM orders

WHERE order_status='delivered';
Q6. What is the average customer rating?

Visual: KPI Card

SELECT

ROUND(
AVG(review_score),2
) AS Average_Rating

FROM reviews;
Q7. How has revenue changed over time?

Visual: Revenue Growth Trend

SELECT

DATE_FORMAT(o.order_purchase_dt,'%Y-%m') AS Month,

ROUND(
SUM(p.payment_value),2
) AS Revenue

FROM orders o

JOIN payments p

ON o.order_id=p.order_id

GROUP BY Month

ORDER BY Month;
Q8. Which product categories generate the highest revenue?

Visual: Top Categories by Revenue

SELECT

pr.product_category_name,

ROUND(
SUM(oi.price),2
) AS Revenue,

RANK() OVER(
ORDER BY SUM(oi.price) DESC
) AS Category_Rank

FROM products pr

JOIN order_items oi

ON pr.product_id=oi.product_id

GROUP BY pr.product_category_name

ORDER BY Revenue DESC

LIMIT 5;
Q9. Which states generate the highest revenue?

Visual: Revenue Distribution Across Brazil States

SELECT

c.customer_state,

ROUND(
SUM(pay.payment_value),2
) AS Revenue

FROM customers c

JOIN orders o

ON c.customer_id=o.customer_id

JOIN payments pay

ON o.order_id=pay.order_id

GROUP BY c.customer_state

ORDER BY Revenue DESC;
Business Insights (Based on SQL)
1. Total Revenue generated by the business is ₹13M.

2. Around 96K orders were placed.

3. Around 96K unique customers purchased.

4. Average Order Value is ₹137.

5. More than 90% of orders were delivered on time.

6. Average customer rating is above 4, indicating good customer satisfaction.

7. Revenue increased steadily over time with strong growth during late 2017.

8. A few product categories contribute a significant share of total revenue.

9. Revenue is concentrated in a few Brazilian states.




    Dashboard Name: Delivery Delays & Logistics Performance Insights

Nenu Power BI ni base chesi business questions create chestunnanu.

06_Delivery_Performance.sql
/*==========================================================
           DELIVERY PERFORMANCE ANALYSIS

Business Questions

1. What is the average delivery time?
2. What percentage of orders were delivered late?
3. What percentage of orders were delivered on time?
4. How many orders were delivered?
5. Which sellers have the highest average delivery delay?
6. Which states experience the highest delivery delays?
7. How do actual delivery days compare with estimated delivery days?
==========================================================*/
Q1. What is the average delivery time?

KPI Card

SELECT

ROUND(
AVG(DATEDIFF(order_delivered_dt,
order_purchase_dt)),2
) AS Average_Delivery_Days

FROM orders

WHERE order_status='delivered';
Q2. What percentage of orders were delivered late?

KPI Card

SELECT

ROUND(

SUM(
CASE
WHEN delivery_delay>0
THEN 1
ELSE 0
END
)

*100

/

COUNT(*)

,2)

AS Late_Delivery_Percentage

FROM orders

WHERE order_status='delivered';
Q3. What percentage of orders were delivered on time?

KPI Card

SELECT

ROUND(

SUM(
CASE
WHEN delivery_delay<=0
THEN 1
ELSE 0
END
)

*100

/

COUNT(*)

,2)

AS On_Time_Delivery_Percentage

FROM orders

WHERE order_status='delivered';
Q4. How many orders were successfully delivered?

KPI Card

SELECT

COUNT(order_id)
AS Delivered_Orders

FROM orders

WHERE order_status='delivered';
Q5. Which sellers have the highest average delivery delay?

Top 10 Sellers by Average Delivery Delay

SELECT

oi.seller_id,

ROUND(

AVG(o.delivery_delay)

,2)

AS Average_Delay

FROM orders o

JOIN order_items oi

ON o.order_id=oi.order_id

WHERE o.order_status='delivered'

GROUP BY oi.seller_id

ORDER BY Average_Delay DESC

LIMIT 10;

Note: Nee screenshot lo negative values (early deliveries) chupisthunnayi. Top delayed sellers kavali ante DESC, earliest sellers kavali ante ASC. Nee Power BI logic ki match ayye direction ni use cheyyi.

Q6. Which states have the highest delivery delays?

Top Delayed States

SELECT

c.customer_state,

ROUND(

AVG(o.delivery_delay)

,2)

AS Average_Delay

FROM customers c

JOIN orders o

ON c.customer_id=o.customer_id

WHERE o.order_status='delivered'

GROUP BY c.customer_state

ORDER BY Average_Delay DESC;
Q7. How do actual delivery days compare with estimated delivery days over time?

Line Chart

SELECT

DATE_FORMAT(order_purchase_dt,'%Y-%m') AS Month,

ROUND(
AVG(DATEDIFF(order_delivered_dt,
order_purchase_dt)),2
) AS Actual_Delivery_Days,

ROUND(
AVG(DATEDIFF(order_estimated_dt,
order_purchase_dt)),2
) AS Estimated_Delivery_Days

FROM orders

WHERE order_status='delivered'

GROUP BY Month

ORDER BY Month;
Business Insights
1. Average delivery time is approximately 12.5 days.

2. Around 93% of orders are delivered on or before the estimated date.

3. Only a small percentage of orders are delivered late.

4. A few sellers contribute disproportionately to delivery delays.

5. Some customer states experience significantly longer delivery times.

6. Actual delivery is often faster than the estimated delivery date, indicating conservative delivery estimates.

7. Improving the performance of high-delay sellers can significantly improve customer experience.



Page 3 – Customer Satisfaction & Review Analysis.

Idi GitHub level SQL format lo rayachu.

07_Customer_Satisfaction_Analysis.sql
/*==========================================================
        CUSTOMER SATISFACTION & REVIEW ANALYSIS

Business Questions

1. What is the average customer rating?
2. What percentage of reviews are low ratings (1–2 Stars)?
3. What percentage of reviews are 5-star ratings?
4. How many total reviews were received?
5. How are ratings distributed?
6. How do delivery delays impact customer ratings?
7. Which product categories receive the most low ratings?
==========================================================*/
Q1. What is the average customer rating?

KPI Card

SELECT

ROUND(
AVG(review_score),2
) AS Average_Customer_Rating

FROM reviews;
Q2. What percentage of reviews are low ratings (1–2 Stars)?

KPI Card

SELECT

ROUND(

SUM(
CASE
WHEN review_score IN (1,2)
THEN 1
ELSE 0
END
)

*100

/

COUNT(*)

,2)

AS Low_Rating_Percentage

FROM reviews;
Q3. What percentage of reviews are 5-Star?

KPI Card

SELECT

ROUND(

SUM(
CASE
WHEN review_score=5
THEN 1
ELSE 0
END
)

*100

/

COUNT(*)

,2)

AS Five_Star_Percentage

FROM reviews;
Q4. How many reviews were submitted?

KPI Card

SELECT

COUNT(review_id)

AS Total_Reviews

FROM reviews;

Note: review_id column reviews table lo undali. Screenshot lo undi.

Q5. How are customer ratings distributed?

Bar Chart

SELECT

review_score,

COUNT(review_id)

AS Total_Reviews

FROM reviews

GROUP BY review_score

ORDER BY review_score DESC;
Q6. How do delivery delays affect customer ratings?

Line Chart

SELECT

CASE

WHEN delivery_delay<0
THEN 'Early'

WHEN delivery_delay=0
THEN 'On Time'

WHEN delivery_delay BETWEEN 1 AND 3
THEN '1-3 Days Late'

WHEN delivery_delay BETWEEN 4 AND 7
THEN '4-7 Days Late'

WHEN delivery_delay BETWEEN 8 AND 15
THEN '8-15 Days Late'

ELSE '15+ Days Late'

END AS Delay_Category,

ROUND(
AVG(review_score),2
) AS Average_Rating

FROM orders o

JOIN reviews r

ON o.order_id=r.order_id

WHERE order_status='delivered'

GROUP BY Delay_Category

ORDER BY

MIN(delivery_delay);
Q7. Which product categories receive the most low ratings?

Bar Chart

SELECT

p.product_category_name,

COUNT(r.review_id)

AS Low_Rating_Count

FROM reviews r

JOIN orders o

ON r.order_id=o.order_id

JOIN order_items oi

ON o.order_id=oi.order_id

JOIN products p

ON oi.product_id=p.product_id

WHERE r.review_score IN (1,2)

GROUP BY p.product_category_name

ORDER BY Low_Rating_Count DESC

LIMIT 10;
Business Insights
1. Average customer rating is around 4.1, indicating generally positive customer satisfaction.

2. Around 58% of reviews are 5-star ratings.

3. Approximately 15% of reviews are low ratings (1–2 stars).

4. More than 99K customer reviews were collected.

5. Customer ratings decrease as delivery delays increase.

6. Orders delivered on time or earlier consistently receive higher ratings.

7. A small number of product categories account for most negative customer feedback.



    Seller Performance & Operational Efficiency.

Nee dashboard ni exactly match ayye SQL below.

08_Seller_Performance_Analysis.sql
/*==========================================================
        SELLER PERFORMANCE & OPERATIONAL EFFICIENCY

Business Questions

1. How many sellers are available?
2. Who is the highest revenue generating seller?
3. What is the average seller rating?
4. What percentage of sellers have high delivery delays?
5. Which sellers generate the highest revenue?
6. Which sellers have the highest average delivery delay?
7. What is the relationship between seller revenue, rating, and delivery delay?
==========================================================*/
Q1. How many sellers are registered?

KPI Card

SELECT

COUNT(DISTINCT seller_id)
AS Total_Sellers

FROM sellers;
Q2. Which seller generated the highest revenue?

KPI Card

SELECT

ROUND(MAX(Seller_Revenue),2)
AS Top_Seller_Revenue

FROM(

SELECT

seller_id,

SUM(price) AS Seller_Revenue

FROM order_items

GROUP BY seller_id

)t;
Q3. What is the average seller rating?

KPI Card

SELECT

ROUND(

AVG(review_score)

,2)

AS Average_Seller_Rating

FROM reviews;

Note: Nee dashboard logic prakaram seller rating ni seller orders reviews nundi derive chestunnav. Interview lo idi explain cheyyi.

Q4. What percentage of sellers have high delivery delays?

KPI Card

SELECT

ROUND(

COUNT(DISTINCT CASE
WHEN Avg_Delay>30
THEN seller_id
END)

*100

/

COUNT(DISTINCT seller_id)

,2)

AS High_Delay_Seller_Percentage

FROM(

SELECT

oi.seller_id,

AVG(o.delivery_delay) AS Avg_Delay

FROM order_items oi

JOIN orders o

ON oi.order_id=o.order_id

WHERE o.order_status='delivered'

GROUP BY oi.seller_id

)t;
Q5. Who are the Top 10 Revenue Generating Sellers?

Bar Chart

SELECT

seller_id,

ROUND(

SUM(price)

,2)

AS Revenue

FROM order_items

GROUP BY seller_id

ORDER BY Revenue DESC

LIMIT 10;
Q6. Which sellers have the highest average delivery delay?

Bar Chart

SELECT

oi.seller_id,

ROUND(

AVG(o.delivery_delay)

,2)

AS Average_Delay

FROM order_items oi

JOIN orders o

ON oi.order_id=o.order_id

WHERE o.order_status='delivered'

GROUP BY oi.seller_id

ORDER BY Average_Delay DESC

LIMIT 10;
Q7. What is the relationship between revenue, rating and delivery delay?

Scatter Plot

SELECT

oi.seller_id,

ROUND(

SUM(oi.price)

,2)

AS Revenue,

ROUND(

AVG(r.review_score)

,2)

AS Average_Rating,

ROUND(

AVG(o.delivery_delay)

,2)

AS Average_Delay

FROM order_items oi

JOIN orders o

ON oi.order_id=o.order_id

JOIN reviews r

ON o.order_id=r.order_id

WHERE o.order_status='delivered'

GROUP BY oi.seller_id;
Business Insights
1. Around 3,095 sellers are registered on the platform.

2. A small number of sellers generate the highest revenue.

3. Average seller rating is above 4, indicating good overall seller performance.

4. Only a small percentage of sellers experience significant delivery delays.

5. Revenue is concentrated among the top-performing sellers.

6. Sellers with higher delivery delays generally receive lower customer ratings.

7 .Improving the performance of high-delay sellers can improve customer satisfaction and operational efficiency.
 One Important Suggestion




hich payment method is used the most?

KPI Card

SELECT

payment_type,

COUNT(*) AS Total_Transactions

FROM payments

GROUP BY payment_type

ORDER BY Total_Transactions DESC

LIMIT 1;
Q2. What is the average number of installments per order?

KPI Card

SELECT

ROUND(
AVG(payment_installments),2
) AS Average_Installments

FROM payments;
Q3. What is the average payment value?

KPI Card

SELECT

ROUND(
AVG(payment_value),2
) AS Average_Payment_Value

FROM payments;
Q4. What percentage of orders use high installments?

KPI Card

Example:
High Installment = 3 or more installments

SELECT

ROUND(

SUM(
CASE

WHEN payment_installments>=3

THEN 1

ELSE 0

END

)

*100

/

COUNT(*)

,2)

AS High_Installment_Percentage

FROM payments;
Q5. How are payment methods distributed?

Donut Chart

SELECT

payment_type,

COUNT(*) AS Total_Transactions

FROM payments

GROUP BY payment_type

ORDER BY Total_Transactions DESC;
Q6. What is the average payment value by payment method?

Bar Chart

SELECT

payment_type,

ROUND(

AVG(payment_value)

,2)

AS Average_Payment_Value

FROM payments

GROUP BY payment_type

ORDER BY Average_Payment_Value DESC;
Q7. How has installment usage changed over time?

Line Chart

SELECT

DATE_FORMAT(o.order_purchase_dt,'%Y-%m') AS Month,

ROUND(

AVG(p.payment_installments)

,2)

AS Average_Installments

FROM orders o

JOIN payments p

ON o.order_id=p.order_id

GROUP BY Month

ORDER BY Month;
Q8. Which payment methods generate the highest revenue?

Bar Chart

SELECT

payment_type,

ROUND(

SUM(payment_value)

,2)

AS Total_Revenue

FROM payments

GROUP BY payment_type

ORDER BY Total_Revenue DESC;
Business Insights
1. Credit cards are the most preferred payment method.

2. Customers use around 2–3 installments on average.

3. Average payment value is approximately ₹154.

4. Around one-third of transactions use higher installment plans.

5. Credit cards contribute the highest share of total revenue.

6. Installment usage has gradually declined over time.

7. Voucher and debit card transactions contribute a much smaller share of total revenue.

8. Customer spending behavior is strongly influenced by the availability of installment payments.



    Who are the Top 10 Revenue Generating Sellers?

WITH SellerRevenue AS (
    SELECT
        seller_id,
        ROUND(SUM(price),2) AS Revenue
    FROM order_items
    GROUP BY seller_id
)

SELECT
    ROW_NUMBER() OVER(ORDER BY Revenue DESC) AS Seller_Rank,
    seller_id,
    Revenue
FROM SellerRevenue;
Why use ROW_NUMBER()?
Gives a unique rank (1, 2, 3...).
Best when you want a top-N list without tied ranks.




    DENSE_RANK()
Business Question

Rank Product Categories by Revenue

WITH CategoryRevenue AS (
    SELECT
        p.product_category_name,
        ROUND(SUM(oi.price),2) AS Revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_category_name
)

SELECT
    DENSE_RANK() OVER(ORDER BY Revenue DESC) AS Category_Rank,
    product_category_name,
    Revenue
FROM CategoryRevenue;
Why use DENSE_RANK()?

If two categories have the same revenue:

Dense Rank

1
2
2
3

No rank is skipped.








    Business Question

How did monthly revenue change compared to the previous month?

WITH MonthlyRevenue AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS Month,
        ROUND(SUM(p.payment_value),2) AS Revenue
    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY Month
)

SELECT
    Month,
    Revenue,
    LAG(Revenue) OVER(ORDER BY Month) AS Previous_Month_Revenue,
    Revenue -
    LAG(Revenue) OVER(ORDER BY Month) AS Revenue_Growth
FROM MonthlyRevenue;
Business Insight

Shows whether revenue increased or decreased compared with the previous month.

4. LEAD()
Business Question

Compare current month revenue with the next month

WITH MonthlyRevenue AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS Month,
        ROUND(SUM(p.payment_value),2) AS Revenue
    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY Month
)

SELECT
    Month,
    Revenue,
    LEAD(Revenue) OVER(ORDER BY Month) AS Next_Month_Revenue
FROM MonthlyRevenue;

Useful for trend analysis.

5. CTE Example – Top Sellers
/*=========================================
Top Revenue Generating Sellers
=========================================*/

WITH SellerRevenue AS (

SELECT

seller_id,

ROUND(SUM(price),2) AS Revenue

FROM order_items

GROUP BY seller_id

)

SELECT *

FROM SellerRevenue

ORDER BY Revenue DESC

LIMIT 10;
6. CTE Example – Delivery Performance
/*=========================================
Average Delivery Performance by State
=========================================*/

WITH StateDelivery AS (

SELECT

c.customer_state,

ROUND(AVG(o.delivery_delay),2) AS Average_Delay

FROM customers c

JOIN orders o

ON c.customer_id = o.customer_id

WHERE o.order_status='delivered'

GROUP BY c.customer_state

)

SELECT *

FROM StateDelivery

ORDER BY Average_Delay DESC;
7. CTE Example – Customer Rating
/*=========================================
Average Rating by Delay Category
=========================================*/

WITH ReviewAnalysis AS (

SELECT

CASE

WHEN o.delivery_delay < 0 THEN 'Early'

WHEN o.delivery_delay = 0 THEN 'On Time'

WHEN o.delivery_delay BETWEEN 1 AND 3 THEN '1-3 Days Late'

WHEN o.delivery_delay BETWEEN 4 AND 7 THEN '4-7 Days Late'

ELSE '8+ Days Late'

END AS Delay_Category,

r.review_score

FROM orders o

JOIN reviews r

ON o.order_id = r.order_id

)

SELECT

Delay_Category,

ROUND(AVG(review_score),2) AS Average_Rating

FROM ReviewAnalysis

GROUP BY Delay_Category

ORDER BY Average_Rating DESC;


