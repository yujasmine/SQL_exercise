-- This exercise focus on dealing with duplicated data

-- 1. Which id value has the most number of duplicate records in the health.user_logs table?Click here to show solution

WITH value_count AS (
  SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency
  FROM health.user_logs
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
)
SELECT
  id,
  SUM(frequency) AS repeated_value
FROM value_count
WHERE frequency > 1
GROUP BY id
ORDER BY repeated_value DESC


