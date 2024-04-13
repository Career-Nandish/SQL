## D. Pricing And Ratings


### D.1 If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```SQL
SELECT '$' || SUM(
           CASE
               WHEN c.pizza_id = 1 THEN 12
               ELSE 10
           END
       ) AS total_money_made
FROM temp_cust_orders c
JOIN clean_runner_orders r
    ON c.order_id = r.order_id AND r.cancellation IS NULL
```

Result:

<pre>
 total_money_made 
------------------
 $138
</pre>

### D.2 What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra

```SQL
SELECT  '$' || SUM(
            CASE
               WHEN c.pizza_id = 1 THEN 12
               ELSE 10
            END + COALESCE(
                      ARRAY_LENGTH(STRING_TO_ARRAY(c.extras, ', '), 1), 0)
                ) AS total_money_made
FROM temp_cust_orders c
JOIN clean_runner_orders r
    ON c.order_id = r.order_id AND r.cancellation IS NULL
```

Result:

<pre>
 total_money_made 
------------------
 $142
</pre>

### D.3 The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```SQL
CREATE TABLE runner_ratings (
    cust_id INTEGER, -- customer id 
    order_id INTEGER, -- order id
    runner_id INTEGER, -- runner id
    delivery_rating SMALLINT CHECK(delivery_rating BETWEEN 1 AND 5), -- delivery rating between 1, 5 higher the number better the rating
    additional_feedback TEXT -- Additional feedback about runner
);

INSERT INTO runner_ratings
    (cust_id, order_id, runner_id, delivery_rating, additional_feedback)
    VALUES
    (101, 1, 1, NULL, NULL),
    (101, 2, 1, 4, 'Quick delivery'),
    (102, 3, 1, 3, NULL),
    (103, 4, 2, 5, 'Super fast'),
    (104, 5, 3, 1, 'A slice was missing');

SELECT * FROM runner_ratings
```

Result:

<pre>
 cust_id | order_id | runner_id | delivery_rating | additional_feedback 
---------+----------+-----------+-----------------+---------------------
     101 |        1 |         1 |                 | 
     101 |        2 |         1 |               4 | Quick delivery
     102 |        3 |         1 |               3 | 
     103 |        4 |         2 |               5 | Super fast
     104 |        5 |         3 |               1 | A slice was missing   
</pre>


### D.4 Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
* ### customer_id
* ### order_id
* ### runner_id
* ### rating
* ### order_time
* ### pickup_time
* ### Time between order and pickup
* ### Delivery duration
* ### Average speed
* ### Total number of pizzas

```SQL
SELECT DISTINCT c.customer_id, c.order_id, r.runner_id,
       COUNT(c.pizza_id) OVER (PARTITION BY c.order_id) AS pizza_count,
       c.order_time, r.pickup_time, 
       ROUND(EXTRACT (EPOCH FROM r.pickup_time - c.order_time)/60, 2) AS diff_order_pickup_time_min, 
       r.duration AS duration_min, 
       ROUND((r.distance * 60)::NUMERIC/r.duration, 2) AS speed_kmph, 
       rr.delivery_rating, rr.additional_feedback
FROM temp_cust_orders c
JOIN clean_runner_orders r
  ON c.order_id = r.order_id AND r.cancellation IS NULL
LEFT JOIN runner_ratings rr
  ON c.order_id = rr.order_id
```

Result:

<pre>
 customer_id | order_id | runner_id | pizza_count |     order_time      |     pickup_time     | diff_order_pickup_time_mins | duration_min | speed_kmph | delivery_rating | additional_feedback 
-------------+----------+-----------+-------------+---------------------+---------------------+-----------------------------+--------------+------------+-----------------+---------------------
         101 |        1 |         1 |           1 | 2020-01-01 18:05:02 | 2020-01-01 18:15:34 |                       10.53 |           32 |      37.50 |                 | 
         101 |        2 |         1 |           1 | 2020-01-01 19:00:52 | 2020-01-01 19:10:54 |                       10.03 |           27 |      44.44 |               4 | Quick delivery
         102 |        3 |         1 |           2 | 2020-01-02 23:51:23 | 2020-01-03 00:12:37 |                       21.23 |           20 |      40.20 |               3 | 
         102 |        8 |         2 |           1 | 2020-01-09 23:54:33 | 2020-01-10 00:15:02 |                       20.48 |           15 |      93.60 |                 | 
         103 |        4 |         2 |           3 | 2020-01-04 13:23:46 | 2020-01-04 13:53:03 |                       29.28 |           40 |      35.10 |               5 | Super fast
         104 |        5 |         3 |           1 | 2020-01-08 21:00:29 | 2020-01-08 21:10:57 |                       10.47 |           15 |      40.00 |               1 | A slice was missing
         104 |       10 |         1 |           2 | 2020-01-11 18:34:49 | 2020-01-11 18:50:20 |                       15.52 |           10 |      60.00 |                 | 
         105 |        7 |         2 |           1 | 2020-01-08 21:20:29 | 2020-01-08 21:30:45 |                       10.27 |           25 |      60.00 |                 |    
</pre>

### D.5 If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```SQL
WITH total_revenue AS (
    SELECT SUM(
               CASE
                   WHEN c.pizza_id = 1 THEN 12
                   ELSE 10
               END
            ) AS total  
    FROM temp_cust_orders c
    JOIN clean_runner_orders r
        ON c.order_id = r.order_id AND r.cancellation IS NULL
),
runner_fees AS (
    SELECT SUM(distance)*0.30 AS fee FROM clean_runner_orders
)

SELECT (SELECT total FROM total_revenue) - (SELECT fee FROM runner_fees) AS total_money_made
```

Result:

<pre>
 total_money_made 
------------------
           94.440
</pre>