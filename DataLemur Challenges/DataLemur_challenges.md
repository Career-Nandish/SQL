## [1. [Easy]Histogram of Tweets](https://datalemur.com/questions/sql-histogram-tweets)

Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.

Table: tweets

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