# A. Customer Journey

## Data Preparation
I joined the tables susbscriptions and plans because I used them extensively in this section.  I created a table for accessibility.

```python
DROP TABLE IF EXISTS subscriptions_plans;
CREATE TEMP TABLE subscriptions_plans AS 
SELECT
  t1.customer_id AS customer_id,
  t1.plan_id AS plan_id,
  t2.plan_name AS plan_name,
  t1.start_date AS start_date,
  t2.price AS price
FROM foodie_fi.subscriptions AS t1
INNER JOIN foodie_fi.plans AS t2
ON t1.plan_id = t2.plan_id
ORDER BY customer_id;

```
The below output is limited to 10 rows.
> Output

| customer_id |plan_id |plan_name |start_date |price |
| --- | --- | --- |--- |--- |
| 1 | 1 |basic monthly |2020-08-08 |9.90  |
|1| 0 | trial| 2020-08-01 |0.00  |  
| 2 | 3 |pro annual |2020-09-27|199.00 |
| 2 | 0 |trial |2020-09-20|0.00|
| 3 | 1 |basic monthly|2020-01-20|9.90|
| 3 | 0 |trial|2020-01-13|0.00|
| 4 | 0 |trial|2020-01-17|0.00|
| 4 | 4 |churn|2020-04-21|null|
| 4 | 1 |basic monthly|2020-01-24|9.90|
| 5 | 1 |basic monthly|2020-08-10|9.90|


## Case Study Questions and Solutions

### Write a brief description about the customers' onboarding journey.

### How many customers has Food-fi had?
```python
SELECT 
  COUNT(DISTINCT customer_id) AS customer_count
FROM subscriptions_plans
```
> Solution
> |customer_count   |
> |---|
> |1000   |
> ---
> ### How many plans does Food-fi offer and how many customers are enrolled in each?
 ```python
SELECT
  plan_name,
  COUNT(customer_id) AS number_cust_enrolled
FROM subscriptions_plans
GROUP BY 1
```
> Solution

| plan_name | number_cust_enrolled |
| --- | --- |
| pro annual | 258 |
|trial | 1000 |   
| churn | 307 |
| pro monthly | 539 |
| basic monthly | 546 |
----