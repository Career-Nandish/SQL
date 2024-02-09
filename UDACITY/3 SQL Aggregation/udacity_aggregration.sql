# Aggregation Questions


/*
1. Find the total amount of poster_qty paper ordered in 
the orders table.
*/

SELECT SUM(poster_qty) total_poster_qty
FROM orders;

/*
2. Find the total amount of standard_qty paper ordered 
in the orders table.
*/

SELECT SUM(standard_qty) total_standard_qty
FROM orders;

/*
3. Find the total dollar amount of sales using the 
total_amt_usd in the orders table.
*/

SELECT SUM(total_amt_usd) total_amount_usd
FROM orders;

/*
4. Find the total amount spent on standard_amt_usd and 
gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the 
table.
*/

SELECT SUM(standard_amt_usd) std_amount_usd, 
SUM(gloss_amt_usd) gloss_amount_usd
FROM orders;

/*
5. Find the standard_amt_usd per unit of standard_qty 
paper. Your solution should use both an aggregation and 
a mathematical operator.
*/

SELECT SUM(standard_amt_usd)/SUM(standard_qty) 
AS unit_price_standard
FROM orders;


-----------------------------------
-----------------------------------


# Questions: MIN, MAX, & AVERAGE

/*
1. When was the earliest order ever placed? You only 
need to return the date.
*/

SELECT MIN(occurred_at) 
FROM orders;

/*
2. Try performing the same query as in question 1 
without using an aggregation function.
*/

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;


SELECT occurred_at
FROM orders
ORDER BY 1
LIMIT 1;


/*
3. When did the most recent (latest) web_event occur?
*/

SELECT MAX(occurred_at)
FROM web_events;

/*
4. Try to perform the result of the previous query 
without using an aggregation function.
*/

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;


SELECT occurred_at
FROM web_events
ORDER BY 1 DESC
LIMIT 1;


/*
5. Find the mean (AVERAGE) amount spent per order on 
each paper type, as well as the mean amount of each 
paper type purchased per order. Your final answer 
should have 6 values - one for each paper type for the 
average number of sales, as well as the average amount.
*/

SELECT AVG(standard_qty) mean_standard, 
AVG(gloss_qty) mean_gloss, 
AVG(poster_qty) mean_poster, 
AVG(standard_amt_usd) mean_standard_usd, 
AVG(gloss_amt_usd) mean_gloss_usd, 
AVG(poster_amt_usd) mean_poster_usd
FROM orders;

/*
6. Via the video, you might be interested in how to 
calculate the MEDIAN. Though this is more advanced than 
what we have covered so far try finding - what is the 
MEDIAN total_usd spent on all orders?
*/

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;


-----------------------------------
-----------------------------------


# Questions: GROUP BY


/*
1. Which account (by name) placed the earliest order? 
Your solution should have the account name and the date 
of the order.
*/


SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;


SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a
ON o.account_id = a.id
ORDER BY 2
LIMIT 1;


/*
2. Find the total sales in usd for each account. You 
should include two columns - the total sales for each 
company's orders in usd and the company name.
*/


SELECT a.name, SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total_sales DESC;


SELECT a.name, SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;


/*
3. Via what channel did the most recent (latest) 
web_event occur, which account was associated with this 
web_event? Your query should return only three values - 
the date, channel, and account name.
*/


SELECT w.channel, a.name, w.occurred_at
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;


SELECT w.channel, a.name, w.occurred_at
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY 3 DESC
LIMIT 1;


/*
4. Find the total number of times each type of channel 
from the web_events was used. Your final table should 
have two columns - the channel and the number of times 
the channel was used.
*/


SELECT channel, COUNT(*) times_used
FROM web_events
GROUP BY channel
ORDER BY times_used DESC;


SELECT channel, COUNT(*) times_used
FROM web_events
GROUP BY 1
ORDER BY 2 DESC;


/*
5. Who was the primary contact associated with the 
earliest web_event?
*/


SELECT w.occurred_at, a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1; 


SELECT w.occurred_at, a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY 1
LIMIT 1; 


/*
6. What was the smallest order placed by each account 
in terms of total usd. Provide only two columns - the 
account name and the total usd. Order from smallest 
dollar amounts to largest.
*/


SELECT a.name, MIN(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_usd;


SELECT a.name, MIN(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2;


/*
7. Find the number of sales reps in each region. Your 
final table should have two columns - the region and 
the number of sales_reps. Order from fewest reps to 
most reps.
*/


SELECT r.name, COUNT(*) total_sales_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY total_sales_reps;


SELECT r.name, COUNT(*) total_sales_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY 1
ORDER BY 2;


-----------------------------------
-----------------------------------


# Questions: GROUP BY Part II


/*
1. For each account, determine the average amount of 
each type of paper they purchased across their orders. 
Your result should have four columns - one for the 
account name and one for the average quantity purchased 
for each of the paper types for each account.
*/


SELECT a.name, AVG(standard_qty) standard_avg, 
AVG(gloss_qty) gloss_avg, AVG(poster_qty) poster_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;


SELECT a.name, AVG(standard_qty) standard_avg, 
AVG(gloss_qty) gloss_avg, AVG(poster_qty) poster_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 1;


/*
2. For each account, determine the average amount spent 
per order on each paper type. Your result should have 
four columns - one for the account name and one for the 
average amount spent on each paper type.
*/


SELECT a.name, AVG(standard_amt_usd) standard_amt, 
AVG(gloss_amt_usd) gloss_amt, 
AVG(poster_amt_usd) poster_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;


SELECT a.name, AVG(standard_amt_usd) standard_amt, 
AVG(gloss_amt_usd) gloss_amt, 
AVG(poster_amt_usd) poster_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 1;


/*
3. Determine the number of times a particular channel 
was used in the web_events table for each sales rep. 
Your final table should have three columns - the name 
of the sales rep, the channel, and the number of 
occurrences. Order your table with the highest number 
of occurrences first.
*/


SELECT s.name, w.channel, COUNT(*) num_occ
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name, w.channel
ORDER BY num_occ DESC;


SELECT s.name, w.channel, COUNT(*) num_occ
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1, 2
ORDER BY 3 DESC;


/*
4. Determine the number of times a particular channel 
was used in the web_events table for each region. Your 
final table should have three columns - the region name, 
the channel, and the number of occurrences. Order your 
table with the highest number of occurrences first.
*/


SELECT r.name, w.channel, COUNT(*) num_occ
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY r.name, w.channel
ORDER BY num_occ DESC;


SELECT r.name, w.channel, COUNT(*) num_occ
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1, 2
ORDER BY 3 DESC;


-----------------------------------
-----------------------------------


# Questions: DISTINCT


/*
1. Use DISTINCT to test if there are any accounts 
associated with more than one region.
*/


SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;


SELECT DISTINCT id, name
FROM accounts;


/*
2. Have any sales reps worked on more than one account?
*/


SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;


SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1, 2
ORDER BY 3;


SELECT DISTINCT id, name
FROM sales_reps;


-----------------------------------
-----------------------------------


# Questions: HAVING

# NOTE
/*
HAVING is the “clean” way to filter a query that has 
been aggregated, but this is also commonly done using 
a subquery. Essentially, any time you want to perform 
a WHERE on an element of your query that was created 
by an aggregate, you need to use HAVING instead.
*/


/*
1. How many of the sales reps have more than 5 accounts 
that they manage?
*/

SELECT s.id, s.name COUNT(a.id) num_accounts
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name # GROUP BY 1, 2
HAVING COUNT(a.id) > 5
ORDER BY num_accounts DESC; # ORDER BY 2 DESC


/*
2. How many accounts have more than 20 orders?
*/

SELECT a.id, a.name, COUNT(o.id) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING COUNT(o.id) > 20
ORDER BY 3 DESC; # ORDER BY num_orders


/*
3. Which account has the most orders?
*/

SELECT a.id, a.name, COUNT(o.id) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING COUNT(o.id) > 20
ORDER BY 3 DESC # ORDER BY num_orders
LIMIT 1; 


/*
4. Which accounts spent more than 30,000 usd total 
across all orders?
*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING SUM(o.total) > 30000
ORDER BY 3 DESC; # ORDER BY total_amt


/*
5. Which accounts spent less than 1,000 usd total 
across all orders?
*/

SELECT a.id, a.name, SUM(o.total) total_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING SUM(o.total) < 1000
ORDER BY 3; # ORDER BY total_amt

/*
6. Which account has spent the most with us?
*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
ORDER BY 3 DESC # ORDER BY total_amt
LIMIT 1; 


/*
7. Which account has spent the least with us?
*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1, 2 # GROUP BY a.id, a.name
ORDER BY 3 # ORDER BY total_amt
LIMIT 1; 


/*
8. Which accounts used facebook as a channel to contact 
customers more than 6 times?
*/

SELECT a.id, a.name, COUNT(*) times_used
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY 1, 2 # GROUP BY a.id, a.name
HAVING COUNT(*) > 6 # HAVING COUNT(*) > 6 
                    # AND w.channel = 'facebook'
ORDER BY 3 DESC; # ORDER BY times_used


/*
9. Which account used facebook most as a channel?
*/

SELECT a.id, a.name, COUNT(*) times_used
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY 1, 2 # GROUP BY a.id, a.name
ORDER BY 3 DESC # ORDER BY times_used
LIMIT 1;


/*
10. Which channel was most frequently used by most 
accounts?
*/

SELECT a.id, a.name, w.channel, COUNT(*) times_used
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1, 2, 3 # GROUP BY a.id, a.name, w.channel
ORDER BY 4 DESC # ORDER BY times_used
LIMIT 20;


-----------------------------------
-----------------------------------


# DATE FUNCTIONS


/*
GROUPing BY a date column is not usually very useful in 
SQL, as these columns tend to have transaction data 
down to a second. Keeping date information at such a 
granular data is both a blessing and a curse, as it 
gives really precise information (a blessing), but it 
makes grouping information together directly difficult 
(a curse).

Lucky for us, there are a number of built in SQL 
functions that are aimed at helping us improve our 
experience in working with dates.

The first function you are introduced to in working 
with dates is DATE_TRUNC.

DATE_TRUNC allows you to truncate your date to a 
particular part of your date-time column. Common 
trunctions are day, month, and year. Here is a great 
blog post by Mode Analytics on the power of this 
function.

DATE_PART can be useful for pulling a specific portion 
of a date, but notice pulling month or day of the week 
(dow) means that you are no longer keeping the years 
in order. Rather you are grouping for certain 
components regardless of which year they belonged in.

For additional functions you can use with dates, check 
out the documentation here, but the DATE_TRUNC and 
DATE_PART functions definitely give you a great start!
*/


/*
1. Find the sales in terms of total dollars for all 
orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals?
*/

SELECT DATE_TRUNC('year', occurred_at) year_order,
       # DATE_PART('year', occurred_at) year_order,
SUM(total_amt_usd) total_amt_usd
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/* 
When we look at the yearly totals, you might notice 
that 2013 and 2017 have much smaller totals than all 
other years. If we look further at the monthly data, 
we see that for 2013 and 2017 there is only one month 
of sales for each of these years (12 for 2013 and 1 
for 2017). Therefore, neither of these are evenly 
represented. Sales have been increasing year over year, 
with 2016 being the largest sales to date. At this rate, 
we might expect 2017 to have the largest sales.
*/


/*
2. Which month did Parch & Posey have the greatest 
sales in terms of total dollars? Are all months evenly 
represented by the dataset?
*/

SELECT DATE_PART('month', occurred_at) month_order,
SUM(total_amt_usd) total_amt_usd
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
# December


/*
3. Which year did Parch & Posey have the greatest sales 
in terms of total number of orders? Are all years 
evenly represented by the dataset?
*/

SELECT DATE_PART('year', occurred_at) month_order,
COUNT(*) total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
# 2016. 
# NO, year 13 and 17 are not


/*
4. Which month did Parch & Posey have the greatest 
sales in terms of total number of orders? Are all 
months evenly represented by the dataset?
*/

SELECT DATE_PART('month', occurred_at) month_order,
COUNT(*) total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
# December

/*
5. In which month of which year did Walmart spend the 
most on gloss paper in terms of dollars?
*/


SELECT a.name, 
DATE_TRUNC('month', o.occurred_at) month_order,
SUM(o.gloss_amt_usd) as gloss_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC;
# May 2016


-----------------------------------
-----------------------------------


# CASE Statement

/*
The CASE statement always goes in the SELECT clause.

CASE must include the following components: WHEN, THEN, 
and END. ELSE is an optional component to catch cases 
that didn’t meet any of the other previous CASE 
conditions.

CASE WHEN <statement> THEN <value> END

You can make any conditional statement using any 
conditional operator (like WHERE) between WHEN and 
THEN. This includes stringing together multiple 
conditional statements using AND and OR.

You can include multiple WHEN statements, as well as 
an ELSE statement again, to deal with any unaddressed 
conditions.
*/



/*
1. Write a query to display for each order, the account 
ID, total amount of the order, and the level of the 
order - ‘Large’ or ’Small’ - depending on if the order 
is $3000 or more, or smaller than $3000.
*/

SELECT o.account_id, o.total_amt_usd, 
	CASE WHEN o.total_amt_usd >= 3000 
		THEN 'Large' ELSE 'Small' END AS Level
FROM orders o;


/*
2. Write a query to display the number of orders in 
each of three categories, based on the total number of 
items in each order. The three categories are: 
'At Least 2000', 'Between 1000 and 2000' and 
'Less than 1000'.
*/

SELECT CASE 
			WHEN o.total >= 2000 THEN 'At Least 2000'
			WHEN o.total >= 1000 AND o.total < 2000 
				THEN 'Between 1000 and 2000'
			WHEN o.total < 1000 THEN 'Less than 1000'
	    END AS Order_Category, 
		COUNT(*) as total_orders
FROM orders o
GROUP BY 1;


/*
3. We would like to understand 3 different levels of 
customers based on the amount associated with their 
purchases. The top level includes anyone with a 
Lifetime Value (total sales of all orders) greater than 
200,000 usd. The second level is between 200,000 and 
100,000 usd. The lowest level is anyone under 100,000
usd. Provide a table that includes the level associated 
with each account. You should provide the account name, 
the total sales of all orders for the customer, and the 
level. Order with the top spending customers listed 
first.
*/

SELECT a.name, SUM(o.total_amt_usd) as total_sales,
       CASE
           WHEN SUM(o.total_amt_usd) > 200000 
               THEN 'TOP'
           WHEN SUM(o.total_amt_usd) >= 100000 AND
               SUM(o.total_amt_usd) <= 200000 
               THEN 'MIDDLE'
           WHEN SUM(o.total_amt_usd) < 100000 
               THEN 'LOWEST'
       END AS Level_Account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


/*
4. We would now like to perform a similar calculation 
to the first, but we want to obtain the total amount 
spent by customers only in 2016 and 2017. Keep the same 
levels as in the previous question. Order with the top 
spending customers listed first.
*/

SELECT a.name, SUM(o.total_amt_usd) as total_sales,
       CASE
           WHEN SUM(o.total_amt_usd) > 200000 
               THEN 'TOP'
           WHEN SUM(o.total_amt_usd) >= 100000 AND
               SUM(o.total_amt_usd) <= 200000 
               THEN 'MIDDLE'
           WHEN SUM(o.total_amt_usd) < 100000 
               THEN 'LOWEST'
       END AS Level_Account
FROM accounts a
JOIN orders o
ON a.id = o.account_id AND 
    o.occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;


/*
5. We would like to identify top performing sales reps, 
which are sales reps associated with more than 200 
orders. Create a table with the sales rep name, the 
total number of orders, and a column with top or not 
depending on if they have more than 200 orders. Place 
the top sales people first in your final table.
*/

SELECT s.name, COUNT(*) total_orders,
       CASE
           WHEN COUNT(*) > 200 THEN 'TOP' ELSE 'NOT TOP'
       END AS Level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


/*
6. The previous didn't account for the middle, nor the 
dollar amount associated with the sales. Management 
decides they want to see these characteristics 
represented as well. We would like to identify top 
performing sales reps, which are sales reps associated 
with more than 200 orders or more than 750000 in total 
sales. The middle group has any rep with more than 150 
orders or 500000 in sales. Create a table with the 
sales rep name, the total number of orders, total 
sales across all orders, and a column with top, middle, 
or low depending on this criteria. Place the top sales 
people based on dollar amount of sales first in your 
final table. You might see a few upset sales people by 
this criteria!
*/

SELECT s.name, COUNT(*) total_orders, 
       SUM(o.total_amt_usd) total_amt,
       CASE
           WHEN COUNT(*) > 200 OR 
                    SUM(o.total_amt_usd) > 750000
               THEN 'TOP'
           WHEN COUNT(*) > 150
               OR SUM(o.total_amt_usd) > 500000
               THEN 'MIDDLE'
           ELSE 'LOW'
       END AS Level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;