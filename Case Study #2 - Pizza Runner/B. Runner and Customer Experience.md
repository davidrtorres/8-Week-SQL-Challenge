# B. Runner and Customer Experience
### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)?
```python

SELECT
  DATE_PART('week', registration_date::TIMESTAMP) AS registration_week,
  COUNT(*) AS runners_signed_up
FROM pizza_runner.runners
GROUP BY 1

```
> Output

| registration_week | runners_signed_up | 
| --------- | ------------- | 
| 53         | 2  | 
| 1        | 1   | 
| 2         | 1   | 

------
### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up orders?
```python
WITH cte_avg_pickup_time AS (
SELECT
  DISTINCT r.runner_id AS runner_id,
  DATE_PART('minute', r.pickup_time::TIMESTAMP - c.order_time::TIMESTAMP)::INTEGER AS minute_of_day
FROM cleaned_runner_orders AS r 
INNER JOIN cleaned_customer_orders AS c 
ON r.order_id = c.order_id
WHERE pickup_time != 'null'
)
SELECT
  runner_id,
  ROUND(AVG(minute_of_day),2) AS avg_minutes
FROM cte_avg_pickup_time
GROUP BY 1
ORDER BY runner_id;

```
> Output
> 
| runner_id | avg_minutes | 
| --------- | ------------- | 
| 1         | 15.33 | 
| 2        | 19.67   | 
| 3         | 10.00   | 

------
### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
```python

SELECT 
  t2.order_id AS order_id,
  COUNT(t2.order_id) AS num_pizzas,
  DATE_PART('MINUTE',AGE(t1.pickup_time::TIMESTAMP,t2.order_time::TIMESTAMP))::INTEGER AS time_prepare_order
FROM pizza_runner.runner_orders AS t1
INNER JOIN pizza_runner.customer_orders AS t2
  ON t1.order_id = t2.order_id
WHERE t1.pickup_time != 'null'
GROUP BY 1,3
ORDER BY order_id;
```
>Output

| order_id  | num_pizzas | time_prepare_order | 
| --------- | ------------- | ------------- |
| 1         | 1   | 10 |
| 2         | 1   | 10 |
| 3         | 2   | 21 |
| 4         | 3   | 29 |
| 5         | 1   | 10 |
| 7         | 1   | 10 |
| 8         | 1   | 20 |
| 10        | 2   | 15 |
----
### What was the average distance traveled for each customer?
```python

WITH my_sample AS (
SELECT
  t2.customer_id AS customer_id,
  NULLIF(REGEXP_REPLACE(t1.distance,'[^0-9.]','','g'),'')::NUMERIC AS distance
FROM pizza_runner.runner_orders AS t1
INNER JOIN pizza_runner.customer_orders AS t2
  ON t1.order_id = t2.order_id
WHERE t1.distance != 'null'
)
SELECT
  customer_id,
  ROUND(AVG(distance),2)
FROM my_sample  
GROUP BY customer_id
ORDER BY customer_id;
```
> Output
> 
| customer_id  | avg_distance |  
| --------- | ------------- |
| 101         | 20.00   |
| 102       | 16.73   | 
| 103       | 23.40   | 
| 104         | 10.00   | 
| 105         | 25.00   | 
----