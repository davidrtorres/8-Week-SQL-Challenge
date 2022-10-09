
<p align= "center">
    <h1>A.   Pizza Metrics</h1>
</p>

<p align="center">
  <img width="350" height="350" src="images/pizza_runner.png">
</p>

---
### Cleaning Tables
### 1. customer_orders Table
* The exclusion and extras columns need to be cleaned.
* There are blank spaces which will be indicated as null.
* The null string values in exclusion and extras columns will be converted to null values.

```python
DROP TABLE IF EXISTS cleaned_customer_orders;
CREATE TEMP TABLE cleaned_customer_orders AS
SELECT
  order_id,
  customer_id, 
  pizza_id,
  CASE 
  WHEN exclusions LIKE '%null%' OR exclusions = '' THEN Null 
  ELSE exclusions
  END AS exclusions,
  CASE
  WHEN extras LIKE '%null%' OR extras = '' THEN Null 
  ELSE extras
  END AS extras,
  order_time
FROM pizza_runner.customer_orders;
```
> Output

| order_id | customer_id | pizza_id | exclusions | extras |order_time |
| --------- | ------------- |  ------------- | -------- | ----------- |----------- |
| 1 | 101  |  1 | null | null |2021-01-01 18:05:02.000 |
| 2 | 101   |  1 | null  | null  |2021-01-01 19:00:52.000 |
| 3 | 102   |  1 | null  | null  | 2021-01-02 23:51:23.000 |
| 3 | 102   |  2 | null | null | 2021-01-02 23:51:23.000 |
| 4 | 103   |  1 | 4 | null | 2021-01-04 13:23:46.000
| 4 | 103   |  1 | 4  | null | 2021-01-04 13:23:46.000
----

### 1.  How many pizzas were ordered?

```python
SELECT 
  COUNT(order_id) AS pizzas_ordered
FROM cleaned_customer_orders
```
> Output
> 
|pizzas_ordered| 
|--------------| 
| 14           | 

---
### 2.  How many unique customer orders were made??

```python
SELECT
  COUNT(DISTINCT order_id) AS unique_customer_orders
FROM cleaned_customer_orders  
```
> Output
 
|unique_customer_orders| 
|--------------| 
| 10           | 

---
### 3.  How many successful orders were delivered by each runner?

```python
SELECT
  runner_id,
  COUNT(duration) AS successful_orders
FROM cleaned_runner_orders
GROUP BY runner_id
ORDER BY runner_id
 
```
> Output

| runner_id | successful_orders | 
| --------- | ------------- | 
| 1         | 4   | 
| 2         | 3   | 
| 3         | 1   | 
 
---
### 4.  How many of each type of pizza was delivered?

```python
SELECT
  n.pizza_name AS pizza_name,
  COUNT(r.duration) AS delivered
FROM cleaned_runner_orders AS r 
INNER JOIN cleaned_customer_orders AS c 
ON r.order_id = c.order_id
INNER JOIN pizza_runner.pizza_names AS n 
ON c.pizza_id = n.pizza_id
GROUP BY pizza_name
 
```
> Output
>
| pizza_name | delivered | 
| --------- | ------------- | 
| Meatlovers | 9   | 
| Vegetarian | 3   | 

---
### 5.  How many vegetarian and meatlovers were ordered by each customer?

```python
SELECT
  c.customer_id AS customer_id,
  n.pizza_name AS pizza_name,
  COUNT(*) AS num_ordered
FROM cleaned_runner_orders AS r 
INNER JOIN cleaned_customer_orders AS c 
ON r.order_id = c.order_id
INNER JOIN pizza_runner.pizza_names AS n 
ON c.pizza_id = n.pizza_id
GROUP BY customer_id, pizza_name
ORDER BY customer_id
 
```
> Output

| customer_id    | pizza_name   | num_ordered   |
| ------------- | ------------- | ------------- |
| 101 | Meatlovers    | 2  |
| 101 | Vegetarian | 1  |
| 102 | Meatlover    | 2  |
| 102 | Vegetarian  | 1  |
| 103 | Meatlovers      | 3  |
| 103 | Vegetarian  | 1  |
| 104 | Meatlovers      | 3  |
| 105 | Vegetarian  | 1  |

----
### 6.  What was the maximum number of pizzas delivered in a single order? 

```python

DROP TABLE IF EXISTS max_pizzas_deliver;
CREATE TEMP TABLE max_pizzas_deliver AS
SELECT
  c.order_id AS order_id
FROM cleaned_runner_orders AS r 
INNER JOIN cleaned_customer_orders AS c 
ON r.order_id = c.order_id
WHERE distance IS NOT NULL
ORDER BY order_id;

SELECT 
  order_id,
  COUNT(*) AS max_pizzas_delivered
FROM max_pizzas_deliver
GROUP BY order_id
ORDER BY max_pizzas_delivered DESC
LIMIT 1;
 
```
> Output

| order_id    | max_pizzas_delivered   | 
| ------------- | ------------- | 
| 4 | 3  |

--------
### 7.  For each customer, how many delivered pizzas had at least 1 change and how many had no changes? 

```python
DROP TABLE IF EXISTS pizza_changes;
CREATE TEMP TABLE pizza_changes AS
SELECT
  c.order_id AS order_id,
  c.customer_id AS customer_id,
  c.exclusions AS exclusions,
  c.extras AS extras,
  r.cancellation
FROM cleaned_runner_orders AS r 
INNER JOIN cleaned_customer_orders AS c 
ON r.order_id = c.order_id
INNER JOIN pizza_runner.pizza_names AS n 
ON c.pizza_id = n.pizza_id;


WITH cte_pizza_changes AS (
SELECT
  customer_id,
  SUM(CASE
  WHEN (exclusions IS NOT NULL 
      OR extras IS NOT NULL) THEN 1
  ELSE 0
  END) AS at_least_1_change,
  SUM(CASE
  WHEN (exclusions IS NULL 
      AND extras IS NULL) THEN 1
  ELSE 0
  END) AS no_change
FROM pizza_changes  
WHERE cancellation is NULL
GROUP BY customer_id
)
SELECT
  *
FROM cte_pizza_changes;  

```
> Output

| customer_id    | at_least_1_change  | no_change  | 
| ------------- | ------------- | ------------- | 
| 101 | 0  | 2  |
| 102 | 0  | 3  |
| 103 | 3  | 0  |
| 104 | 2  | 1  |
| 105 | 1  | 0  |

### 8.  How many pizzas were delivered that had both exclusions and extras? 

```python
SELECT
  COUNT(*) AS pizzas_w_exclusions_extras
FROM cleaned_runner_orders AS r 
INNER JOIN cleaned_customer_orders AS c 
ON r.order_id = c.order_id
WHERE distance IS NOT NULL
  AND (exclusions IS NOT NULL AND extras IS NOT NULL);
```
> Output

| pizzas_w_exclusions_extras | 
| ------------- | 
| 1 | 

------
### 9.  What was the total volumne of pizzas ordered for each hour of the day? 

```python
SELECT 
  EXTRACT(HOUR FROM order_time) AS hour_of_day,
  COUNT(order_id) AS num_pizzas_ordered
FROM cleaned_customer_orders
GROUP BY hour_of_day
ORDER BY hour_of_day;
```
> Output

| hour_of_the_day | pizza_count   | 
| ------------- | ------------- | 
| 11 | 1 | 
| 13 | 3 | 
| 18 | 3 | 
| 19 | 1 | 
| 21 | 3 | 
| 23 | 3 | 

-----
### 10.  What was the volume of orders for each day of the week? 

```python
SELECT 
  TO_CHAR(order_time, 'DAY') AS day_of_week,
  COUNT(order_id) AS num_pizzas_ordered
FROM cleaned_customer_orders
GROUP BY day_of_week
ORDER BY day_of_week;

```
> Output

| day_of_week | num_orders_each_day_week | 
| ------------- | ------------- | 
| Friday | 5 | 
| Monday | 5 | 
| Saturday | 3 | 
| Sunday | 1 | 




