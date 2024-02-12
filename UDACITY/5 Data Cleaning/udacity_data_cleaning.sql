# LEFT and RIGHT


/*
1. In the accounts table, there is a column holding the
website for each company. The last three digits specify
what type of web address they are using. A list of 
extensions (and pricing) is provided here. Pull these 
extensions and provide how many of each website type 
exist in the accounts table.
*/

SELECT RIGHT(website, 3), COUNT(*) AS counts
FROM accounts
GROUP BY 1
ORDER BY 2 DESC


/*
2. There is much debate about how much the name (or 
even the first letter of a company name) matters. Use 
the accounts table to pull the first letter of each 
company name to see the distribution of company names 
that begin with each letter (or number).
*/

SELECT LEFT(name, 1), COUNT(*) AS frequency
FROM accounts
GROUP BY 1
ORDER BY 2 DESC


/*
3. Use the accounts table and a CASE statement to 
create two groups: one group of company names that 
start with a number and a second group of those company
names that start with a letter. What proportion of 
company names start with a letter? 
*/

SELECT
	CASE 
		WHEN LEFT(name, 1) IN 
			('0', '1', '2', '3', '4', '5', '6', '7', 
				'8', '9') THEN 'Digit'
    	ELSE 'Letter' 
    END AS group, COUNT(*) frequency
FROM accounts
GROUP BY 1
ORDER BY 2 DESC

/*
4. Consider vowels as a, e, i, o, and u. What 
proportion of company names start with a vowel, and 
what percent start with anything else?
*/

SELECT 
	CASE 
		WHEN LEFT(name, 1) IN 
			('A', 'E', 'I', 'O', 'U') THEN 'Vowel'
        ELSE 'Other' 
    END AS group, COUNT(*) frequency
FROM accounts
GROUP BY 1
ORDER BY 2 DESC


-----------------------------------
-----------------------------------


# STRPOS, POSITION, LOWER and UPPER


/*
In this lesson, you learned about:
	1. POSITION
	2. STRPOS
	3. LOWER
	4. UPPER

- POSITION takes a character and a column, and provides 
the index where that character is for each row. The 
index of the first position is 1 in SQL. If you come 
rom another programming language, many begin indexing 
at 0. Here, you saw that you can pull the index of a 
comma as POSITION(',' IN city_state).

- STRPOS provides the same result as POSITION, but the 
syntax for achieving those results is a bit different 
as shown here: STRPOS(city_state, ',').

- Note, both POSITION and STRPOS are case sensitive, 
so looking for A is different than looking for a.

- Therefore, if you want to pull an index regardless of 
the case of a letter, you might want to use LOWER or 
UPPER to make all of the characters lower or uppercase.
*/


/*
1. Use the accounts table to create first and last 
name columns that hold the first and last names for 
the primary_poc.
*/

-- STRPOS(primary_poc, ' ')

SELECT primary_poc, 
	   LEFT(primary_poc, pos_space) AS firstName,
	   RIGHT(primary_poc, len - pos_space) AS lastName
FROM 
	(SELECT POSITION(' ' IN primary_poc) AS pos_space, 
		LENGTH(primary_poc) AS len, primary_poc
      FROM accounts) AS t1


/*
2. Now see if you can do the same thing for every rep 
name in the sales_reps table. Again provide first and 
last name columns.
*/

-- STRPOS(name, ' ')

SELECT name, LEFT(name, pos_space) AS firstName,
	RIGHT(name, len - pos_space)  lastName
FROM 
	(SELECT POSITION(' ' IN name) AS pos_space, 
		LENGTH(name) AS len, name
      FROM sales_reps) AS t1


-----------------------------------
-----------------------------------


# CONCAT

/*
In this lesson you learned about:

	1. CONCAT
	2. Piping ||

- Each of these will allow you to combine columns 
together across rows. In this video, you saw how first 
and last names stored in separate columns could be 
combined together to create a full name: 
CONCAT(first_name, ' ', last_name) or with piping as 
first_name || ' ' || last_name.
*/


/*
1. Each company in the accounts table wants to create 
an email address for each primary_poc. The email 
address should be the first name of the primary_poc '.' 
last name primary_poc @ company name .com.
*/

SELECT primary_poc, name, 
	   LOWER(CONCAT(firstName, '.', lastName, 
	   	'@', name, '.com')) AS email
FROM
(SELECT SPLIT_PART(primary_poc, ' ', 1) AS firstName,
		SPLIT_PART(primary_poc, ' ', 2) AS lastName,
        name,
 		primary_poc
from accounts) AS t1


/*
2. You may have noticed that in the previous solution 
some of the company names include spaces, which will 
certainly not work in an email address. See if you can 
create an email address that will work by removing all 
of the spaces in the account name, but otherwise your 
solution should be just as in question 1. Some helpful 
documentation is here.
*/

SELECT primary_poc, name, LOWER(CONCAT(firstName, '.', lastName, '@', REPLACE(name, ' ', ''), '.com'))
FROM
(SELECT SPLIT_PART(primary_poc, ' ', 1) AS firstName,
		SPLIT_PART(primary_poc, ' ', 2) AS lastName,
        name,
 		primary_poc
from accounts) AS t1


/*
3. We would also like to create an initial password, 
which they will change after their first log in. The 
first password will be the first letter of the 
primary_poc's first name (lowercase), then the last 
letter of their first name (lowercase), the first 
letter of their last name (lowercase), the last letter 
of their last name (lowercase), the number of letters 
in their first name, the number of letters in their 
last name, and then the name of the company they are 
working with, all capitalized with no spaces.
*/

SELECT primary_poc, name, 
	    CONCAT(LOWER(LEFT(firstName, 1)),
			LOWER(RIGHT(firstName, 1)),
			LOWER(LEFT(lastName, 1)),
			LOWER(RIGHT(lastName, 1)),
			LENGTH(firstName),
			LENGTH(lastName),
			UPPER(REPLACE(name, ' ', ''))
		)
FROM
(SELECT SPLIT_PART(primary_poc, ' ', 1) AS firstName,
		SPLIT_PART(primary_poc, ' ', 2) AS lastName,
        name,
 		primary_poc
from accounts) AS t1


-----------------------------------
-----------------------------------


# CAST

/*
In this video, you saw additional functionality for 
working with dates including:

	1. TO_DATE
	2. CAST
	3. Casting with ::

DATE_PART('month', TO_DATE(month, 'month')) here 
changed a month name into the number associated with 
that particular month.

Then you can change a string to a date using CAST. 
CAST is actually useful to change lots of column types.
Commonly you might be doing as you saw here, where you 
change a string to a date using CAST(date_column AS 
DATE). However, you might want to make other changes 
to your columns in terms of their data types. You can 
see other examples here.

In this example, you also saw that instead of 
CAST(date_column AS DATE), you can use 
date_column::DATE.
*/


/*
1. Change the date into correct format
*/

SELECT (year || '-' || month  || '-' || day)::date
FROM
	(SELECT SPLIT_PART(date, '/', 1) AS month, 
		SPLIT_PART(date, '/', 2) AS day,
        LEFT(SPLIT_PART(date, '/', 3), 4) AS year
from sf_crime_data) as t1;