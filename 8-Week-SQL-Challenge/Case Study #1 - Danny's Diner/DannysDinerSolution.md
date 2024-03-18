## 1. What is the total amount each customer spent at the restaurant?

```SQL
SELECT s.customer_id AS customer, 
       CONCAT('$',SUM(m.price)) AS total_spend
FROM sales s
JOIN menu m
	ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_spend DESC
```

Result:

<pre>
 customer | total_spend 
----------+-------------
 A        | $76
 B        | $74
 C        | $36
</pre>


## 2. How many days has each customer visited the restaurant?

```SQL
SELECT customer_id AS customer,
       COUNT(DISTINCT order_date) AS num_days
FROM sales
GROUP BY customer_id
ORDER BY num_days DESC
```
Result:

<pre>
 customer | num_days 
----------+----------
 B        |        6
 A        |        4
 C        |        2
</pre>

## 3. What was the first item from the menu purchased by each customer?

```SQL
WITH cust_orders AS (
  SELECT customer_id, 
         product_id,
         RANK() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS rnk
  FROM sales
)

SELECT c.customer_id, 
       STRING_AGG(DISTINCT m.product_name, ', ' ORDER BY m.product_name) AS items
FROM cust_orders c 
JOIN menu m 
    ON c.product_id = m.product_id
WHERE c.rnk = 1
GROUP BY c.customer_id
```

Result:

<pre>
 customer_id |    items     
-------------+--------------
 A           | curry, sushi
 B           | curry
 C           | ramen
</pre>


## 4. What is the most purchased item on the menu and how many times was it purchased by all customers?


```SQL
WITH most_ordered_prod AS (
  SELECT product_id, COUNT(*) AS num_ordered
  FROM sales
  GROUP BY product_id
  ORDER BY num_ordered DESC
  LIMIT 1
)

SELECT m.product_id, mn.product_name, m.num_ordered
FROM most_ordered_prod m
JOIN menu mn
  ON m.product_id = mn.product_id
```

Result:

<pre>
 product_id | product_name | num_ordered 
------------+--------------+-------------
          3 | ramen        |           8
</pre>

## 5. Which item was the most popular for each customer?

```SQL
WITH most_pop_items AS (
  SELECT customer_id,
         product_id,
         RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS rnk
  FROM sales
  GROUP BY customer_id, product_id
)

SELECT mp.customer_id AS customer,
       STRING_AGG(m.product_name, ', ' ORDER BY m.product_name) AS most_pop_item
FROM menu m
JOIN most_pop_items mp
  ON m.product_id = mp.product_id
WHERE mp.rnk = 1
GROUP BY mp.customer_id
```

Result:

<pre>
 customer |    most_pop_item    
----------+---------------------
 A        | ramen
 B        | curry, ramen, sushi
 C        | ramen
</pre>

## 6. Which item was purchased first by the customer after they became a member?

```SQL
WITH member_sales AS (
    SELECT s.customer_id,
           s.product_id,
           s.order_date,
           m.join_date,
           RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id AND s.order_date >= m.join_date
)

SELECT ms.customer_id AS customer,
       ms.order_date,
       m.product_name,
       ms.join_date
FROM menu m
JOIN member_sales ms
  ON m.product_id = ms.product_id
WHERE ms.rnk = 1
ORDER BY ms.customer_id
```

Result:

<pre>
 customer | order_date | product_name | join_date  
----------+------------+--------------+------------
 A        | 2021-01-07 | curry        | 2021-01-07
 B        | 2021-01-11 | sushi        | 2021-01-09
</pre>

## 7. Which item was purchased just before the customer became a member?


## 8. What is the total items and amount spent for each member before they became a member?


## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


## 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?