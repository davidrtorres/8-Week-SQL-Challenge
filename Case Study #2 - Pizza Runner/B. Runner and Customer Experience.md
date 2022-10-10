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

| runner_id | runners_signed_up | 
| --------- | ------------- | 
| 53         | 2  | 
| 1        | 1   | 
| 2         | 1   | 