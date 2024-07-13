## D. Bonus Question

### 1. Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?

### region, platform, age_band, demographic, customer_type

### Do you have any further recommendations for Danny’s team at Data Mart or any interesting insights based off this analysis?

### 1.1 Region

```SQL
WITH event_week AS (
    SELECT week_number AS w_num
    FROM data_mart.clean_weekly_sales
    WHERE week_date = '2020-06-15'
    LIMIT 1
),
event_sales AS (
	SELECT region,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num-12 AND w_num-1
           ) AS before_sales12,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num AND w_num+11
           ) AS after_sales12
    FROM data_mart.clean_weekly_sales, event_week
    WHERE calendar_year = 2020
    GROUP BY region
)

SELECT *,
       ROUND(
           (after_sales12 - before_sales12)*100.0/before_sales12, 
           2
       ) AS pct_change12
FROM event_sales
ORDER BY pct_change12
```

Result:

<pre>
| region        | before_sales12 | after_sales12 | pct_change12 |
|---------------|----------------|---------------|--------------|
| ASIA          | 1637244466     | 1583807621    | -3.26        |
| OCEANIA       | 2354116790     | 2282795690    | -3.03        |
| SOUTH AMERICA | 213036207      | 208452033     | -2.15        |
| CANADA        | 426438454      | 418264441     | -1.92        |
| USA           | 677013558      | 666198715     | -1.60        |
| AFRICA        | 1709537105     | 1700390294    | -0.54        |
| EUROPE        | 108886567      | 114038959     | 4.73         |
</pre>

#### Insights

* Almost, all regions saw decrease in sales after changing packaging, where `ASIA` had the highest decrease in sales with `-3.26%` closely followed by `OCEANIA` with `-3.03%`.
* The only region with increase in sales was `EUROPE` with `+4.73%`.

### 1.2 platform

```SQL
WITH event_week AS (
    SELECT week_number AS w_num
    FROM data_mart.clean_weekly_sales
    WHERE week_date = '2020-06-15'
    LIMIT 1
),
event_sales AS (
	SELECT platform,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num-12 AND w_num-1
           ) AS before_sales12,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num AND w_num+11
           ) AS after_sales12
    FROM data_mart.clean_weekly_sales, event_week
    WHERE calendar_year = 2020
    GROUP BY platform
)

SELECT *,
       ROUND(
           (after_sales12 - before_sales12)*100.0/before_sales12, 
           2
       ) AS pct_change12
FROM event_sales
ORDER BY pct_change12
```

Result:

<pre>
| platform | before_sales12 | after_sales12 | pct_change12 |
|----------|----------------|---------------|--------------|
| Retail   | 6906861113     | 6738777279    | -2.43        |
| Shopify  | 219412034      | 235170474     | 7.18         |
</pre>

#### Insights

* `Retail` and `Shopify` had opposite trends, with latter saw increase of `+7.18%` and the former had a decrease of `-2.43%` in total sales.

### 1.3 age_band

```SQL
WITH event_week AS (
    SELECT week_number AS w_num
    FROM data_mart.clean_weekly_sales
    WHERE week_date = '2020-06-15'
    LIMIT 1
),
event_sales AS (
	SELECT age_band,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num-12 AND w_num-1
           ) AS before_sales12,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num AND w_num+11
           ) AS after_sales12
    FROM data_mart.clean_weekly_sales, event_week
    WHERE calendar_year = 2020
    GROUP BY age_band
)

SELECT *,
       ROUND(
           (after_sales12 - before_sales12)*100.0/before_sales12, 
           2
       ) AS pct_change12
FROM event_sales
ORDER BY pct_change12
```

Result:

<pre>
| age_band     | before_sales12 | after_sales12 | pct_change12 |
|--------------|----------------|---------------|--------------|
| unknown      | 2764354464     | 2671961443    | -3.34        |
| Middle Aged  | 1164847640     | 1141853348    | -1.97        |
| Retirees     | 2395264515     | 2365714994    | -1.23        |
| Young Adults | 801806528      | 794417968     | -0.92        |
</pre>

#### Insights

* All of the `age_band` values saw a slight decrease in total sales in the year of 2020, except of `unknown` which simply represents missing data.

### 1.4 demographic

```SQL
WITH event_week AS (
    SELECT week_number AS w_num
    FROM data_mart.clean_weekly_sales
    WHERE week_date = '2020-06-15'
    LIMIT 1
),
event_sales AS (
	SELECT demographic,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num-12 AND w_num-1
           ) AS before_sales12,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num AND w_num+11
           ) AS after_sales12
    FROM data_mart.clean_weekly_sales, event_week
    WHERE calendar_year = 2020
    GROUP BY demographic
)

SELECT *,
       ROUND(
           (after_sales12 - before_sales12)*100.0/before_sales12, 
           2
       ) AS pct_change12
FROM event_sales
ORDER BY pct_change12
```

Result:

<pre>
| demographic | before_sales12 | after_sales12 | pct_change12 |
|-------------|----------------|---------------|--------------|
| unknown     | 2764354464     | 2671961443    | -3.34        |
| Families    | 2328329040     | 2286009025    | -1.82        |
| Couples     | 2033589643     | 2015977285    | -0.87        |
</pre>

#### Insights

* The decrease in sales for demographic group `Families`(due to change in packaging) was more than 2x compared to demographic group `Couples`.

### 1.5 customer_type

```SQL
WITH event_week AS (
    SELECT week_number AS w_num
    FROM data_mart.clean_weekly_sales
    WHERE week_date = '2020-06-15'
    LIMIT 1
),
event_sales AS (
	SELECT customer_type,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num-12 AND w_num-1
           ) AS before_sales12,
           SUM(sales) FILTER (
               WHERE week_number BETWEEN w_num AND w_num+11
           ) AS after_sales12
    FROM data_mart.clean_weekly_sales, event_week
    WHERE calendar_year = 2020
    GROUP BY customer_type
)

SELECT *,
       ROUND(
           (after_sales12 - before_sales12)*100.0/before_sales12, 
           2
       ) AS pct_change12
FROM event_sales
ORDER BY pct_change12
```

Result:

<pre>
| customer_type | before_sales12 | after_sales12 | pct_change12 |
|---------------|----------------|---------------|--------------|
| Guest         | 2573436301     | 2496233635    | -3.00        |
| Existing      | 3690116427     | 3606243454    | -2.27        |
| New           | 862720419      | 871470664     | 1.01         |
</pre>

#### Insights

* The sales for customer types `Guest` and `Existing` decreased while customer type `New` had increase in sales.
* The sustainable packaging as a marketing strat could have gotten new customers in.
