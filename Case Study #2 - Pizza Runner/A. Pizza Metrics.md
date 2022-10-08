# Head
## Head
### Head
*Testing*
* Testing<br>
__ This is a test __
---
<p align= "center">
    <h1>A.   Pizza Metrics</h1>
</p>

<p align="center">
  <img width="350" height="350" src="images/pizza_runner.png">
</p>
<h1><center>The text</center></h1>

---
### How many pizzas were ordered?


```python
SELECT 
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_schema = 'pizza_runner' AND table_name = 'customer_orders'
```
> ## Output

| table_name    | column_name   | data_type   |
| ------------- | ------------- | ------------- |
| customer_orders | order_id    | integer  |
| customer_orders | customer_id | inter  |
| customer_orders | pizza_id    | inter  |
| customer_orders | exclusions  | character varying  |
| customer_orders | extras      | character varying  |
| customer_orders | order_time  | timestamp without time  |



| Left columns  | Right columns  | Center Align|
| ------------- |-------------:  | :----------:|
| left foo      | right foo      | center foo  |
| left bar      | right bar      | center bar  |
| left baz      | right baz      | center baz  |