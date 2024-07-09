## B. Data Exploration

### 1. What day of the week is used for each week_date value?

```SQL
SELECT DISTINCT TO_CHAR(week_date, 'Day') AS day_of_week
FROM clean_weekly_sales;
```

Result:

<pre>
| day_of_week |
| ----------- |
| Monday      |
</pre>

### 2. What range of week numbers are missing from the dataset?

```SQL
SELECT GENERATE_SERIES(1, 52, 1) AS week_number

EXCEPT

SELECT DISTINCT week_number
FROM clean_weekly_sales

ORDER BY week_number
```
Week number from 1-12 and 37-52 are missing. Here are the first 10 rows.

Result:

<pre>
| week_number |
| ----------- |
| 1           |
| 2           |
| 3           |
| 4           |
| 5           |
| 6           |
| 7           |
| 8           |
| 9           |
| 10          |
</pre>

### 3. How many total transactions were there for each year in the dataset?

```SQL
SELECT calendar_year,
       SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year
```

Result:

<pre>
| calendar_year | total_transactions |
|---------------|--------------------|
| 2018          | 346406460          |
| 2019          | 365639285          |
| 2020          | 375813651          |
</pre>

### 4. What is the total sales for each region for each month?

```SQL
SELECT region,
       month_number,
       SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY region, month_number
ORDER BY region, month_number
```

Only first 10 rows..

Result:

<pre>
| region | month_number | total_sales |
|--------|--------------|-------------|
| AFRICA | 3            | 567767480   |
| AFRICA | 4            | 1911783504  |
| AFRICA | 5            | 1647244738  |
| AFRICA | 6            | 1767559760  |
| AFRICA | 7            | 1960219710  |
| AFRICA | 8            | 1809596890  |
| AFRICA | 9            | 276320987   |
| ASIA   | 3            | 529770793   |
| ASIA   | 4            | 1804628707  |
| ASIA   | 5            | 1526285399  |
</pre>

### 5. What is the total count of transactions for each platform

```SQL
SELECT platform,
       SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform
ORDER BY platform
```

Result:

<pre>
| platform | total_transactions |
|----------|--------------------|
| Retail   | 1081934227         |
| Shopify  | 5925169            |
</pre>

### 6. What is the percentage of sales for Retail vs Shopify for each month?

```SQL
SELECT month_number,
       ROUND(retail_trans*100.0/total_trans, 2) AS retail_perc,
       ROUND(shopify_trans*100.0/total_trans, 2) AS shopify_perc
FROM (
    SELECT month_number,
           SUM(transactions) FILTER (WHERE platform LIKE 'R%') AS retail_trans,
           SUM(transactions) FILTER (WHERE platform LIKE 'S%') AS shopify_trans,
           SUM(transactions) AS total_trans
    FROM data_mart.clean_weekly_sales
    GROUP BY month_number
) AS platform_transactions
ORDER BY month_number
```

Result:

<pre>
| month_number | retail_perc | shopify_perc |
|--------------|-------------|--------------|
| 3            | 99.49       | 0.51         |
| 4            | 99.51       | 0.49         |
| 5            | 99.44       | 0.56         |
| 6            | 99.44       | 0.56         |
| 7            | 99.45       | 0.55         |
| 8            | 99.42       | 0.58         |
| 9            | 99.48       | 0.52         |
</pre>

### 7. What is the percentage of sales by demographic for each year in the dataset?

```SQL
SELECT calendar_year,
       ROUND(SUM(sales) FILTER (WHERE demographic LIKE 'C%')*100.0/SUM(sales), 2) AS couples_sales_perc,
       ROUND(SUM(sales) FILTER (WHERE demographic LIKE 'F%')*100.0/SUM(sales), 2) AS family_sales_perc,
       ROUND(SUM(sales) FILTER (WHERE demographic LIKE 'u%')*100.0/SUM(sales), 2) AS unknown_sales_perc
FROM data_mart.clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year
```

Result:

<pre>
| calendar_year | couples_sales_perc | family_sales_perc | unknown_sales_perc |
|---------------|--------------------|-------------------|--------------------|
| 2018          | 26.38              | 31.99             | 41.63              |
| 2019          | 27.28              | 32.47             | 40.25              |
| 2020          | 28.72              | 32.73             | 38.55              |
</pre>

### 8. Which age_band and demographic values contribute the most to Retail sales?

```SQL
SELECT age_band,
       demographic,
       tot_sales,
       ROUND(tot_sales*100.0/SUM(tot_sales) OVER (), 2) AS contribution_perc
FROM (
    SELECT age_band,
           demographic,
           SUM(sales) AS tot_sales
    FROM data_mart.clean_weekly_sales
    WHERE platform = 'Retail'
    GROUP BY age_band, demographic
) AS sale_info
ORDER BY contribution_perc DESC
```

Result:

<pre>
| age_band     | demographic | tot_sales   | contribution_perc |
|--------------|-------------|-------------|-------------------|
| unknown      | unknown     | 16067285533 | 40.52             |
| Retirees     | Families    | 6634686916  | 16.73             |
| Retirees     | Couples     | 6370580014  | 16.07             |
| Middle Aged  | Families    | 4354091554  | 10.98             |
| Young Adults | Couples     | 2602922797  | 6.56              |
| Middle Aged  | Couples     | 1854160330  | 4.68              |
| Young Adults | Families    | 1770889293  | 4.47              |
</pre>

### 9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

No, we can't use that column, below is how we will calculate it. 

```SQL
SELECT calendar_year,
       platform,
       SUM(sales)/sum(transactions) AS avg_trans_size
FROM data_mart.clean_weekly_sales
GROUP BY calendar_year, platform
ORDER BY calendar_year, platform
```

Result:

<pre>
| calendar_year | platform | avg_trans_size |
|---------------|----------|----------------|
| 2018          | Retail   | 36             |
| 2018          | Shopify  | 192            |
| 2019          | Retail   | 36             |
| 2019          | Shopify  | 183            |
| 2020          | Retail   | 36             |
| 2020          | Shopify  | 179            |
</pre>