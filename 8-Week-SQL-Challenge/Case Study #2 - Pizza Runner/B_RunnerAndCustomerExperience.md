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
```

Result:

<pre>

</pre>

### B.4 What was the average distance travelled for each customer?

```SQL
```

Result:

<pre>

</pre>

### B.5 What was the difference between the longest and shortest delivery times for all orders?

```SQL
```

Result:

<pre>

</pre>

### B.6 What was the average speed for each runner for each delivery and do you notice any trend for these values?

```SQL
```

Result:

<pre>

</pre>

### B.7 What is the successful delivery percentage for each runner?

```SQL
```

Result:

<pre>

</pre>