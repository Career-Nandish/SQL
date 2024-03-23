Before we move onto solving the case study questions, we must clean the data provided by Danny. 


## 1. Data Cleaning

### *customer_order*

Let's observe the data first, since *customer_order* has a few rows we can explore the data by simply selecting the entire table. 

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

1. There are some missing values and some incorrect values(*NULL* is represented by *'null'*)
2. The columns *exclusions* and *extras* has values separated by commas, which are valid values but it might be difficult to deal with them later using SQL, so we will create new rows for them.

```SQL
-- Handling data Issue no 1
WITH temp_cust_orders (
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