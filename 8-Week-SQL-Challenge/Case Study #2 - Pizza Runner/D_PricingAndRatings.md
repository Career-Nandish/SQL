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
```

Result:

<pre>
      
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
```

Result:

<pre>
      
</pre>

### D.5 If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```SQL
```

Result:

<pre>
      
</pre>