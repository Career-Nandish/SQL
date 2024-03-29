## A. Pizza Metrics

### A.1 How many pizzas were ordered?

```SQL
SELECT COUNT(pizza_id) AS "Total Number Of Pizzas Ordered"
FROM temp_cust_orders
```

Result:

<pre>
 Total Number Of Pizzas Ordered 
--------------------------------
                             14
</pre>

### A.2 How many unique customer orders were made?

```SQL
SELECT COUNT(DISTINCT order_id) AS "Unique Orders Placed"
FROM temp_cust_orders
```

Result:

<pre>
 Unique Orders Placed 
----------------------
                   10
</pre>

### A.3 How many successful orders were delivered by each runner?

```SQL
SELECT runner_id, COUNT(*) AS "Successful Deliveries"
FROM clean_runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id
```

Result:

<pre>
 runner_id | Successful Deliveries 
-----------+-----------------------
         1 |                     4
         2 |                     3
         3 |                     1
</pre>

### A.4 How many of each type of pizza was delivered?

```SQL
SELECT c.pizza_id, 
       p.pizza_name, 
       COUNT(*) AS "Number of Pizzas Delivered"
FROM temp_cust_orders c
JOIN clean_runner_orders r
    ON c.order_id = r.order_id
JOIN pizza_names p
    ON c.pizza_id = p.pizza_id
WHERE r.cancellation IS NULL
GROUP BY c.pizza_id, p.pizza_name
```

Result:

<pre>
 pizza_id | pizza_name | Number of Pizzas Delivered 
----------+------------+----------------------------
        1 | Meatlovers |                          9
        2 | Vegetarian |                          3
</pre>


### A.5 How many Vegetarian and Meatlovers were ordered by each customer?

```SQL
SELECT customer_id,
       SUM(
           CASE
               WHEN pizza_id = 1 THEN 1
               ELSE 0
           END
        ) AS "Meatlovers Pizza Count",
       SUM(
           CASE
               WHEN pizza_id = 2 THEN 1
               ELSE 0
           END
        ) AS "Vegetarian Pizza Count"
FROM temp_cust_orders
GROUP BY customer_id
ORDER BY customer_id
```

Result:

<pre>
 customer_id | Meatlovers Pizza Count | Vegetarian Pizza Count 
-------------+------------------------+------------------------
         101 |                      2 |                      1
         102 |                      2 |                      1
         103 |                      3 |                      1
         104 |                      3 |                      0
         105 |                      0 |                      1
</pre>


### A.6 What was the maximum number of pizzas delivered in a single order?

```SQL
SELECT c.order_id, 
       COUNT(*) AS pizza_count
FROM temp_cust_orders c
JOIN clean_runner_orders r
  ON c.order_id = r.order_id AND r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY pizza_count DESC
LIMIT 1
```

Result:

<pre>
 order_id | pizza_count 
----------+-------------
        4 |           3
</pre>


### A.7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```SQL
SELECT c.customer_id,
       SUM(
           CASE
               WHEN c.extras IS NOT NULL OR c.exclusions IS NOT NULL THEN 1
               ELSE 0
           END
       ) AS "At Least One Change",
       SUM(
           CASE
               WHEN c.extras IS NULL AND c.exclusions IS NULL THEN 1
               ELSE 0
           END
       ) AS "No changes"
FROM temp_cust_orders c
JOIN clean_runner_orders r
  ON c.order_id = r.order_id AND r.cancellation IS NULL
GROUP BY c.customer_id
ORDER BY c.customer_id
```

Result:

<pre>
 customer_id | At Least One Change | No changes 
-------------+---------------------+------------
         101 |                   0 |          2
         102 |                   0 |          3
         103 |                   3 |          0
         104 |                   2 |          1
         105 |                   1 |          0
</pre>


### A.8 How many pizzas were delivered that had both exclusions and extras?

```SQL
SELECT c.customer_id,
       SUM(
           CASE
               WHEN c.extras IS NOT NULL AND c.exclusions IS NOT NULL THEN 1
               ELSE 0
           END
       ) AS "No Of Pizzas With Exclusions & Extras"
FROM temp_cust_orders c
JOIN clean_runner_orders r
  ON c.order_id = r.order_id AND r.cancellation IS NULL
GROUP BY c.customer_id
ORDER BY c.customer_id
```

Result:

<pre>
 customer_id | No Of Pizzas With Exclusions & Extras 
-------------+---------------------------------------
         101 |                                     0
         102 |                                     0
         103 |                                     0
         104 |                                     1
         105 |                                     0
</pre>


### A.9 What was the total volume of pizzas ordered for each hour of the day?

```SQL
SELECT DATE_PART('hour', order_time) AS "Hour", 
       COUNT(order_id) AS "Number Of Pizzas Ordered", 
       ROUND((COUNT(order_id) * 100)/SUM(COUNT(order_id)) OVER (), 2) "% Of Pizzas Ordered"
FROM temp_cust_orders
GROUP BY "Hour"
ORDER BY "Number Of Pizzas Ordered" DESC
```

Result:

<pre>
 Hour | Number Of Pizzas Ordered | % Of Pizzas Ordered 
------+--------------------------+---------------------
   18 |                        3 |               21.43
   23 |                        3 |               21.43
   21 |                        3 |               21.43
   13 |                        3 |               21.43
   11 |                        1 |                7.14
   19 |                        1 |                7.14
</pre>


### A.10 What was the volume of orders for each day of the week?


```SQL
SELECT TO_CHAR(order_time, 'Day') AS "Day Of Week", 
       COUNT(order_id) AS "Number Of Pizzas Ordered", 
       ROUND((COUNT(order_id) * 100)/SUM(COUNT(order_id)) OVER (), 2) AS "% Of Pizzas Ordered"
FROM temp_cust_orders
GROUP BY "Day Of Week"
ORDER BY "Number Of Pizzas Ordered" DESC
```

Result:

<pre>
 Day Of Week | Number Of Pizzas Ordered | % Of Pizzas Ordered 
-------------+--------------------------+---------------------
 Saturday    |                        5 |               35.71
 Wednesday   |                        5 |               35.71
 Thursday    |                        3 |               21.43
 Friday      |                        1 |                7.14
</pre>