## B. Runner and Customer Experience

### B.1 How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```SQL
SELECT TO_CHAR(registration_date, 'WW')::INT AS "Week", 
       COUNT(runner_id) AS "Number Of Runners"
FROM runners
GROUP BY 1
```

Result:

<pre>
 Week | Number Of Runners 
------+-------------------
    1 |                 2
    2 |                 1
    3 |                 1
</pre>

### B.2 What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```SQL
SELECT r.runner_id, 
       ROUND(
           AVG(EXTRACT(minutes FROM r.pickup_time - c.order_time)), 
           2
       ) AS "Average time(in minutes)"
FROM clean_runner_orders r
JOIN temp_cust_orders c
    ON r.order_id = c.order_id
GROUP BY r.runner_id
ORDER BY r.runner_id
```

Result:

<pre>
 runner_id | Average time(in minutes) 
-----------+--------------------------
         1 |                    15.33
         2 |                    23.40
         3 |                    10.00
</pre>

### B.3 Is there any relationship between the number of pizzas and how long the order takes to prepare?

```SQL
SELECT subq.num_pizzas,
       ROUND(AVG(subq.cooking_time), 2) AS avg_cooking_time_in_mins
FROM (
    SELECT COUNT(pizza_id) AS num_pizzas, 
           AVG(EXTRACT(minutes FROM r.pickup_time - c.order_time)) AS cooking_time
    FROM clean_runner_orders r
    JOIN temp_cust_orders c
        ON r.order_id = c.order_id AND r.cancellation IS NULL
    GROUP BY c.order_id
) AS subq
GROUP BY subq.num_pizzas
```

Result:

<pre>
 num_pizzas | avg_cooking_time_in_mins 
------------+--------------------------
          1 |                    12.00
          2 |                    18.00
          3 |                    29.00
</pre>

### B.4 What was the average distance travelled for each customer?

```SQL
SELECT c.customer_id,
       ROUND(AVG(distance), 2) AS avg_distance_in_km 
FROM clean_runner_orders r
JOIN temp_cust_orders c
    ON r.order_id = c.order_id AND r.cancellation IS NULL
GROUP BY c.customer_id
```

Result:

<pre>
 customer_id | avg_distance_in_km 
-------------+--------------------
         101 |              20.00
         102 |              16.73
         103 |              23.40
         104 |              10.00
         105 |              25.00
</pre>

### B.5 What was the difference between the longest and shortest delivery times for all orders?

```SQL
SELECT MAX(duration) - MIN(duration) AS "DifferenceBetweenLongestShortestDelivery(in Minutes)"
FROM clean_runner_orders
```

Result:

<pre>
 DifferenceBetweenLongestShortestDelivery(in Minutes) 
------------------------------------------------------
                                                   30
</pre>

### B.6 What was the average speed for each runner for each delivery and do you notice any trend for these values?

```SQL
SELECT subq2.order_id, subq2.runner_id, subq1.pizza_count, subq2.distance_km,
       subq2.duration_hr, subq2.speed_kmph
FROM (
    SELECT order_id, COUNT(pizza_id) AS pizza_count
    FROM temp_cust_orders
    GROUP BY order_id
) AS subq1
JOIN (
    SELECT order_id, runner_id, 
           distance AS distance_km, 
           ROUND(duration/60.0, 2) AS duration_hr,
           ROUND(distance * 60.0/duration, 2) AS speed_kmph
    FROM clean_runner_orders r
    WHERE cancellation is NULL
) AS subq2
    ON subq1.order_id = subq2.order_id
 ORDER BY subq2.order_id
```

Result:

<pre>
 order_id | runner_id | pizza_count | distance_km | duration_hr | speed_kmph 
----------+-----------+-------------+-------------+-------------+------------
        1 |         1 |           1 |          20 |        0.53 |      37.50
        2 |         1 |           1 |          20 |        0.45 |      44.44
        3 |         1 |           2 |        13.4 |        0.33 |      40.20
        4 |         2 |           3 |        23.4 |        0.67 |      35.10
        5 |         3 |           1 |          10 |        0.25 |      40.00
        7 |         2 |           1 |          25 |        0.42 |      60.00
        8 |         2 |           1 |        23.4 |        0.25 |      93.60
       10 |         1 |           2 |          10 |        0.17 |      60.00
</pre>

### B.7 What is the successful delivery percentage for each runner?

```SQL
SELECT runner_id, 
       COUNT(distance) AS successful_orders,
       COUNT(*) AS total_orders,
       ROUND(COUNT(distance) * 100.0/COUNT(*), 2) AS percent_successful_delivery
FROM clean_runner_orders
GROUP BY runner_id
```

Result:

<pre>
 runner_id | successful_orders | total_orders | percent_successful_delivery 
-----------+-------------------+--------------+-----------------------------
         3 |                 1 |            2 |                       50.00
         2 |                 3 |            4 |                       75.00
         1 |                 4 |            4 |                      100.00
</pre>