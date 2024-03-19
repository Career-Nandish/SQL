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


```SQL
WITH cust_sales AS (
    SELECT s.customer_id,
           s.product_id,
           s.order_date,
           m.join_date,
           RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rnk
    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id AND s.order_date < m.join_date
)

SELECT cs.customer_id,
       MIN(cs.order_date) AS order_date,
       STRING_AGG(m.product_name, ', ' ORDER BY m.product_name) AS product_name,
       MIN(cs.join_date) AS join_date
FROM menu m
JOIN cust_sales cs
  ON m.product_id = cs.product_id
WHERE cs.rnk = 1
GROUP BY cs.customer_id
```

Result:

<pre>
 customer_id | order_date | product_name | join_date  
-------------+------------+--------------+------------
 A           | 2021-01-01 | curry, sushi | 2021-01-07
 B           | 2021-01-04 | sushi        | 2021-01-09
</pre>

## 8. What is the total items and amount spent for each member before they became a member?

```SQL
WITH cust_sales AS (
    SELECT s.customer_id,
           s.product_id,
           s.order_date,
           m.join_date
    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id AND s.order_date < m.join_date
)

SELECT cs.customer_id, 
       COUNT(cs.product_id) AS total_items, 
       CONCAT('$', SUM(m.price)) AS amount_spent
FROM menu m
JOIN cust_sales cs
  ON m.product_id = cs.product_id
GROUP BY cs.customer_id
ORDER BY cs.customer_id
```

Result:

<pre>
 customer_id | total_items | amount_spent 
-------------+-------------+--------------
 A           |           2 | $25
 B           |           3 | $40
</pre>

## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


```SQL
SELECT s.customer_id,
       SUM(
           CASE
               WHEN m.product_name = 'sushi' THEN m.price * 2 * 10
               ELSE m.price * 10
           END
       ) AS points
FROM sales s
JOIN menu m
  ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id
```

Result:

<pre>
 customer_id | points 
-------------+--------
 A           |    860
 B           |    940
 C           |    360
</pre>

## 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


```SQL
WITH cust_sales AS (
    SELECT s.customer_id,
           s.product_id,
           s.order_date,
           m.join_date,
           s.order_date - m.join_date AS diff
    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id AND s.order_date >= m.join_date
    WHERE s.order_date < '2021-02-01'
    
)

SELECT cs.customer_id,
       SUM(CASE
           WHEN cs.diff <= 6 THEN m.price * 20
           WHEN cs.diff > 6 AND m.product_name = 'sushi' THEN m.price * 20
           ELSE m.price * 10
       END) AS points
FROM menu m
JOIN cust_sales cs
  ON m.product_id = cs.product_id
GROUP BY cs.customer_id
ORDER BY cs.customer_id
```

Result:

<pre>
 customer_id | points 
-------------+--------
 A           |   1020
 B           |    320
</pre>



## Bonus Questions

### Join All The Things

Create basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL. Fill Member column as 'N' if the purchase was made before becoming a member and 'Y' if the after is amde after joining the membership. Danny is trying to come up with following results:


<div class="responsive-table"><table><thead>
      <tr>
        <th>customer_id</th>
        <th>order_date</th>
        <th>product_name</th>
        <th>price</th>
        <th>member</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>A</td>
        <td>2021-01-01</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-01</td>
        <td>sushi</td>
        <td>10</td>
        <td>N</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-07</td>
        <td>curry</td>
        <td>15</td>
        <td>Y</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-10</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-11</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-11</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-01</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-02</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-04</td>
        <td>sushi</td>
        <td>10</td>
        <td>N</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-11</td>
        <td>sushi</td>
        <td>10</td>
        <td>Y</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-16</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-02-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-07</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
      </tr>
    </tbody>
  </table>
</div>


```SQL
WITH cte_members AS (
	SELECT s.customer_id,
	       s.order_date,
	       m.product_name,
	       m.price, 
	       CASE
	           WHEN s.order_date >= mb.join_date THEN 'Y'
	           ELSE 'N'
	       END AS member
	FROM sales s
	JOIN menu m
	    ON s.product_id = m.product_id
	LEFT JOIN members mb
	    ON s.customer_id = mb.customer_id
	ORDER BY s.customer_id, s.order_date, m.product_name
)

SELECT * FROM cte_members
``` 
	
Result:

<pre>
 customer_id | order_date | product_name | price | member 
-------------+------------+--------------+-------+--------
 A           | 2021-01-01 | curry        |    15 | N
 A           | 2021-01-01 | sushi        |    10 | N
 A           | 2021-01-07 | curry        |    15 | Y
 A           | 2021-01-10 | ramen        |    12 | Y
 A           | 2021-01-11 | ramen        |    12 | Y
 A           | 2021-01-11 | ramen        |    12 | Y
 B           | 2021-01-01 | curry        |    15 | N
 B           | 2021-01-02 | curry        |    15 | N
 B           | 2021-01-04 | sushi        |    10 | N
 B           | 2021-01-11 | sushi        |    10 | Y
 B           | 2021-01-16 | ramen        |    12 | Y
 B           | 2021-02-01 | ramen        |    12 | Y
 C           | 2021-01-01 | ramen        |    12 | N
 C           | 2021-01-01 | ramen        |    12 | N
 C           | 2021-01-07 | ramen        |    12 | N
</pre>



### Rank All The Things

Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program. Danny is trying to achieve following result:

<div class="responsive-table">

  <table>
    <thead>
      <tr>
        <th>customer_id</th>
        <th>order_date</th>
        <th>product_name</th>
        <th>price</th>
        <th>member</th>
        <th>ranking</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>A</td>
        <td>2021-01-01</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-01</td>
        <td>sushi</td>
        <td>10</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-07</td>
        <td>curry</td>
        <td>15</td>
        <td>Y</td>
        <td>1</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-10</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>2</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-11</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>3</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-11</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>3</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-01</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-02</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-04</td>
        <td>sushi</td>
        <td>10</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-11</td>
        <td>sushi</td>
        <td>10</td>
        <td>Y</td>
        <td>1</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-16</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>2</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-02-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>3</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-07</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
        <td>null</td>
      </tr>
    </tbody>
  </table>

</div>

```SQL
WITH cte_members AS (
	SELECT s.customer_id,
	       s.order_date,
	       m.product_name,
	       m.price, 
	       CASE
	           WHEN s.order_date >= mb.join_date THEN 'Y'
	           ELSE 'N'
	       END AS member
	FROM sales s
	JOIN menu m
	    ON s.product_id = m.product_id
	LEFT JOIN members mb
	    ON s.customer_id = mb.customer_id
	ORDER BY s.customer_id, s.order_date, m.product_name
)

SELECT *, 
       CASE
           WHEN member = 'N' THEN NULL
           ELSE DENSE_RANK() OVER (PARTITION BY customer_id, member ORDER BY order_date)
       END AS ranking
FROM cte_members
```

Result:

<pre>
 customer_id | order_date | product_name | price | member | ranking 
-------------+------------+--------------+-------+--------+---------
 A           | 2021-01-01 | sushi        |    10 | N      |        
 A           | 2021-01-01 | curry        |    15 | N      |        
 A           | 2021-01-07 | curry        |    15 | Y      |       1
 A           | 2021-01-10 | ramen        |    12 | Y      |       2
 A           | 2021-01-11 | ramen        |    12 | Y      |       3
 A           | 2021-01-11 | ramen        |    12 | Y      |       3
 B           | 2021-01-01 | curry        |    15 | N      |        
 B           | 2021-01-02 | curry        |    15 | N      |        
 B           | 2021-01-04 | sushi        |    10 | N      |        
 B           | 2021-01-11 | sushi        |    10 | Y      |       1
 B           | 2021-01-16 | ramen        |    12 | Y      |       2
 B           | 2021-02-01 | ramen        |    12 | Y      |       3
 C           | 2021-01-01 | ramen        |    12 | N      |        
 C           | 2021-01-01 | ramen        |    12 | N      |        
 C           | 2021-01-07 | ramen        |    12 | N      |        
</pre>