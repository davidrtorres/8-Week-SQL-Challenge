# Solutions


I created a temporary table to join the sales and menu tables.
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

```python
SELECT
  customer_id,
  SUM(price)
FROM dannys_diner_complete
GROUP BY customer_id
ORDER BY customer_id;
```
> Output
> 
|customer_id |sum|
|--|---|
|A | 76|
|B | 74|
|C | 36|


### 2. How many days has each customer visited the restaurant?
```python
SELECT
  customer_id,
  COUNT(DISTINCT order_date) 
FROM dannys_diner_complete
GROUP BY customer_id
ORDER BY customer_id;
```
> Output

|customer_id |count|
|--|---|
|A | 4|
|B | 6|
|C | 2|


### 3. What was the first item from the menu purchased by each customer?
```python
WITH cte_first_purchase AS (
SELECT
  customer_id, 
  product_name,  
  order_date,
  ROW_NUMBER() OVER(
    PARTITION BY customer_id ORDER BY order_date) category_ranking
FROM dannys_diner_complete
)
SELECT
  customer_id,
  product_name,
  ROW_NUMBER() OVER(
    PARTITION BY customer_id ORDER BY order_date) category_ranking
FROM cte_first_purchase  
WHERE category_ranking =1
```
> Output

|customer_id |product_name|category_ranking|
|--|---|---|
|A | curry| 1|
|B | curry| 1|
|C | ramen| 1|


### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```python
SELECT
  product_name,
  COUNT(*) AS item_purchased_count
FROM dannys_diner_complete
GROUP BY product_name
ORDER BY item_purchased_count DESC;
```
> Output

|product_name |item_purchased_count|
|--|---|
|ramen | 8|
|curry | 4|
|sushi |  3|

### 5. Which item was the most popular for each customer?
```python
WITH cte_popular_item AS (
SELECT
  customer_id,
  product_name,
  COUNT(*) AS times_purchased,
  ROW_NUMBER() OVER(
    PARTITION BY customer_id ORDER BY COUNT(product_name) DESC) category_ranking
FROM dannys_diner_complete
GROUP BY customer_id, product_name
)
SELECT
  customer_id,
  product_name,
  times_purchased
FROM cte_popular_item
WHERE category_ranking = 1
```
> Output

|customer_id |product_name|times_purchased|
|--|---|---|
|A| ramen|3|
|B | sushi|2|
|C |  ramen| 3|

### 6. Which item was purchased first by the customer after they became a member?
```
DROP TABLE IF EXISTS membership_purchase;
CREATE TEMP TABLE membership_purchase AS (
SELECT
  s.customer_id AS customer_id,
  s.order_date AS order_date,
  m.product_name AS product_name,
  me.join_date AS join_date,
  CASE
  WHEN s.order_date >= join_date 
    THEN 'X'
  ELSE ''  
  END AS membership
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m
ON s.product_id = m.product_id
JOIN dannys_diner.members AS me
ON s.customer_id = me.customer_id
ORDER BY s.customer_id
);
WITH cte_purchase_membership AS (
SELECT
  customer_id,
  product_name,
  order_date,
  RANK() OVER(
    PARTITION BY customer_id ORDER BY order_date) AS purchase_after_join
FROM  membership_purchase
WHERE membership = 'X'
)
SELECT
*
FROM cte_purchase_membership
WHERE purchase_after_join =1;

```
> Output

|customer_id |product_name|order_date|purchase_after_join |
|--|---|---|---|
|A| curry|2021-01-07| 1|
|B | sushi|2021-01-11 | 1|


### 7. Which item was purchased just before the customer became a member?
```
DROP TABLE IF EXISTS purchase_before_member;
CREATE TEMP TABLE purchase_before_member AS (
SELECT
  s.customer_id AS customer_id,
  s.order_date AS order_date,
  m.product_name AS product_name,
  me.join_date AS join_date,
  CASE
  WHEN s.order_date < join_date 
    THEN 'X'
  ELSE ''  
  END AS membership
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m
ON s.product_id = m.product_id
JOIN dannys_diner.members AS me
ON s.customer_id = me.customer_id
ORDER BY s.customer_id
);
SELECT * FROM purchase_before_member

WITH cte_purchase_before_member AS (
SELECT
  customer_id,
  product_name,
  order_date,
  RANK() OVER(
    PARTITION BY customer_id ORDER BY order_date DESC) AS purchase
FROM purchase_before_member
WHERE membership = 'X'
)
SELECT
  customer_id,
  product_name,
  order_date
FROM cte_purchase_before_member
WHERE purchase = 1;
```
Output
<p align="left">
  <img width="400" height="100" src="images/seven.png">
</p>

### 8. What is the total items and amount spent for each member before they became a member?
```
DROP TABLE IF EXISTS purchase_member;
CREATE TEMP TABLE purchase_member AS (
SELECT
  s.customer_id AS customer_id,
  s.order_date AS order_date,
  m.product_name AS product_name,
  me.join_date AS join_date,
  m.price AS price,
  CASE
  WHEN s.order_date >= join_date 
    THEN 'X'
  ELSE ''  
  END AS membership
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m
ON s.product_id = m.product_id
JOIN dannys_diner.members AS me
ON s.customer_id = me.customer_id
ORDER BY s.customer_id
);

WITH cte_purchase_member AS (
SELECT
  customer_id,
  price
FROM purchase_member
WHERE membership= ''
)
SELECT
  customer_id,
  SUM(price) AS total_spent,
  COUNT(*) AS total_items
FROM cte_purchase_member
GROUP BY customer_id;

```
Output
<p align="left">
  <img width="350" height="100" src="images/eight.png">
</p>

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```
DROP TABLE IF EXISTS customer_points;
CREATE TEMP TABLE customer_points AS (
SELECT
  s.customer_id AS customer_id,
  s.order_date AS order_date,
  m.product_name AS product_name,
  me.join_date AS join_date,
  m.price AS price,
  CASE
  WHEN product_name= 'sushi' 
    THEN price * 20
  ELSE price * 10  
  END AS points
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m
ON s.product_id = m.product_id
JOIN dannys_diner.members AS me
ON s.customer_id = me.customer_id
ORDER BY s.customer_id
);
WITH cte_customer_points_total AS (
SELECT
  customer_id,
  SUM(points) AS total_points
FROM customer_points
GROUP BY customer_id
)
SELECT
  *
FROM cte_customer_points_total
ORDER BY customer_id;
```
Output
<p align="left">
  <img width="350" height="100" src="images/nine.png">
</p>

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```


```
