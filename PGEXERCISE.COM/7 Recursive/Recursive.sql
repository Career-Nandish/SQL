# Question 1

/*
Find the upward recommendation chain for member ID 27: 
that is, the member who recommended them, and the 
member who recommended that member, and so on. Return 
member ID, first name, and surname. Order by 
descending member id.
*/

WITH RECURSIVE rec_query(recommender) AS(
  SELECT recommendedby
  FROM cd.members
  WHERE memid = 27
  
  UNION ALL
  
  SELECT m.recommendedby
  FROM cd.members m
  JOIN rec_query r
  ON m.memid = r.recommender
)

SELECT r.recommender, m.firstname, m.surname
FROM rec_query r
JOIN cd.members m
ON r.recommender = m.memid
ORDER BY m.memid DESC;


# Question 2

/*
Find the downward recommendation chain for member 
ID 1: that is, the members they recommended, the 
members those members recommended, and so on. Return 
member ID and name, and order by ascending member id.
*/

WITH RECURSIVE rec_query(recommended) AS(
  SELECT memid AS recommended
  FROM cd.members
  WHERE recommendedby = 1

  UNION ALL
  
  SELECT memid
  FROM cd.members m
  JOIN rec_query r
  ON m.recommendedby = r.recommended
)

SELECT r.recommended AS memid, m.firstname, m.surname
FROM rec_query r
JOIN cd.members m
ON r.recommended = m.memid
ORDER BY 1;

# Question 3

/*
Produce a CTE that can return the upward recommendation 
chain for any member. You should be able to select 
recommender from recommenders where member=x. 
Demonstrate it by getting the chains for members 12 
and 22. Results table should have member and 
recommender, ordered by member ascending, recommender 
descending.
*/

WITH RECURSIVE rec_query(recommender, member) AS(
	SELECT recommendedby AS recommender, memid AS member
	FROM cd.members
  	
  	UNION ALL
  	
  	SELECT m.recommendedby, r.member
  	FROM cd.members m
  	JOIN rec_query r
  	ON m.memid = r.recommender
)

SELECT r.member, r.recommender, m.firstname, m.surname
FROM cd.members m
JOIN rec_query r
ON m.memid = r.recommender
WHERE r.member IN (12, 22)
ORDER BY 1, 2 DESC;