# Question 1

/*
Produce a timestamp for 1 a.m. on the 31st of August 
2012.
*/

SELECT '2012-08-31 01:00' :: TIMESTAMP;

# Question 2

/*
Find the result of subtracting the timestamp 
'2012-07-30 01:00:00' from the timestamp 
'2012-08-31 01:00:00'
*/

SELECT '2012-08-31 01:00:00' :: TIMESTAMP - 
       '2012-07-30 01:00:00' :: TIMESTAMP AS interval;

# Question 3

/*
Produce a list of all the dates in October 2012. They 
can be output as a timestamp (with time set to 
midnight) or a date.
*/

SELECT GENERATE_SERIES('2012-10-01' :: TIMESTAMP WITH TIME ZONE, '2012-10-31' ,'1 day') AS ts

# Question 4

/*
Get the day of the month from the timestamp 
'2012-08-31' as an integer.
*/

SELECT DATE_PART('day', '2012-10-31' :: DATE);

SELECT EXTRACT('day' FROM '2012-10-31' :: TIMESTAMP);

# Question 5

/*
Work out the number of seconds between the timestamps 
'2012-08-31 01:00:00' and '2012-09-02 00:00:00'
*/

SELECT EXTRACT('epoch' FROM '2012-09-02 00:00:00' :: TIMESTAMP - 
                        '2012-08-31 01:00:00' :: TIMESTAMP);

# Question 6

/*
For each month of the year in 2012, output the 
number of days in that month. Format the output as 
an integer column containing the month of the year, 
and a second column containing an interval data type.
*/

SELECT EXTRACT('month' FROM series.months), 
     ((series.months + INTERVAL '1 month') - series.months) AS length
FROM 
(
  SELECT GENERATE_SERIES('2012-01-01'::TIMESTAMP,  '2012-12-01', '1 month') AS months
) AS series;

# Question 7

/*
For any given timestamp, work out the number of days 
remaining in the month. The current day should count 
as a whole day, regardless of the time. Use 
'2012-02-11 01:00:00' as an example timestamp for the 
purposes of making the answer. Format the output as a 
single interval value.
*/

SELECT (DATE_TRUNC('month',ts.tsts) + INTERVAL '1 month') - 
       DATE_TRUNC('day', ts.tsts)
FROM (SELECT '2012-02-11 01:00:00' :: TIMESTAMP as tsts) as ts;

# Question 8

/*
Return a list of the start and end time of the last 
10 bookings (ordered by the time at which they end, 
followed by the time at which they start) in the 
system.
*/

SELECT starttime, starttime + slots * (
       INTERVAL '30 minutes') AS endtime
FROM cd.bookings
ORDER BY endtime DESC, starttime DESC
LIMIT 10;

# Question 9

/*
Return a count of bookings for each month, sorted by 
month
*/

SELECT DATE_TRUNC('month', starttime), COUNT(*)
FROM cd.bookings
GROUP BY 1
ORDER BY 1;

# Question 10

/* 
Work out the utilisation percentage for each facility 
by month, sorted by name and month, rounded to 1 
decimal place. Opening time is 8am, closing time is 
8.30pm. You can treat every month as a full month, 
regardless of if there were some dates the club was 
not open.
*/

SELECT name, months, ROUND(CAST((slots * 100)/(DATE_PART('days', months + INTERVAL '1 month' - months)*25) AS NUMERIC), 1)
FROM (
SELECT f.name, DATE_TRUNC('month', b.starttime) months, SUM(b.slots) slots
FROM cd.bookings b
JOIN cd.facilities f
ON b.facid = f.facid
GROUP BY 1, 2
) AS subq
ORDER BY name, months;