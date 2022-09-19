# Health Analytics Case Study


For Questions 2-7 I created a temporary table.  The output concerns the columns id and measure.  The measure feature has 3 categories: blood_pressure, blood_glucose and weight.  The ouput shows the unique ids, the measure count for each id and the unique measure count for each id (how many measure categories did user use).
```
DROP TABLE IF EXISTS user_measure_count;

CREATE TEMP TABLE user_measure_count AS (
SELECT
  id,
  COUNT(*) AS measure_count,
  COUNT(DISTINCT measure) AS unique_measure_count
FROM health.user_logs 
GROUP BY id);
```
Output

<img src="images/health_data.png/" alt="Employee data">

------
#### Question 1: How many unique users exist in the logs dataset?
There are 554 unique users in the user_logs table.
```
SELECT
  COUNT(DISTINCT id)
FROM user_measure_count;  
```
#### Question 2: How many total measurements do we have per user on averge?
There are an average of 79.23 measurements per user
```
SELECT
  ROUND(AVG(measure_count),2) AS average_value
FROM user_measure_count
```
#### Question 3: What is the median number of the total measurements per user?
The median number is 2.
```
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_count) AS median_value
FROM user_measure_count;

```
