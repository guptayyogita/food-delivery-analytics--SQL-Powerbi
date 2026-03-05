CREATE DATABASE SWIGGY;
USE SWIGGY;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date DATE,
    order_time TIME,
    city VARCHAR(100),
    cost DECIMAL(10,2),
    delivery_time INT,  -- in minutes
    delivery_status VARCHAR(50),
    rating DECIMAL(2,1),
    payment_mode VARCHAR(50),
    discount_applied DECIMAL(10,2),
    platform VARCHAR(50)
);

SELECT * FROM swiggy.`excel project 1`; 
ALTER TABLE swiggy.`excel project 1`
RENAME TO Delivery_table; 

SELECT * FROM Delivery_table; 
SELECT * FROM Orders; 
SELECT * FROM  Resturants; 
SELECT * FROM  Customers;  

-- JOINING TABLES

SELECT O.ORDER_ID,
C.CUSTOMER_NAME,
R.RESTAURANT_NAME,
O.CITY, O.COST,
O.DELIVERY_TIME, O.RATING
FROM ORDERS AS O
LEFT JOIN CUSTOMERS AS C
ON O.CUSTOMER_ID = C.CUSTOMER_ID
LEFT JOIN RESTURANTS AS R 
ON O.RESTAURANT_ID = R.RESTAURANT_ID ;

-- RANKING CUSTOMERS BY THEIR SPENDING 
SELECT 
CUSTOMER_ID ,
SUM(COST)  AS TOTAL_SPENT,
RANK() OVER(ORDER BY SUM(COST) DESC) AS CUSTOMER_RATINGS
FROM ORDERS
GROUP BY CUSTOMER_ID;


-- TOP 10 CUSTOMERS BY THIER TOTAL SPENT
SELECT 
CUSTOMER_ID ,
SUM(COST)  AS TOTAL_SPENT,
RANK() OVER(ORDER BY SUM(COST) DESC) AS CUSTOMER_RATINGS
FROM ORDERS
GROUP BY CUSTOMER_ID
LIMIT 10 ;


-- RUNNING REVENUE
SELECT 
 ORDER_DATE,
 SUM(COST) AS DAILY_REVENUE,
 SUM(SUM(COST)) OVER(ORDER BY ORDER_DATE) AS RUNNING_REVENUE
 FROM ORDERS
 GROUP BY ORDER_DATE;


-- PEAK HOUR ANALYSIS
SELECT 
    EXTRACT(HOUR FROM order_time) AS order_hour,
    COUNT(*) AS total_orders,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS peak_hour_rank
FROM orders
GROUP BY order_hour; 


-- LATE DELIVERY BY CITY
WITH city_delivery AS (
    SELECT 
        city,
        COUNT(*) AS total_orders,
        SUM(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_orders
    FROM orders
    GROUP BY city
)
SELECT 
    city,
    total_orders,
    (late_orders * 100.0 / total_orders) AS late_percentage
FROM city_delivery;










