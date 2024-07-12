## C. Before & After Analysis

### This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

### Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.

### We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before

### Using this analysis approach - answer the following questions:

### 1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?

```SQL
WITH event_week AS (
    SELECT week_number AS w_num
    FROM data_mart.clean_weekly_sales
    WHERE week_date = '2020-06-15'
    LIMIT 1
),
event_sales AS (
	SELECT calendar_year,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num-4 AND w_num-1
           ) AS before_sales4,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num AND w_num+3
           ) AS after_sales4,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num-12 AND w_num-1
           ) AS before_sales12,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num AND w_num+11
           ) AS after_sales12
    FROM data_mart.clean_weekly_sales, event_week
    GROUP BY calendar_year
)

SELECT calendar_year,
       before_sales4,
       after_sales4,
       ROUND(
           (after_sales4 - before_sales4)*100.0/before_sales4, 
           2
       ) AS pct_change4
FROM event_sales
WHERE calendar_year = 2020
```

Result:

<pre>
| calendar_year | before_sales4 | after_sales4 | pct_change4 |
|---------------|---------------|--------------|-------------|
| 2020          | 2345878357    | 2318994169   | -1.15       |
</pre>

### 2. What about the entire 12 weeks before and after?

```SQL
-- Consider Previous CTEs as well
SELECT calendar_year,
       before_sales12,
       after_sales12,
       ROUND(
           (after_sales12 - before_sales12)*100.0/before_sales12, 
           2
       ) AS pct_change12
FROM event_sales
WHERE calendar_year = 2020
```

Result:

<pre>
| calendar_year | before_sales12 | after_sales12 | pct_change12 |
|---------------|----------------|---------------|--------------|
| 2020          | 7126273147     | 6973947753    | -2.14        |
</pre>

### 3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?


```SQL
-- Consider previous CTEs as well
SELECT calendar_year,
       before_sales4,
       after_sales4,
       ROUND(
           (after_sales4 - before_sales4)*100.0/before_sales4, 
           2
       ) AS pct_change4,
       before_sales12,
       after_sales12,
       ROUND(
           (after_sales12 - before_sales12)*100.0/before_sales12, 
           2
       ) AS pct_change12
FROM event_sales
ORDER BY calendar_year
```

Result:

<pre>
| calendar_year | before_sales4 | after_sales4 | pct_change4 | before_sales12 | after_sales12 | pct_change12 |
|---------------|---------------|--------------|-------------|----------------|---------------|--------------|
| 2018          | 2125140809    | 2129242914   | 0.19        | 6396562317     | 6500818510    | 1.63         |
| 2019          | 2249989796    | 2252326390   | 0.10        | 6883386397     | 6862646103    | -0.30        |
| 2020          | 2345878357    | 2318994169   | -1.15       | 7126273147     | 6973947753    | -2.14        |
</pre>