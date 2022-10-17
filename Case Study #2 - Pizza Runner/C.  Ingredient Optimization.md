# Ingredient Optimization 

## Data Cleaning
The pizza_recipes table needs to be cleaned because the toppings feature has multiple topping ids values which are grouped together on 2 rows instead if having a pizza_id and the corresponding topping id each on a separate row. 
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
