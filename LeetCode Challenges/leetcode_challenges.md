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
product_id is the primary key (column with unique values) for this table.

low_fats is an ENUM (category) of type ('Y', 'N') where 'Y' means this product is low fat and 'N' means it is not.

recyclable is an ENUM (category) of types ('Y', 'N') where 'Y' means this product is recyclable and 'N' means it is not.
 
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

In SQL, id is the primary key column for this table.
Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
 
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
name is the primary key (column with unique values) for this table.

Each row of this table gives information about the name of a country, the continent to which it belongs, its area, the population, and its GDP value.
 
A country is big if:

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


# [1148. [Easy]Article Views I](https://leetcode.com/problems/article-views-i)

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

There is no primary key (column with unique values) for this table, the table may have duplicate rows.

Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 

Note that equal author_id and viewer_id indicate the same person.
 

### Write a solution to find all the authors that viewed at least one of their own articles. Return the result table sorted by id in ascending order.

```SQL
SELECT DISTINCT author_id AS id
FROM views
WHERE author_id = viewer_id
ORDER BY id ASC
```