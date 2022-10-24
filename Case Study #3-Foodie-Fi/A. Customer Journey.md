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

```
> Solution

|plan_name  |customer_count |percentage |
|---|---|-----|
|basic monthly|546| 20.60|
|pro monthly|539|20.34|

-----
### For the year end review, what is the breakdown of all plan_names and percentages up to 2020-12-31?
```python
SELECT
  plan_name,
  COUNT(customer_id) AS customers_count,
  ROUND(100 * COUNT(DISTINCT customer_id)::NUMERIC / SUM(COUNT(DISTINCT customer_id)) OVER(),
    2) AS percentage
FROM subscriptions_plans
WHERE start_date <= '2020-12-31'
GROUP BY 1
```
> Solution
> 
|plan_name  |customer_count |percentage |
|---|---|-----|
|basic monthly|538| 21.98|
|churn|236|9.64|
|pro annual|195|7.97|
|pro monthly|479|19.57|
|trial|1000|40.85|
----