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


## 29.

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


## 30.

/*

*/