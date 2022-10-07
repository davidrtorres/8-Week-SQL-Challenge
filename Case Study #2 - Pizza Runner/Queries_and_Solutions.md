# Head
## Head
### Head
*Testing*
* Testing<br>
__ This is a test __
---
<p align= "center">
    <h2>A piece of centered text</h2>
</p>

<p align="center">
  <img width="250" height="250" src="images/pizza_runner.png">
</p>
<h1><center>The text</center></h1>


```python
SELECT 
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_schema = 'pizza_runner' AND table_name = 'customer_orders'
```
### Output

| table_name    | column_name   | data_type   |
| ------------- | ------------- | ------------- |
| customer_orders | order_id  | integer  |
| customer_orders | customer_id  | inter  |
| customer_orders | pizza_id  | inter  |
| customer_orders | exclusions  | character varying  |
| customer_orders | extras  | character varying  |
| customer_orders | order_time  | timestamp without time  |



