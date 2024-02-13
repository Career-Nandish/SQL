# SQL Window Functions


/*
1. Create a running total of standard_amt_usd (in the 
orders table) over order time with no date truncation. 
Your final table should have two columns: one with the 
amount being added for each new row, and a second with 
the running total.
*/

SELECT standard_amt_usd, 
	   SUM(standard_amt_usd) 
	   		OVER (ORDER BY occurred_at)
FROM orders;



/*
2.  create a running total of standard_amt_usd (in the 
orders table) over order time, but this time, date 
truncate occurred_at by year and partition by that same 
year-truncated occurred_at variable. Your final table 
should have three columns: One with the amount being 
added for each row, one for the truncated date, and a 
final column with the running total within each year.
*/

SELECT standard_amt_usd, 
       DATE_TRUNC('year', occurred_at) year_order,
	   SUM(standard_amt_usd) 
	     OVER (
	     	PARTITION BY DATE_TRUNC('year', occurred_at) 
	     	ORDER BY occurred_at
	      )
FROM orders;

/*
3. Select the id, account_id, and total variable from 
the orders table, then create a column called 
total_rank that ranks this total amount of paper 
ordered (from highest to lowest) for each account 
using a partition. Your final table should have these 
four columns.
*/

SELECT id, account_id, total,
	   RANK() OVER (
         PARTITION BY account_id 
         ORDER BY total DESC
       )
FROM orders o;

/*
4. how the current order's total revenue ("total" 
meaning from sales of all types of paper) compares to 
the next order's total revenue.
*/

WITH total_sum AS (
SELECT occurred_at AS at, SUM(total_amt_usd) AS total
FROM orders
GROUP BY 1)

SELECT at, total, 
	LEAD(total) OVER (ORDER BY at),
    LEAD(total) OVER (ORDER BY at) - total AS lead_diff
FROM total_sum

/*
5. Use the NTILE functionality to divide the accounts 
into 4 levels in terms of the amount of standard_qty 
for their orders. Your resulting table should have the 
account_id, the occurred_at time for each order, the 
total amount of standard_qty paper purchased, and one 
of four levels in a standard_quartile column.
*/

SELECT account_id, occurred_at, standard_qty,
	   NTILE(4) OVER(PARTITION BY account_id ORDER BY standard_qty) AS std_quartile
FROM orders
ORDER BY account_id;


/*
6. Use the NTILE functionality to divide the accounts 
into two levels in terms of the amount of gloss_qty 
for their orders. Your resulting table should have the 
account_id, the occurred_at time for each order, the 
total amount of gloss_qty paper purchased, and one of 
two levels in a gloss_half column.
*/

SELECT account_id, occurred_at, gloss_qty,
	   NTILE(2) OVER(PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id;

/*
7. Use the NTILE functionality to divide the orders 
for each account into 100 levels in terms of the 
amount of total_amt_usd for their orders. Your 
resulting table should have the account_id, the 
occurred_at time for each order, the total amount of 
total_amt_usd paper purchased, and one of 100 levels 
in a total_percentile column.
*/

SELECT account_id, occurred_at, total_amt_usd,
	   NTILE(100) OVER(PARTITION BY account_id ORDER BY total_amt_usd) AS total_perc
FROM orders
ORDER BY account_id;