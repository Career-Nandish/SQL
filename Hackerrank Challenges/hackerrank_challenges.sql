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