## [1757. [Easy]Recyclable and Low Fat Products](https://leetcode.com/problems/recyclable-and-low-fat-products)

Table: Products

<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| low_fats    | enum    |
| recyclable  | enum    |
+-------------+---------+
</pre>
* product_id is the primary key (column with unique values) for this table.
* low_fats is an ENUM (category) of type ('Y', 'N') where 'Y' means this product is low fat and 'N' means it is not.
* recyclable is an ENUM (category) of types ('Y', 'N') where 'Y' means this product is recyclable and 'N' means it is not.
 
### Write a solution to find the ids of products that are both low fat and recyclable.

```SQL
SELECT product_id
FROM products
WHERE low_fats = 'Y' AND
          recyclable = 'Y'
```


## [584. [Easy]Find Customer Referee](https://leetcode.com/problems/find-customer-referee)

Table: Customer

<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
</pre>

* In SQL, id is the primary key column for this table.
* Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
 
### Find the names of the customer that are not referred by the customer with id = 2.

```SQL
SELECT name
FROM customer
WHERE COALESCE(referee_id, 0) != 2
```


## [595. [Easy]Big Countries](https://leetcode.com/problems/big-countries)

Table: World
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
| area        | int     |
| population  | int     |
| gdp         | bigint  |
+-------------+---------+
</pre>
* name is the primary key (column with unique values) for this table.
* Each row of this table gives information about the name of a country, the continent to which it belongs, its area, the population, and its GDP value.
 
* A country is big if:

	* it has an area of at least three million (i.e., 3000000 km2), or
	* it has a population of at least twenty-five million (i.e., 25000000).

### Write a solution to find the name, population, and area of the big countries.


```SQL
SELECT name, 
       population, 
       area
FROM world
WHERE area >= 3000000 OR
          population >= 25000000
```


## [1148. [Easy]Article Views I](https://leetcode.com/problems/article-views-i)

Table: Views
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
</pre>

* There is no primary key (column with unique values) for this table, the table may have duplicate rows.
* Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
* Note that equal author_id and viewer_id indicate the same person.
 

### Write a solution to find all the authors that viewed at least one of their own articles. Return the result table sorted by id in ascending order.

```SQL
SELECT DISTINCT author_id AS id
FROM views
WHERE author_id = viewer_id
ORDER BY id ASC
```

## [1683. [Easy]Invalid Tweets]()

Table: Tweets

<pre>
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
</pre>

* tweet_id is the primary key (column with unique values) for this table.
* This table contains all the tweets in a social media app.
 

### Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

```SQL
SELECT tweet_id
FROM tweets
WHERE LENGTH(content) > 15
```

## [1378. [Easy]Replace Employee ID With The Unique Identifier](https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier)

Table: Employees
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
</pre>
* id is the primary key (column with unique values) for this table.
* Each row of this table contains the id and the name of an employee in a company.
 

Table: EmployeeUNI
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| unique_id     | int     |
+---------------+---------+
</pre>
* (id, unique_id) is the primary key (combination of columns with unique values) for this table.
* Each row of this table contains the id and the corresponding unique id of an employee in the company.
 

### Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.


```SQL
SELECT eu.unique_id, e.name
FROM employees e
LEFT JOIN employeeuni eu
    ON e.id = eu.id
```

## [1068. [Easy]Product Sales Analysis I](https://leetcode.com/problems/product-sales-analysis-i)

Table: Sales
<pre>
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
</pre>
* (sale_id, year) is the primary key (combination of columns with unique values) of this table.
* product_id is a foreign key (reference column) to Product table.
* Each row of this table shows a sale on the product product_id in a certain year.
* Note that the price is per unit.
 

Table: Product
<pre>
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
</pre>
* product_id is the primary key (column with unique values) of this table.
* Each row of this table indicates the product name of each product.
 

### Write a solution to report the product_name, year, and price for each sale_id in the Sales table

```SQL
SELECT p.product_name, s.year, s.price
FROM sales s
JOIN product p
    ON s.product_id = p.product_id
```

## [1581. [Easy]Customer Who Visited but Did Not Make Any Transactions](https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions)

Table: Visits
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| visit_id    | int     |
| customer_id | int     |
+-------------+---------+
</pre>
* visit_id is the column with unique values for this table.
* This table contains information about the customers who visited the mall.
 

Table: Transactions
<pre>
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| transaction_id | int     |
| visit_id       | int     |
| amount         | int     |
+----------------+---------+
</pre>
* transaction_id is column with unique values for this table.
* This table contains information about the transactions made during the visit_id.
 

### Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

```SQL
SELECT v.customer_id, COUNT(*) AS count_no_trans
FROM visits v
LEFT JOIN transactions t
    ON v.visit_id = t.visit_id
WHERE t.visit_id IS NULL
GROUP BY v.customer_id

-- OR

SELECT v.customer_id, COUNT(*) AS count_no_trans
FROM visits v
WHERE v.visit_id NOT IN (SELECT DISTINCT visit_id FROM transactions)
GROUP BY v.customer_id
```

## [197. [Easy]Rising Temperature](https://leetcode.com/problems/rising-temperature)

Table: Weather
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
</pre>
* id is the column with unique values for this table.
* There are no different rows with the same recordDate.
* This table contains information about the temperature on a certain day.
 

### Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday)


```SQL
SELECT w2.id
FROM weather w1
JOIN weather w2
ON w1.recordDate + INTERVAL '1 day' = w2.recordDate AND
       w2.temperature > w1.temperature
```

## [1661. [Easy]Average Time of Process per Machine](https://leetcode.com/problems/average-time-of-process-per-machine)

Table: Activity
<pre>
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
</pre>
* The table shows the user activities for a factory website.
* (machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
* machine_id is the ID of a machine.
* process_id is the ID of a process running on the machine with ID machine_id.
* activity_type is an ENUM (category) of type ('start', 'end').
* timestamp is a float representing the current time in seconds.
* 'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
* The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
 

* There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

* The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

* The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

```SQL
SELECT machine_id,
       ROUND(CAST(SUM(diff)/SUM(process_count) AS NUMERIC), 3) AS processing_time
FROM (
    SELECT machine_id,
        process_id,
        COUNT(*)/2 AS process_count,
        MAX(timestamp) - MIN(timestamp) AS diff
    FROM activity
    GROUP BY machine_id, process_id
) AS subq
GROUP BY machine_id
```