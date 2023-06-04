-- This exercise focus on dealing with duplicated data

-- 1. Which id value has the most number of duplicate records in the health.user_logs table?
-- ANS: 054250c692e07a9fa9e62e345231df4b54ff435d
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
LIMIT 10

-- 2. Which log_date value had the most duplicate records after removing the max duplicate id value from question 1?
-- ANS: 2019-12-11	
WITH dup_log AS(
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
 log_date,
 SUM(frequency) AS repeated_log
FROM dup_log
WHERE frequency > 1 AND id != '054250c692e07a9fa9e62e345231df4b54ff435d'
GROUP BY log_date
ORDER BY repeated_log DESC
LIMIT 10

-- 3. Which measure_value had the most occurences in the health.user_logs value when measure = 'weight'?
-- ANS: 68.49244787
SELECT 
  measure_value,
  COUNT(*) AS frequency
FROM health.user_logs
WHERE measure = 'weight'
GROUP BY measure_value
ORDER BY frequency DESC

-- 4. How many single duplicated rows exist when measure = 'blood_pressure' in the health.user_logs? How about the total number of duplicate records in the same table?
-- ANS: single_duplicated_rows 147 ; ttl__duplicate_records 301
WITH single_dup AS(
  SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency
  FROM health.user_logs
  WHERE measure = 'blood_pressure'
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
  ORDER BY frequency DESC
)
SELECT
  COUNT(*) AS single_duplicated_rows,
  SUM(frequency) AS ttl__duplicate_records
FROM single_dup
WHERE frequency >1 

-- 5. What percentage of records measure_value = 0 when measure = 'blood_pressure' in the health.user_logs table? How many records are there also for this same condition?
-- ANS: percentage 23.25 ; same condition records 562
WITH blood_presure_precentage AS (
SELECT
  measure_value,
  COUNT(*) AS frequency,
  SUM(COUNT(*)) OVER () AS ttl_blood_pressure
FROM health.user_logs
WHERE measure = 'blood_pressure'
GROUP BY measure_value
ORDER BY measure_value ASC
)
SELECT
  measure_value,
  frequency,
  ttl_blood_pressure,
  ROUND((frequency/ttl_blood_pressure) *100,2) AS zero_pressure_percentage
FROM blood_presure_precentage
WHERE measure_value = 0

-- 6. What percentage of records are duplicates in the health.user_logs table?
-- ANS: 29.36
WITH value_count AS (
  SELECT 
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS duplicated_rows,
    SUM(COUNT(*)) OVER() AS ttl_rows
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
  -- Need to subtract 1 from the duplicated_rows to count actual duplicates!
  ROUND(
    100 * SUM(CASE 
      WHEN duplicated_rows > 1 THEN duplicated_rows - 1 
      ELSE 0 END
    ) ::NUMERIC / ttl_rows,
    2
  ) AS duplicate_percentage
FROM value_count
GROUP BY ttl_rows




