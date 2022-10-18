
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
> | total_sales |
> | --- |
> | 138 |
> -----