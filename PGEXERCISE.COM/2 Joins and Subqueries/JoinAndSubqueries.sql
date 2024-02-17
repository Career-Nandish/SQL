# Question 1

/* 
How can you produce a list of the start times for bookings by members 
named 'David Farrell'?
*/

SELECT b.starttime
FROM cd.bookings b
JOIN cd.members m
ON b.memid = m.memid AND (m.firstname = 'David' AND m.surname = 'Farrell');

# Question 2

/* 
How can you produce a list of the start times for bookings for tennis 
courts, for the date '2012-09-21'? Return a list of start time and 
facility name pairings, ordered by the time.
*/

SELECT b.starttime, f.name
FROM cd.bookings b
JOIN cd.facilities f
ON b.facid = f.facid
WHERE DATE(b.starttime) = '2012-09-21' AND f.name LIKE '%Tennis Court%'
ORDER BY 1, 2;

# Question 3

/* 
How can you output a list of all members who have recommended another 
member? Ensure that there are no duplicates in the list, and that results 
are ordered by (surname, firstname).
*/

SELECT DISTINCT r.firstname as firstname, r.surname as surname
FROM cd.members m
INNER JOIN cd.members r
ON r.memid = m.recommendedby
ORDER BY 2, 1;    


# Question 4

/* 
How can you output a list of all members, including the individual who 
recommended them (if any)? Ensure that results are ordered by 
(surname, firstname).
*/

SELECT mem.firstname memfname, mem.surname memsname, rec.firstname recfname, 
	   rec.surname recsname
FROM cd.members mem
LEFT OUTER JOIN cd.members rec
ON rec.memid = mem.recommendedby
ORDER BY 2, 1;

# Question 5

/*
How can you produce a list of all members who have used a tennis court? 
Include in your output the name of the court, and the name of the member 
formatted as a single column. Ensure no duplicate data, and order by the 
member name followed by the facility name.
*/

SELECT DISTINCT CONCAT(mem.firstname, ' ', mem.surname) member, fac.name facility
FROM cd.members mem
JOIN cd.bookings book
ON mem.memid = book.memid
JOIN cd.facilities fac
ON book.facid = fac.facid AND fac.name LIKE '%Tennis Court%'
ORDER BY 1, 2;

# Question 6

/*
How can you produce a list of bookings on the day of 2012-09-14 which will 
cost the member (or guest) more than $30? Remember that guests have 
different costs to members (the listed costs are per half-hour 'slot'), and 
the guest user is always ID 0. Include in your output the name of the 
facility, the name of the member formatted as a single column, and the 
cost. Order by descending cost, and do not use any subqueries.
*/

SELECT CONCAT(m.firstname, ' ', m.surname) member, f.name facility, 
		CASE
			WHEN m.memid = 0 THEN b.slots * f.guestcost
			ELSE b.slots * f.membercost
		END AS cost
FROM cd.members m
JOIN cd.bookings b
ON m.memid = b.memid AND DATE(b.starttime) = '2012-09-14'
JOIN cd.facilities f
ON b.facid = f.facid
WHERE (m.memid = 0 AND b.slots * f.guestcost > 30) OR 
		(m.memid != 0 AND b.slots * f.membercost > 30)
ORDER BY 3 DESC;

# Question 7

/*
How can you output a list of all members, including the individual who 
recommended them (if any), without using any joins? Ensure that there are 
no duplicates in the list, and that each firstname + surname pairing is 
formatted as a column and ordered.
*/

SELECT DISTINCT CONCAT(m.firstname, ' ', m.surname) AS member, 
		(
		 SELECT CONCAT(m1.firstname, ' ', m1.surname) AS recommender 
		 FROM cd.members m1 
		 WHERE m1.memid = m.recommendedby
		) 
FROM cd.members m
ORDER BY 1, 2;


# Question 8

/*
Question 6 bookings exercise contained some messy logic: we had to calculate 
the booking cost in both the WHERE clause and the CASE statement. Try to 
simplify this calculation using subqueries.
*/

SELECT * 
FROM 
   (
	SELECT CONCAT(m.firstname, ' ', m.surname) member, f.name facility, 
		  CASE
			  WHEN m.memid = 0 THEN b.slots * f.guestcost
			  ELSE b.slots * f.membercost
		  END AS cost
	FROM cd.members m
	JOIN cd.bookings b
	ON m.memid = b.memid AND DATE(b.starttime) = '2012-09-14'
	JOIN cd.facilities f
	ON b.facid = f.facid
   ) AS sub
WHERE cost > 30
ORDER BY 3 DESC;