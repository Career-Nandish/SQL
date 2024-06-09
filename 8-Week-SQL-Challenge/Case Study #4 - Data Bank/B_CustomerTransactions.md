## B. Customer Transactions

### 1. What is the unique count and total amount for each transaction type?

```SQL
SELECT txn_type,
       COUNT(*) AS unique_count,
       SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type
```

Result:

<pre>
  txn_type  | unique_count | total_amount 
------------+--------------+--------------
 purchase   |         1617 |       806537
 deposit    |         2671 |      1359168
 withdrawal |         1580 |       793003
</pre>

### 2. What is the average total historical deposit counts and amounts for all customers?

```SQL
SELECT ROUND(AVG(txn_count)) AS avg_txn_count,
       ROUND(AVG(total_amount), 2) AS avg_amount
FROM (
    SELECT customer_id,
           COUNT(*) AS txn_count,
           SUM(txn_amount) AS total_amount
    FROM customer_transactions
    WHERE txn_type = 'deposit'
    GROUP BY customer_id
) AS deposit_tran
```

Result:

<pre>
 avg_txn_count | avg_amount 
---------------+------------
             5 |    2718.34
</pre>

### 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

```SQL
SELECT month,
       COUNT(customer_id) AS customer_count
FROM (
    SELECT customer_id, DATE_PART('month', txn_date) AS month,
           COUNT(1) FILTER (WHERE txn_type = 'deposit') AS dep,
           COUNT(1) FILTER (WHERE txn_type = 'purchase') AS pur,
           COUNT(1) FILTER (WHERE txn_type = 'withdrawal') AS wit
    FROM customer_transactions
    GROUP BY customer_id, DATE_PART('month', txn_date)
) AS monthly_transaction_count
WHERE dep > 1 AND (pur = 1 OR wit = 1)
GROUP BY month
ORDER BY month
```

Result:

<pre>
 month | customer_count 
-------+----------------
     1 |            115
     2 |            108
     3 |            113
     4 |             50
</pre>

### 4. What is the closing balance for each customer at the end of the month?

```SQL
WITH RECURSIVE gen_dates AS (
    SELECT DISTINCT customer_id,
           '2020-01-31'::DATE AS last_dd
    FROM customer_transactions
    UNION ALL
    SELECT customer_id,
            (last_dd + INTERVAL '1 month')::DATE AS last_dd
    FROM gen_dates
    WHERE (last_dd + INTERVAL '1 month')::DATE < '2020-12-31'
),
modify_gen_dates AS (
  SELECT customer_id, 
         (DATE_trunc('month', last_dd) + INTERVAL '1 month - 1 day')::DATE AS last_date
  FROM gen_dates
),
monthly_transactions AS (
    SELECT customer_id,
           (DATE_trunc('month', txn_date) + INTERVAL '1 month - 1 day')::DATE AS last_date,
           SUM(CASE
               WHEN txn_type = 'deposit' THEN txn_amount
               ELSE txn_amount * -1
           END) as monthly_amount
    FROM customer_transactions
    GROUP BY customer_id, last_date
),
customer_last_month AS (
    SELECT customer_id,
           MAX(last_date) AS last_date
    FROM monthly_transactions
    GROUP BY customer_id
),
EOM_balances AS (
    SELECT g.customer_id,
           g.last_date,
           COALESCE(m.monthly_amount, 0) AS EOM_bal,
           SUM(m.monthly_amount) OVER win AS running_EOM_bal
    FROM modify_gen_dates g
    LEFT JOIN monthly_transactions m
        ON g.customer_id = m.customer_id AND
            g.last_date = m.last_date
    WINDOW win AS (PARTITION BY g.customer_id ORDER BY g.last_date ROWS UNBOUNDED PRECEDING)
)


SELECT e.customer_id,
       e.last_date,
       DATE_PART('month', e.last_date) AS month,
       e.EOM_bal,
       e.running_EOM_bal
FROM EOM_balances e
JOIN customer_last_month c
    ON e.customer_id = c.customer_id AND
        e.last_date <= c.last_date
```

Result: 

<pre>
 customer_id | last_date  | month | eom_bal | running_eom_bal 
-------------+------------+-------+---------+-----------------
           1 | 2020-01-31 |     1 |     312 |             312
           1 | 2020-02-29 |     2 |       0 |             312
           1 | 2020-03-31 |     3 |    -952 |            -640
           2 | 2020-01-31 |     1 |     549 |             549
           2 | 2020-02-29 |     2 |       0 |             549
           2 | 2020-03-31 |     3 |      61 |             610
           3 | 2020-01-31 |     1 |     144 |             144
           3 | 2020-02-29 |     2 |    -965 |            -821
           3 | 2020-03-31 |     3 |    -401 |           -1222
           3 | 2020-04-30 |     4 |     493 |            -729
           4 | 2020-01-31 |     1 |     848 |             848
           4 | 2020-02-29 |     2 |       0 |             848
           4 | 2020-03-31 |     3 |    -193 |             655
           5 | 2020-01-31 |     1 |     954 |             954
           5 | 2020-02-29 |     2 |       0 |             954
           5 | 2020-03-31 |     3 |   -2877 |           -1923
           5 | 2020-04-30 |     4 |    -490 |           -2413
           . |      .     |     . |      .  |              .
           . |      .     |     . |      .  |              .
           . |      .     |     . |      .  |              .
           . |      .     |     . |      .  |              .
</pre>

### 5. What is the percentage of customers who increase their closing balance by more than 5%?

```SQL
```

Result:

<pre>

</pre>