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