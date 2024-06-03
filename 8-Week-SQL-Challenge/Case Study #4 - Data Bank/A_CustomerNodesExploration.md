## A. Customer Nodes Exploration

### 1. How many unique nodes are there on the Data Bank system?

```SQL
SELECT COUNT(DISTINCT node_id) AS unique_nodes
FROM customer_nodes
```

Result:

<pre>
 unique_nodes 
--------------
            5
</pre>

### 2. What is the number of nodes per region?

```SQL
SELECT r.region_id,
       r.region_name,
       subq.total_nodes
FROM (
    SELECT region_id,
           COUNT(node_id) AS total_nodes
    FROM customer_nodes
    GROUP BY region_id
) subq
JOIN regions r
    ON r.region_id = subq.region_id
```

Result:

<pre>
 region_id | region_name | total_nodes 
-----------+-------------+-------------
         1 | Australia   |         770
         2 | America     |         735
         5 | Europe      |         616
         4 | Asia        |         665
         3 | Africa      |         714
</pre>

### 3. How many customers are allocated to each region?

```SQL
SELECT r.region_id,
       r.region_name,
       subq.total_customers
FROM (
    SELECT region_id, 
           COUNT(DISTINCT customer_id) AS total_customers
    FROM customer_nodes
    GROUP BY region_id
) subq
JOIN regions r
    ON subq.region_id = r.region_id
```

Result:

<pre>
 region_id | region_name | total_customers 
-----------+-------------+-----------------
         1 | Australia   |             110
         2 | America     |             105
         3 | Africa      |             102
         4 | Asia        |              95
         5 | Europe      |              88
</pre>

### 4. How many days on average are customers reallocated to a different node?

```SQL
SELECT ROUND(AVG(moving_days)) AS avg_moving_days
FROM (
    SELECT LEAD(first_date) OVER (PARTITION BY customer_id ORDER BY first_date) - first_date AS moving_days
    FROM (
        SELECT customer_id,
               region_id,
               node_id,
               MIN(start_date) AS first_date
        FROM customer_nodes
        GROUP BY customer_id, region_id, node_id
    ) AS min_dates
) AS diff_dates
```

Result:

<pre>
 avg_moving_days 
-----------------
              24
</pre>

### 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

```SQL
WITH min_dates AS (
    SELECT customer_id,
           region_id,
           node_id,
           MIN(start_date) AS first_date
    FROM customer_nodes
    GROUP BY customer_id, region_id, node_id
), moving_days_tab AS (
    SELECT region_id,
           LEAD(first_date) OVER (PARTITION BY customer_id ORDER BY first_date) - first_date AS moving_days
    FROM min_dates
), perc_region_moving_days AS (
    SELECT region_id,
           percentile_cont(0.5) WITHIN GROUP (ORDER BY moving_days) AS median,
           percentile_cont(0.8) WITHIN GROUP (ORDER BY moving_days) AS prcntl_80,
           percentile_cont(0.95) WITHIN GROUP (ORDER BY moving_days) AS prcntl_95
    FROM moving_days_tab
    WHERE moving_days IS NOT NULL
    GROUP BY region_id
)

SELECT r.region_id,
       r.region_name,
       ROUND(p.median) AS median,
       ROUND(p.prcntl_80) AS prcntl_80,
       ROUND(p.prcntl_95) AS prcntl_95
FROM perc_region_moving_days p
JOIN regions r
    ON p.region_id = r.region_id
```

Result:

<pre>
 region_id | region_name | median | prcntl_80 | prcntl_95 
-----------+-------------+--------+-----------+-----------
         1 | Australia   |     22 |        31 |        54
         2 | America     |     21 |        33 |        57
         3 | Africa      |     21 |        33 |        59
         4 | Asia        |     22 |        32 |        50
         5 | Europe      |     22 |        31 |        54
</pre>