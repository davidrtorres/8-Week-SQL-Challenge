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

### 1. How many customers has Foodie-Fi ever had?
```python
SELECT 
  COUNT(DISTINCT customer_id) AS total_customer_count
FROM subscriptions_plans
```
> Solution
> |total_customer_count   |
> |---|
> |1000   |
> ---

###  2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
 ```python
SELECT
  DATE_TRUNC('month', start_date)::DATE AS month,
  COUNT(customer_id) AS monthly_trial
FROM subscriptions_plans
WHERE plan_name = 'trial'
GROUP BY 1
```
> Solution

| month | monthly_trial |
| --- | --- |
| 2020-01-01 | 88 |
|2020-02-01 | 68|
| 2020-03-01 | 94 |
| 2020-04-01 | 81 |
| 2020-05-01 | 88 |
| 2020-06-01 | 79 |
| 2020-07-01 | 89 |
| 2020-08-01 | 88 |
| 2020-09-01 | 87 |
| 2020-10-01 | 79 |
| 2020-11-01 | 75 |
| 2020-12-01 | 84 |
----

### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name


```python
SELECT
  plan_name,
  COUNT(customer_id) AS count_after_2020
FROM subscriptions_plans
WHERE start_date > '2020-12-31'
GROUP BY 1
```

> Solution

|plan_name  |count_after_2020 |
|---|---|
|pro annual|63|
|churn|71|
|pro monthly|60|
|basic monthly|8|

-----
### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?


```python
SELECT
  SUM(
  CASE
  WHEN plan_id= 4 THEN 1
  ELSE 0
  END) AS churn_customers, 
  ROUND(
    100 * SUM(CASE WHEN plan_id= 4 THEN 1 ELSE 0 END)::NUMERIC / COUNT(DISTINCT customer_id),1)
    AS percentage
FROM subscriptions_plans
```
> Solution

|churn_customers  |percentage |
|---|---|
|307| 30.7|

-----
### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
```python
WITH cte_churn AS(
  SELECT
    customer_id,
    plan_id,
    ROW_NUMBER() OVER(
      PARTITION BY customer_id
      ORDER BY start_date
    ) AS rank
  FROM
    foodie_fi.subscriptions
)
SELECT
  SUM(
    CASE
      WHEN plan_id = 4
      AND rank = 2 THEN 1
      ELSE 0
    END
  ) AS frequency,
  ROUND(
    100 * SUM(
      CASE
        WHEN plan_id = 4
        AND rank = 2 THEN 1
        ELSE 0
      END
    ) / SUM(COUNT(DISTINCT customer_id)) OVER(),
    1
  ) AS percentage
FROM cte_churn
```
> Solution
> 
|frequency  |percentage |
|---|---|
|92|9.2| 
----
### 6. What is the number and percentage of customer plans after their initial free trial?

```python 
WITH ranked_plans AS (
  SELECT
    customer_id,
    plan_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY plan_id ASC --plan_id ASC replaced start_date DESC--
    ) AS plan_rank
  FROM foodie_fi.subscriptions
)
SELECT
  plans.plan_id,
  plans.plan_name,
  COUNT(*) AS customer_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER ()) AS percentage
FROM ranked_plans
INNER JOIN foodie_fi.plans
  ON ranked_plans.plan_id = plans.plan_id
WHERE plan_rank = 2 
GROUP BY plans.plan_id, plans.plan_name
ORDER BY plans.plan_id;
```
> Solution
> 
|plan_id  |plan_name |customer_count | percentage |
|---|---|---|---|
|1|basic monthly| 546|55|
|2|pro monthly| 325 | 33|
|3|pro annual|37 | 4 |
|4|churn|92 | 9|
------
### 8. How many customers have upgraded to an annual plan in 2020?

```python
SELECT
  plan_name,
  COUNT(DISTINCT customer_id) AS annual_customer_count
FROM subscriptions_plans
WHERE start_date BETWEEN '2020-01-01' AND '2020-12-31' AND 
PLAN_ID = 3
GROUP BY plan_name
```
> Solution
> 
|plan_name  |annual_customer_count |
|---|---|
|pro annual|195| 

------
### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
```python
WITH cte_trial_dates AS (
SELECT
  customer_id,
  plan_id,
  start_date AS trial_date
FROM foodie_fi.subscriptions
WHERE plan_id = 0
),
cte_annual_dates AS (
SELECT
  customer_id,
  start_date AS annual_date
FROM foodie_fi.subscriptions
WHERE plan_id = 3
)
SELECT 
  ROUND(AVG(DATE_PART('DAY', t2.annual_date::TIMESTAMP - t1.trial_date::TIMESTAMP)::INTEGER),0) AS avg_days
FROM cte_trial_dates AS t1 
INNER JOIN cte_annual_dates AS t2 
ON t1.customer_id = t2.customer_id
```
>Solution

|avg_days  |
|---|
|105|

------
### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
```python
WITH cte_trial_dates AS (
SELECT
  customer_id,
  plan_id,
  start_date AS trial_date
FROM foodie_fi.subscriptions
WHERE plan_id = 0
),
cte_annual_dates AS (
SELECT
  customer_id,
  start_date AS annual_date
FROM foodie_fi.subscriptions
WHERE plan_id = 3
),
cte_days_bin AS (
SELECT 
  WIDTH_bucket(t2.annual_date - t1.trial_date,0,360,12) AS days_bucket
FROM cte_trial_dates AS t1 
INNER JOIN cte_annual_dates AS t2 
ON t1.customer_id = t2.customer_id
)
SELECT
  ((days_bucket - 1)*30 || '-' || (days_bucket)*30) AS "30-day-range", 
  COUNT(*) AS Count 
FROM cte_days_bin
GROUP BY days_bucket
ORDER BY days_bucket
```
> Solution
 
|30-day-range | count|
|---|---|
|0-30|48 |
|30-60|25 | 
|60-90|33 | 
|90-120|35 |
|120-150|43 |
|150-180|35 |  
|180-210|27 |   
|210-240|4 |  
|240-270|5 |    
|270-300|1 |  
|300-330|1|
|330-360|1|