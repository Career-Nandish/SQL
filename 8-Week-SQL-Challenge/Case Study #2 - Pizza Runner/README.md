# :pizza: :pizza: :pizza: [Case Study #2 - Pizza Runner](https://8weeksqlchallenge.com/case-study-2/) :pizza: :pizza: :pizza:

<p align = "center">
	<img src="./images/title.png" alt="Image" width="450" height="450">
</p>


## Table of Contents

1. [Introduction](#introduction)
2. [Datasets](#datasets)
   - [Key datasets for this case study](#key-datasets-for-this-case-study)
3. [Entity Relationship Diagram](#entity-relationship-diagram)
4. [Data](#data)
   - [Table 1: runners](#table-1-runners)
   - [Table 2: customer_orders](#table-2-customer_orders)
   - [Table 3: runner_orders](#table-3-runner_orders)
   - [Table 4: pizza_names](#table-4-pizza_names)
   - [Table 5: pizza_recipes](#table-5-pizza_recipes)
   - [Table 6: pizza_toppings](#table-6-pizza_toppings)
5. [Case Study Questions](#case-study-questions)
   - [0. Data Cleaning](#0-data-cleaning)
   - [A. Pizza Metrics](#a-pizza-metrics)
   - [B. Runner and Customer Experience](#b-runner-and-customer-experience)
   - [C. Ingredient Optimisation](#c-ingredient-optimisation)
   - [D. Pricing and Ratings](#d-pricing-and-ratings)
   - [E. Bonus Questions](#e-bonus-questions)



## Introduction

Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.



## Datasets

Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the pizza_runner database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.

### Key datasets for this case study

* `runners` : The table shows the registration_date for each new runner
* `customer_orders` : Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.
* `runner_orders` : After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.
* `pizza_names` : Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!
* `pizza_recipes` : Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.
* `pizza_toppings` : The table contains all of the topping_name values with their corresponding topping_id value

## Entity Relationship Diagram

![Entity Relationship Diagram](./images/ERD.jpg)


## Data

### Table 1: `runners`

The `runners` table shows the `registration_date` for each new runner(`runner_id`).

<pre>
  runner_id | registration_date 
-----------+-------------------
         1 | 2021-01-01
         2 | 2021-01-03
         3 | 2021-01-08
         4 | 2021-01-15
</pre>

### Table 2: `customer_orders`

Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.

The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.

Note that customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!

The exclusions and extras columns will need to be cleaned up before using them in your queries.

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


### Table 3: `runner_orders`

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The `pickup_time` is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The `distance` and `duration` fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

***Note from Danny** : There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!*

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


### Table 4: `pizza_names`

At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!

<pre>
 pizza_id | pizza_name 
----------+------------
        1 | Meatlovers
        2 | Vegetarian
</pre>


### Table 5: `pizza_recipes`

Each `pizza_id` has a standard set of `toppings` which are used as part of the pizza recipe.

<pre>
 pizza_id |        toppings         
----------+-------------------------
        1 | 1, 2, 3, 4, 5, 6, 8, 10
        2 | 4, 6, 7, 9, 11, 12
</pre>


### Table 6: `pizza_toppings`

This table contains all of the `topping_name` values with their corresponding `topping_id` value

<pre>
 topping_id | topping_name 
------------+--------------
          1 | Bacon
          2 | BBQ Sauce
          3 | Beef
          4 | Cheese
          5 | Chicken
          6 | Mushrooms
          7 | Onions
          8 | Pepperoni
          9 | Peppers
         10 | Salami
         11 | Tomatoes
         12 | Tomato Sauce
</pre>


## Case Study Questions

This case study has LOTS of questions - they are broken up by area of focus including:

* [Data Cleaning](./0_DataCleaning.md)
* [Pizza Metrics](./A_PizzaMetrics.md)
* [Runner and Customer Experience](./B_RunnerAndCustomerExperience.md)
* [Ingredient Optimisation](./C_IngredientOptimisation.md)
* [Pricing and Ratings](./D_PricingAndRatings.md)
* [Bonus DML Challenges (DML = Data Manipulation Language)](./E_BonusDMLChallenges.md)

Each of the following case study questions can be answered using a single SQL statement.

Again, there are many questions in this case study - please feel free to pick and choose which ones you’d like to try!

Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the *customer_orders* and *runner_orders* tables!

### [0. Data Cleaning](./0_DataCleaning.md)

There are some issues with data so before we jump into the case study questions, we will need to handle them.

### [A. Pizza Metrics](./A_PizzaMetrics.md)

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

### [B. Runner and Customer Experience](./B_RunnerAndCustomerExperience.md)

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

### [C. Ingredient Optimisation](./C_IngredientOptimisation.md)

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
    * Meat Lovers
    * Meat Lovers - Exclude Beef
    * Meat Lovers - Extra Bacon
    * Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
    * For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

### [D. Pricing and Ratings](./D_PricingAndRatings.md)

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
    * customer_id
    * order_id
    * runner_id
    * rating
    * order_time
    * pickup_time
    * Time between order and pickup
    * Delivery duration
    * Average speed
    * Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

### [E. Bonus DML Challenges (DML = Data Manipulation Language)](./E_BonusDMLChallenges.md)

If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?