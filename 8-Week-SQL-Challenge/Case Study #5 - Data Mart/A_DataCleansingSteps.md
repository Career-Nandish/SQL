## A. Data Cleansing Steps

### In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

### 1. Convert the week_date to a DATE format

### 2. Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc

### 3. Add a month_number with the calendar month for each week_date value as the 3rd column

### 4. Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values

### 5. Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value

| segment | age_band     |
|---------|--------------|
| 1       | Young Adults |
| 2       | Middle Aged  |
| 3 or 4  | Retirees     |

### 6. Add a new demographic column using the following mapping for the first letter in the segment values:

| segment | demographic |
|---------|-------------|
| C       | Couples     |
| F       | Families    |


### 7. Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns

### 8. Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record.

Creating a new table, instead of creating temporary table.

```SQL
CREATE TABLE clean_weekly_sales AS 
    SELECT TO_DATE(week_date, 'DD/MM/YY') AS week_date,
  		   DATE_PART('week', TO_DATE(week_date, 'DD/MM/YY')) AS week_number,
           DATE_PART('month', TO_DATE(week_date, 'DD/MM/YY')) AS month_number,
           DATE_PART('year', TO_DATE(week_date, 'DD/MM/YY')) AS calendar_year,
           region,
           platform,
           CASE
               WHEN segment = 'null' THEN 'unknown'
  			   ELSE segment
           END AS segment,
           CASE
               WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults'
  			   WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
  			   WHEN RIGHT(segment, 1) = '3' THEN 'Retirees'
  			   WHEN RIGHT(segment, 1) = '4' THEN 'Retirees'
               ELSE 'unknown'               
           END AS age_band,
  		   CASE
               WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
  			   WHEN LEFT(segment, 1) = 'F' THEN 'Families'
  			   ELSE 'unknown'
           END AS demographic,
           customer_type,
           transactions,
           sales,
           ROUND(sales*1.0/transactions, 2)AS avg_transaction
    FROM weekly_sales 
```

Result:

<pre>
| week_date              | week_number | month_number | calendar_year | region | platform | segment | age_band     | demographic | customer_type | transactions | sales    | avg_transaction |
|------------------------|-------------|--------------|---------------|--------|----------|---------|--------------|-------------|---------------|--------------|----------|-----------------|
| 2020-08-31 00:00:00+10 | 36          | 8            | 2020          | ASIA   | Retail   | C3      | Retirees     | Couples     | New           | 120631       | 3656163  | 30.31           |
| 2020-08-31 00:00:00+10 | 36          | 8            | 2020          | ASIA   | Retail   | F1      | Young Adults | Families    | New           | 31574        | 996575   | 31.56           |
| 2020-08-31 00:00:00+10 | 36          | 8            | 2020          | USA    | Retail   | unknown | unknown      | unknown     | Guest         | 529151       | 16509610 | 31.20           |
| 2020-08-31 00:00:00+10 | 36          | 8            | 2020          | EUROPE | Retail   | C1      | Young Adults | Couples     | New           | 4517         | 141942   | 31.42           |
| 2020-08-31 00:00:00+10 | 36          | 8            | 2020          | AFRICA | Retail   | C2      | Middle Aged  | Couples     | New           | 58046        | 1758388  | 30.29           |
</pre>

