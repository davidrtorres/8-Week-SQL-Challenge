# Health Analytics Case Study


For Questions 2-7 I created a temporary table
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
