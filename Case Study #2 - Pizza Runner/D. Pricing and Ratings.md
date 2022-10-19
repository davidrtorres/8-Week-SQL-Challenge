
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