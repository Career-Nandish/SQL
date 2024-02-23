# Question 1

/*
Output the names of all members, formatted as 
'Surname, Firstname'
*/

SELECT CONCAT(surname, ', ', firstname)
FROM cd.members;

# Question 2

/*
Find all facilities whose name begins with 'Tennis'. 
Retrieve all columns.
*/

SELECT *
FROM cd.facilities
WHERE name LIKE 'Tennis%';

# Question 3

/*
Perform a case-insensitive search to find all 
facilities whose name begins with 'tennis'. Retrieve 
all columns.
*/

SELECT *
FROM cd.facilities
WHERE LOWER(name) LIKE 'tennis%';

# Question 4

/*
You've noticed that the club's member table has 
telephone numbers with very inconsistent formatting. 
You'd like to find all the telephone numbers that 
contain parentheses, returning the member ID and 
telephone number sorted by member ID.
*/

SELECT memid, telephone
FROM cd.members
WHERE telephone ~ '[()]'

# Question 5

/*
The zip codes in our example dataset have had leading 
zeroes removed from them by virtue of being stored as 
a numeric type. Retrieve all zip codes from the 
members table, padding any zip codes less than 5 
characters long with leading zeroes. Order by the new 
zip code.
*/

SELECT LPAD(CAST(zipcode AS TEXT), 5 , '0') as zip
FROM cd.members
ORDER BY 1;

# Question 6

/*
You'd like to produce a count of how many members you 
have whose surname starts with each letter of the 
alphabet. Sort by the letter, and don't worry about 
printing out a letter if the count is 0.
*/

SELECT UPPER(LEFT(surname, 1)), COUNT(*)
FROM cd.members
GROUP BY 1
ORDER BY 1;

# Question 7

/*
The telephone numbers in the database are very 
inconsistently formatted. You'd like to print a 
list of member ids and numbers that have had 
'-','(',')', and ' ' characters removed. Order by 
member id
*/

SELECT memid, TRANSLATE(telephone, '-() ', '')
FROM cd.members;

SELECT memid, REGEXP_REPLACE(telephone, '[^0-9]', '', 'g') as telephone
FROM cd.members;

SELECT memid, REPLACE(REPLACE(REPLACE(REPLACE(telephone,' ', ''), '-', ''), '(', ''), ')', '')
FROM cd.members;