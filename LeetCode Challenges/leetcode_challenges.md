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


## [577. [Easy]Employee Bonus](https://leetcode.com/problems/employee-bonus)

Table: Employee
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
</pre>
* empId is the column with unique values for this table.
* Each row of this table indicates the name and the ID of an employee in addition to their salary and the id of their manager.
 

Table: Bonus
<pre>
+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
</pre>
* empId is the column of unique values for this table.
* empId is a foreign key (reference column) to empId from the Employee table.
* Each row of this table contains the id of an employee and their respective bonus.
 

### Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.


```SQL
SELECT e.name, b.bonus
FROM employee e
LEFT JOIN bonus b
    ON e.empid = b.empid
WHERE COALESCE(b.bonus, 0) < 1000
```

## [1280. [Easy]Students and Examinations](https://leetcode.com/problems/students-and-examinations)

Table: Students
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
</pre>
* student_id is the primary key (column with unique values) for this table.
* Each row of this table contains the ID and the name of one student in the school.
 

Table: Subjects
<pre>
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
</pre>
* subject_name is the primary key (column with unique values) for this table.
* Each row of this table contains the name of one subject in the school.
 

Table: Examinations
<pre>
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
</pre>
* There is no primary key (column with unique values) for this table. It may contain duplicates.
* Each student from the Students table takes every course from the Subjects table.
* Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 

### Write a solution to find the number of times each student attended each exam. Return the result table ordered by student_id and subject_name.


```SQL
SELECT subq.student_id, 
       subq.student_name, 
       subq.subject_name, 
       COUNT(e.subject_name) AS attended_exams
FROM examinations e
RIGHT JOIN (
    SELECT DISTINCT s2.student_id, s1.subject_name, s2.student_name
    FROM subjects s1
    CROSS JOIN students s2
) AS subq
    ON e.student_id = subq.student_id AND
           e.subject_name = subq.subject_name
GROUP BY subq.student_id, subq.student_name, subq.subject_name
ORDER BY subq.student_id, subq.subject_name
```

## [570. [Medium]Managers with at Least 5 Direct Reports](https://leetcode.com/problems/managers-with-at-least-5-direct-reports)

Table: Employee
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
</pre>
* id is the primary key (column with unique values) for this table.
* Each row of this table indicates the name of an employee, their department, and the id of their manager.
* If managerId is null, then the employee does not have a manager.
* No employee will be the manager of themself.
 

### Write a solution to find managers with at least five direct reports.


```SQL
SELECT name
FROM employee
WHERE id IN (
    SELECT managerid
    FROM employee
    GROUP BY managerid
    HAVING COUNT(*) >= 5 
)
```


## [1934. [Medium]Confirmation Rate](https://leetcode.com/problems/confirmation-rate)

Table: Signups
<pre>
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
</pre>
* user_id is the column of unique values for this table.
* Each row contains information about the signup time for the user with ID user_id.
 

Table: Confirmations
<pre>
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
</pre>
* (user_id, time_stamp) is the primary key (combination of columns with unique values) for this table.
* user_id is a foreign key (reference column) to the Signups table.
* action is an ENUM (category) of the type ('confirmed', 'timeout')
* Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').
 

* The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.

### Write a solution to find the confirmation rate of each user.

```SQL
SELECT s.user_id, 
        ROUND(AVG(
                CASE 
                    WHEN c.action = 'confirmed' THEN 1
                    ELSE 0
                END
        ), 2) AS confirmation_rate
FROM signups s
LEFT JOIN confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id
```

## [620. [Easy]Not Boring Movies](https://leetcode.com/problems/not-boring-movies)

Table: Cinema
<pre>
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| id             | int      |
| movie          | varchar  |
| description    | varchar  |
| rating         | float    |
+----------------+----------+
</pre>
* id is the primary key (column with unique values) for this table.
* Each row contains information about the name of a movie, its genre, and its rating.
* rating is a 2 decimal places float in the range [0, 10]
 

### Write a solution to report the movies with an odd-numbered ID and a description that is not "boring". Return the result table ordered by rating in descending order.


```SQL
SELECT *
FROM cinema
WHERE MOD(id, 2) != 0 AND description != 'boring'
ORDER BY rating DESC
```


## [1251. [Easy]Average Selling Price](https://leetcode.com/problems/average-selling-price)

Table: Prices
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
</pre>
* (product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
* Each row of this table indicates the price of the product_id in the period from start_date to end_date.
* For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

Table: UnitsSold
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
</pre>
* This table may contain duplicate rows.
* Each row of this table indicates the date, units, and product_id of each product sold. 
 

### Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places.


```SQL
SELECT p.product_id, 
       ROUND(COALESCE(SUM(u.units * p.price)/SUM(u.units)::DECIMAL, 0), 2) AS average_price
FROM prices p
LEFT JOIN unitssold u
    ON p.product_id = u.product_id AND
            u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id
```


## [1075. [Easy]Project Employees I](https://leetcode.com/problems/project-employees-i)

Table: Project
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
</pre>
* (project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
* Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 

Table: Employee
<pre>
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
</pre>
* employee_id is the primary key of this table. It's guaranteed that experience_years is not NULL.
* Each row of this table contains information about one employee.
 

### Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.


```SQL
SELECT p.project_id, ROUND(AVG(e.experience_years), 2) AS average_years
FROM project p
JOIN employee e
    ON p.employee_id = e.employee_id
GROUP BY p.project_id
```


## [1633. [Easy]Percentage of Users Attended a Contest]()

Table: Users
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
</pre>
* user_id is the primary key (column with unique values) for this table.
* Each row of this table contains the name and the id of a user.
 

Table: Register
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
</pre>
* (contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
* Each row of this table contains the id of a user and the contest they registered into.


### Write a solution to find the percentage of the users registered in each contest rounded to two decimals. Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.


```SQL
WITH total_users AS (
    SELECT COUNT(*) AS user_cnt FROM users
)

SELECT contest_id, 
       ROUND(COUNT(user_id) * 100::DECIMAL/(SELECT user_cnt FROM total_users), 2) AS percentage
FROM register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id
```


## [1211. [Easy]Queries Quality and Percentage](https://leetcode.com/problems/queries-quality-and-percentage)

Table: Queries
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| query_name  | varchar |
| result      | varchar |
| position    | int     |
| rating      | int     |
+-------------+---------+
</pre>
* This table may have duplicate rows.
* This table contains information collected from some queries on a database.
* The position column has a value from 1 to 500.
* The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.
 

* We define query quality as:

	* The average of the ratio between query rating and its position.

* We also define poor query percentage as:

	* The percentage of all queries with rating less than 3.


### Write a solution to find each query_name, the quality and poor_query_percentage. Both quality and poor_query_percentage should be rounded to 2 decimal places.


```SQL
-- Write your PostgreSQL query statement below
SELECT subq.query_name,
       ROUND(AVG(ratio), 2) AS quality,
       ROUND(AVG(rating_lt_3) * 100, 2) AS poor_query_percentage
FROM (
    SELECT query_name, 
        rating::DECIMAL/position AS ratio,
        CASE
            WHEN rating < 3 THEN 1
            ELSE 0
        END AS rating_lt_3
    FROM queries
    WHERE query_name IS NOT NULL
) AS subq
GROUP BY subq.query_name
```