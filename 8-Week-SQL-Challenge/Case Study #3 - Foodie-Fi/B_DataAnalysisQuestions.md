## B. Data Analysis Questions

### 1. How many customers has Foodie-Fi ever had?

```SQL
SELECT COUNT(DISTINCT customer_id)
FROM subscriptions
```

Result:

<pre>
 Total Customers 
-----------------
            1000
</pre>


### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```SQL
SELECT DATE_PART('month', start_date) AS month, 
       COUNT(*) AS "# of free trials distributed"
FROM subscriptions
WHERE plan_id = 0
GROUP BY month
ORDER BY month
```

Result:

<pre>
 month | # of free trials distributed 
-------+------------------------------
     1 |                           88
     2 |                           68
     3 |                           94
     4 |                           81
     5 |                           88
     6 |                           79
     7 |                           89
     8 |                           88
     9 |                           87
    10 |                           79
    11 |                           75
    12 |                           84	
</pre>

* There's no discernible trend. A thing to note is that, Febuary has the lowest number of free trials given it has only 28 days. 

### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.

```SQL
SELECT p.plan_name, 
       COUNT(*) AS "Events Count"
FROM subscriptions s
JOIN plans p
    ON p.plan_id = s.plan_id AND
        DATE_PART('year', s.start_date) > 2020
GROUP BY p.plan_name
ORDER BY "Events Count" DESC
```

Result:

<pre>
   plan_name   | Events Count 
---------------+--------------
 churn         |           71
 pro annual    |           63
 pro monthly   |           60
 basic monthly |            8
</pre>

* After 2020, Most of the events are customer leaving the platform. 

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```SQL
WITH total_cust_count AS (
  SELECT COUNT(DISTINCT customer_id)
  FROM subscriptions
)

SELECT COUNT(DISTINCT customer_id) AS churned_cust_count,
       ROUND((COUNT(DISTINCT customer_id) * 100.0)/(SELECT * FROM total_cust_count), 1) AS churned_cust_perc
FROM subscriptions
WHERE plan_id = 4                 -- plan_id = 4 represents customers being churned
```

Result:

<pre>
 churned_cust_count | churned_cust_perc 
--------------------+-------------------
                307 |              30.7
</pre>


### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```SQL
```

Result:

<pre>
	
</pre>


### 6. What is the number and percentage of customer plans after their initial free trial?

```SQL
```

Result:

<pre>
	
</pre>


### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```SQL
```

Result:

<pre>
	
</pre>


### 8. How many customers have upgraded to an annual plan in 2020?

```SQL
```

Result:

<pre>
	
</pre>


### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```SQL
```

Result:

<pre>
	
</pre>


### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

```SQL
```

Result:

<pre>
	
</pre>


### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```SQL
```

Result:

<pre>
	
</pre>

