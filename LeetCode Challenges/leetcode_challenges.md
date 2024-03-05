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


## [584. [EASY]Find Customer Referee](https://leetcode.com/problems/find-customer-referee)

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