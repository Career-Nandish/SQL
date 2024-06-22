## C. Data Allocation Challenge

### To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:

### &nbsp;&nbsp;&nbsp;&#9679; Option 1: data is allocated based off the amount of money at the end of the previous month
### &nbsp;&nbsp;&nbsp;&#9679; Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
### &nbsp;&nbsp;&nbsp;&#9679; Option 3: data is updated real-time

### For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:

### &nbsp;&nbsp;&nbsp;&#9679; running customer balance column that includes the impact each transaction

```SQL
SELECT *,
       SUM(
           CASE
               WHEN txn_type = 'deposit' THEN txn_amount
               ELSE txn_amount * -1
           END
       ) OVER (PARTITION BY customer_id ORDER BY txn_date) AS running_balance
FROM customer_transactions
```

Result:

<pre>
 customer_id |  txn_date  |  txn_type  | txn_amount | running_balance 
-------------+------------+------------+------------+-----------------
           1 | 2020-01-02 | deposit    |        312 |             312
           1 | 2020-03-05 | purchase   |        612 |            -300
           1 | 2020-03-17 | deposit    |        324 |              24
           1 | 2020-03-19 | purchase   |        664 |            -640
           2 | 2020-01-03 | deposit    |        549 |             549
           2 | 2020-03-24 | deposit    |         61 |             610
           3 | 2020-01-27 | deposit    |        144 |             144
           3 | 2020-02-22 | purchase   |        965 |            -821
           3 | 2020-03-05 | withdrawal |        213 |           -1034
           3 | 2020-03-19 | withdrawal |        188 |           -1222
           . |      .     |     .      |         .  |              .
           . |      .     |     .      |         .  |              .
           . |      .     |     .      |         .  |              .
           . |      .     |     .      |         .  |              .
</pre>

### &nbsp;&nbsp;&nbsp;&#9679; customer balance at the end of each month

```SQL
-- Consider CTEs from B.4, B.5
SELECT *
FROM EOM_balances
```

Result:

<pre>
customer_id | last_date  | eom_bal | running_eom_bal 
-------------+------------+---------+-----------------
           1 | 2020-01-31 |     312 |             312
           1 | 2020-02-29 |       0 |             312
           1 | 2020-03-31 |    -952 |            -640
           1 | 2020-04-30 |       0 |            -640
           1 | 2020-05-31 |       0 |            -640
           1 | 2020-06-30 |       0 |            -640
           1 | 2020-07-31 |       0 |            -640
           1 | 2020-08-31 |       0 |            -640
           1 | 2020-09-30 |       0 |            -640
           1 | 2020-10-31 |       0 |            -640
           1 | 2020-11-30 |       0 |            -640
           1 | 2020-12-31 |       0 |            -640
           2 | 2020-01-31 |     549 |             549
           2 | 2020-02-29 |       0 |             549
           2 | 2020-03-31 |      61 |             610
           2 | 2020-04-30 |       0 |             610
           2 | 2020-05-31 |       0 |             610
           2 | 2020-06-30 |       0 |             610
           2 | 2020-07-31 |       0 |             610
           2 | 2020-08-31 |       0 |             610
           2 | 2020-09-30 |       0 |             610
           2 | 2020-10-31 |       0 |             610
           2 | 2020-11-30 |       0 |             610
           2 | 2020-12-31 |       0 |             610
           . |      .     |       . |              .  
           . |      .     |       . |              .  
           . |      .     |       . |              .  
           . |      .     |       . |              .  
</pre>


### &nbsp;&nbsp;&nbsp;&#9679; minimum, average and maximum values of the running balance for each customer

```SQL
SELECT *, 
       MIN(running_balance) OVER (PARTITION BY customer_id) AS min_balance,
       ROUND(AVG(running_balance) OVER (PARTITION BY customer_id), 2) AS avg_balance,
       MAX(running_balance) OVER (PARTITION BY customer_id) AS max_balance
FROM (
    SELECT *,
           SUM(
               CASE
                   WHEN txn_type = 'deposit' THEN txn_amount
                   ELSE txn_amount * -1
               END
           ) OVER (PARTITION BY customer_id ORDER BY txn_date) AS running_balance
    FROM customer_transactions
) AS running_bal
```

Result:

<pre>
 customer_id |  txn_date  |  txn_type  | txn_amount | running_balance | min_bal | avg_bal  | max_bal 
-------------+------------+------------+------------+-----------------+---------+----------+---------
           1 | 2020-01-02 | deposit    |        312 |             312 |    -640 |  -151.00 |     312
           1 | 2020-03-05 | purchase   |        612 |            -300 |    -640 |  -151.00 |     312
           1 | 2020-03-17 | deposit    |        324 |              24 |    -640 |  -151.00 |     312
           1 | 2020-03-19 | purchase   |        664 |            -640 |    -640 |  -151.00 |     312
           2 | 2020-01-03 | deposit    |        549 |             549 |     549 |   579.50 |     610
           2 | 2020-03-24 | deposit    |         61 |             610 |     549 |   579.50 |     610
           3 | 2020-01-27 | deposit    |        144 |             144 |   -1222 |  -732.40 |     144
           3 | 2020-02-22 | purchase   |        965 |            -821 |   -1222 |  -732.40 |     144
           3 | 2020-03-05 | withdrawal |        213 |           -1034 |   -1222 |  -732.40 |     144
           3 | 2020-03-19 | withdrawal |        188 |           -1222 |   -1222 |  -732.40 |     144
           3 | 2020-04-12 | deposit    |        493 |            -729 |   -1222 |  -732.40 |     144
           4 | 2020-01-07 | deposit    |        458 |             458 |     458 |   653.67 |     848
           4 | 2020-01-21 | deposit    |        390 |             848 |     458 |   653.67 |     848
           4 | 2020-03-25 | purchase   |        193 |             655 |     458 |   653.67 |     848
           . |      .     |     .      |         .  |              .  |       . |      .   |      .
           . |      .     |     .      |         .  |              .  |       . |      .   |      . 
           . |      .     |     .      |         .  |              .  |       . |      .   |      .
           . |      .     |     .      |         .  |              .  |       . |      .   |      . 
</pre>

### Using all of the data available - how much data would have been required for each option on a monthly basis?

#### &nbsp;&nbsp;&nbsp;&#9679; Option 1: data is allocated based off the amount of money at the end of the previous month


```SQL
SELECT DATE_PART('month', txn_date) AS month,
       SUM(CASE
               WHEN txn_type = 'deposit' THEN txn_amount
               ELSE txn_amount * -1
           END
       ) AS monthly_date
FROM customer_transactions
GROUP BY DATE_PART('month', txn_date)
ORDER BY month
```

Result:

<pre>
month | monthly_date 
-------+--------------
     1 |       126091
     2 |      -139799
     3 |      -170884
     4 |       -55780
</pre>

As you can see that if we consider running total of each month as data, some data is in negative. We could either only consider `txn_type = deposit` for data allocation and then the montly running total would be positive and we can rely on that for data allocation.

#### &nbsp;&nbsp;&nbsp;&#9679; Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days

*is it me or these questions are hard to understand??*

```SQL

```

Result:

<pre>

</pre>


#### &nbsp;&nbsp;&nbsp;&#9679; Option 3: data is updated real-time 

```SQL
```

Result:

<pre>

</pre>