# B. Runner and Customer Experience
### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)?
```python

SELECT
  DATE_PART('week', registration_date) AS registration_week,
  COUNT(*) AS runners_signed_up
FROM pizza_runner.runners
GROUP BY 1

```
> Output

| registration_week | runners_signed_up | 
| --------- | ------------- | 
| 53         | 2  | 
| 1        | 1   | 
| 2         | 1   | 

------
### 1. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up orders?
```python
WITH cte_avg_pickup_time AS (
SELECT
  DISTINCT r.runner_id AS runner_id,
  DATE_PART('minute', r.pickup_time::TIMESTAMP - c.order_time::TIMESTAMP)::INTEGER AS minute_of_day
FROM cleaned_runner_orders AS r 
INNER JOIN cleaned_customer_orders AS c 
ON r.order_id = c.order_id
WHERE pickup_time != 'null'
)
SELECT
  runner_id,
  ROUND(AVG(minute_of_day),2) AS avg_minutes
FROM cte_avg_pickup_time
GROUP BY 1
ORDER BY runner_id;

```
> Output
> 
| runner_id | avg_minutes | 
| --------- | ------------- | 
| 1         | 15.33 | 
| 2        | 19.67   | 
| 3         | 10.00   | 