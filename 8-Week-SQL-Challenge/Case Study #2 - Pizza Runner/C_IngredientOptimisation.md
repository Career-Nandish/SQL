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
```

Result:

<pre>
</pre>

### C.4 Generate an order item for each record in the customers_orders table in the format of one of the following:
	- Meat Lovers
	- Meat Lovers - Exclude Beef
	- Meat Lovers - Extra Bacon
	- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```SQL
```

Result:

<pre>
</pre>

### C.5 Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
	- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

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