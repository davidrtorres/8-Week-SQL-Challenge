# Solutions

```
DROP TABLE IF EXISTS dannys_diner_complete;
CREATE TEMP TABLE dannys_diner_complete AS
SELECT
  s.customer_id AS customer_id,
  s.order_date AS order_date,
  m.product_name AS product_name,
  m.price AS price
FROM dannys_diner.sales AS s
INNER JOIN dannys_diner.menu AS m
ON s.product_id = m.product_id;

SELECT * FROM dannys_diner_complete;
```
Output
<p align="center">
  <img width="350" height="350" src="images/dannys_diner.png">
</p>

### 1. What is the total amount each customer spent at the restaurant?

```
SELECT
  customer_id,
  SUM(price)
FROM dannys_diner_complete
GROUP BY customer_id
ORDER BY customer_id;
```
Output
<p align="center">
  <img width="350" height="350" src="images/one.png">
</p>
