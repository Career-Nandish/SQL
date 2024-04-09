## C. Ingredient Optimisation


### C.1 What are the standard ingredients for each pizza?

```SQL
SELECT 
    r.pizza_id, 
    STRING_AGG(t.topping_name, ', ') AS "Standard Ingredients"
FROM 
    clean_pizza_recipes r
    JOIN pizza_toppings t
        ON r.toppings = t.topping_id
GROUP BY 
    r.pizza_id
ORDER BY 
    r.pizza_id
```

Result:

<pre>
 pizza_id |                         Standard Ingredients                          
----------+-----------------------------------------------------------------------
        1 | Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami
        2 | Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce
</pre>

### C.2 What was the most commonly added extra?

```SQL
SELECT 
    t.topping_name, 
    COUNT(*) "Number Of Times Added"
FROM 
    clean_cust_orders c
    JOIN pizza_toppings t
        ON c.extras = t.topping_id
GROUP BY 
    t.topping_name
ORDER BY 
    "Number Of Times Added" DESC
```

Result:

<pre>
 topping_name | Number Of Times Added 
--------------+-----------------------
 Bacon        |                     5
 Cheese       |                     2
 Chicken      |                     1
</pre>

### C.3 What was the most common exclusion?

```SQL
SELECT 
    t.topping_name, 
    COUNT(*) "Number Of Times Excluded"
FROM 
    clean_cust_orders c
    JOIN pizza_toppings t
        ON c.exclusions = t.topping_id
GROUP BY 
    t.topping_name
ORDER BY 
    "Number Of Times Excluded" DESC
```

Result:

<pre>
 topping_name | Number Of Times Excluded 
--------------+--------------------------
 Cheese       |                        5
 Mushrooms    |                        2
 BBQ Sauce    |                        2
</pre>

### C.4 Generate an order item for each record in the customers_orders table in the format of one of the following:
###	- Meat Lovers
###	- Meat Lovers - Exclude Beef
###	- Meat Lovers - Extra Bacon
###	- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```SQL
SELECT subq.order_id, 
       CASE
           WHEN subq.extras IS NULL AND subq.exclusions IS NULL 
           THEN pn.pizza_name
           
           WHEN subq.extras IS NULL 
           THEN pn.pizza_name || ' - Exclude ' || subq.exclusions
        
           WHEN subq.exclusions IS NULL 
           THEN pn.pizza_name || ' - Extra ' || subq.extras
           
           ELSE pn.pizza_name || ' - Exclude ' || subq.exclusions || ' - Extra ' || subq.extras
        END AS order_details
FROM 
    pizza_names pn
JOIN (
  SELECT MIN(c.order_id) AS order_id, 
         MIN(c.pizza_id) AS pizza_id, 
         STRING_AGG(DISTINCT pt.topping_name,  ', ') AS extras, 
         STRING_AGG(DISTINCT pt1.topping_name, ', ') AS exclusions
  FROM clean_cust_orders c
  LEFT JOIN pizza_toppings pt
      ON c.extras = pt.topping_id
  LEFT JOIN pizza_toppings pt1
      ON c.exclusions = pt1.topping_id
  GROUP BY c.row_num
) AS subq
  ON pn.pizza_id = subq.pizza_id
```

Result:

<pre>
 order_id |                          order_details                          
----------+-----------------------------------------------------------------
        1 | Meatlovers
        2 | Meatlovers
        3 | Meatlovers
        3 | Vegetarian
        4 | Meatlovers - Exclude Cheese
        4 | Meatlovers - Exclude Cheese
        4 | Vegetarian - Exclude Cheese
        5 | Meatlovers - Extra Bacon
        6 | Vegetarian
        7 | Vegetarian - Extra Bacon
        8 | Meatlovers
        9 | Meatlovers - Exclude Cheese - Extra Bacon, Chicken
       10 | Meatlovers
       10 | Meatlovers - Exclude BBQ Sauce, Mushrooms - Extra Bacon, Cheese
</pre>

### C.5 Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
###	- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

```SQL
```

Result:

<pre>

</pre>

### C.6 What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

```SQL
```

Result:

<pre>
</pre>