## [1. [Easy]Histogram of Tweets](https://datalemur.com/questions/sql-histogram-tweets)

Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.

Table: `tweets`

| Column Name | Type      |
|-------------|-----------|
| tweet_id    | integer   |
| user_id     | integer   |
| msg         | string    |
| tweet_date  | timestamp |


```SQL
SELECT COUNT(user_id) AS tweet_bucket, num_users AS users_num
FROM (
  SELECT user_id, COUNT(tweet_id) AS num_users
  FROM tweets
  WHERE DATE_PART('year', tweet_date) = 2022
  GROUP BY user_id
) AS subq
GROUP BY num_users
ORDER BY num_users DESC
```

Result:

| tweet_bucket | users_num |
|:------------:|:---------:|
| 1            | 2         |
| 2            | 1         |


## [2. [Easy]Data Science Skills](https://datalemur.com/questions/matching-skills)

Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

Table: `Candidates`

| Column Name  | Type    |
|--------------|---------|
| candidate_id | integer |
| skill        | varchar |


```SQL
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'PostgreSQL', 'Tableau')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id
```

Result:

<pre>
| candidate_id |
|--------------|
| 123          |
| 147          |
</pre>


## [3. [Easy]Page With No Likes](https://datalemur.com/questions/sql-page-with-no-likes)

Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.

Table: `pages`

| Column Name | Type    |
|-------------|---------|
| page_id     | integer |
| page_name   | varchar |

Table: `page_likes`

| Column Name | Type     |
|-------------|----------|
| user_id     | integer  |
| page_id     | integer  |
| liked_date  | datetime |

```SQL
SELECT page_id
FROM pages
WHERE page_id NOT IN (SELECT page_id FROM page_likes)
```

Result:

<pre>
| page_id |
|---------|
| 20701   |
| 32728   |
</pre>


## [4. [Easy] Unfinished Parts](https://datalemur.com/questions/tesla-unfinished-parts)

Tesla is investigating production bottlenecks and they need your help to extract the relevant data. Write a query to determine which parts have begun the assembly process but are not yet finished.

Assumptions:

* `parts_assembly` table contains all parts currently in production, each at varying stages of the assembly process.
* An unfinished part is one that lacks a `finish_date`.

Table: `parts_assembly`

| Column Name   | Type     |
|---------------|----------|
| part          | string   |
| finish_date   | datetime |
| assembly_step | integer  |

```SQL
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;
```

Result:

<pre>
| part   | assembly_step |
|--------|---------------|
| bumper | 3             |
| bumper | 4             |
| engine | 5             |
</pre>


## [5. [Easy] Laptop vs. Mobile Viewership](https://datalemur.com/questions/laptop-mobile-viewership)

Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.

Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. Output the total viewership for laptops as `laptop_reviews` and the total viewership for mobile devices as `mobile_views`.

Table: `viewership`

| Column Name | Type                                 |
|-------------|--------------------------------------|
| user_id     | integer                              |
| device_type | string ('laptop', 'tablet', 'phone') |
| view_time   | timestamp                            |


```SQL
SELECT SUM(CASE
           WHEN device_type IN ('laptop') THEN 1 
       END) AS laptop_views,
       SUM(CASE
           WHEN device_type IN ('tablet', 'phone') THEN 1 
       END) AS mobile_views
FROM viewership
```

Result:

<pre>
| laptop_views | mobile_views |
|--------------|--------------|
| 2            | 3            |
</pre>


## [6. [Easy] Average Post Hiatus (Part 1)](https://datalemur.com/questions/sql-average-post-hiatus-1)

Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.

Table : `posts`

| Column Name  | Type      |
|--------------|-----------|
| user_id      | integer   |
| post_id      | integer   |
| post_content | text      |
| post_date    | timestamp |

```SQL
SELECT user_id,
       EXTRACT(Days FROM (MAX(post_date) - MIN(post_date))) AS days_between
FROM posts
WHERE DATE_PART('year', post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) >= 2
ORDER BY user_id
```

Result:

<pre>
| user_id | days_between |
|---------|--------------|
| 151652  | 307          |
| 661093  | 206          |
</pre>


## [7. [Easy] Teams Power Users](https://datalemur.com/questions/teams-power-users)

Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.

Assumption:

* No two users have sent the same number of messages in August 2022.

Table: `messages`

| Column Name | Type     |
|-------------|----------|
| message_id  | integer  |
| sender_id   | integer  |
| receiver_id | integer  |
| content     | varchar  |
| sent_date   | datetime |

```SQL
SELECT sender_id, 
       COUNT(message_id) AS message_count
FROM messages
WHERE DATE_TRUNC('month', sent_date) = '08/01/2022 00:00:00'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2
```

Result:

<pre>
| sender_id | message_count |
|-----------|---------------|
| 3601      | 4             |
| 2520      | 3             |
</pre>


## [8. [Easy] Duplicate Job Listings](https://datalemur.com/questions/duplicate-job-listings)

Assume you're given a table containing job postings from various companies on the LinkedIn platform. Write a query to retrieve the count of companies that have posted duplicate job listings.

Definition:

* Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions.

Table: `job_listings`

| Column Name | Type    |
|-------------|---------|
| job_id      | integer |
| company_id  | integer |
| title       | string  |
| description | string  |


```SQL
SELECT COUNT(company_id) AS duplicate_companies
FROM (
  SELECT company_id, 
         COUNT(*) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description
  HAVING COUNT(*) >= 2
) AS subq
```

Result:

<pre>
| duplicate_companies |
|---------------------|
| 3                   |
</pre>


## [9. [Easy] Average Review Ratings](https://datalemur.com/questions/sql-avg-review-ratings)

Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. Sort the output first by month and then by product ID.

Table: `reviews`

| Column Name | Type          |
|-------------|---------------|
| review_id   | integer       |
| user_id     | integer       |
| submit_date | datetime      |
| product_id  | integer       |
| stars       | integer (1-5) |


```SQL
SELECT DATE_PART('month', submit_date) AS month,
       product_id,
       ROUND(AVG(stars), 2) AS avg_rating
FROM reviews
GROUP BY DATE_PART('month', submit_date), product_id
ORDER BY DATE_PART('month', submit_date), product_id
```

Result:

<pre>
| month | product_id | avg_rating |
|-------|------------|------------|
| 5     | 25255      | 4.00       |
| 5     | 25600      | 4.33       |
| 6     | 12580      | 4.50       |
| 6     | 50001      | 3.50       |
| 6     | 69852      | 4.00       |
| 7     | 11223      | 5.00       |
| 7     | 69852      | 2.50       |
</pre>


## [10. [Easy] App Click-through Rate](https://datalemur.com/questions/click-through-rate)

Assume you have an events table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.

Definition and note:

* Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions

Table: `events`

| Column Name | Type     |
|-------------|----------|
| app_id      | integer  |
| event_type  | string   |
| timestamp   | datetime |

```SQL
SELECT app_id, 
       ROUND(clicks * 100.0 / impressions, 2) AS ctr
FROM (
    SELECT app_id,
           COUNT(1) FILTER (WHERE event_type = 'click') AS clicks,
           COUNT(1) FILTER (WHERE event_type = 'impression') AS impressions
    FROM events
    WHERE DATE_PART('year', timestamp) = 2022
    GROUP BY app_id
) AS event_types
```

Result:

<pre>
| app_id | ctr   |
|--------|-------|
| 123    | 66.67 |
| 234    | 33.33 |
</pre>


## [11. [Easy] Second Day Confirmation](https://datalemur.com/questions/second-day-confirmation)

Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account.

Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.

Definition:

* action_date refers to the date when users activated their accounts and confirmed their sign-up through text messages.

Table: `emails`

| Column Name | Type     |
|-------------|----------|
| email_id    | integer  |
| user_id     | integer  |
| signup_date | datetime |


Table: `texts`

| Column Name   | Type                                  |
|---------------|---------------------------------------|
| text_id       | integer                               |
| email_id      | integer                               |
| signup_action | string ('Confirmed', 'Not confirmed') |
| action_date   | datetime                              |

```SQL
SELECT e.user_id
FROM emails e
JOIN texts t
    ON e.email_id = t.email_id AND 
        t.signup_action = 'Confirmed' AND
            t.action_date = e.signup_date + INTERVAL '1 day'
```

Result:

<pre>
| user_id |
|---------|
| 1052    |
| 1235    |
</pre>


## [12. [Easy] IBM db2 Product Analytics](https://datalemur.com/questions/sql-ibm-db2-product-analytics)

IBM is analyzing how their employees are utilizing the Db2 database by tracking the SQL queries executed by their employees. The objective is to generate data to populate a histogram that shows the number of unique queries run by employees during the third quarter of 2023 (July to September). Additionally, it should count the number of employees who did not run any queries during this period.

Display the number of unique queries as histogram categories, along with the count of employees who executed that number of unique queries.

Table: `queries`

| Column Name     | Type     | Description                                         |
|-----------------|----------|-----------------------------------------------------|
| employee_id     | integer  | The ID of the employee who executed the query.      |
| query_id        | integer  | The unique identifier for each query (Primary Key). |
| query_starttime | datetime | The timestamp when the query started.               |
| execution_time  | integer  | The duration of the query execution in seconds.     |

Table: `employees`

| Column Name | Type    | Description                                    |
|-------------|---------|------------------------------------------------|
| employee_id | integer | The ID of the employee who executed the query. |
| full_name   | string  | The full name of the employee.                 |
| gender      | string  | The gender of the employee.                    |

```SQL
SELECT unique_queries,
       COUNT(employee_id) AS employee_count
FROM (
    SELECT e.employee_id,
           COALESCE(COUNT(DISTINCT q.query_id), 0) AS unique_queries
    FROM queries q
    RIGHT JOIN employees e
        ON q.employee_id = e.employee_id AND
               q.query_starttime >= '2023-07-01T00:00:00Z' AND 
                  q.query_starttime < '2023-10-01T00:00:00Z'
    GROUP BY e.employee_id
) AS queries_count
GROUP BY unique_queries
ORDER BY unique_queries
```

Result:

<pre>
| unique_queries | employee_count |
|----------------|----------------|
| 0              | 94             |
| 1              | 86             |
| 2              | 46             |
| 3              | 19             |
| 4              | 4              |
| 5              | 1              |
</pre>


## [13. [Easy] Cards Issued Difference](https://datalemur.com/questions/cards-issued-difference)

Your team at JPMorgan Chase is preparing to launch a new credit card, and to gain some insights, you're analyzing how many credit cards were issued each month.

Write a query that outputs the name of each credit card and the difference in the number of issued cards between the month with the highest issuance cards and the lowest issuance. Arrange the results based on the largest disparity.

Table: `monthly_cards_issued`

| Column Name   | Type    |
|---------------|---------|
| card_name     | string  |
| issued_amount | integer |
| issue_month   | integer |
| issue_year    | integer |


```SQL
SELECT card_name,
       MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC
```

Result:

<pre>
| card_name              | difference |
|------------------------|------------|
| Chase Sapphire Reserve | 30000      |
| Chase Freedom Flex     | 15000      |
</pre>


## [14. [Easy] Compressed Mean](https://datalemur.com/questions/alibaba-compressed-mean)

You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes information on the count of items in each order (`item_count` table) and the corresponding number of orders for each item count (`order_occurrences` table).

Table: `items_per_order`

| Column Name       | Type    |
|-------------------|---------|
| item_count        | integer |
| order_occurrences | integer |

```SQL
SELECT ROUND((SUM(item_count * order_occurrences)/SUM(order_occurrences))::NUMERIC, 1) AS mean
FROM items_per_order;
```

Result:

<pre>
| mean |
|------|
| 3.9  |
</pre>


## [15. [Easy] Pharmacy Analytics (Part 1)](https://datalemur.com/questions/top-profitable-drugs)

CVS Health is trying to better understand its pharmacy sales, and how well different products are selling. Each drug can only be produced by one manufacturer.

Write a query to find the top 3 most profitable drugs sold, and how much profit they made. Assume that there are no ties in the profits. Display the result from the highest to the lowest total profit.

Definition: cogs stands for Cost of Goods Sold which is the direct cost associated with producing the drug. Total Profit = Total Sales - Cost of Goods Sold

Table: `pharmacy_sales`

| Column Name  | Type    |
|--------------|---------|
| product_id   | integer |
| units_sold   | integer |
| total_sales  | decimal |
| cogs         | decimal |
| manufacturer | varchar |
| drug         | varchar |


```SQL
SELECT drug, 
       (total_sales - cogs) AS total_profit
FROM pharmacy_sales
ORDER BY total_profit DESC
LIMIT 3
```

Result:

<pre>
| drug     | total_profit |
|----------|--------------|
| Humira   | 81515652.55  |
| Keytruda | 11622022.02  |
| Dupixent | 11217052.34  |
</pre>


## [16. [Easy] Pharmacy Analytics (Part 2)](https://datalemur.com/questions/non-profitable-drugs)

CVS Health is analyzing its pharmacy sales data, and how well different products are selling in the market. Each drug is exclusively manufactured by a single manufacturer.

Write a query to identify the manufacturers associated with the drugs that resulted in losses for CVS Health and calculate the total amount of losses incurred.

Output the manufacturer's name, the number of drugs associated with losses, and the total losses in absolute value. Display the results sorted in descending order with the highest losses displayed at the top.

Table: `pharmacy_sales`

| Column Name  | Type    |
|--------------|---------|
| product_id   | integer |
| units_sold   | integer |
| total_sales  | decimal |
| cogs         | decimal |
| manufacturer | varchar |
| drug         | varchar |


```SQL
SELECT manufacturer,
       COUNT(drug) AS drug_count, 
       SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;
```

Result:

<pre>
| manufacturer          | drug_count | total_loss |
|-----------------------|------------|------------|
| Johnson &amp; Johnson | 6          | 894913.13  |
| Eli Lilly             | 4          | 447352.90  |
| Biogen                | 3          | 417018.89  |
| AbbVie                | 2          | 413991.10  |
| Roche                 | 2          | 159741.62  |
| Bayer                 | 1          | 28785.28   |
</pre>


## [17. [Easy] Pharmacy Analytics (Part 3)](https://datalemur.com/questions/total-drugs-sales)

CVS Health wants to gain a clearer understanding of its pharmacy sales and the performance of various products.

Write a query to calculate the total drug sales for each manufacturer. Round the answer to the nearest million and report your results in descending order of total sales. In case of any duplicates, sort them alphabetically by the manufacturer name.

Since this data will be displayed on a dashboard viewed by business stakeholders, please format your results as follows: "$36 million".

Table: `pharmacy_sales`

| Column Name  | Type    |
|--------------|---------|
| product_id   | integer |
| units_sold   | integer |
| total_sales  | decimal |
| cogs         | decimal |
| manufacturer | varchar |
| drug         | varchar |


```SQL
SELECT manufacturer,
       CONCAT('$', ROUND(SUM(total_sales)/1000000), ' million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer;
```

Result:

<pre>
| manufacturer          | sale         |
|-----------------------|--------------|
| AbbVie                | $114 million |
| Eli Lilly             | $77 million  |
| Biogen                | $70 million  |
| Johnson &amp; Johnson | $43 million  |
| Bayer                 | $34 million  |
| AstraZeneca           | $32 million  |
| Pfizer                | $28 million  |
| Novartis              | $26 million  |
| Sanofi                | $25 million  |
| Merck                 | $25 million  |
| Roche                 | $16 million  |
| GlaxoSmithKline       | $4 million   |
</pre>


## [18. [Easy] Patient Support Analysis (Part 1) ](https://datalemur.com/questions/frequent-callers)

UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy holders (or, members) to call an advocate and receive support for their health care needs – whether that's claims and benefits support, drug coverage, pre- and post-authorisation, medical records, emergency assistance, or member portal services.

Write a query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the `case_id` column.


Table: `callers`

| Column Name        | Type      |
|--------------------|-----------|
| policy_holder_id   | integer   |
| case_id            | varchar   |
| call_category      | varchar   |
| call_date          | timestamp |
| call_duration_secs | integer   |



```SQL
SELECT COUNT(*) AS policy_holder_count
FROM (
  SELECT policy_holder_id
  FROM callers
  GROUP BY policy_holder_id
  HAVING COUNT(case_id) >= 3
) AS sub
```

Result:

<pre>
| policy_holder_count |
|---------------------|
| 38                  |
</pre>


## [19. [Medium]User's Third Transaction](https://datalemur.com/questions/sql-third-transaction)

Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

Table: `transactions`

| Column Name      | Type      |
|------------------|-----------|
| user_id          | integer   |
| spend            | decimal   |
| transaction_date | timestamp |

```SQL
WITH ranking_users AS (
  SELECT user_id,
         spend,
         transaction_date,
         RANK() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rnk
  FROM transactions
)

SELECT user_id,
       spend,
       transaction_date
FROM ranking_users
WHERE rnk = 3
```

Result:

<pre>
| user_id | spend  | transaction_date    |
|---------|--------|---------------------|
| 111     | 89.60  | 02/05/2022 12:00:00 |
| 121     | 67.90  | 04/03/2022 12:00:00 |
| 263     | 100.00 | 07/12/2022 12:00:00 |
</pre>


## [20. [Medium] Second Highest Salary](https://datalemur.com/questions/sql-second-highest-salary)

Imagine you're an HR analyst at a tech company tasked with analyzing employee salaries. Your manager is keen on understanding the pay distribution and asks you to determine the second highest salary among all employees.

It's possible that multiple employees may share the same second highest salary. In case of duplicate, display the salary only once.

Table: `employee`

| column_name   | type    | description                        |
|---------------|---------|------------------------------------|
| employee_id   | integer | The unique ID of the employee.     |
| name          | string  | The name of the employee.          |
| salary        | integer | The salary of the employee.        |
| department_id | integer | The department ID of the employee. |
| manager_id    | integer | The manager ID of the employee.    |

```SQL
SELECT salary
FROM (
  SELECT employee_id,
         salary,
         RANK() OVER (ORDER BY salary DESC) AS rnk
  FROM employee
) AS ranking_salary
WHERE rnk = 2
```

Result:

<pre>
| salary |
|--------|
| 12500  |
</pre>


## [21. [Medium] Sending vs. Opening Snaps](https://datalemur.com/questions/time-spent-snaps)

Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

Calculate the following percentages:
    * Time spent sending / (Time spent sending + Time spent opening)
    * Time spent opening / (Time spent sending + Time spent opening)

Table: `activities`

| Column Name   | Type                            |
|---------------|---------------------------------|
| activity_id   | integer                         |
| user_id       | integer                         |
| activity_type | string ('send', 'open', 'chat') |
| time_spent    | float                           |
| activity_date | datetime                        |

Table: `age_breakdown`

| Column Name | Type                               |
|-------------|------------------------------------|
| user_id     | integer                            |
| age_bucket  | string ('21-25', '26-30', '31-25') |

```SQL
SELECT age_bucket,
       ROUND(send_time * 100.0/(send_time + open_time), 2) AS send_perc,
       ROUND(open_time * 100.0/(send_time + open_time), 2) AS open_perc
FROM (
  SELECT ag.age_bucket,
         SUM(ac.time_spent) FILTER (WHERE ac.activity_type = 'open') AS open_time,
         SUM(ac.time_spent) FILTER (WHERE ac.activity_type = 'send') AS send_time
  FROM activities ac
  JOIN age_breakdown ag
      ON ac.user_id = ag.user_id
  GROUP BY ag.age_bucket
) AS time_calc

```

Result:

<pre>
| age_bucket | send_perc | open_perc |
|------------|-----------|-----------|
| 21-25      | 54.31     | 45.69     |
| 26-30      | 82.26     | 17.74     |
| 31-35      | 37.84     | 62.16     |
</pre>


## [22. [Medium] Tweets' Rolling Averages](https://datalemur.com/questions/rolling-average-tweets)

Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.

Notes:

* A rolling average, also known as a moving average or running mean is a time-series technique that examines trends in data over a specified period of time.
* In this case, we want to determine how the tweet count for each user changes over a 3-day period.

Table: `tweets`

| Column Name | Type      |
|-------------|-----------|
| user_id     | integer   |
| tweet_date  | timestamp |
| tweet_count | integer   |

```SQL
SELECT user_id,
       tweet_date,
       ROUND(AVG(tweet_count) OVER win, 2) AS rolling_avg_3d
FROM tweets
WINDOW win AS (
                  PARTITION BY user_id ORDER BY tweet_date 
                  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
              )
```

Result:

<pre>
| user_id | tweet_date          | rolling_avg_3d |
|---------|---------------------|----------------|
| 111     | 06/01/2022 00:00:00 | 2.00           |
| 111     | 06/02/2022 00:00:00 | 1.50           |
| 111     | 06/03/2022 00:00:00 | 2.00           |
| 111     | 06/04/2022 00:00:00 | 2.67           |
| 111     | 06/05/2022 00:00:00 | 4.00           |
| 111     | 06/06/2022 00:00:00 | 4.33           |
| 111     | 06/07/2022 00:00:00 | 5.00           |
| 199     | 06/01/2022 00:00:00 | 7.00           |
| 199     | 06/02/2022 00:00:00 | 6.00           |
| 199     | 06/03/2022 00:00:00 | 7.00           |
| 199     | 06/04/2022 00:00:00 | 5.00           |
| 199     | 06/05/2022 00:00:00 | 6.00           |
| 199     | 06/06/2022 00:00:00 | 3.67           |
| 199     | 06/07/2022 00:00:00 | 4.00           |
| 254     | 06/01/2022 00:00:00 | 1.00           |
| 254     | 06/02/2022 00:00:00 | 1.00           |
| 254     | 06/03/2022 00:00:00 | 1.33           |
| 254     | 06/04/2022 00:00:00 | 1.33           |
| 254     | 06/05/2022 00:00:00 | 2.00           |
| 254     | 06/06/2022 00:00:00 | 1.67           |
| 254     | 06/07/2022 00:00:00 | 2.33           |
</pre>


## [23. [Medium] Highest-Grossing Items](https://datalemur.com/questions/sql-highest-grossing)

Assume you're given a table containing data on Amazon customers and their spending on products in different category, write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.

Table: `product_spend`

| Column Name      | Type      |
|------------------|-----------|
| category         | string    |
| product          | string    |
| user_id          | integer   |
| spend            | decimal   |
| transaction_date | timestamp |


```SQL
WITH tot_prod_spend_2022 AS (
    SELECT category,
           product,
           SUM(spend) AS total_spend,
           RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS rnk
    FROM product_spend
    WHERE DATE_PART('year', transaction_date) = 2022
    GROUP BY category, product
)

SELECT category,
       product,
       total_spend
FROM tot_prod_spend_2022
WHERE rnk <= 2
```

Result:

<pre>
| category    | product          | total_spend |
|-------------|------------------|-------------|
| appliance   | washing machine  | 439.80      |
| appliance   | refrigerator     | 299.99      |
| electronics | vacuum           | 486.66      |
| electronics | wireless headset | 467.89      |
</pre>


## [24. [Medium] Top Three Salaries](https://datalemur.com/questions/sql-top-three-salaries)

As part of an ongoing analysis of salary distribution within the company, your manager has requested a report identifying high earners in each department. A 'high earner' within a department is defined as an employee with a salary ranking among the top three salaries within that department.

You're tasked with identifying these high earners across all departments. Write a query to display the employee's name along with their department name and salary. In case of duplicates, sort the results of department name in ascending order, then by salary in descending order. If multiple employees have the same salary, then order them alphabetically.

Table: `employee`

| column_name   | type    | description                        |
|---------------|---------|------------------------------------|
| employee_id   | integer | The unique ID of the employee.     |
| name          | string  | The name of the employee.          |
| salary        | integer | The salary of the employee.        |
| department_id | integer | The department ID of the employee. |
| manager_id    | integer | The manager ID of the employee.    |

Table: `department`

| column_name     | type    | description                        |
|-----------------|---------|------------------------------------|
| department_id   | integer | The department ID of the employee. |
| department_name | string  | The name of the department.        |

```SQL
SELECT department_name,
       name,
       salary
FROM department d
JOIN (
    SELECT department_id,
           name,
           salary,
           DENSE_RANK() OVER w AS d_rnk
    FROM employee
    WINDOW w AS (PARTITION BY department_id ORDER BY salary DESC)
) AS rs
    ON d.department_id = rs.department_id AND
        rs.d_rnk <= 3
ORDER BY department_name, salary DESC, name
```

Result:

<pre>
| department_name  | name             | salary |
|------------------|------------------|--------|
| Data Analytics   | Olivia Smith     | 7000   |
| Data Analytics   | Amelia Lee       | 4000   |
| Data Analytics   | James Anderson   | 4000   |
| Data Analytics   | Emma Thompson    | 3800   |
| Data Engineering | Liam Brown       | 13000  |
| Data Engineering | Ava Garcia       | 12500  |
| Data Engineering | Isabella Wilson  | 11000  |
| Data Science     | Logan Moore      | 8000   |
| Data Science     | Charlotte Miller | 7000   |
| Data Science     | Noah Johnson     | 6800   |
| Data Science     | William Davis    | 6800   |
</pre>


## [25. [Medium] Top 5 Artists](https://datalemur.com/questions/top-fans-rank)

Assume there are three Spotify tables: `artists`, `songs`, and `global_song_rank`, which contain information about the artists, songs, and music charts, respectively.

Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. Display the top 5 artist names in ascending order, along with their song appearance ranking.


Table: `artists`

| Column Name | Type    |
|-------------|---------|
| artist_id   | integer |
| artist_name | varchar |
| label_owner | varchar |

Table: `songs`

| Column Name | Type    |
|-------------|---------|
| song_id     | integer |
| artist_id   | integer |
| name        | varchar |

Table: `global_song_rank`

| Column Name | Type                  |
|-------------|-----------------------|
| day         | integer (1-52)        |
| song_id     | integer               |
| rank        | integer (1-1,000,000) |

```SQL
SELECT *
FROM (
    SELECT a.artist_name,
           DENSE_RANK() OVER (ORDER BY COUNT(s.song_id) DESC) AS artist_rank
    FROM global_song_rank gs
    JOIN songs s
        ON gs.song_id = s.song_id
    JOIN artists a
        ON s.artist_id = a.artist_id
    WHERE gs.rank <= 10
    GROUP BY a.artist_name
) AS top_10
WHERE artist_rank <= 5
```

Result:

<pre>
| artist_name  | artist_rank |
|--------------|-------------|
| Taylor Swift | 1           |
| Bad Bunny    | 2           |
| Drake        | 2           |
| Ed Sheeran   | 3           |
| Adele        | 3           |
| Lady Gaga    | 4           |
| Katy Perry   | 5           |
</pre>


## [26. [Medium] Signup Activation Rate](https://datalemur.com/questions/signup-confirmation-rate)

New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. Users may receive multiple text messages for account confirmation until they have confirmed their new account.

A senior analyst is interested to know the activation rate of specified users in the emails table. Write a query to find the activation rate. Round the percentage to 2 decimal places.

Definitions:

* emails table contain the information of user signup details.
* texts table contains the users' activation information.

Assumptions:

* The analyst is interested in the activation rate of specific users in the emails table, which may not include all users that could potentially be found in the texts table.
* For example, user 123 in the emails table may not be in the texts table and vice versa.

Table: `emails`

| Column Name | Type     |
|-------------|----------|
| email_id    | integer  |
| user_id     | integer  |
| signup_date | datetime |

Table: `texts`

| Column Name   | Type    |
|---------------|---------|
| text_id       | integer |
| email_id      | integer |
| signup_action | varchar |

```SQL
SELECT ROUND(
           COUNT(t.email_id)*1.0/COUNT(e.email_id), 2
       ) AS confirm_rate
FROM emails e
  LEFT JOIN texts t
      ON e.email_id = t.email_id AND
          t.signup_action = 'Confirmed'
```

Result:

<pre>
| confirm_rate |
|--------------|
| 0.33         |
</pre>


## [27. [Medium] Supercloud Customer](https://datalemur.com/questions/supercloud-customer)

A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product from every product category listed in the products table.

Write a query that identifies the customer IDs of these Supercloud customers.

Table: `customer_contracts`

| Column Name | Type    |
|-------------|---------|
| customer_id | integer |
| product_id  | integer |
| amount      | integer |

Table: `products`

| Column Name      | Type    |
|------------------|---------|
| product_id       | integer |
| product_category | string  |
| product_name     | string  |

```SQL
SELECT cc.customer_id
FROM customer_contracts cc
RIGHT JOIN products p
    ON cc.product_id = p.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT p.product_category) =  
           (SELECT COUNT(DISTINCT product_category) FROM products)
```

Result:

<pre>
| customer_id |
|-------------|
| 7           |
</pre>


## [28. [Medium] Odd and Even Measurements](https://datalemur.com/questions/odd-even-measurements)

Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. Refer to the Example Output below for the desired format.

Definition:

* Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.

Table: `measurements`

| Column Name       | Type     |
|-------------------|----------|
| measurement_id    | integer  |
| measurement_value | decimal  |
| measurement_time  | datetime |

```SQL
SELECT measurement_day,
       SUM(measurement_value) FILTER (WHERE MOD(rnk, 2) = 1) AS odd_sum,
       SUM(measurement_value) FILTER (WHERE MOD(rnk, 2) = 0) AS even_sum
FROM (
    SELECT measurement_time::DATE AS measurement_day, 
           ROW_NUMBER() OVER win AS rnk,
           measurement_value
    FROM measurements
    WINDOW win AS (PARTITION BY measurement_time::DATE ORDER BY measurement_time)
) AS ranking_measurements
GROUP BY measurement_day
ORDER BY measurement_day
```

Result:

<pre>
| measurement_day     | odd_sum | even_sum |
|---------------------|---------|----------|
| 07/10/2022 00:00:00 | 2355.75 | 1662.74  |
| 07/11/2022 00:00:00 | 2377.12 | 2480.70  |
| 07/12/2022 00:00:00 | 2903.40 | 1244.30  |
</pre>


## [29. [Medium] Histogram of Users and Purchases](https://datalemur.com/questions/histogram-users-purchases)

Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.

Table: `user_transactions`

| Column Name      | Type      |
|------------------|-----------|
| product_id       | integer   |
| user_id          | integer   |
| spend            | decimal   |
| transaction_date | timestamp |

```SQL
SELECT transaction_date,
       user_id,
       cnt AS product_count
FROM (
  SELECT transaction_date,
         user_id,
         COUNT(product_id) OVER (PARTITION BY user_id, transaction_date) AS cnt,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS rnk
  FROM user_transactions
) AS subq
WHERE rnk = 1
ORDER BY transaction_date
```

Result:

<pre>
| transaction_date    | user_id | product_count |
|---------------------|---------|---------------|
| 07/11/2022 10:00:00 | 123     | 1             |
| 07/12/2022 10:00:00 | 115     | 1             |
| 07/12/2022 10:00:00 | 159     | 2             |
</pre>


## [30. [Medium] Compressed Mode](https://datalemur.com/questions/alibaba-compressed-mode)

You're given a table containing the item count for each order on Alibaba, along with the frequency of orders that have the same item count. Write a query to retrieve the mode of the order occurrences. Additionally, if there are multiple item counts with the same mode, the results should be sorted in ascending order.

Clarifications:

* `item_count`: Represents the number of items sold in each order.
* `order_occurrences`: Represents the frequency of orders with the corresponding number of items sold per order.
* For example, if there are 800 orders with 3 items sold in each order, the record would have an `item_count` of 3 and an `order_occurrences` of 800.

Table: `items_per_order`

| Column Name       | Type    |
|-------------------|---------|
| item_count        | integer |
| order_occurrences | integer |

```SQL
SELECT item_count
FROM (
    SELECT item_count,
           RANK() OVER (ORDER BY order_occurrences DESC) AS rnk
    FROM items_per_order
) AS subq
WHERE rnk = 1
ORDER BY item_count
```

Result:

<pre>
| item_count |
|------------|
| 2          |
| 4          |
</pre>


## [31. [Medium] Card Launch Success](https://datalemur.com/questions/card-launch-success)

Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.

Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.

Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the `monthly_cards_issued` table for a given card. Order the results starting from the biggest issued amount.

Table: `monthly_cards_issued`

| Column Name   | Type    |
|---------------|---------|
| issue_month   | integer |
| issue_year    | integer |
| card_name     | string  |
| issued_amount | integer |

```SQL
SELECT card_name,
       issued_amount
FROM (
    SELECT card_name,
           issued_amount,
           RANK() OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) AS rnk
    FROM monthly_cards_issued
) AS subq
WHERE rnk = 1
ORDER BY issued_amount DESC
```

Result:

<pre>
| card_name              | issued_amount |
|------------------------|---------------|
| Chase Sapphire Reserve | 150000        |
| Chase Freedom Flex     | 55000         |
</pre>


## [32. [Medium] International Call Percentage](https://datalemur.com/questions/international-call-percentage)

A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

What percentage of phone calls are international? Round the result to 1 decimal.

Assumption: The caller_id in phone_info table refers to both the caller and receiver.

Table: `phone_calls`

| Column Name | Type      |
|-------------|-----------|
| caller_id   | integer   |
| receiver_id | integer   |
| call_time   | timestamp |


Table: `phone_info`

| Column Name  | Type    |
|--------------|---------|
| caller_id    | integer |
| country_id   | integer |
| network      | integer |
| phone_number | string  |

```SQL
WITH country_info AS (
    SELECT pic.country_id AS cc,
           pir.country_id AS rc
    FROM phone_calls pc
    JOIN phone_info pic
        ON pc.caller_id = pic.caller_id 
    JOIN phone_info pir
        ON pc.receiver_id = pir.caller_id
)

SELECT ROUND(
            COUNT(*) FILTER (WHERE cc != rc)*100.0/
            (SELECT COUNT(*) FROM phone_calls), 
        1) AS internations_calls_pct
FROM country_info
```

Result:

<pre>
| internations_calls_pct |
|------------------------|
| 54.5                   |
</pre>


## [33. [Medium] Patient Support Analysis (Part 2)](https://datalemur.com/questions/uncategorized-calls-percentage)

UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy holders (or, members) to call an advocate and receive support for their health care needs – whether that's claims and benefits support, drug coverage, pre- and post-authorisation, medical records, emergency assistance, or member portal services.

Calls to the Advocate4Me call centre are classified into various categories, but some calls cannot be neatly categorised. These uncategorised calls are labeled as “n/a”, or are left empty when the support agent does not enter anything into the call category field.

Write a query to calculate the percentage of calls that cannot be categorised. Round your answer to 1 decimal place. For example, 45.0, 48.5, 57.7.

Table: `callers`

| Column Name        | Type      |
|--------------------|-----------|
| policy_holder_id   | integer   |
| case_id            | varchar   |
| call_category      | varchar   |
| call_date          | timestamp |
| call_duration_secs | integer   |

```SQL
SELECT ROUND(
           COUNT(case_id) FILTER (
               WHERE call_category IS NULL OR call_category = 'n/a')*100.0/COUNT(*), 
        1) AS uncategorised_call_pct
FROM callers
```

Result:

<pre>
| uncategorised_call_pct |
|------------------------|
| 5.5                    |
</pre>


## [34. [Hard] Active User Retention](https://datalemur.com/questions/user-retention)

Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.

Table: `user_actions`

| Column Name | Type                                 |
|-------------|--------------------------------------|
| user_id     | integer                              |
| event_id    | integer                              |
| event_type  | string ("sign-in, "like", "comment") |
| event_date  | datetime                             |

```SQL
SELECT mon AS month,
       COUNT(DISTINCT user_id) FILTER (WHERE lg_month = mon - 1) AS monthly_active_users
FROM (
    SELECT user_id,
           DATE_PART('month', event_date) AS mon,
           LAG(DATE_PART('month', event_date)) OVER win AS lg_month
    FROM user_actions
    WHERE DATE_PART('year', event_date) = 2022
    WINDOW win AS (PARTITION BY user_id ORDER BY event_date)
) AS activity2022
WHERE mon = 7
GROUP BY mon
```

Result:

<pre>
| month | monthly_active_users |
|-------|----------------------|
| 7     | 2                    |
</pre>


## [35. [Medium] Swapped Food Delivery](https://datalemur.com/questions/sql-swapped-food-delivery)

Zomato is a leading online food delivery service that connects users with various restaurants and cuisines, allowing them to browse menus, place orders, and get meals delivered to their doorsteps.

Recently, Zomato encountered an issue with their delivery system. Due to an error in the delivery driver instructions, each item's order was swapped with the item in the subsequent row. As a data analyst, you're asked to correct this swapping error and return the proper pairing of order ID and item.

If the last item has an odd order ID, it should remain as the last item in the corrected data. For example, if the last item is Order ID 7 Tandoori Chicken, then it should remain as Order ID 7 in the corrected data.

In the results, return the correct pairs of order IDs and items.

Table: `orders`

| column_name | type    | description                              |
|-------------|---------|------------------------------------------|
| order_id    | integer | The ID of each Zomato order.             |
| item        | string  | The name of the food item in each order. |

```SQL
SELECT order_id AS correct_order_id,
       COALESCE(
           CASE
               WHEN order_id % 2 = 1 
               THEN LEAD(item) OVER (ORDER BY order_id)
               
               WHEN order_id % 2 = 0
               THEN LAG(item) OVER (ORDER BY order_id)
           END, item
        ) AS item
FROM orders
```

Result:

<pre>
| correct_order_id | item             |
|------------------|------------------|
| 1                | Pizza            |
| 2                | Chow Mein        |
| 3                | Butter Chicken   |
| 4                | Pad Thai         |
| 5                | Burger           |
| 6                | Eggrolls         |
| 7                | Sushi            |
| 8                | Tandoori Chicken |
| 9                | Ramen            |
| 10               | Tacos            |
| 11               | Lasagna          |
| 12               | Burrito          |
| 13               | Steak            |
| 14               | Salad            |
| 15               | Spaghetti        |
</pre>


## [36. [Medium] FAANG Stock Min-Max (Part 1)](https://datalemur.com/questions/sql-bloomberg-stock-min-max-1)

The Bloomberg terminal is the go-to resource for financial professionals, offering convenient access to a wide array of financial datasets. As a Data Analyst at Bloomberg, you have access to historical data on stock performance.

Currently, you're analyzing the highest and lowest open prices for each FAANG stock by month over the years.

For each FAANG stock, display the ticker symbol, the month and year ('Mon-YYYY') with the corresponding highest and lowest open prices (refer to the Example Output format). Ensure that the results are sorted by ticker symbol.

Table: `stock_prices`

| Column Name | Type     | Description                                                         |
|-------------|----------|---------------------------------------------------------------------|
| date        | datetime | The specified date (mm/dd/yyyy) of the stock data.                  |
| ticker      | varchar  | The stock ticker symbol (e.g., AAPL) for the corresponding company. |
| open        | decimal  | The opening price of the stock at the start of the trading day.     |
| high        | decimal  | The highest price reached by the stock during the trading day.      |
| low         | decimal  | The lowest price reached by the stock during the trading day.       |
| close       | decimal  | The closing price of the stock at the end of the trading day.       |

```SQL
SELECT ticker,
       MIN(CASE
           WHEN rnb = 1 THEN TO_CHAR(date, 'Mon-YYYY')
       END) AS highest_mth,
       MIN(CASE
           WHEN rnb = 1 THEN open
       END) AS highest_open,
       MIN(CASE
           WHEN rnb = tcnt THEN TO_CHAR(date, 'Mon-YYYY')
       END) AS lowest_mth,
       MIN(CASE
           WHEN rnb = tcnt THEN open
       END) AS lowest_open
FROM (
    SELECT ticker,
           date,
           open,
           ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY open DESC) AS rnb,
           COUNT(*) OVER (PARTITION BY ticker) AS tcnt
    FROM stock_prices
) AS ranking
GROUP BY ticker
```

Result:

<pre>
| ticker | highest_mth | highest_open | lowest_mth | lowest_open |
|--------|-------------|--------------|------------|-------------|
| AAPL   | Jul-2023    | 195.26       | Apr-2020   | 61.63       |
| AMZN   | Dec-2021    | 177.25       | Jan-2023   | 85.46       |
| GOOG   | Nov-2021    | 148.16       | Apr-2020   | 56.10       |
| META   | Sep-2021    | 379.59       | Nov-2022   | 94.33       |
| MSFT   | Jul-2023    | 339.19       | Apr-2020   | 153.00      |
| NFLX   | Nov-2021    | 689.06       | Jul-2022   | 176.49      |
</pre>


## [37. [Hard] Y-on-Y Growth Rate](https://datalemur.com/questions/yoy-growth-rate)

Assume you're given a table containing information about Wayfair user transactions for different products. Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.

The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.

Table: `user_transactions`

| Column Name      | Type     |
|------------------|----------|
| transaction_id   | integer  |
| product_id       | integer  |
| spend            | decimal  |
| transaction_date | datetime |

```SQL
WITH spending AS (
  SELECT DATE_PART('year', transaction_date) AS year,
         product_id,
         SUM(spend) AS curr_year_spend,
         LAG(SUM(spend)) OVER win AS prev_year_spend
  FROM user_transactions
  GROUP BY DATE_PART('year', transaction_date), product_id
  WINDOW win AS (PARTITION BY product_id ORDER BY DATE_PART('year', transaction_date))
)

SELECT year,
       product_id,
       curr_year_spend,
       prev_year_spend,
       ROUND(
           (curr_year_spend - prev_year_spend)*100.0/prev_year_spend, 2
       ) AS yoy_rate
FROM spending
ORDER BY product_id
```

Result:

<pre>
| year | product_id | curr_year_spend | prev_year_spend | yoy_rate |
|------|------------|-----------------|-----------------|----------|
| 2019 | 123424     | 1500.60         | NULL            | NULL     |
| 2020 | 123424     | 1000.20         | 1500.60         | -33.35   |
| 2021 | 123424     | 1246.44         | 1000.20         | 24.62    |
| 2022 | 123424     | 2145.32         | 1246.44         | 72.12    |
| 2019 | 234412     | 1800.00         | NULL            | NULL     |
| 2020 | 234412     | 1234.00         | 1800.00         | -31.44   |
| 2021 | 234412     | 889.50          | 1234.00         | -27.92   |
| 2022 | 234412     | 2900.00         | 889.50          | 226.03   |
| 2019 | 543623     | 6450.00         | NULL            | NULL     |
| 2020 | 543623     | 5348.12         | 6450.00         | -17.08   |
| 2021 | 543623     | 2345.00         | 5348.12         | -56.15   |
| 2022 | 543623     | 5680.00         | 2345.00         | 142.22   |
</pre>


## [38. [Hard] Maximize Prime Item Inventory](https://datalemur.com/questions/prime-warehouse-storage)

Amazon wants to maximize the storage capacity of its 500,000 square-foot warehouse by prioritizing a specific batch of prime items. The specific prime product batch detailed in the inventory table must be maintained.

So, if the prime product batch specified in the item_category column included 1 laptop and 1 side table, that would be the base batch. We could not add another laptop without also adding a side table; they come all together as a batch set.

After prioritizing the maximum number of prime batches, any remaining square footage will be utilized to stock non-prime batches, which also come in batch sets and cannot be separated into individual items.

Write a query to find the maximum number of prime and non-prime batches that can be stored in the 500,000 square feet warehouse based on the following criteria:

Prioritize stocking prime batches
After accommodating prime items, allocate any remaining space to non-prime batches
Output the item_type with prime_eligible first followed by not_prime, along with the maximum number of batches that can be stocked.

Assumptions:

* Again, products must be stocked in batches, so we want to find the largest available quantity of prime batches, and then the largest available quantity of non-prime batches
* Non-prime items must always be available in stock to meet customer demand, so the non-prime item count should never be zero.
* Item count should be whole numbers (integers).

------NO YOU ARE NOT ALONE, I DIDN'T GET THE QUESTION IN THE FIRST GO AS WELL.-----

Table: `inventory`

| Column Name    | Type    |
|----------------|---------|
| item_id        | integer |
| item_type      | string  |
| item_category  | string  |
| square_footage | decimal |

```SQL
WITH cte AS (
    SELECT
        SUM(CASE WHEN item_type LIKE 'p%' THEN 1 ELSE 0 END) AS p_count,
        SUM(CASE WHEN item_type LIKE 'n%' THEN 1 ELSE 0 END) AS np_count,
        SUM(CASE WHEN item_type LIKE 'p%' THEN square_footage ELSE 0 END) AS p_footage,
        SUM(CASE WHEN item_type LIKE 'n%' THEN square_footage ELSE 0 END) AS np_footage
    FROM
        inventory
)

SELECT 
    'prime_eligible' AS item_type,
    FLOOR(500000/p_footage) * p_count AS item_count
FROM 
    cte
UNION ALL
SELECT 
    'not_prime',
    FLOOR((500000 - FLOOR(500000/p_footage)*p_footage)/np_footage)*np_count
FROM 
    cte
```

Result:

<pre>
| item_type      | item_count |
|----------------|------------|
| prime_eligible | 5400       |
| not_prime      | 8          |
</pre>


## [39. [Medium] ]()


Table: ``


```SQL

```

Result:

<pre>

</pre>