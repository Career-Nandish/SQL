## E. Bonus DML Challenges


### E.1 If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

We have insert values into two tables `pizza_names` and `pizza_recipes`.

```SQL
INSERT INTO pizza_names (pizza_id, pizza_name)
(
	SELECT MAX(pizza_id) + 1, 'Supreme' 
	FROM pizza_names
);

SELECT * FROM pizza_names
```

Result:

<pre>
 pizza_id | pizza_name 
----------+------------
        1 | Meatlovers
        2 | Vegetarian
        3 | Supreme
</pre>

```SQL
INSERT INTO pizza_recipes (pizza_id, toppings)
(
	SELECT (SELECT MAX(pizza_id) FROM pizza_names), 
	    STRING_AGG(topping_id::TEXT, ', ') 
    FROM pizza_toppings
);

SELECT * FROM pizza_recipes    
```

Result:

<pre>
 pizza_id |               toppings                
----------+---------------------------------------
        1 | 1, 2, 3, 4, 5, 6, 8, 10
        2 | 4, 6, 7, 9, 11, 12
        3 | 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
</pre>