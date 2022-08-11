-- Danny's Diner Case Study Questions

-- What is the total amount each customer spent at the restaurant?
-- Customer A spent 76.00, Customer B spent 74.00 Customer c spent 36.00.
SELECT * FROM dannys_diner.sales;
SELECT * FROM dannys_diner.menu;

SELECT *
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu
ON sales.product_id = menu.product_id;

SELECT 
	customer_id,
    SUM(price) total_spent
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
GROUP BY customer_id;