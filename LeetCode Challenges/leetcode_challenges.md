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


## [1193. [Medium]Monthly Transactions I](https://leetcode.com/problems/monthly-transactions-i)

Table: Transactions
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
</pre>
* id is the primary key of this table.
* The table has information about incoming transactions.
* The state column is an enum of type ["approved", "declined"].
 

### Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.


```SQL
SELECT LEFT(trans_date::TEXT, 7) AS month,
       country,
       COUNT(id) AS trans_count,
       SUM(
           CASE
               WHEN state = 'approved' THEN 1
               ELSE 0
           END
       ) AS approved_count,
       SUM(amount) AS trans_total_amount,
       SUM(
           CASE
               WHEN state = 'approved' THEN amount
               ELSE 0
           END
       ) AS approved_total_amount
FROM transactions
GROUP BY month, country
```


## [1174. [Medium]Immediate Food Delivery II](https://leetcode.com/problems/immediate-food-delivery-ii)

Table: Delivery
<pre>
+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
</pre>
* delivery_id is the column of unique values of this table.
* The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 
* If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

* The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

### Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.


```SQL
-- Write your PostgreSQL query statement below
SELECT ROUND(AVG(
           CASE
               WHEN order_date = customer_pref_delivery_date THEN 1
               ELSE 0
           END
        ) * 100, 2) AS immediate_percentage
FROM (
    SELECT order_date,
           customer_pref_delivery_date,
           RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rnk
    FROM delivery
) AS subq
WHERE rnk = 1
```


## [550. [Medium]Game Play Analysis IV](https://leetcode.com/problems/game-play-analysis-iv)

Table: Activity
<pre>
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
</pre>
* (player_id, event_date) is the primary key (combination of columns with unique values) of this table.
* This table shows the activity of players of some games.
* Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 
### Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

```SQL
WITH players_first_login AS (
    SELECT player_id, MIN(event_date) AS login_date
    FROM activity
    GROUP BY player_id
)
, players_count AS (
    SELECT COUNT(*) AS goal_count
    FROM players_first_login as pfl
    JOIN activity a
        ON a.player_id = pfl.player_id AND 
               pfl.login_date + INTERVAL '1 day' = a.event_date
)

SELECT ROUND((SELECT goal_count FROM players_count)::DECIMAL/COUNT(player_id), 2) AS fraction FROM players_first_login
```


## [2356. [Easy]Number of Unique Subjects Taught by Each Teacher](https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher)

Table: Teacher
<pre>
+-------------+------+
| Column Name | Type |
+-------------+------+
| teacher_id  | int  |
| subject_id  | int  |
| dept_id     | int  |
+-------------+------+
</pre>
* (subject_id, dept_id) is the primary key (combinations of columns with unique values) of this table.
* Each row in this table indicates that the teacher with teacher_id teaches the subject subject_id in the department dept_id.
 

### Write a solution to calculate the number of unique subjects each teacher teaches in the university.

```SQL
SELECT teacher_id,
       COUNT(DISTINCT subject_id) AS cnt
FROM teacher
GROUP BY teacher_id
```


## [1141. [Easy]User Activity for the Past 30 Days I](https://leetcode.com/problems/user-activity-for-the-past-30-days-i)

Table: Activity
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
</pre>
* This table may have duplicate rows.
* The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
* The table shows the user activities for a social media website. 
* Note that each session belongs to exactly one user.
 
### Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.

```SQL
SELECT activity_date AS day, 
       COUNT(DISTINCT user_id) AS active_users
FROM activity
WHERE AGE('2019-07-27', activity_date) < '30 days' AND
          activity_date <= '2019-07-27'
GROUP BY activity_date
```

## [1070. [Medium]Product Sales Analysis III](https://leetcode.com/problems/product-sales-analysis-iii)

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
 
### Write a solution to select the product id, year, quantity, and price for the first year of every product sold.

```SQL
SELECT product_id, year AS first_year, quantity, price
FROM (
    SELECT product_id,
           year,
           quantity,
           price,
           RANK() OVER (PARTITION BY product_id ORDER BY year) AS rnk
    FROM sales
) AS subq
WHERE rnk = 1
```


## [596. [Easy]Classes More Than 5 Students](https://leetcode.com/problems/classes-more-than-5-students)

Table: Courses
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student     | varchar |
| class       | varchar |
+-------------+---------+
</pre>
* (student, class) is the primary key (combination of columns with unique values) for this table.
* Each row of this table indicates the name of a student and the class in which they are enrolled.
 
### Write a solution to find all the classes that have at least five students.

```SQL
SELECT class 
FROM courses
GROUP BY class
HAVING COUNT(student) >= 5
```

## [1729. [Easy]Find Followers Count](https://leetcode.com/problems/find-followers-count)

Table: Followers
<pre>
+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
</pre>
* (user_id, follower_id) is the primary key (combination of columns with unique values) for this table.
* This table contains the IDs of a user and a follower in a social media app where the follower follows the user.
 
### Write a solution that will, for each user, return the number of followers. Return the result table ordered by user_id in ascending order.

```SQL
SELECT user_id,
       COUNT(follower_id) AS followers_count
FROM followers
GROUP BY user_id
ORDER BY user_id
```


## [619. [Easy]Biggest Single Number](https://leetcode.com/problems/biggest-single-number)

Table: MyNumbers
<pre>
+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
</pre>
* This table may contain duplicates (In other words, there is no primary key for this table in SQL).
* Each row of this table contains an integer.
 

### A single number is a number that appeared only once in the MyNumbers table. Find the largest single number. If there is no single number, report null.


```SQL
SELECT MAX(num) AS num
FROM (
    SELECT num
    FROM mynumbers
    GROUP BY num
    HAVING COUNT(num) = 1
) AS subq
```


## [1045. [Medium]Customers Who Bought All Products](https://leetcode.com/problems/customers-who-bought-all-products)

Table: Customer
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
</pre>
* This table may contain duplicates rows. 
* customer_id is not NULL.
* product_key is a foreign key (reference column) to Product table.
 
Table: Product
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
</pre>
* product_key is the primary key (column with unique values) for this table.

### Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

```SQL
SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM product)
```


## [1731. The Number of Employees Which Report to Each Employee](https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee)

Table: Employees
<pre>
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| reports_to  | int      |
| age         | int      |
+-------------+----------+
</pre>
* employee_id is the column with unique values for this table.
* This table contains information about the employees and the id of the manager they report to. Some employees do not report to anyone (reports_to is null). 

* For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

### Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer. Return the result table ordered by employee_id.


```SQL
SELECT e.employee_id, 
       e.name, 
       subq.reports_count, 
       subq.average_age
FROM (
    SELECT reports_to, 
           COUNT(reports_to) AS reports_count, 
           ROUND(AVG(age)) AS average_age
    FROM employees
    WHERE reports_to IS NOT NULL
    GROUP BY reports_to
) AS subq
JOIN employees e
    ON e.employee_id = subq.reports_to
ORDER BY e.employee_id
```


## [1789. [Easy]Primary Department for Each Employee](https://leetcode.com/problems/primary-department-for-each-employee)

Table: Employee
<pre>
+---------------+---------+
| Column Name   |  Type   |
+---------------+---------+
| employee_id   | int     |
| department_id | int     |
| primary_flag  | varchar |
+---------------+---------+
</pre>
* (employee_id, department_id) is the primary key (combination of columns with unique values) for this table.
* employee_id is the id of the employee.
* department_id is the id of the department to which the employee belongs.
* primary_flag is an ENUM (category) of type ('Y', 'N'). If the flag is 'Y', the department is the primary department for the employee. If the flag is 'N', the department is not the primary.
 

* Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.

### Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.


```SQL
SELECT employee_id, department_id
FROM employee
WHERE primary_flag = 'Y' OR 
          employee_id IN (
                SELECT employee_id 
                FROM employee 
                GROUP BY employee_id
                HAVING COUNT(department_id) = 1
              )
```


## [610. [Easy]Triangle Judgement](https://leetcode.com/problems/triangle-judgement)

Table: Triangle
<pre>
+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
</pre>
* In SQL, (x, y, z) is the primary key column for this table.
* Each row of this table contains the lengths of three line segments.
 

### Report for every three line segments whether they can form a triangle.


```SQL
SELECT x, y, z,
       CASE
           WHEN (x + y > z) AND (x + z > y) AND (y + z > x) THEN 'Yes'
           ELSE 'No'
       END AS triangle
FROM triangle
```


## [180. [Medium]Consecutive Numbers](https://leetcode.com/problems/consecutive-numbers)

Table: Logs
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
</pre>
* In SQL, id is the primary key for this table.
* id is an autoincrement column.
 
### Find all numbers that appear at least three times consecutively.

```SQL
SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT num,
           LEAD(num, 1) OVER () AS lead1,
           LEAD(num, 2) OVER () AS lead2
    FROM logs
) AS subq
WHERE num = lead1 AND num = lead2
```


## [1164. [Medium]Product Price at a Given Date](https://leetcode.com/problems/product-price-at-a-given-date)

Table: Products
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
</pre>
* (product_id, change_date) is the primary key (combination of columns with unique values) of this table.
* Each row of this table indicates that the price of some product was changed to a new price at some date.
 

### Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.


```SQL
WITH before_16 AS (
    SELECT product_id,
           new_price,
           RANK() OVER (PARTITION BY product_id ORDER BY change_date DESC) AS rnk
    FROM products
    WHERE change_date <= '2019-08-16'
),
unique_products AS (
    SELECT DISTINCT product_id 
    FROM products
)

SELECT up.product_id,
       COALESCE(b.new_price, 10) AS price
FROM unique_products AS up
LEFT JOIN before_16 AS b
    ON up.product_id = b.product_id AND
           b.rnk = 1
```


## [1204. [Medium]Last Person to Fit in the Bus](https://leetcode.com/problems/last-person-to-fit-in-the-bus)

Table: Queue
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
</pre>
* person_id column contains unique values.
* This table has the information about all people waiting for a bus.
* The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
* turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and turn=n denotes the last person to board.
* weight is the weight of the person in kilograms.
* There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.

### Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit.


```SQL
SELECT person_name
FROM (
    SELECT person_name,
        SUM(weight) OVER (ORDER BY turn) AS cum_weight
    FROM queue
) AS subq
WHERE cum_weight <= 1000
ORDER BY cum_weight DESC
LIMIT 1
```


## [1907. [Medium]Count Salary Categories](https://leetcode.com/problems/count-salary-categories)

Table: Accounts
<pre>
+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
</pre>
* account_id is the primary key (column with unique values) for this table.
* Each row contains information about the monthly income for one bank account.
 
### Write a solution to calculate the number of bank accounts for each salary category. The salary categories are: 
### * "Low Salary": All the salaries strictly less than $20000.
### * "Average Salary": All the salaries in the inclusive range [$20000, $50000].
### * "High Salary": All the salaries strictly greater than $50000. 
### The result table must contain all three categories. If there are no accounts in a category, return 0.

```SQL
WITH build_cat AS (
    SELECT CASE
               WHEN income < 20000 THEN 'Low Salary'
               WHEN income > 50000 THEN 'High Salary'
               ELSE 'Average Salary'
           END AS category,
           COUNT(1) AS accounts_count
    FROM accounts
    GROUP BY category
), 
all_cat AS (
    SELECT 'Low Salary' AS category
    UNION ALL
    SELECT 'Average Salary'
    UNION ALL
    SELECT 'High Salary'
)

SELECT a.category,
       COALESCE(b.accounts_count, 0) AS accounts_count
FROM all_cat a 
LEFT JOIN build_cat b
    ON a.category = b.category
```


## [1978. [Easy]Employees Whose Manager Left the Company](https://leetcode.com/problems/employees-whose-manager-left-the-company)

Table: Employees
<pre>
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| manager_id  | int      |
| salary      | int      |
+-------------+----------+
</pre>
* In SQL, employee_id is the primary key for this table.
* This table contains information about the employees, their salary, and the ID of their manager. Some employees do not have a manager (manager_id is null). 
 

### Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left. Return the result table ordered by employee_id.


```SQL
SELECT employee_id
FROM employees
WHERE salary < 30000 AND
      manager_id NOT IN (SELECT employee_id FROM employees)
ORDER BY employee_id
```


## [626. [Medium]Exchange Seats](https://leetcode.com/problems/exchange-seats)

Table: Seat
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
</pre>
* id is the primary key (unique value) column for this table.
* Each row of this table indicates the name and the ID of a student.
* id is a continuous increment.
 

### Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped. Return the result table ordered by id in ascending order.


```SQL
SELECT CASE
           WHEN MOD(id, 2) != 0 AND id != (SELECT COUNT(*) FROM seat) THEN id + 1
           WHEN MOD(id, 2) = 0 THEN id - 1
           ELSE id
       END AS id,
       student
FROM seat
ORDER BY id

-- OR -- 

SELECT COALESCE(new_id, id) AS id, student
FROM (
    SELECT id, student,
        CASE
            WHEN MOD(id, 2) = 0 THEN LAG(id) OVER (ORDER BY id)
            ELSE LEAD(id) OVER (ORDER BY id)
        END AS new_id
    FROM seat
) AS subq
ORDER BY id
```


## [1341. [Medium]Movie Rating](https://leetcode.com/problems/movie-rating)

Table: Movies
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
</pre>
* movie_id is the primary key (column with unique values) for this table.
* title is the name of the movie.

Table: Users
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
</pre>
* user_id is the primary key (column with unique values) for this table.
 
Table: MovieRating
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
</pre>
* (movie_id, user_id) is the primary key (column with unique values) for this table.
* This table contains the rating of a movie by a user in their review.
created_at is the user's review date. 
 
### Write a solution to:
* ### Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
* ### Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.


```SQL
WITH num_ratings_users AS (
    SELECT user_id,
        COUNT(movie_id) AS num_ratings
    FROM movierating
    GROUP BY user_id
),
user_most_ratings AS (
    SELECT u.name
    FROM users u
    JOIN num_ratings_users n
        ON u.user_id = n.user_id
    ORDER BY n.num_ratings DESC, u.name
    LIMIT 1    
),
movie_rating_avg_feb2020 AS (
    SELECT movie_id,
           AVG(rating) AS avg_rating
    FROM movierating
    WHERE DATE_TRUNC('month', created_at) = '2020-02-01'
    GROUP BY movie_id
),
highest_avg_rating_feb2020 AS (
    SELECT m.title
    FROM movies m
    JOIN movie_rating_avg_feb2020 mf
        ON m.movie_id = mf.movie_id
    ORDER BY mf.avg_rating DESC, m.title
    LIMIT 1
)

SELECT name AS results FROM user_most_ratings
UNION ALL
SELECT title FROM highest_avg_rating_feb2020
```


## [1321. [Medium]Restaurant Growth](https://leetcode.com/problems/restaurant-growth)

Table: Customer
<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
</pre>
* In SQL,(customer_id, visited_on) is the primary key for this table.
* This table contains data about customer transactions in a restaurant.
* visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
* amount is the total paid by a customer.
 

### You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day). Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places. Return the result table ordered by visited_on in ascending order.

```SQL
WITH dates AS (
    SELECT GENERATE_SERIES(MIN(visited_on) + INTERVAL '6 days', MAX(visited_on), INTERVAL '1 day') AS dt
    FROM customer
)

SELECT d.dt::DATE AS visited_on, SUM(c.amount) AS amount, ROUND(SUM(c.amount)::DECIMAL/7, 2) AS average_amount
FROM dates d
JOIN customer c
    ON c.visited_on <= d.dt AND c.visited_on >= d.dt - INTERVAL '6 days'
GROUP BY d.dt
ORDER BY d.dt

-- OR Better way -- 

SELECT *
FROM (
    SELECT visited_on,
           SUM(SUM(amount)) OVER (
               ORDER BY visited_on 
               ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            ) AS amount,
            ROUND(AVG(SUM(amount)) OVER (
               ORDER BY visited_on 
               ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            ), 2) AS average_amount
    FROM customer
    GROUP BY visited_on
) AS subq
WHERE subq.visited_on >= (SELECT MIN(visited_on) FROM customer) + INTERVAL '6 days'


-- OR --

WITH cust AS (
    SELECT visited_on,
           SUM(amount) AS amount
    FROM customer
    GROUP BY visited_on
)

SELECT c2.visited_on,
       SUM(c1.amount) AS amount,
       ROUND(AVG(c1.amount), 2) AS average_amount
FROM cust c1
JOIN cust c2
    ON c2.visited_on BETWEEN c1.visited_on AND c1.visited_on + INTERVAL '6 days'
WHERE c2.visited_on >= (SELECT MIN(visited_on) + INTERVAL '6 days' FROM cust)
GROUP BY c2.visited_on
ORDER BY c2.visited_on
```

## [602. [Medium]Friend Requests II: Who Has the Most Friends](https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends)

Table: RequestAccepted
<pre>
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
</pre>
* (requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
* This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
 

### Write a solution to find the people who have the most friends and the most friends number. The test cases are generated so that only one person has the most friends.

### Follow up - In the real world, multiple people could have the same most number of friends. Could you find all these people in this case?


```SQL
SELECT id, num
FROM (
    SELECT id,
        COUNT(*) AS num, 
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM (
        SELECT requester_id AS id
        FROM RequestAccepted
        UNION ALL
        SELECT accepter_id AS id
        FROM RequestAccepted
    ) AS unions
    GROUP BY id
) AS subq
WHERE rnk = 1
```

## [585. [Medium]Investments in 2016](https://leetcode.com/problems/investments-in-2016)

Table: Insurance
<pre>
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
</pre>
* pid is the primary key (column with unique values) for this table.
* Each row of this table contains information about one policy where:
    * pid is the policyholder's policy ID.
    * tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
    * lat is the latitude of the policy holder's city. It's guaranteed that lat is not NULL.
    * lon is the longitude of the policy holder's city. It's guaranteed that lon is not NULL.
 

### Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:

* ### have the same tiv_2015 value as one or more other policyholders, 
* ### and are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique). 

### Round tiv_2016 to two decimal places.


```SQL
SELECT ROUND(SUM(tiv_2016)::DECIMAL, 2) AS tiv_2016
FROM (
    SELECT tiv_2016,
           COUNT(*) OVER (PARTITION BY lat, lon) AS cnt_loc,
           COUNT(*) OVER (PARTITION BY tiv_2015) AS cnt_tiv2015
    FROM insurance
) AS subq
WHERE subq.cnt_loc = 1 AND subq.cnt_tiv2015 > 1
```

## [185. [Hard]Department Top Three Salaries](https://leetcode.com/problems/department-top-three-salaries)

Table: Employee
<pre>
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
</pre>
* id is the primary key (column with unique values) for this table.
* departmentId is a foreign key (reference column) of the ID from the Department table.
* Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
</pre>
* id is the primary key (column with unique values) for this table.
* Each row of this table indicates the ID of a department and its name.
 
### A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department. Write a solution to find the employees who are high earners in each of the departments.


```SQL
SELECT d.name AS department, 
       subq.name AS employee, 
       subq.salary
FROM department d
JOIN (
    SELECT name, 
           salary, 
           departmentid,
           DENSE_RANK() OVER (PARTITION BY departmentid ORDER BY salary DESC) AS drnk
    FROM employee
) AS subq
    ON d.id = subq.departmentid AND subq.drnk <= 3
```


## [1667. [Easy]Fix Names in a Table](https://leetcode.com/problems/fix-names-in-a-table)

Table: Users
<pre>
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
</pre>
* user_id is the primary key (column with unique values) for this table.
* This table contains the ID and the name of the user. The name consists of only lowercase and uppercase characters.
 
### Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase. Return the result table ordered by user_id.


```SQL
SELECT user_id, 
       CONCAT(
           UPPER(LEFT(name, 1)), 
           LOWER(SUBSTRING(name, 2))
       ) AS name
FROM users
ORDER BY user_id
```

## [1527. [Easy]Patients With a Condition](https://leetcode.com/problems/patients-with-a-condition)

Table: Patients
<pre>
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| patient_id   | int     |
| patient_name | varchar |
| conditions   | varchar |
+--------------+---------+
</pre>
* patient_id is the primary key (column with unique values) for this table.
* 'conditions' contains 0 or more code separated by spaces. 
* This table contains information of the patients in the hospital.
 

### Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.

```SQL
SELECT *
FROM patients
WHERE conditions ~ '^DIAB1|\sDIAB1'

-- conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%'
```


## [196. [Easy]Delete Duplicate Emails](https://leetcode.com/problems/delete-duplicate-emails)

Table: Person
<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
</pre>
* id is the primary key (column with unique values) for this table.
* Each row of this table contains an email. The emails will not contain uppercase letters.
 

### Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.


```SQL
DELETE FROM person
WHERE id NOT IN (
    SELECT MIN(id) as id
    FROM person
    GROUP BY email
)

-- OR --

DELETE FROM person p1
USING person p2
WHERE p1.email = p2.email AND
           p1.id > p2.id
```