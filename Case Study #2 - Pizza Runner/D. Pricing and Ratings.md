
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