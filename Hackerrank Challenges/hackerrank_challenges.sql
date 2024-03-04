## 1. Revising the Select Query I

/*
URL - https://www.hackerrank.com/challenges/revising-the-select-query/problem

Query all columns for all American cities in the CITY table with 
populations larger than 100000. The CountryCode for America is USA.
*/


SELECT *
FROM CITY
WHERE POPULATION > 100000 AND COUNTRYCODE = 'USA'


## 2. Revising the Select Query II

/*
https://www.hackerrank.com/challenges/revising-the-select-query-2/problem

Query the NAME field for all American cities in the CITY table with 
populations larger than 120000. The CountryCode for America is USA.
*/


SELECT NAME
FROM CITY
WHERE COUNTRYCODE = 'USA' AND
          POPULATION > 120000


## 3. SELECT ALL

/*
https://www.hackerrank.com/challenges/select-all-sql/problem

Query all columns (attributes) for every row in 
the CITY table.
*/

SELECT * 
FROM CITY


## 4. Select by ID

/*
https://www.hackerrank.com/challenges/select-by-id/problem

Query all columns for a city in CITY with the ID 
1661.
*/


SELECT *
FROM CITY
WHERE ID = 1661


## 5. Japanese Cities' Attributes

/*
https://www.hackerrank.com/challenges/japanese-cities-attributes/problem

Query all attributes of every Japanese city in 
the CITY table. The COUNTRYCODE for Japan is JPN.
*/

SELECT *
FROM CITY
WHERE COUNTRYCODE = 'JPN'


## 6. Japanese Cities' Names

/*
https://www.hackerrank.com/challenges/japanese-cities-name/problem

Query the names of all the Japanese cities in the 
CITY table. The COUNTRYCODE for Japan is JPN.
*/

SELECT NAME
FROM CITY
WHERE COUNTRYCODE = 'JPN';


## 7. Weather Observation Station 1

/*
https://www.hackerrank.com/challenges/weather-observation-station-1/problem

Query a list of CITY and STATE from the STATION 
table.
*/


SELECT CITY, STATE
FROM STATION


## 8. Weather Observation Station 3

/*
https://www.hackerrank.com/challenges/weather-observation-station-3/problem

Query a list of CITY names from STATION for 
cities that have an even ID number. Print the 
results in any order, but exclude duplicates 
from the answer.
*/


SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0


## 9. Weather Observation Station 4

/*
https://www.hackerrank.com/challenges/weather-observation-station-4/problem

Find the difference between the total number of 
CITY entries in the table and the number of 
distinct CITY entries in the table.
*/


SELECT COUNT(CITY) - COUNT(DISTINCT CITY)
FROM STATION 


## 10. Weather Observation Station 5

/*
https://www.hackerrank.com/challenges/weather-observation-station-5/problem

Query the two cities in STATION with the 
shortest and longest CITY names, as well as their 
respective lengths (i.e.: number of characters in 
the name). If there is more than one smallest or 
largest city, choose the one that comes first 
when ordered alphabetically.
*/


(SELECT CITY, LENGTH(CITY) AS len
FROM STATION
ORDER BY len ASC, CITY ASC
LIMIT 1)

UNION ALL

(SELECT CITY, LENGTH(CITY) AS len
FROM STATION
ORDER BY len DESC, CITY ASC
LIMIT 1)


## 11. Weather Observation Station 6

/*
https://www.hackerrank.com/challenges/weather-observation-station-6/problem

Query the list of CITY names starting with vowels 
(i.e., a, e, i, o, or u) from STATION. Your 
result cannot contain duplicates.
*/

SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u')

/*OR*/

SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[aeiou]'


## 12. Weather Observation Station 7

/*
https://www.hackerrank.com/challenges/weather-observation-station-7/problem

Query the list of CITY names ending with vowels 
(i.e., a, e, i, o, or u) from STATION. Your 
result cannot contain duplicates.
*/


SELECT DISTINCT CITY
FROM STATION
WHERE RIGHT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u')

/*OR*/

SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '[aeiou]$'


## 13. Weather Observation Station 8

/*
https://www.hackerrank.com/challenges/weather-observation-station-8/problem

Query the list of CITY names starting and ending 
with vowels (i.e., a, e, i, o, or u) from STATION. 
Your result cannot contain duplicates.
*/

SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[aeiou].*[aeiou]$'


## 14. Weather Observation Station 9

/*
https://www.hackerrank.com/challenges/weather-observation-station-9/problem

Query the list of CITY names from STATION that 
do not start with vowels. Your result cannot 
contain duplicates.
*/


SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY, 1) NOT LIKE ('a','e','i','o','u')


## 15. Weather Observation Station 10

/*
https://www.hackerrank.com/challenges/weather-observation-station-10/problem

Query the list of CITY names from STATION that 
do not end with vowels. Your result cannot 
contain duplicates.
*/


SELECT DISTINCT CITY
FROM STATION
WHERE RIGHT(CITY, 1) NOT IN ('a','e','i','o','u')


## 16. Weather Observation Station 11

/*
https://www.hackerrank.com/challenges/weather-observation-station-11/problem

Query the list of CITY names from STATION that 
do not end with vowels or do not start with 
vowels. Your result cannot contain duplicates.
*/


SELECT DISTINCT CITY
FROM STATION
WHERE RIGHT(CITY, 1) NOT IN ('a','e','i','o','u') OR
        LEFT(CITY, 1) NOT IN ('a','e','i','o','u')



## 17. Weather Observation Station 12

/*
https://www.hackerrank.com/challenges/weather-observation-station-11/problem

Query the list of CITY names from STATION that 
do not end with vowels and do not start with 
vowels. Your result cannot contain duplicates.
*/


SELECT DISTINCT CITY
FROM STATION
WHERE RIGHT(CITY, 1) NOT IN ('a','e','i','o','u') AND
        LEFT(CITY, 1) NOT IN ('a','e','i','o','u')



## 18. Higher Than 75 Marks

/*
https://www.hackerrank.com/challenges/more-than-75-marks/problem

Query the Name of any student in STUDENTS who 
scored higher than  Marks. Order your output by 
the last three characters of each name. If two or 
more students both have names ending in the same 
last three characters (i.e.: Bobby, Robby, etc.), 
secondary sort them by ascending ID.
*/


SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID


## 19. Employee Names

/*
https://www.hackerrank.com/challenges/name-of-employees/problem

Write a query that prints a list of employee 
names (i.e.: the name attribute) from the 
Employee table in alphabetical order.
*/


SELECT name
FROM Employee
ORDER BY name


## 20. Employee Salaries

/*
https://www.hackerrank.com/challenges/salary-of-employees/problem

Write a query that prints a list of employee 
names (i.e.: the name attribute) for employees in 
Employee having a salary greater than  per month 
who have been employees for less than  months. 
Sort your result by ascending employee_id.
*/


SELECT name
FROM Employee
WHERE salary > 2000 AND 
        months < 10


## 21. Average Population

/*
https://www.hackerrank.com/challenges/average-population/problem

Query the average population for all cities in 
CITY, rounded down to the nearest integer.
*/


SELECT ROUND(AVG(POPULATION)) AS avg_pop
FROM CITY


## 22. Japan Population

/*
https://www.hackerrank.com/challenges/japan-population/problem

Query the sum of the populations for all Japanese 
cities in CITY. The COUNTRYCODE for Japan is JPN.
*/


SELECT SUM(POPULATION) AS japan_pop
FROM CITY
WHERE COUNTRYCODE = 'JPN'


## 23. Population Density Difference

/*
https://www.hackerrank.com/challenges/population-density-difference/problem

Query the difference between the maximum and 
minimum populations in CITY.
*/


SELECT MAX(POPULATION) - MIN(POPULATION) AS difference
FROM CITY


## 24. The Blunder

/*
https://www.hackerrank.com/challenges/the-blunder/problem

Samantha was tasked with calculating the average 
monthly salaries for all employees in the 
EMPLOYEES table, but did not realize her 
keyboard's  key was broken until after completing 
the calculation. She wants your help finding the 
difference between her miscalculation (using 
salaries with any zeros removed), and the actual 
average salary.

Write a query calculating the amount of error 
(i.e.:  average monthly salaries), and round it 
up to the next integer.
*/


SELECT CEIL(AVG(SALARY) - AVG(CAST(REPLACE(CAST(SALARY AS CHAR), '0','') AS SIGNED))) AS diff_avg_salary
FROM EMPLOYEES


## 25. Type of Triangle


/*
https://www.hackerrank.com/challenges/what-type-of-triangle/problem

Write a query identifying the type of each record in the TRIANGLES 
table using its three side lengths.
*/


SELECT CASE
            WHEN (A + B <= C) OR (A + C <= B) OR (B + C <= A) THEN 'Not A Triangle'
            WHEN (A = B AND B = C) THEN 'Equilateral'
            WHEN (A = B AND B != C) OR (A != B AND B = C) OR (A = C AND C != B) THEN 'Isosceles'
            WHEN (A != B AND B != C AND A != C) THEN 'Scalene'
       END
FROM TRIANGLES


## 26. The PADS

/*
https://www.hackerrank.com/challenges/the-pads/problem

Query an alphabetically ordered list of all names in OCCUPATIONS, 
immediately followed by the first letter of each profession as a 
parenthetical (i.e.: enclosed in parentheses). 
For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and 
ASingerName(S).

Query the number of ocurrences of each occupation in OCCUPATIONS. Sort 
the occurrences in ascending order, and output them in the following 
format:

There are a total of [occupation_count] [occupation]s.
where [occupation_count] is the number of occurrences of an occupation 
in OCCUPATIONS and [occupation] is the lowercase occupation name. If 
more than one Occupation has the same [occupation_count], they should 
be ordered alphabetically.
*/


SELECT CONCAT(Name, '(', UPPER(LEFT(Occupation, 1)), ')')
FROM OCCUPATIONS
ORDER BY Name;

SELECT CONCAT('There are a total of ', COUNT(*), ' ', lower(Occupation),'s.')
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(*), Occupation


## 27. Weather Observation Station 18

/*
https://www.hackerrank.com/challenges/weather-observation-station-18/problem

Consider P1(a, b) and P2(c, d) to be two points on a 2D plane.

a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
Query the Manhattan Distance between points P1 and P2 and round it to 
a scale of  decimal places.
*/


SELECT ROUND(ABS(a - c) + ABS(b - d), 4)
FROM (
    SELECT MIN(LAT_N) AS a,
           MIN(LONG_W) AS b,
           MAX(LAT_N) AS c,
           MAX(LONG_W) AS d
    FROM STATION
    ) AS subq


## 28. New Companies

/*
https://www.hackerrank.com/challenges/the-company/problem

Amber's conglomerate corporation just acquired some new companies. 
Each of the companies follows this hierarchy:

Founder -> Lead Manager -> Senior Manager -> Manager -> Employee

Given the table schemas below, write a query to print the company_code, 
founder name, total number of lead managers, total number of senior 
managers, total number of managers, and total number of employees. 
Order your output by ascending company_code.
*/


SELECT c.company_code, 
       c.founder, 
       COUNT(DISTINCT e.lead_manager_code),
       COUNT(DISTINCT e.senior_manager_code),
       COUNT(DISTINCT e.manager_code),
       COUNT(DISTINCT e.employee_code)
FROM Company c
JOIN Employee e
    ON c.company_code = e.company_code
GROUP BY c.founder, c.company_code
ORDER BY c.company_code


## 29. Weather Observation Station 20

/*
https://www.hackerrank.com/challenges/weather-observation-station-20/problem

A median is defined as a number separating the higher half of a data 
set from the lower half. Query the median of the Northern Latitudes 
(LAT_N) from STATION and round your answer to  decimal places.
*/


SELECT ROUND(AVG(LAT_N), 4) AS median_lat_n 
FROM (
        SELECT LAT_N,
               ROW_NUMBER() OVER (ORDER BY LAT_N) AS row_n,
               COUNT(*) OVER () AS tot
        FROM STATION
) AS subq
WHERE subq.row_n IN (
                        FLOOR((subq.tot + 1)/2),
                        FLOOR((subq.tot + 2)/2)
                )


## 30. Occupations

/*
https://www.hackerrank.com/challenges/occupations/problem

Pivot the Occupation column in OCCUPATIONS so that each Name is sorted 
alphabetically and displayed underneath its corresponding Occupation. 
The output column headers should be Doctor, Professor, Singer, and 
Actor, respectively.

Note: Print NULL when there are no more names corresponding to an 
occupation.
*/


SELECT MIN(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
       MIN(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
       MIN(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
       MIN(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM (
        SELECT Name, 
               Occupation,
               ROW_NUMBER() OVER(PARTITION BY Occupation ORDER BY Name) AS n_row
        FROM OCCUPATIONS
) AS subq
GROUP BY subq.n_row


## 31. Weather Station 19

/*
https://www.hackerrank.com/challenges/weather-observation-station-19/problem

Consider  and  to be two points on a 2D plane where  are the 
respective minimum and maximum values of Northern Latitude (LAT_N) and  
are the respective minimum and maximum values of Western Longitude 
(LONG_W) in STATION.

Query the Euclidean Distance between points  and  and format your 
answer to display  decimal digits.
*/


SELECT ROUND(POWER(POWER(a - b, 2) + POWER(c - d, 2), 0.5), 4)
FROM (
        SELECT MIN(LAT_N) AS a,
               MAX(LAT_N) AS b,
               MIN(LONG_W) AS c,
               MAX(LONG_W) AS d
        FROM STATION
) AS subq


## 32. The report

/*
https://www.hackerrank.com/challenges/the-report/problem

You are given two tables: Students and Grades. Students contains 
three columns ID, Name and Marks. Grades has grade, min_marks, and
max_marks.

Ketty gives Eve a task to generate a report containing three 
columns: Name, Grade and Mark. Ketty doesn't want the NAMES of 
those students who received a grade lower than 8. The report must 
be in descending order by grade -- i.e. higher grades are entered 
first. If there is more than one student with the same grade 
(8-10) assigned to them, order those particular students by their 
name alphabetically. Finally, if the grade is lower than 8, use 
"NULL" as their name and list them by their grades in descending 
order. If there is more than one student with the same grade (1-7) 
assigned to them, order those particular students by their marks 
in ascending order.

Write a query to help Eve.
*/


SELECT CASE
            WHEN grade > 7 THEN s.Name
            ELSE 'NULL'
       END AS Name, g.Grade, s.Marks 
FROM Students s
LEFT JOIN Grades g
    ON s.Marks >= g.Min_Mark AND s.Marks <= g.Max_Mark
ORDER BY g.Grade DESC, s.Name ASC, s.Marks ASC


## 33. Top Competitors

/*
URL - https://www.hackerrank.com/challenges/full-score/problem

Julia just finished conducting a coding contest, and she
needs your help assembling the leaderboard! Write a 
query to print the respective hacker_id and name of 
hackers who achieved full scores for more than one 
challenge. Order your output in descending order by the
total number of challenges in which the hacker earned a
full score. If more than one hacker received full scores
in same number of challenges, then sort them by 
ascending hacker_id.
*/


SELECT h.hacker_id, h.name
FROM hackers h
JOIN submissions s
    ON h.hacker_id = s.hacker_id
JOIN challenges c
    ON s.challenge_id = c.challenge_id
JOIN difficulty d
    ON c.difficulty_level = d.difficulty_level AND s.score = d.score
GROUP BY h.hacker_id, h.name
HAVING COUNT(s.challenge_id) > 1
ORDER BY COUNT(s.challenge_id) DESC, h.hacker_id


## 34. Olivander's Inventory

/*
URL - https://www.hackerrank.com/challenges/harry-potter-and-wands/problem

Harry Potter and his friends are at Ollivander's with Ron, finally 
replacing Charlie's old broken wand.

Hermione decides the best way to choose is by determining the minimum 
number of gold galleons needed to buy each non-evil wand of high power 
and age. Write a query to print the id, age, coins_needed, and power 
of the wands that Ron's interested in, sorted in order of descending 
power. If more than one wand has same power, sort the result in order 
of descending age.
*/


SELECT w1.id, subq.age, subq.min_coins, w1.power
FROM wands w1
JOIN (
    SELECT w.code, wp.age, MIN(coins_needed) AS min_coins
    FROM wands AS w
    JOIN wands_property AS wp
        ON w.code  = wp.code AND wp.is_evil = 0
    GROUP BY w.code, wp.age, w.power
) AS subq
    ON w1.code = subq.code AND w1.coins_needed = subq.min_coins
ORDER BY w1.power DESC, subq.age DESC


## 35. Challenges

/*
URL - https://www.hackerrank.com/challenges/challenges/problem

Julia asked her students to create some coding challenges. Write a query 
to print the hacker_id, name, and the total number of challenges created 
by each student. Sort your results by the total number of challenges in 
descending order. If more than one student created the same number of 
challenges, then sort the result by hacker_id. If more than one student 
created the same number of challenges and the count is less than the 
maximum number of challenges created, then exclude those students from 
the result.
*/


WITH count_challenges AS (
    SELECT h.hacker_id, h.name, COUNT(*) AS cnt
    FROM hackers h
    JOIN challenges c
        ON h.hacker_id = c.hacker_id
    GROUP BY h.hacker_id, h.name
)
        
SELECT cc.hacker_id, cc.name, cc.cnt 
FROM count_challenges AS cc
WHERE cc.cnt IN (
    SELECT cnt
    FROM count_challenges
    GROUP BY cnt
    HAVING COUNT(*) = 1 OR MAX(cnt) = (SELECT MAX(cnt) FROM count_challenges)
)
ORDER BY cc.cnt DESC, cc.hacker_id


## 36. Contest Leaderboard

/*
URL - https://www.hackerrank.com/challenges/contest-leaderboard/problem

You did such a great job helping Julia with her last coding contest 
challenge that she wants you to work on this one, too!

The total score of a hacker is the sum of their maximum scores for all 
of the challenges. Write a query to print the hacker_id, name, and total 
score of the hackers ordered by the descending score. If more than one 
hacker achieved the same total score, then sort the result by ascending 
hacker_id. Exclude all hackers with a total score of  from your result.
*/


SELECT h.hacker_id, h.name, SUBQ2.tot_max_score
FROM HACKERS h
JOIN (
    SELECT SUBQ1.hacker_id, SUM(SUBQ1.max_score) as tot_max_score 
    FROM (
        SELECT hacker_id, challenge_id, MAX(score) AS max_score
        FROM SUBMISSIONS
        GROUP BY hacker_id, challenge_id
        HAVING MAX(score) > 0
    ) AS SUBQ1
    GROUP BY SUBQ1.hacker_id
) AS SUBQ2
    ON h.hacker_id = SUBQ2.hacker_id
ORDER BY SUBQ2.tot_max_score DESC, h.hacker_id


## 37. Placements

/*
URL - https://www.hackerrank.com/challenges/placements/problem

You are given three tables: Students, Friends and Packages. Students 
contains two columns: ID and Name. Friends contains two columns: ID and 
Friend_ID (ID of the ONLY best friend). Packages contains two columns: 
ID and Salary (offered salary in $ thousands per month).

Write a query to output the names of those students whose best friends 
got offered a higher salary than them. Names must be ordered by the 
salary amount offered to the best friends. It is guaranteed that no two 
students got same salary offer.
*/


SELECT s.name
FROM students s
JOIN friends f
    ON s.id = f.id
JOIN packages p
    ON f.id = p.id
JOIN packages fp
    ON fp.id = f.friend_id
WHERE p.salary < fp.salary
ORDER BY fp.salary


## 38. Symmetric Pairs

/*
URL - https://www.hackerrank.com/challenges/symmetric-pairs/problem

You are given a table, Functions, containing two columns: X and Y.

Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 
and X2 = Y1.

Write a query to output all such symmetric pairs in ascending order by 
the value of X. List the rows such that X1 ≤ Y1.
*/


WITH cte AS (
    SELECT x, y, ROW_NUMBER() OVER() r_num FROM functions
)

SELECT DISTINCT c1.X, c1.Y 
FROM cte c1
JOIN cte c2 
    ON c1.X = c2.Y AND c2.X = c1.Y AND c1.r_num != c2.r_num 
WHERE c1.x <= c1.Y 
ORDER BY c1.x;


## 39. Interviews

/*
URL - https://www.hackerrank.com/challenges/interviews/problem

Samantha interviews many candidates from different colleges using coding 
challenges and contests. Write a query to print the contest_id, 
hacker_id, name, and the sums of total_submissions, 
total_accepted_submissions, total_views, and total_unique_views for each 
contest sorted by contest_id. Exclude the contest from the result if all 
four sums are .

Note: A specific contest can be used to screen candidates at more than 
one college, but each college only holds  screening contest.
*/


SELECT cts.contest_id, 
       cts.hacker_id,
       cts.name, 
       SUM(ss.tot_subs),
       SUM(ss.tot_acc_subs),
       SUM(vs.tot_vws),
       SUM(vs.tot_unq_vws)
FROM contests cts
JOIN colleges clg
    ON cts.contest_id = clg.contest_id
JOIN challenges chlg
    ON clg.college_id = chlg.college_id
LEFT JOIN (
    SELECT challenge_id, 
           SUM(total_views) as tot_vws, 
           SUM(total_unique_views) AS tot_unq_vws
    FROM view_stats
    GROUP BY challenge_id
) AS vs
    ON chlg.challenge_id = vs.challenge_id
LEFT JOIN (
    SELECT challenge_id, 
           SUM(total_submissions) as tot_subs, 
           SUM(total_accepted_submissions) AS tot_acc_subs
    FROM submission_stats
    GROUP BY challenge_id
) AS ss
    ON chlg.challenge_id = ss.challenge_id
GROUP BY cts.contest_id, cts.hacker_id, cts.name
HAVING SUM(ss.tot_subs) + SUM(ss.tot_acc_subs) + 
                              SUM(vs.tot_vws) + SUM(vs.tot_unq_vws) != 0
ORDER BY cts.contest_id


## 40. Draw a triangle 1

/*
URL - https://www.hackerrank.com/challenges/draw-the-triangle-1

P(R) represents a pattern drawn by Julia in R rows. The following 
pattern represents P(5):

* * * * * 
* * * * 
* * * 
* * 
*

Write a query to print the pattern P(20).
*/


WITH RECURSIVE pattern AS (
    SELECT 20 AS n
    UNION ALL
    SELECT n - 1 FROM pattern
    where n >= 1 
)

SELECT REPEAT('* ', n) FROM pattern;


## 41. Draw a triangle 2

/*
URL - https://www.hackerrank.com/challenges/draw-the-triangle-2

P(R) represents a pattern drawn by Julia in R rows. The following 
pattern represents P(5):

* 
* * 
* * * 
* * * * 
* * * * *

Write a query to print the pattern P(20).
*/


WITH RECURSIVE pattern AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM pattern
    WHERE n <= 19
)

SELECT REPEAT('* ', n) FROM pattern


## 42. Prime numbers

/*
URL - https://www.hackerrank.com/challenges/print-prime-numbers

Write a query to print all prime numbers less than or equal to . Print 
your result on a single line, and use the ampersand () character as your 
separator (instead of a space).

For example, the output for all prime numbers  would be:
        
        2&3&5&7
*/


WITH RECURSIVE num AS (
  SELECT 2 AS n
  UNION ALL
  SELECT n + 1
  FROM num
  WHERE n < 1000
)

SELECT GROUP_CONCAT(n SEPARATOR '&')
FROM num 
WHERE n NOT IN (SELECT n2.n
FROM num n1
JOIN num n2
  ON n1.n < n2.n AND n2.n % n1.n = 0)


## 43. SQL Project Planning

/*
URL - https://www.hackerrank.com/challenges/sql-projects/problem

You are given a table, Projects, containing three columns: Task_ID, 
Start_Date and End_Date. It is guaranteed that the difference between 
the End_Date and the Start_Date is equal to 1 day for each row in the 
table.

If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the 
number of days it took to complete the project in ascending order. If 
there is more than one project that have the same number of completion 
days, then order by the start date of the project.
*/


SELECT MIN(start_date) AS sd, MAX(end_date) AS ed
FROM (
    SELECT start_date, end_date,
           end_date - ROW_NUMBER() OVER (ORDER BY end_date) as diff
    FROM projects
) AS subq
GROUP BY subq.diff
ORDER BY ed - sd, sd


## 44. Binary Tree Nodes

/*
URL - https://www.hackerrank.com/challenges/binary-search-tree-1/problem

You are given a table, BST, containing two columns: N and P, where N 
represents the value of a node in Binary Tree, and P is the parent of N.

Write a query to find the node type of Binary Tree ordered by the value 
of the node. Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.
*/


SELECT N, 
       CASE
            WHEN P IS NULL THEN 'Root'
            WHEN N IN (SELECT P FROM BST) THEN 'Inner'
            ELSE 'Leaf'
       END AS s
FROM BST
ORDER BY N


## 45. 15 Days Of Learning SQL

/*
URL - https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem

Julia conducted a  days of learning SQL contest. The start date of the 
contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least 
submission each day (starting on the first day of the contest), and 
find the hacker_id and name of the hacker who made maximum number of 
submissions each day. If more than one such hacker has a maximum number 
of submissions, print the lowest hacker_id. The query should print this 
information for each day of the contest, sorted by the date.
*/


WITH unique_hackers AS (
    SELECT DISTINCT submission_date, 
           hacker_id
    FROM submissions
    WHERE submission_date = (SELECT MIN(submission_date) FROM submissions)
    
    UNION ALL
    
    SELECT s.submission_date, 
           s.hacker_id
    FROM submissions s
    JOIN unique_hackers uha
        ON s.hacker_id = uha.hacker_id AND 
            s.submission_date = DATEADD(day, 1, uha.submission_date)
),
unique_hackers_everyday AS (
    SELECT submission_date, 
           COUNT(DISTINCT hacker_id) AS cnt_unq_hacker
    FROM unique_hackers
    GROUP BY submission_date
),
total_sub_hackers AS (
    SELECT submission_date, 
           hacker_id, 
           COUNT(submission_id) AS cnt_subs, 
           ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY COUNT(DISTINCT submission_id) DESC, hacker_id) AS rnk
    FROM submissions
    GROUP BY submission_date, hacker_id
),
unique_hackers_join_total_subs AS (
    SELECT uha.submission_date, 
           uha.cnt_unq_hacker, 
           tsh.hacker_id
    FROM unique_hackers_everyday uha
    JOIN total_sub_hackers tsh
        ON uha.submission_date = tsh.submission_date AND tsh.rnk = 1
)

SELECT u.submission_date, u.cnt_unq_hacker, u.hacker_id, h.name 
FROM hackers h
JOIN unique_hackers_join_total_subs u
    ON h.hacker_id = u.hacker_id
ORDER BY u.submission_date