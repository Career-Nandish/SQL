## A. Customer Journey

### Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.


First, let's learn how to select 8 random customers from the `subscriptions` table. 

```SQL
SELECT customer_id
FROM subscriptions
ORDER BY RANDOM()
LIMIT 8
```

Result:

<pre>
 customer_id 
-------------
         777
          87
          31
         498
         441
         182
         871
         416
</pre>

Using above lines of code, we can select 8 random customers from the `subscriptions` table. The problem is that `RANDOM()` function will always choose random values between 0 and 1. For our purpose here we don't require that. We need same set of customers every time we run the code so we will use `SETSEED()` function to set the seed before calling the `RANDOM()` function which will return same set of customer all the time. 

Let's implement the above idea.


```SQL
SELECT setseed(0.652);

SELECT s.customer_id, 
       s.plan_id, 
       p.plan_name, 
       s.start_date
FROM subscriptions s
JOIN plans p
    ON s.plan_id = p.plan_id
WHERE s.customer_id IN (
                          SELECT customer_id
                          FROM subscriptions
                          ORDER BY RANDOM()
                          LIMIT 8
                      )
ORDER BY s.customer_id, s.plan_id
```

Result:

<pre>
 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
           2 |       0 | trial         | 2020-09-20
           2 |       3 | pro annual    | 2020-09-27
          26 |       0 | trial         | 2020-12-08
          26 |       2 | pro monthly   | 2020-12-15
          79 |       0 | trial         | 2020-07-30
          79 |       2 | pro monthly   | 2020-08-06
         178 |       0 | trial         | 2020-02-22
         178 |       4 | churn         | 2020-02-29
         373 |       0 | trial         | 2020-10-20
         373 |       1 | basic monthly | 2020-10-27
         373 |       2 | pro monthly   | 2020-11-03
         691 |       0 | trial         | 2020-06-15
         691 |       2 | pro monthly   | 2020-06-22
         691 |       3 | pro annual    | 2020-11-22
         830 |       0 | trial         | 2020-07-19
         830 |       1 | basic monthly | 2020-07-26
         830 |       2 | pro monthly   | 2020-12-26
         909 |       0 | trial         | 2020-09-09
         909 |       1 | basic monthly | 2020-09-16
         909 |       3 | pro annual    | 2021-01-18
</pre>


Now we have selected 8 random customers, let's go through their journeys.

1. `customer_id = 2`

<pre>
	 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
           2 |       0 | trial         | 2020-09-20
           2 |       3 | pro annual    | 2020-09-27
</pre>

* This customer started their 7-day trial plan on `2020-09-20` and after that they switched to `pro annual` plan from `2020-09-27` onwards.

2. `customer_id = 26`

<pre>
		 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
		  26 |       0 | trial         | 2020-12-08
          26 |       2 | pro monthly   | 2020-12-15
</pre>

* This customer started their 7-day trial plan on `2020-12-08` and after that they switched to `pro monthly` plan from `2020-12-15` onwards.


3. `customer_id = 79`

<pre>
		 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
          79 |       0 | trial         | 2020-07-30
          79 |       2 | pro monthly   | 2020-08-06
</pre>

* This customer started their 7-day trial plan on `2020-07-30` and after that they switched to `pro monthly` plan from `2020-08-06` onwards.


4. `customer_id = 178`

<pre>
		 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
         178 |       0 | trial         | 2020-02-22
         178 |       4 | churn         | 2020-02-29
</pre>

* This customer used their 7-day free trial from `2020-02-22` to `2020-02-29` and then never signed up for any paid plans.

5. `customer_id = 373`

<pre>
		 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
         373 |       0 | trial         | 2020-10-20
         373 |       1 | basic monthly | 2020-10-27
         373 |       2 | pro monthly   | 2020-11-03
</pre>

* After using their free 7-day trial, customer signed up for `basic monthly` plan from `2020-10-27` which they upgraded to `pro monthly` after just a week of usage. 

6. `customer_id = 691`

<pre>
		 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
         691 |       0 | trial         | 2020-06-15
         691 |       2 | pro monthly   | 2020-06-22
         691 |       3 | pro annual    | 2020-11-22
</pre>

* After using their free 7-day trial, customer signed up for `pro monthly` plan from `2020-06-22` which they switched to `pro annual` after 6 months of usage.

7. `customer_id = 830`          

<pre>
		 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
         830 |       0 | trial         | 2020-07-19
         830 |       1 | basic monthly | 2020-07-26
         830 |       2 | pro monthly   | 2020-12-26

</pre>

* After using their free 7-day trial, customer signed up for `basic monthly` plan from `2020-07-26` which they upgraded to `pro monthly` after 5 months of usage. 

8. `customer_id = 909`

<pre>
		 customer_id | plan_id |   plan_name   | start_date 
-------------+---------+---------------+------------
         909 |       0 | trial         | 2020-09-09
         909 |       1 | basic monthly | 2020-09-16
         909 |       3 | pro annual    | 2021-01-18
</pre>

* After using their free 7-day trial, customer signed up for `basic monthly` plan from `2020-09-16` which they switched to `pro annual` after about 4 months of usage.