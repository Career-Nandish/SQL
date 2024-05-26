## B. Data Analysis Questions

### 1. How many customers has Foodie-Fi ever had?

```SQL
SELECT COUNT(DISTINCT customer_id)
FROM subscriptions
```

Result:

<pre>
 Total Customers 
-----------------
            1000
</pre>


### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```SQL
SELECT DATE_PART('month', start_date) AS month, 
       COUNT(*) AS "# of free trials distributed"
FROM subscriptions
WHERE plan_id = 0
GROUP BY month
ORDER BY month
```

Result:

<pre>
 month | # of free trials distributed 
-------+------------------------------
     1 |                           88
     2 |                           68
     3 |                           94
     4 |                           81
     5 |                           88
     6 |                           79
     7 |                           89
     8 |                           88
     9 |                           87
    10 |                           79
    11 |                           75
    12 |                           84	
</pre>

* There's no discernible trend. A thing to note is that, Febuary has the lowest number of free trials given it has only 28 days. 

### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.

```SQL
SELECT p.plan_name, 
       COUNT(*) AS "Events Count"
FROM subscriptions s
JOIN plans p
    ON p.plan_id = s.plan_id AND
        DATE_PART('year', s.start_date) > 2020
GROUP BY p.plan_name
ORDER BY "Events Count" DESC
```

Result:

<pre>
   plan_name   | Events Count 
---------------+--------------
 churn         |           71
 pro annual    |           63
 pro monthly   |           60
 basic monthly |            8
</pre>

* After 2020, Most of the events are customer leaving the platform. 

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```SQL
WITH total_cust_count AS (
  SELECT COUNT(DISTINCT customer_id)
  FROM subscriptions
)

SELECT COUNT(DISTINCT customer_id) AS churned_cust_count,
       ROUND((COUNT(DISTINCT customer_id) * 100.0)/(SELECT * FROM total_cust_count), 1) AS churned_cust_perc
FROM subscriptions
WHERE plan_id = 4                 -- plan_id = 4 represents customers being churned
```

Result:

<pre>
 churned_cust_count | churned_cust_perc 
--------------------+-------------------
                307 |              30.7
</pre>


### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```SQL
WITH total_cust_count AS (
  SELECT COUNT(DISTINCT customer_id)
  FROM subscriptions
),
immediate_churn AS (
  SELECT customer_id, plan_id, start_date,
         LEAD(plan_id) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_plan, 
         LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_start_date
  FROM subscriptions
)

SELECT (SELECT * FROM total_cust_count) AS total_cust_count, 
       COUNT(customer_id) AS immediate_churn_count, 
       ROUND(COUNT(customer_id) * 100.0/(SELECT * FROM total_cust_count), 
             0) || '%' AS immediate_churn_perc
FROM immediate_churn
WHERE next_plan = 4 AND plan_id = 0
```

Result:

<pre>
 total_cust_count | immediate_churn_count | immediate_churn_perc 
------------------+-----------------------+----------------------
             1000 |                    92 | 9%
</pre>


### 6. What is the number and percentage of customer plans after their initial free trial?

```SQL
WITH total_cust_count AS (
  SELECT COUNT(DISTINCT customer_id)
  FROM subscriptions
),
next_plans AS (
  SELECT LEAD(plan_id) OVER (PARTITION BY customer_id ORDER BY start_date) AS plan_id, 
         RANK() OVER (PARTITION BY customer_id ORDER BY start_date) AS rnk
  FROM subscriptions
)

SELECT p.plan_name,
       pc.plan_cnt,
       ROUND(pc.plan_cnt * 100.0/(SELECT * FROM total_cust_count), 2) || '%' AS plan_cnt_perc
FROM plans p
JOIN (
  SELECT plan_id, COUNT(*) AS plan_cnt
  FROM next_plans
  WHERE rnk = 1
  GROUP BY plan_id
) AS pc
  ON p.plan_id = pc.plan_id
```

Result:

<pre>
   plan_name   | plan_cnt | plan_cnt_perc 
---------------+----------+---------------
 basic monthly |      546 | 54.60%
 pro monthly   |      325 | 32.50%
 pro annual    |       37 | 3.70%
 churn         |       92 | 9.20%
</pre>


### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```SQL
WITH total_cust_count AS (
  SELECT COUNT(DISTINCT customer_id)
  FROM subscriptions
),
plan_count AS (
  SELECT plan_id,
         DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY start_date DESC) AS d_rnk
  FROM subscriptions
  WHERE start_date <= '2020-12-31'
)

SELECT p.plan_name, 
       pc.plan_cnt,
       ROUND(pc.plan_cnt * 100.0/(SELECT * FROM total_cust_count), 2) || '%' AS plan_perc 
FROM plans p
JOIN (
  SELECT plan_id, COUNT(*) AS plan_cnt
  FROM plan_count
  WHERE d_rnk = 1
  GROUP BY plan_id
) AS pc
  ON p.plan_id = pc.plan_id
```

Result:

<pre>
   plan_name   | plan_cnt | plan_perc 
---------------+----------+-----------
 trial         |       19 | 1.90%
 basic monthly |      224 | 22.40%
 pro monthly   |      326 | 32.60%
 pro annual    |      195 | 19.50%
 churn         |      236 | 23.60%	
</pre>


### 8. How many customers have upgraded to an annual plan in 2020?

```SQL
SELECT COUNT(*) AS cust_count
FROM subscriptions 
WHERE DATE_PART('year', start_date) = 2020 AND plan_id = 3
```

Result:

<pre>
 cust_count 
------------
        195
</pre>


### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```SQL
SELECT 
    ROUND(AVG(s2.start_date - s1.start_date)) AS avg_days_to_annual_plan
FROM
    (SELECT customer_id, start_date FROM subscriptions WHERE plan_id = 0) AS s1
JOIN 
    (SELECT customer_id, start_date FROM subscriptions WHERE plan_id = 3) AS s2
ON 
    s1.customer_id = s2.customer_id
```

Result:

<pre>
avg_days_to_annual_plan 
-------------------------
                     105
</pre>


### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

```SQL
WITH date_diff AS (
    SELECT 
        s2.start_date - s1.start_date AS dd,
        CEIL((s2.start_date - s1.start_date)/30.0) AS bucket
    FROM
        (SELECT customer_id, start_date FROM subscriptions WHERE plan_id = 0) AS s1
    JOIN 
        (SELECT customer_id, start_date FROM subscriptions WHERE plan_id = 3) AS s2
      ON
        s1.customer_id = s2.customer_id
)

SELECT 
    CASE
        WHEN bucket = 1
            THEN (bucket - 1) * 30 || ' - ' || bucket * 30 || ' days'
        ELSE
            (bucket - 1) * 30 + 1 || ' - ' || bucket * 30 || ' days'
    END AS periods, 
    COUNT(*) AS cust_count
FROM 
    date_diff
GROUP BY
    bucket, periods
ORDER BY
    bucket
```

Result:

<pre>
    periods     | cust_count 
----------------+------------
 0 - 30 days    |         49
 31 - 60 days   |         24
 61 - 90 days   |         34
 91 - 120 days  |         35
 121 - 150 days |         42
 151 - 180 days |         36
 181 - 210 days |         26
 211 - 240 days |          4
 241 - 270 days |          5
 271 - 300 days |          1
 301 - 330 days |          1
 331 - 360 days |          1	
</pre>


### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```SQL
```

Result:

<pre>
	
</pre>

