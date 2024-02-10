# Subqueries and temporary tables

/*
Both subqueries and table expressions are methods for 
being able to write a query that creates a table, and 
then write a query that interacts with this newly 
created table. Sometimes the question you are trying to 
answer doesn't have an answer when working directly 
with existing tables in database.
*/


/*
1. On which day-channel pair did the most events occur.
*/

SELECT DATE_TRUNC('day', w.occurred_at) as day, 
w.channel, COUNT(*) event_count
FROM web_events w
GROUP BY 1, 2
ORDER BY 3 desc;

# January 1 2017; direct
# Decemeber 21 2016; direct


/*
2. Mark all of the below that are true regarding 
writing your subquery.
*/

# a. The original query goes in the FROM statement.
# b. A * is used to pull all the data from the original
	# query
#c. Ypu must use an alias for the table you nest within
	# the outer query


/*
3. Match each channel to its corresponding average 
number of events per day.
*/


SELECT channel, AVG(event_count)
FROM
	(
	SELECT DATE_TRUNC('day', occurred_at) as day, 
	channel, COUNT(*) event_count
	FROM web_events 
	GROUP BY 1, 2
	) inner_query

GROUP BY 1
ORDER BY 2 DESC;


# direct - 4.90
# facebook - 1.60
# organic - 1.67
# twitter - 1.32


-----------------------------------
-----------------------------------


# Subqueries and temporary tables II

/*
Note that you should not include an alias when you 
write a subquery in a conditional statement. This is 
because the subquery is treated as an individual value 
(or set of values in the IN case) rather than as a 
table.

Also, notice the query here compared a single value. If 
we returned an entire column IN would need to be used 
to perform a logical argument. If we are returning an 
entire table, then we must use an ALIAS for the table, 
and perform additional logic on the entire table.
*/


/*
1. What was the month/year combo for the first order 
placed?
*/

SELECT MIN(occurred_at) as first_order_date
FROM orders;

/*
2. Match each value to the corresponding description.
*/

/*
a. The average amount of standard paper sold on the 
first month that any order was placed in the orders 
table (in terms of quantity).
*/

SELECT AVG(standard_qty) AS first_month_standard_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);

/*
b. The average amount of gloss paper sold on the first 
month that any order was placed in the orders table 
(in terms of quantity).
*/

SELECT AVG(gloss_qty) AS first_month_gloss_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);


/*
c. The average amount of poster paper sold on the first 
month that any order was placed in the orders table 
(in terms of quantity).
*/

SELECT AVG(poster_qty) AS first_month_poster_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);



/*
d. The total amount spent on all orders on the first 
month that any order was placed in the orders table 
(in terms of usd).
*/

SELECT SUM(total_amt_usd) AS first_month_sales
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);


/*
OR a, b, c & d together can be written as
*/

SELECT AVG(standard_qty) AS first_month_std_qty,
	   AVG(gloss_qty) AS first_month_gloss_qty,
	   AVG(poster_qty) AS first_month_poster_qty,
	   SUM(total_amt_usd) AS first_month_sales
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at))
	FROM orders);


-----------------------------------
-----------------------------------


# More Subquery Questions with WITH

/*
1. Provide the name of the sales_rep in each region 
with the largest amount of total_amt_usd sales.
*/

SELECT t2.sname, t1.max_total
FROM (SELECT rname, MAX(total) as max_total
	  FROM (SELECT r.name rname, s.name sname, 
	   		SUM(o.total_amt_usd) total
			FROM orders o
			JOIN accounts a
			ON a.id = o.account_id
			JOIN sales_reps s
			ON a.sales_rep_id = s.id
			JOIN region r
			ON s.region_id = r.id
			GROUP BY 1, 2
			) sub
	   GROUP BY 1
	   ) t1
JOIN   (SELECT r.name rname, s.name sname, 
	    SUM(o.total_amt_usd) total
	    FROM orders o
		JOIN accounts a
		ON a.id = o.account_id
		JOIN sales_reps s
		ON a.sales_rep_id = s.id
		JOIN region r
		ON s.region_id = r.id
		GROUP BY 1, 2
	    ) t2
ON t1.max_total = t2.total and t1.rname = t2.rname;

-- OR -- BETTER WAY USING WINDOW FUNCTION

SELECT sname, rname, sales
FROM (
  SELECT s.name sname, r.name rname, 
         SUM(o.total_amt_usd) sales, 
         RANK() OVER(
         	PARTITION BY r.name 
         	ORDER BY SUM(o.total_amt_usd) DESC
         	) AS ranks
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  JOIN sales_reps s
  ON s.id = a.sales_rep_id
  JOIN region r
  ON s.region_id = r.id
  GROUP BY 1, 2
) AS subq
WHERE ranks = 1;

-- OR -- with WITH

WITH t1 AS (
  SELECT s.name rep_name, r.name region_name, 
  SUM(o.total_amt_usd) total_amt
  FROM sales_reps s
  JOIN accounts a
  ON a.sales_rep_id = s.id
  JOIN orders o
  ON o.account_id = a.id
  JOIN region r
  ON r.id = s.region_id
  GROUP BY 1,2
  ), 
t2 AS (
  SELECT region_name, MAX(total_amt) total_amt
  FROM t1
  GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;



/*
2. For the region with the largest (sum) of sales 
total_amt_usd, how many total (count) orders were 
placed?
*/

SELECT r.name, COUNT(o.id)
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name = (SELECT rname 
	FROM  (SELECT r.name rname, SUM(o.total_amt_usd) total_region
			FROM orders o
			JOIN accounts a
			ON a.id = o.account_id
			JOIN sales_reps s
			ON a.sales_rep_id = s.id
			JOIN region r
			ON s.region_id = r.id
			GROUP BY 1
			ORDER BY 2 DESC
		   ) t1
	LIMIT 1
	)
GROUP BY 1

-- OR -- Better way

SELECT r.name rname, SUM(o.total_amt_usd) total_sales, 
	   COUNT(o.id) order_count
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


/*
3. How many accounts had more total purchases than the 
account name which has bought the most standard_qty 
paper throughout their lifetime as a customer?
*/

SELECT COUNT(*) 
FROM
	(SELECT a.name aname, SUM(o.total) total_qty
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > 
		(SELECT total_qty
		FROM 
			(SELECT a.name aname, 
				SUM(o.standard_qty) std_qty,
				SUM(o.total) total_qty
			FROM orders o
			JOIN accounts a
			ON a.id = o.account_id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1) t1
		)
	) t3

-- OR with WITH

WITH t1 AS (
  SELECT a.name account_name, 
  SUM(o.standard_qty) total_std, SUM(o.total) total
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1), 
t2 AS (
  SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total FROM t1)
  )

SELECT COUNT(*)
FROM t2;

/*
4. For the customer that spent the most (in total over 
their lifetime as a customer) total_amt_usd, how many 
web_events did they have for each channel?
*/

SELECT w.channel, COUNT(*)
FROM web_events w
JOIN accounts a
ON a.id = w.account_id and a.name = (SELECT aname
FROM
	(SELECT a.name aname, SUM(total_amt_usd) total_spent
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1) t1
)
GROUP BY 1
ORDER BY 2 DESC

-- OR with WITH

WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;


/*
5. What is the lifetime average amount spent in terms 
of total_amt_usd for the top 10 total spending 
accounts?
*/

SELECT AVG(total_sales) lifetime_avg
FROM (
  SELECT a.id, SUM(o.total_amt_usd) total_sales
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  GROUP BY a.id
  LIMIT 10
) AS subq


/*
6. What is the lifetime average amount spent in terms 
of total_amt_usd, including only the companies that 
spent more per order, on average, than the average of 
all orders.
*/

SELECT AVG(acc_avg) lifetime_avg
FROM (
  SELECT a.id, AVG(o.total_amt_usd) acc_avg
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY a.id
  HAVING AVG(o.total_amt_usd) > 
         (SELECT AVG(total_amt_usd) FROM orders)
) AS subq


-- OR with WITH

WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;