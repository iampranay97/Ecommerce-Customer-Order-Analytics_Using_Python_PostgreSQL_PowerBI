CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    month VARCHAR(10)
);

COPY orders(order_id, customer_id, order_status, order_purchase_timestamp,
            order_approved_at, order_delivered_carrier_date,
            order_delivered_customer_date, order_estimated_delivery_date, month)
FROM 'C:/Data Analyst Projects/02_E-Commerce_Customer_&_Order_Analytics/02_Cleaned Dataset/orders_cleaned.csv'
DELIMITER ',' CSV HEADER;


CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(20),
    customer_city VARCHAR(100),
    customer_state VARCHAR(50)
);

COPY customers(customer_id, customer_unique_id, customer_zip_code_prefix,
               customer_city, customer_state)
FROM 'C:/Data Analyst Projects/02_E-Commerce_Customer_&_Order_Analytics/02_Cleaned Dataset/customers_cleaned.csv'
DELIMITER ',' CSV HEADER;


CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght NUMERIC,
    product_description_lenght NUMERIC,
    product_photos_qty NUMERIC,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

COPY products(product_id, product_category_name, product_name_lenght,
              product_description_lenght, product_photos_qty,
              product_weight_g, product_length_cm,
              product_height_cm, product_width_cm)
FROM 'C:/Data Analyst Projects/02_E-Commerce_Customer_&_Order_Analytics/02_Cleaned Dataset/products_cleaned.csv'
DELIMITER ',' CSV HEADER;


CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value NUMERIC(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

COPY payments(order_id, payment_sequential, payment_type,
              payment_installments, payment_value)
FROM 'C:/Data Analyst Projects/02_E-Commerce_Customer_&_Order_Analytics/02_Cleaned Dataset/payments_cleaned.csv'
DELIMITER ',' CSV HEADER;


CREATE TABLE reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

COPY reviews(review_id, order_id, review_score,
             review_comment_title, review_comment_message,
             review_creation_date, review_answer_timestamp)
FROM 'C:/Data Analyst Projects/02_E-Commerce_Customer_&_Order_Analytics/02_Cleaned Dataset/reviews_cleaned.csv'
DELIMITER ',' CSV HEADER;


CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(20),
    seller_city VARCHAR(100),
    seller_state VARCHAR(50)
);

COPY sellers(seller_id, seller_zip_code_prefix,
             seller_city, seller_state)
FROM 'C:/Data Analyst Projects/02_E-Commerce_Customer_&_Order_Analytics/02_Cleaned Dataset/sellers_cleaned.csv'
DELIMITER ',' CSV HEADER;

-- Step 1 :- Data Validation

-- 1.1 Row Counts

SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers;


-- 1.2 Unique ID's

SELECT 'orders' AS table_name, COUNT(DISTINCT order_id) AS unique_ids FROM orders
UNION ALL
SELECT 'customers', COUNT(DISTINCT customer_id) FROM customers
UNION ALL
SELECT 'products', COUNT(DISTINCT product_id) FROM products
UNION ALL
SELECT 'sellers', COUNT(DISTINCT seller_id) FROM sellers
UNION ALL
SELECT 'reviews', COUNT(DISTINCT review_id) FROM reviews;

-- 1.3 Date Range

SELECT
	MIN(order_purchase_timestamp) AS first_order_date,
	MAX(order_purchase_timestamp) AS last_order_date
FROM orders;

-- Step 2 :- Overall E-Commerce KPIs

-- 2.1 Core KPIs

WITH payment_by_order AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_value
    FROM payments
    GROUP BY order_id
)
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    ROUND(SUM(p.order_value), 2) AS total_revenue,
    ROUND(
        SUM(p.order_value) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN payment_by_order p
    ON o.order_id = p.order_id;

-- 2.2 Paid Vs Unpaid Orders

SELECT
	COUNT(DISTINCT o.order_id) AS total_orders,
	COUNT(DISTINCT p.order_id) AS paid_orders,
	COUNT(DISTINCT o.order_id)
		- COUNT(DISTINCT p.order_id) AS unapid_orders
FROM orders o
LEFT JOIN payments p
ON o.order_id = p.order_id;

-- Step 3 :- Monthly Trend & Revenue Trend

-- 3.1 Monthly Performance

WITH payment_by_order AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_value
    FROM payments
    GROUP BY order_id
)
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::date AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(COALESCE(SUM(p.order_value), 0), 2) AS total_revenue
FROM orders o
LEFT JOIN payment_by_order p
    ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 1;	

-- 3.2 Month-Over-Month Revenue Growth

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS order_month,
        SUM(p.order_value) AS total_revenue
    FROM orders o
    JOIN (
        SELECT
            order_id,
            SUM(payment_value) AS order_value
        FROM payments
        GROUP BY order_id
    ) p
        ON o.order_id = p.order_id
    GROUP BY 1
),
sales_with_previous AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    order_month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue)
        * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_mom_growth_pct
FROM sales_with_previous
ORDER BY order_month;

-- 3.3 Highest & Lowest Order Month

WITH monthly_orders AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS order_month,
        COUNT(o.order_id) AS total_orders
    FROM orders o
    GROUP BY 1
)
SELECT 
    (SELECT TO_CHAR(order_month, 'Mon YYYY')
     FROM monthly_orders
     ORDER BY total_orders DESC
     LIMIT 1) AS highest_order_month,
    (SELECT TO_CHAR(order_month, 'Mon YYYY')
     FROM monthly_orders
     ORDER BY total_orders ASC
     LIMIT 1) AS lowest_order_month;


-- Step 4 :- Customer Analysis

-- 4.1 Customer Count By State

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- 4.2 Top 5 Customers By Revenue

WITH payment_by_order AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_value
    FROM payments
    GROUP BY order_id
)
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.order_value), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payment_by_order p
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_revenue DESC
LIMIT 5;

-- 4.3 Repeat Vs One-time Customers

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct
FROM customer_orders
GROUP BY 1
ORDER BY customers DESC;

-- 4.4 Repeat Purchase Rate

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) FILTER (WHERE total_orders > 1) AS repeat_customers,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) FILTER (WHERE total_orders > 1) * 100.0
        / COUNT(*),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;


-- Step 5 :- Payment Analysis

-- 5.1 Payment Method Performance

SELECT
    payment_type,
    COUNT(*) AS payment_transactions,
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- 5.2 Payment Method Share

SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(
        SUM(payment_value) * 100.0
        / SUM(SUM(payment_value)) OVER (),
        2
    ) AS payment_value_share_pct
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- 5.3 Installment Analysis

SELECT
    payment_installments,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;


-- Step 6 :- Delivery Analysis

-- 6.1 Average Delivery Time

SELECT
    COUNT(*) AS delivered_orders,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 24 / 3600
        ),
        2
    ) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

 -- 6.2 Average Processing Time

 SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_approved_at
                    - order_purchase_timestamp
                )
            ) / 3600
        ),
        2
    ) AS avg_approval_hours
FROM orders
WHERE order_approved_at IS NOT NULL;

-- 6.3 Carrier Handoff Time

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_carrier_date
                    - order_approved_at
                )
            ) / 86400
        ),
        2
    ) AS avg_carrier_handoff_days
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL;

  /* 
Note:
86400 = 24*3600 seconds = 1 day
So dividing by 86400 or /24/3600 gives same result
*/


-- Step 7 :- Review / Customer Satisfaction Analysis

-- 7.1 Review Score Distribution

SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS review_share_pct
FROM reviews
GROUP BY review_score
ORDER BY review_score;

-- 7.2 Overall Average Review Score

SELECT
    COUNT(*) AS review_records,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;

-- 7.3 Negative Review Rate

SELECT
    COUNT(*) FILTER (WHERE review_score <= 2) AS negative_reviews,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) FILTER (WHERE review_score <= 2) * 100.0
        / COUNT(*),
        2
    ) AS negative_review_rate_pct
FROM reviews;

-- 7.4 Delivery Review Score

SELECT 
    CASE 
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN reviews r 
    ON o.order_id = r.order_id
WHERE r.review_score IS NOT NULL
  AND o.order_status = 'delivered'
GROUP BY delivery_status
ORDER BY delivery_status;


-- Step 8 :- Customer RFM Analysis (R-Recency, F-Frequency, M-Monetary)

WITH customer_metrics AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(p.order_value) AS monetary
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN (
        SELECT
            order_id,
            SUM(payment_value) AS order_value
        FROM payments
        GROUP BY order_id
    ) p
        ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY last_order_date DESC
        ) AS recency_score,
        NTILE(4) OVER (
            ORDER BY frequency
        ) AS frequency_score,
        NTILE(4) OVER (
            ORDER BY monetary
        ) AS monetary_score
    FROM customer_metrics
)
SELECT
    customer_unique_id,
    last_order_date,
    frequency,
    ROUND(monetary, 2) AS monetary,
    recency_score,
    frequency_score,
    monetary_score
FROM rfm_scores
ORDER BY monetary DESC
LIMIT 20;
