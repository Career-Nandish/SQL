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
```

Result:

<pre>

</pre>

### 4. What is the closing balance for each customer at the end of the month?

```SQL
```

Result:

<pre>

</pre>

### 5. What is the percentage of customers who increase their closing balance by more than 5%?

```SQL
```

Result:

<pre>

</pre>