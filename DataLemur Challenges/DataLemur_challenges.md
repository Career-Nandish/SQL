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