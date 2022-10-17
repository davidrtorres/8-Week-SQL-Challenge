# Ingredient Optimization 

## Data Cleaning
The following tables needed to be cleaned:
* The customer_orders table.
* The columns exclusions and extras have blank values or the null values are strings and need to be converted to integers.  

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

 order_id | customer_id | pizza_id  |  exclusions  | extras  | order_time  |
| --------- | ------------- | ------------- |  ------------- | ------------- | ------------- |
| 1  | 101   | 1 | null | null | 2021-01-01 18:05:02.000 |
| 2  | 101   | 1| null | null | 2021-01-01 19:00:52.000 |
| 3  | 102   | 1 | null | null | 2021-01-02 23:51:23.000 |
| 3  | 102   | 2 | null | null | 2021-01-02 23:51:23.000 |
| 4  | 103   | 1 | 4 | null | 2021-01-02 23:51:23.000 |

-----

The pizza_recipes table needs to be cleaned because the toppings feature has multiple topping id values which are grouped together on 2 rows instead if having a pizza_id and the corresponding topping id each on a separate row. 
I using a table to clean the data so its easily accessible and used for any questions.
```python
DROP TABLE IF EXISTS split_toppings;
CREATE TEMP TABLE split_toppings AS
SELECT
  pizza_id,
  UNNEST(string_to_array(toppings,','))::NUMERIC AS topping_id
FROM pizza_runner.pizza_recipes

```
> Output
> 
| pizza_id | topping_id |
| --------- | ------------- |  
| 1  | 1   | 
| 1  | 2   |  
| 1  | 3   | 
| 1  | 4   |  
| 1  | 5   | 
| 1  | 6   |  
| 1  | 8   |  
| 1  | 10   |  
| 2  | 4   |  
| 2  | 6   |  
| 2  | 7   |  
| 2  | 9   |  
| 2  | 11   |  
| 2  | 12   |  
-----

## Questions and Solutions

### 1.  What are the standard ingredients for each pizza?
```python
DROP TABLE IF EXISTS cleaned_pizza_recipes;
CREATE TEMP TABLE cleaned_pizza_recipes AS
SELECT
  UNNEST(string_to_array(toppings,','))::NUMERIC AS "topping_id", 
  pizza_id  
FROM pizza_runner.pizza_recipes;

SELECT
  t1.pizza_id,
  t1.topping_id,
  t2.topping_name
FROM cleaned_pizza_recipes AS t1
INNER JOIN pizza_runner.pizza_toppings AS t2
ON t1.topping_id = t2.topping_id
ORDER BY 1, 2;
```
> Output

| pizza_id | topping_id | topping_name  | 
| --------- | ------------- | ------------- | 
| 1  | 1   | Bacon | 
| 1  | 2   | BBQ Sauce | 
| 1  | 3   | Beef | 
| 1  | 4   | Cheese | 
| 1  | 5   | Chicken | 
| 1  | 6   | Mushrooms | 
| 1  | 8   | Pepperoni | 
| 1  | 10   | Salami | 
| 2  | 4   | Cheese | 
| 2  | 6   | Mushrooms | 
| 2  | 7   | Onions | 
| 2  | 9   | Peppers | 
| 2  | 11   | Tomatoes | 
| 2  | 12   | Tomato Sauce | 
-----

### 2. What was the most commonly added extra?
```python
WITH cte_commonly_added_extra AS (
SELECT
  order_id,
  UNNEST(string_to_array(extras,','))::NUMERIC AS "extra_toppings"
FROM cleaned_customer_orders 
)
SELECT
  topping_name,
  COUNT(*) AS extras_count
FROM  cte_commonly_added_extra AS t1 
INNER JOIN pizza_runner.pizza_toppings AS t2
ON t1.extra_toppings = t2.topping_id
GROUP BY 1
ORDER BY 2 DESC;

```
> Output
> 
| topping_name | extras_count | 
| --------- | ------------- | 
| Bacon  | 4   |
| Chicken  | 1   | 
| Cheese  | 1   | 
---
### 3. What was the most common exclusion?
```python
WITH cte_commonly_excluded AS (
SELECT
  order_id,
  UNNEST(string_to_array(exclusions,','))::NUMERIC AS "excluded_toppings"
FROM cleaned_customer_orders 
)
SELECT
  topping_name,
  COUNT(*) AS exclusion_count
FROM  cte_commonly_excluded AS t1 
INNER JOIN pizza_runner.pizza_toppings AS t2
ON t1.excluded_toppings = t2.topping_id
GROUP BY 1
ORDER BY 2 DESC;

```
> Output
> 
| topping_name | exclusion_count | 
| --------- | ------------- | 
| Cheese  | 4   |
| Mushrooms  | 1   | 
| BBQ Sauce  | 1   | 

-----



```python
WITH cte_customer_orders_toppings AS (
SELECT
  t1.order_id,
  t1.customer_id,
  t1.pizza_id AS pizza_id,
  t1.order_time,
  t2.topping_id AS topping_id
FROM  cleaned_customer_orders AS t1
LEFT JOIN split_toppings AS t2
ON t1.pizza_id = t2.pizza_id
),
-- cte to split double integer values in exclusion
cte_exclusions AS (
SELECT
  order_id,
  customer_id,
  pizza_id,
  order_time,
  UNNEST(string_to_array(exclusions,','))::NUMERIC AS exclusions
FROM cleaned_customer_orders
WHERE exclusions IS NOT NULL
),
--cte to split double integer values in extras
cte_extras AS (
SELECT
  order_id,
  customer_id,
  pizza_id,
  order_time,
  UNNEST(string_to_array(extras,','))::NUMERIC AS extras
FROM cleaned_customer_orders
WHERE extras IS NOT NULL
),
-- union cte_customer_orders_toppings w/cte_exclusions and cte_extras
cte_union_orders_extras_exclusions AS (
  SELECT * FROM cte_customer_orders_toppings
  UNION ALL
  SELECT * FROM cte_exclusions
  UNION ALL
  SELECT * FROM cte_extras
)
SELECT
  t2.topping_name,
  COUNT(*) AS topping_count
FROM cte_union_orders_extras_exclusions AS t1 
INNER JOIN pizza_runner.pizza_toppings AS t2 
ON t1.topping_id = t2.topping_id
GROUP BY 1
ORDER BY 2 DESC;

```
> Solution

| topping_name | topping_count | 
| --------- | ------------- | 
| Cheese  | 19  |
| Mushrooms  | 15   | 
| Bacon  | 14   | 
| BBQ Sauce  | 11  |
| Chicken  | 11   | 
| Pepperoni  | 10   | 
| Salami  | 10  |
| Beef  | 10  |
| Tomato Sauce  | 4   | 
| Onions  | 4   | 
| Tomatoes  | 4   |
| Peppers  | 4   |