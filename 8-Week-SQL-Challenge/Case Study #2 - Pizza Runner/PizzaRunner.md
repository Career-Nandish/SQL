Before we move onto solving the case study questions, we must clean the data provided by Danny. 


## 1. Data Cleaning

Tables - `runners`, `pizza_names`, and `pizza_toppings` have no issues with data. 

### 1.1 `customer_order`

Let's observe the data first, since `customer_order` has a few rows we can explore the data by simply selecting the entire table. 

```SQL
SELECT *
FROM customer_orders
```

Result :

<pre>
 order_id | customer_id | pizza_id | exclusions | extras |     order_time      
----------+-------------+----------+------------+--------+---------------------
        1 |         101 |        1 |            |        | 2020-01-01 18:05:02
        2 |         101 |        1 |            |        | 2020-01-01 19:00:52
        3 |         102 |        1 |            |        | 2020-01-02 23:51:23
        3 |         102 |        2 |            |        | 2020-01-02 23:51:23
        4 |         103 |        1 | 4          |        | 2020-01-04 13:23:46
        4 |         103 |        1 | 4          |        | 2020-01-04 13:23:46
        4 |         103 |        2 | 4          |        | 2020-01-04 13:23:46
        5 |         104 |        1 | null       | 1      | 2020-01-08 21:00:29
        6 |         101 |        2 | null       | null   | 2020-01-08 21:03:13
        7 |         105 |        2 | null       | 1      | 2020-01-08 21:20:29
        8 |         102 |        1 | null       | null   | 2020-01-09 23:54:33
        9 |         103 |        1 | 4          | 1, 5   | 2020-01-10 11:22:59
       10 |         104 |        1 | null       | null   | 2020-01-11 18:34:49
       10 |         104 |        1 | 2, 6       | 1, 4   | 2020-01-11 18:34:49
</pre>


We can see that there are two major issue with the data

1. There are some missing values and some incorrect values(`NULL` is represented by `'null'`)
2. The columns `exclusions` and `extras` has values separated by commas, which are valid values but it might be difficult to deal with them later using SQL, so we will create new rows for them.

```SQL
-- Handling data Issue no 1
WITH temp_cust_orders AS (
    SELECT order_id,
           customer_id,
           pizza_id,
           CASE
               WHEN exclusions = '' OR exclusions = 'null' THEN NULL
               ELSE exclusions
           END AS exclusions,
           CASE
               WHEN extras = '' OR extras = 'null' THEN NULL
               ELSE extras
           END AS extras,
           order_time
    FROM customer_orders
)

SELECT * FROM temp_cust_orders
```

Result:

<pre>
 order_id | customer_id | pizza_id | exclusions | extras |     order_time      
----------+-------------+----------+------------+--------+---------------------
        1 |         101 |        1 |            |        | 2020-01-01 18:05:02
        2 |         101 |        1 |            |        | 2020-01-01 19:00:52
        3 |         102 |        1 |            |        | 2020-01-02 23:51:23
        3 |         102 |        2 |            |        | 2020-01-02 23:51:23
        4 |         103 |        1 | 4          |        | 2020-01-04 13:23:46
        4 |         103 |        1 | 4          |        | 2020-01-04 13:23:46
        4 |         103 |        2 | 4          |        | 2020-01-04 13:23:46
        5 |         104 |        1 |            | 1      | 2020-01-08 21:00:29
        6 |         101 |        2 |            |        | 2020-01-08 21:03:13
        7 |         105 |        2 |            | 1      | 2020-01-08 21:20:29
        8 |         102 |        1 |            |        | 2020-01-09 23:54:33
        9 |         103 |        1 | 4          | 1, 5   | 2020-01-10 11:22:59
       10 |         104 |        1 |            |        | 2020-01-11 18:34:49
       10 |         104 |        1 | 2, 6       | 1, 4   | 2020-01-11 18:34:49
</pre>

Now let's handle issue no 2. I have tried to tackle this issue using two different ways. 

1. At first, I had a simple but lengthy way to achieve the unnesting the comma-separated values. By using Subquery and unnesting `extras` and `exclusions` one at a time.

```SQL
-- Handling Data Issue No 2, Part I
SELECT order_id, customer_id, pizza_id, exclusions, extras, order_time, new_exc,
       unnest (
            CASE WHEN array_length(STRING_TO_ARRAY(extras, ', '), 1) >= 1
                 THEN STRING_TO_ARRAY(extras, ', ')
                 ELSE '{null}'::text[] END
         )::INT AS new_ext

FROM (
  SELECT order_id, customer_id, pizza_id, exclusions, extras, order_time,
         unnest (
            CASE WHEN array_length(STRING_TO_ARRAY(exclusions, ', '), 1) >= 1
                 THEN STRING_TO_ARRAY(exclusions, ', ')
                 ELSE '{null}'::text[] END
         )::INT AS new_exc
  FROM (
    SELECT order_id,
           customer_id,
           pizza_id,
           CASE
               WHEN exclusions IS NULL OR exclusions = '' OR exclusions = 'null' THEN NULL
               ELSE exclusions
           END AS exclusions,
           CASE
               WHEN extras IS NULL OR extras = '' OR extras = 'null' THEN NULL
               ELSE extras
           END AS extras,
           order_time
    FROM customer_orders
  ) AS subq1
) AS subq2
```

2. Then, I realised there must be a better(better as in more clean and concise) way to do it. I was going through a lot of web resources and I have seen a lot of ways to achieve it using procedural language and using JSON arrays. After a lot of searching, I have realised that I could use `CROSS JOIN` and already implemented function `UNNEST()`. By using them both together, a simple `CROSS JOIN` would turn into `LATERAL JOIN`. 

```SQL
-- Handling Data Issue No 2, Part II
   --  Note: temp_cust_orders is a CTE from Part 1 above.
WITH clean_cust_orders AS (
    SELECT order_id, customer_id, pizza_id, order_time, u1.extras::INT, u2.exclusions::INT
    FROM temp_cust_orders, 
         unnest (
                CASE WHEN array_length(STRING_TO_ARRAY(extras, ', '), 1) >= 1
                     THEN STRING_TO_ARRAY(extras, ', ')
                     ELSE '{null}'::text[] 
                END) AS u1 (extras),
         unnest (
                CASE WHEN array_length(STRING_TO_ARRAY(exclusions, ', '), 1) >= 1
                     THEN STRING_TO_ARRAY(exclusions, ', ')
                     ELSE '{null}'::text[]
                END) AS u2 (exclusions)
)

SELECT * FROM clean_cust_orders
```

Result:

<pre>
 order_id | customer_id | pizza_id |     order_time      | extras | exclusions 
----------+-------------+----------+---------------------+--------+------------
        1 |         101 |        1 | 2020-01-01 18:05:02 |        |           
        2 |         101 |        1 | 2020-01-01 19:00:52 |        |           
        3 |         102 |        1 | 2020-01-02 23:51:23 |        |           
        3 |         102 |        2 | 2020-01-02 23:51:23 |        |           
        4 |         103 |        1 | 2020-01-04 13:23:46 |        |          4
        4 |         103 |        1 | 2020-01-04 13:23:46 |        |          4
        4 |         103 |        2 | 2020-01-04 13:23:46 |        |          4
        5 |         104 |        1 | 2020-01-08 21:00:29 |      1 |           
        6 |         101 |        2 | 2020-01-08 21:03:13 |        |           
        7 |         105 |        2 | 2020-01-08 21:20:29 |      1 |           
        8 |         102 |        1 | 2020-01-09 23:54:33 |        |           
        9 |         103 |        1 | 2020-01-10 11:22:59 |      1 |          4
        9 |         103 |        1 | 2020-01-10 11:22:59 |      5 |          4
       10 |         104 |        1 | 2020-01-11 18:34:49 |        |           
       10 |         104 |        1 | 2020-01-11 18:34:49 |      1 |          2
       10 |         104 |        1 | 2020-01-11 18:34:49 |      1 |          6
       10 |         104 |        1 | 2020-01-11 18:34:49 |      4 |          2
       10 |         104 |        1 | 2020-01-11 18:34:49 |      4 |          6
</pre>

### 1.2 `runner_orders`

Let's first observe the data.

```SQL
SELECT * FROM runner_orders
```

Result:

<pre>
 order_id | runner_id |     pickup_time     | distance |  duration  |      cancellation       
----------+-----------+---------------------+----------+------------+-------------------------
        1 |         1 | 2020-01-01 18:15:34 | 20km     | 32 minutes | 
        2 |         1 | 2020-01-01 19:10:54 | 20km     | 27 minutes | 
        3 |         1 | 2020-01-03 00:12:37 | 13.4km   | 20 mins    | 
        4 |         2 | 2020-01-04 13:53:03 | 23.4     | 40         | 
        5 |         3 | 2020-01-08 21:10:57 | 10       | 15         | 
        6 |         3 | null                | null     | null       | Restaurant Cancellation
        7 |         2 | 2020-01-08 21:30:45 | 25km     | 25mins     | null
        8 |         2 | 2020-01-10 00:15:02 | 23.4 km  | 15 minute  | null
        9 |         2 | null                | null     | null       | Customer Cancellation
       10 |         1 | 2020-01-11 18:50:20 | 10km     | 10minutes  | null
</pre>


The above data has following data cleaning issues:

  1. `pickup_time` -  'null' values.
  2. `distance` - 'null' values and values have unit of kilometer 'km' attached.
  3. `duration` - 'null' values and values have unit of time 'minutes', 'mins' 'minute' attached.
  4. `cancellation` - `' '` and 'null' values.

```SQL
clean_runner_orders AS (
    SELECT order_id, 
           runner_id,
           CASE
               WHEN pickup_time = 'null' THEN NULL
               ELSE pickup_time
           END AS pickup_time,
           CASE
               WHEN distance = 'null' THEN NULL
               ELSE REGEXP_REPLACE(distance, '[a-z]+', '')::NUMERIC
           END AS distance,
           CASE
               WHEN duration = 'null' THEN NULL
               ELSE REGEXP_REPLACE(duration, '[a-z]+', '')::INT
           END AS duration,
           CASE
               WHEN cancellation = 'null' OR cancellation = '' THEN NULL
               ELSE cancellation
           END AS cancellation
    FROM runner_orders
)

SELECT * FROM clean_runner_orders
```

Result:

<pre>
 order_id | runner_id |     pickup_time     | distance | duration |      cancellation       
----------+-----------+---------------------+----------+----------+-------------------------
        1 |         1 | 2020-01-01 18:15:34 |       20 |       32 | 
        2 |         1 | 2020-01-01 19:10:54 |       20 |       27 | 
        3 |         1 | 2020-01-03 00:12:37 |     13.4 |       20 | 
        4 |         2 | 2020-01-04 13:53:03 |     23.4 |       40 | 
        5 |         3 | 2020-01-08 21:10:57 |       10 |       15 | 
        6 |         3 |                     |          |          | Restaurant Cancellation
        7 |         2 | 2020-01-08 21:30:45 |       25 |       25 | 
        8 |         2 | 2020-01-10 00:15:02 |     23.4 |       15 | 
        9 |         2 |                     |          |          | Customer Cancellation
       10 |         1 | 2020-01-11 18:50:20 |       10 |       10 | 
</pre>


From the result, we can see that the data issues are fixed. 