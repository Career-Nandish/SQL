## C. Challenge Payment Question

### The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

### &nbsp;&nbsp;&nbsp;&#9679; monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
### &nbsp;&nbsp;&nbsp;&#9679; upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
### &nbsp;&nbsp;&nbsp;&#9679; upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
### &nbsp;&nbsp;&nbsp;&#9679; once a customer churns they will no longer make payments

Example outputs for this table might look like the following:


| customer_id | plan_id | plan_name     | payment_date | amount | payment_order  |
|-------------|---------|---------------|--------------|--------|----------------|
| 1           | 1       | basic monthly | 2020-08-08   | 9.90   | 1              |
| 1           | 1       | basic monthly | 2020-09-08   | 9.90   | 2              |
| 1           | 1       | basic monthly | 2020-10-08   | 9.90   | 3              |
| 1           | 1       | basic monthly | 2020-11-08   | 9.90   | 4              |
| 1           | 1       | basic monthly | 2020-12-08   | 9.90   | 5              |
| 2           | 3       | pro annual    | 2020-09-27   | 199.00 | 1              |
| 13          | 1       | basic monthly | 2020-12-22   | 9.90   | 1              |
| 15          | 2       | pro monthly   | 2020-03-24   | 19.90  | 1              |
| 15          | 2       | pro monthly   | 2020-04-24   | 19.90  | 2              |
| 16          | 1       | basic monthly | 2020-06-07   | 9.90   | 1              |
| 16          | 1       | basic monthly | 2020-07-07   | 9.90   | 2              |
| 16          | 1       | basic monthly | 2020-08-07   | 9.90   | 3              |
| 16          | 1       | basic monthly | 2020-09-07   | 9.90   | 4              |
| 16          | 1       | basic monthly | 2020-10-07   | 9.90   | 5              |
| 16          | 3       | pro annual    | 2020-10-21   | 189.10 | 6              |
| 18          | 2       | pro monthly   | 2020-07-13   | 19.90  | 1              |
| 18          | 2       | pro monthly   | 2020-08-13   | 19.90  | 2              |
| 18          | 2       | pro monthly   | 2020-09-13   | 19.90  | 3              |
| 18          | 2       | pro monthly   | 2020-10-13   | 19.90  | 4              |
	


At first, we will start with coming up with a recursive CTE to increment rows for all monthly paid plans in 2020 until customers changing their plans, except 'pro annual'

```SQL
WITH RECURSIVE cte AS (
  SELECT 
      s.customer_id,
      s.plan_id, 
      p.plan_name, 
      s.start_date, 
      CASE
          -- If next_date is NULL set it to last day of 2020
          WHEN LEAD(s.start_date) OVER win_next_date IS NULL THEN '2020-12-31'
          ELSE LEAD(s.start_date) OVER win_next_date
      END AS last_date,
      p.price
      
  FROM 
      plans p
  JOIN 
      subscriptions s
  ON 
      p.plan_id = s.plan_id AND 
      -- plan_id = 0 shows trial plans
      p.plan_id != 0 AND
      -- Desired year is 2020
      DATE_PART('year', s.start_date) = 2020
  
  -- defining window  
  WINDOW 
      win_next_date AS (PARTITION BY s.customer_id ORDER BY s.start_date)
  
  UNION ALL
  
  SELECT 
      customer_id, 
      plan_id,
      plan_name,
      -- 1 month increaments because payment are done monthly for all plans except plan_id = 3 pro annual
      -- Converting timestamp to date
      (start_date + INTERVAL '1 month')::DATE,
      last_date,
      price
  FROM 
      cte
  WHERE 
      start_date + INTERVAL '1 month' < last_date AND
      -- plan_id = 3 is pro annual, plan_id = 4 is churn
      plan_id NOT IN (3, 4)
)
```


Next thing we will do is adjusting the payments based on the requirements above. The requirements are:

* upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
* upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period `I have trouble understanding this requirement.`

```SQL
WITH payments_table AS (
  SELECT 
      customer_id,
      plan_id,
      plan_name,
      start_date,
      CASE
          -- upgrades from basic to monthly or pro plans are reduced by the current paid amount
          -- in that month and start immediately
          WHEN ((plan_id = 3) OR (plan_id = 2)) AND 
               LAG(plan_id) OVER win_price = 1 AND 
               AGE(start_date, LAG(start_date) OVER win_price) < INTERVAL '1 month'
          THEN price - LAG(price) OVER win_price
          
          -- If conditions don't match 
          ELSE price
      END AS price,
      -- No of payment
      ROW_NUMBER() OVER win_price AS payment_order
  FROM 
      cte
  -- Churns are not payments
  WHERE plan_id != 4
  WINDOW 
      win_price AS (PARTITION BY customer_id ORDER BY start_date)
)
```


The end result looks something like this,

```SQL
SELECT *
FROM payments_table
ORDER BY customer_id, start_date
```

Result:

<pre>
 customer_id | plan_id |   plan_name   | start_date | price  | payment_order 
-------------+---------+---------------+------------+--------+---------------
           1 |       1 | basic monthly | 2020-08-08 |   9.90 |             1
           1 |       1 | basic monthly | 2020-09-08 |   9.90 |             2
           1 |       1 | basic monthly | 2020-10-08 |   9.90 |             3
           1 |       1 | basic monthly | 2020-11-08 |   9.90 |             4
           1 |       1 | basic monthly | 2020-12-08 |   9.90 |             5
           2 |       3 | pro annual    | 2020-09-27 | 199.00 |             1
           3 |       1 | basic monthly | 2020-01-20 |   9.90 |             1
           3 |       1 | basic monthly | 2020-02-20 |   9.90 |             2
           3 |       1 | basic monthly | 2020-03-20 |   9.90 |             3
           3 |       1 | basic monthly | 2020-04-20 |   9.90 |             4
           3 |       1 | basic monthly | 2020-05-20 |   9.90 |             5
           3 |       1 | basic monthly | 2020-06-20 |   9.90 |             6
           3 |       1 | basic monthly | 2020-07-20 |   9.90 |             7
           3 |       1 | basic monthly | 2020-08-20 |   9.90 |             8
           3 |       1 | basic monthly | 2020-09-20 |   9.90 |             9
           3 |       1 | basic monthly | 2020-10-20 |   9.90 |            10
           3 |       1 | basic monthly | 2020-11-20 |   9.90 |            11
           3 |       1 | basic monthly | 2020-12-20 |   9.90 |            12
           4 |       1 | basic monthly | 2020-01-24 |   9.90 |             1
           4 |       1 | basic monthly | 2020-02-24 |   9.90 |             2
           4 |       1 | basic monthly | 2020-03-24 |   9.90 |             3
           5 |       1 | basic monthly | 2020-08-10 |   9.90 |             1
           5 |       1 | basic monthly | 2020-09-10 |   9.90 |             2
           5 |       1 | basic monthly | 2020-10-10 |   9.90 |             3
           5 |       1 | basic monthly | 2020-11-10 |   9.90 |             4
           5 |       1 | basic monthly | 2020-12-10 |   9.90 |             5
           6 |       1 | basic monthly | 2020-12-30 |   9.90 |             1
           7 |       1 | basic monthly | 2020-02-12 |   9.90 |             1
           7 |       1 | basic monthly | 2020-03-12 |   9.90 |             2
           7 |       1 | basic monthly | 2020-04-12 |   9.90 |             3
           7 |       1 | basic monthly | 2020-05-12 |   9.90 |             4
           7 |       2 | pro monthly   | 2020-05-22 |  10.00 |             5
           7 |       2 | pro monthly   | 2020-06-22 |  19.90 |             6
           7 |       2 | pro monthly   | 2020-07-22 |  19.90 |             7
           7 |       2 | pro monthly   | 2020-08-22 |  19.90 |             8
           7 |       2 | pro monthly   | 2020-09-22 |  19.90 |             9
           7 |       2 | pro monthly   | 2020-10-22 |  19.90 |            10
           7 |       2 | pro monthly   | 2020-11-22 |  19.90 |            11
           7 |       2 | pro monthly   | 2020-12-22 |  19.90 |            12
           8 |       1 | basic monthly | 2020-06-18 |   9.90 |             1
           8 |       1 | basic monthly | 2020-07-18 |   9.90 |             2
           8 |       2 | pro monthly   | 2020-08-03 |  10.00 |             3
           8 |       2 | pro monthly   | 2020-09-03 |  19.90 |             4
           8 |       2 | pro monthly   | 2020-10-03 |  19.90 |             5
           8 |       2 | pro monthly   | 2020-11-03 |  19.90 |             6
           8 |       2 | pro monthly   | 2020-12-03 |  19.90 |             7
           9 |       3 | pro annual    | 2020-12-14 | 199.00 |             1
          10 |       2 | pro monthly   | 2020-09-26 |  19.90 |             1
          10 |       2 | pro monthly   | 2020-10-26 |  19.90 |             2
          10 |       2 | pro monthly   | 2020-11-26 |  19.90 |             3
          10 |       2 | pro monthly   | 2020-12-26 |  19.90 |             4
          12 |       1 | basic monthly | 2020-09-29 |   9.90 |             1
          12 |       1 | basic monthly | 2020-10-29 |   9.90 |             2
          12 |       1 | basic monthly | 2020-11-29 |   9.90 |             3
          12 |       1 | basic monthly | 2020-12-29 |   9.90 |             4
          13 |       1 | basic monthly | 2020-12-22 |   9.90 |             1
          14 |       1 | basic monthly | 2020-09-29 |   9.90 |             1
          14 |       1 | basic monthly | 2020-10-29 |   9.90 |             2
          14 |       1 | basic monthly | 2020-11-29 |   9.90 |             3
          14 |       1 | basic monthly | 2020-12-29 |   9.90 |             4
          15 |       2 | pro monthly   | 2020-03-24 |  19.90 |             1
          15 |       2 | pro monthly   | 2020-04-24 |  19.90 |             2
          16 |       1 | basic monthly | 2020-06-07 |   9.90 |             1
          16 |       1 | basic monthly | 2020-07-07 |   9.90 |             2
          16 |       1 | basic monthly | 2020-08-07 |   9.90 |             3
          16 |       1 | basic monthly | 2020-09-07 |   9.90 |             4
          16 |       1 | basic monthly | 2020-10-07 |   9.90 |             5
          16 |       3 | pro annual    | 2020-10-21 | 189.10 |             6
          17 |       1 | basic monthly | 2020-08-03 |   9.90 |             1
          17 |       1 | basic monthly | 2020-09-03 |   9.90 |             2
          17 |       1 | basic monthly | 2020-10-03 |   9.90 |             3
          17 |       1 | basic monthly | 2020-11-03 |   9.90 |             4
          17 |       1 | basic monthly | 2020-12-03 |   9.90 |             5
          17 |       3 | pro annual    | 2020-12-11 | 189.10 |             6
          18 |       2 | pro monthly   | 2020-07-13 |  19.90 |             1
          18 |       2 | pro monthly   | 2020-08-13 |  19.90 |             2
          18 |       2 | pro monthly   | 2020-09-13 |  19.90 |             3
          18 |       2 | pro monthly   | 2020-10-13 |  19.90 |             4
          18 |       2 | pro monthly   | 2020-11-13 |  19.90 |             5
          18 |       2 | pro monthly   | 2020-12-13 |  19.90 |             6
          19 |       2 | pro monthly   | 2020-06-29 |  19.90 |             1
          19 |       2 | pro monthly   | 2020-07-29 |  19.90 |             2
          19 |       3 | pro annual    | 2020-08-29 | 199.00 |             3
          20 |       1 | basic monthly | 2020-04-15 |   9.90 |             1
          20 |       1 | basic monthly | 2020-05-15 |   9.90 |             2
          20 |       3 | pro annual    | 2020-06-05 | 189.10 |             3
</pre>