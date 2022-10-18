
# Pricing and Ratings
--------
## Solutions

### 1. If a Meat Lovers pizza pizza costs $12 and a Vegearian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```python
WITH cte_customer_order_pizza_names AS (
SELECT
  order_id AS order_id,
  customer_id AS customer_id,
  t1.pizza_id AS pizza_id,
  exclusions AS exclusions,
  extras AS extras,
  t2.pizza_name
FROM cleaned_customer_orders AS t1 
INNER JOIN pizza_runner.pizza_names AS t2 
ON t1.pizza_id = t2.pizza_id
),
cte_customer_orders_runner_orders AS (
SELECT
  t3.order_id AS order_id,
  customer_id,
  pizza_id,
  exclusions,
  extras,
  pizza_name,
  t4.distance AS distance

FROM cte_customer_order_pizza_names AS t3 
INNER JOIN pizza_runner.runner_orders AS t4
ON t3.order_id = t4.order_id
WHERE distance != 'null'
),
cte_pizza_prices AS (
SELECT
  CASE 
  WHEN pizza_name = 'Meatlovers' THEN 12
  ELSE 10
  END AS pizza_price
FROM cte_customer_orders_runner_orders
)
SELECT 
  SUM(pizza_price)
FROM cte_pizza_prices;
```
> Solution
> | sum |
> | --- |
> | 138 |
> -----