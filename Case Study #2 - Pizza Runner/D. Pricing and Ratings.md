
# D.  Pricing and Ratings
--------
## Solutions

### 1. If a Meat Lovers pizza pizza costs $12 and a Vegearian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```python
WITH cust_orders_run_orders AS (
SELECT
  *
FROM pizza_runner.customer_orders AS t1 
INNER JOIN pizza_runner.runner_orders AS t2
ON t1.order_id = t2.order_id
WHERE distance <> 'null'
),
cte_pizza_price AS (
SELECT
  CASE 
  WHEN pizza_id = 1 THEN 12
  ELSE 10
  END AS pizza_price
FROM cust_orders_run_orders 
)
SELECT
  SUM(pizza_price) AS total_sales
FROM cte_pizza_price  
```
> Solution
> | total_revenue |
> | --- |
> | 138 |
> -----
### 2. What if there was an additional $1 charge for any pizza extras?

The following column was cleaned and functions were used to get the solution:
* The column extras of table customer_orders was cleaned because there was blank values and null values were strings.
* REGEXP_SPLIT_TO_ARRAY is a function splits a specified string into an array using a POSIX regular expression as the separator and returns the array.
* CARDINALITY is function which returns the total number of individual elements in an array.
* COALESCE is a function that returns the first argument that is not null.

```python
WITH cust_orders_run_orders AS (
SELECT
  t1.order_id AS order_id,
  t1.customer_id,
  t1.pizza_id As pizza_id,
  CASE 
  WHEN exclusions LIKE '%null%' OR exclusions = '' THEN Null 
  ELSE exclusions
  END AS exclusions,
  CASE
  WHEN extras LIKE '%null%' OR extras = '' THEN Null 
  ELSE extras
  END AS extras
FROM pizza_runner.customer_orders AS t1 
INNER JOIN pizza_runner.runner_orders AS t2
ON t1.order_id = t2.order_id
WHERE distance <> 'null'
),
cte_total_revenue AS (
SELECT
  (
  SUM(CASE 
  WHEN pizza_id = 1 THEN 12
  ELSE 10
  END
  ) + SUM (
  COALESCE(
      CARDINALITY(REGEXP_SPLIT_TO_ARRAY(extras, ',\s')),
      0 
    )
    ) 
  ) AS total_revenue
  
FROM cust_orders_run_orders
)
SELECT
  *
FROM cte_total_revenue;  

```
> Solution
> | total_revenue |
> | --- |
> | 142 |
> -----

### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.


```python
DROP TABLE IF EXISTS pizza_runner.runner_ratings;
CREATE TABLE pizza_runner.runner_ratings (
      order_id INT,
      runner_id INT,
      rating SMALLINT NOT NULL CHECK (rating between 1 and 5)
)
INSERT INTO pizza_runner.runner_ratings VALUES
  (1, 1, 5),
  (2, 1, 3),
  (3, 1, 4),
  (4, 2, 3),
  (5, 3, 2),
  (6, 3, 5),
  (9, 2, 2),
  (7, 2, 4),
  (8, 2, 4),
  (10, 1, 3)

SELECT
  *
FROM pizza_runner.runner_ratings  

```
> Solution

| order_id |runner_id |rating |
| --- | --- | --- |
| 1 | 1 |5 |
| 2 | 1 |3 |
| 3 | 1 |4 |
| 4 | 2 |3 |
| 5 | 3 |2 |
| 6 | 3 |5|
| 9 | 2 |2|
| 7 | 2 |4|
| 8 | 2 |4|
| 10 | 1 |3|

 -----
 ### 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
* customer_id
* order_id
* runner_id
* rating
* order_time
* pickup_time
* Time between order and pickup
* Delivery duration
* Speed


```python 
DROP TABLE IF EXISTS cust_orders_run_orders;
CREATE TEMP TABLE cust_orders_run_orders AS
SELECT  
  t1.order_id AS order_id,
  customer_id,
  t2.runner_id,
  t1.order_time AS order_time,
  t2.pickup_time AS pickup_time,
  UNNEST(REGEXP_MATCH(t2.distance, '[0-9]+')):: NUMERIC AS distance_km,
  UNNEST(REGEXP_MATCH(t2.duration, '[0-9]+')):: NUMERIC AS delivery_duration_minutes
FROM pizza_runner.customer_orders AS t1
INNER JOIN pizza_runner.runner_orders AS t2
ON t1.order_id = t2.order_id 
WHERE distance <> 'null'

WITH cte_runner_ratings_cust_orders AS (
SELECT
  *
FROM cust_orders_run_orders AS t3  
INNER JOIN pizza_runner.runner_ratings AS t4 
ON t3.order_id = t4.order_id
),
cte_avg_pickup_time AS (
SELECT
  *,
  DATE_PART('minute', pickup_time::TIMESTAMP - order_time::TIMESTAMP)::INTEGER AS time_between_order_pickup,
  ROUND(distance_km / (delivery_duration_minutes/ 60),2) AS speed
FROM cte_runner_ratings_cust_orders
ORDER BY 1
)
SELECT
  *
FROM cte_avg_pickup_time;
```
> Solution

| order_id |customer_id |runner_id |order_time |pickup_time |distance_km |delivery_duration_minutes |rating |time_between_order_pickup | speed |
| --- | --- | --- |--- |--- |--- |--- |--- |--- |--- |
| 1 | 101 |1 |2021-01-01 18:05:02.000 |2021-01-01 18:15:34 | 20 | 32| 5 | 10| 37.50 |
|2| 101 | 1| 2021-01-01 19:00:52.000  | 2021-01-01 19:10:54 | 20 | 27 | 3 | 10 | 44.44 | 
| 3 | 102 |1 |2021-01-02 23:51:23.000| 2021-01-03 00:12:37|13|20|4|21|39.00|
| 3 | 102 |1 |2021-01-02 23:51:23.000|2021-01-03 00:12:37|13|20|4|21|39.00|
| 4 | 103 |2|2021-01-04 13:23:46.000|2021-01-04 13:53:03|23|40|3|29|34.50
| 4 | 103 |2|2021-01-04 13:23:46.000|2021-01-04 13:53:03|23|40|3|29|34.50
| 4 | 103 |2|2021-01-04 13:23:46.000|2021-01-04 13:53:03|23|40|3|29|34.50|
| 5 | 104 |3|2021-01-08 21:00:29.000|2021-01-08 21:10:57|10|15|2|10|40.00|
| 7 | 105 |2|2021-01-08 21:20:29.000|2021-01-08 21:30:45|25|25|4|10|60.00
| 8 | 102 |2|2021-01-09 23:54:33.000|2021-01-10 00:15:02|23|15|4|20.00|
| 10 | 104 |1|2021-01-11 18:34:49.000|2021-01-11 18:50:20|10|10|3|15|60.00|
| 10 | 104 |1|2021-01-11 18:34:49.000|2021-01-11 18:50:20|10|10|3|15|60.00|

----
### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```python
DROP TABLE IF EXISTS cust_orders_run_orders;
CREATE TEMP TABLE cust_orders_run_orders AS
SELECT  
  t1.order_id AS order_id,
  customer_id,
  CASE 
  WHEN t1.pizza_id = 1 THEN 12
  ELSE 10
  END AS pizza_prices,
  t2.runner_id,
  UNNEST(REGEXP_MATCH(t2.distance, '[0-9]+')):: NUMERIC AS distance_km
FROM pizza_runner.customer_orders AS t1
INNER JOIN pizza_runner.runner_orders AS t2
ON t1.order_id = t2.order_id 
WHERE distance <> 'null'

DROP TABLE IF EXISTS cleaned_distance;
CREATE TEMP TABLE cleaned_distance AS
SELECT
  DISTINCT distance_km
FROM cust_orders_run_orders

SELECT * FROM cleaned_distance

SELECT
  SUM(revenue) AS revenue_after_runner
FROM 
  (
    SELECT
      SUM(pizza_prices) AS revenue
    FROM cust_orders_run_orders
    UNION
    SELECT
      SUM(-1 * distance_km * 0.3) AS revenue
    FROM cleaned_distance
      
  ) AS revenue_after_pay_runner

```
> Solution

| revenue_after_runner |
|--- |
| 110.7 | 