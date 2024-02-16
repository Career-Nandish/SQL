# Introduction to Data used in the exercises
## These exercises were directly taken from https://pgexercises.com/
### Thanks to [Alisdair Owens](https://alisdairowens.net/) for creating these amazing sets of exercises which not only introduced me to new concepts and ways to query but also inspired me to take a deep dive into SQL. Cheers, Mate!

The dataset for these exercises is for a newly created country club, with a set of members, facilities such as tennis courts, and booking history for those facilities. Amongst other things, the club wants to understand how they can use their information to analyse facility usage/demand. 

### Table 1 : Members

    CREATE TABLE cd.members
    (
       memid integer NOT NULL, 
       surname character varying(200) NOT NULL, 
       firstname character varying(200) NOT NULL, 
       address character varying(300) NOT NULL, 
       zipcode integer NOT NULL, 
       telephone character varying(20) NOT NULL, 
       recommendedby integer,
       joindate timestamp NOT NULL,
       CONSTRAINT members_pk PRIMARY KEY (memid),
       CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
            REFERENCES cd.members(memid) ON DELETE SET NULL
    );
          

Each member has an ID (not guaranteed to be sequential), basic address information, a reference to the member that recommended them (if any), and a timestamp for when they joined. The addresses in the dataset are entirely (and unrealistically) fabricated.

#### Data

| memid | surname           | firstname | address                                 | zipcode | telephone      | recommendedby | joindate            |
|-------|-------------------|-----------|-----------------------------------------|---------|----------------|---------------|---------------------|
| 0     | GUEST             | GUEST     | GUEST                                   | 0       | (000) 000-0000 |               | 2012-07-01 00:00:00 |
| 1     | Smith             | Darren    | 8 Bloomsbury Close, Boston              | 4321    | 555-555-5555   |               | 2012-07-02 12:02:05 |
| 2     | Smith             | Tracy     | 8 Bloomsbury Close, New York            | 4321    | 555-555-5555   |               | 2012-07-02 12:08:23 |
| 3     | Rownam            | Tim       | 23 Highway Way, Boston                  | 23423   | (844) 693-0723 |               | 2012-07-03 09:32:15 |
| 4     | Joplette          | Janice    | 20 Crossing Road, New York              | 234     | (833) 942-4710 | 1             | 2012-07-03 10:25:05 |
| 5     | Butters           | Gerald    | 1065 Huntingdon Avenue, Boston          | 56754   | (844) 078-4130 | 1             | 2012-07-09 10:44:09 |
| 6     | Tracy             | Burton    | 3 Tunisia Drive, Boston                 | 45678   | (822) 354-9973 |               | 2012-07-15 08:52:55 |
| 7     | Dare              | Nancy     | 6 Hunting Lodge Way, Boston             | 10383   | (833) 776-4001 | 4             | 2012-07-25 08:59:12 |
| 8     | Boothe            | Tim       | 3 Bloomsbury Close, Reading, 00234      | 234     | (811) 433-2547 | 3             | 2012-07-25 16:02:35 |
| 9     | Stibbons          | Ponder    | 5 Dragons Way, Winchester               | 87630   | (833) 160-3900 | 6             | 2012-07-25 17:09:05 |
| 10    | Owen              | Charles   | 52 Cheshire Grove, Winchester, 28563    | 28563   | (855) 542-5251 | 1             | 2012-08-03 19:42:37 |
| 11    | Jones             | David     | 976 Gnats Close, Reading                | 33862   | (844) 536-8036 | 4             | 2012-08-06 16:32:55 |
| 12    | Baker             | Anne      | 55 Powdery Street, Boston               | 80743   | 844-076-5141   | 9             | 2012-08-10 14:23:22 |
| 13    | Farrell           | Jemima    | 103 Firth Avenue, North Reading         | 57392   | (855) 016-0163 |               | 2012-08-10 14:28:01 |
| 14    | Smith             | Jack      | 252 Binkington Way, Boston              | 69302   | (822) 163-3254 | 1             | 2012-08-10 16:22:05 |
| 15    | Bader             | Florence  | 264 Ursula Drive, Westford              | 84923   | (833) 499-3527 | 9             | 2012-08-10 17:52:03 |
| 16    | Baker             | Timothy   | 329 James Street, Reading               | 58393   | 833-941-0824   | 13            | 2012-08-15 10:34:25 |
| 17    | Pinker            | David     | 5 Impreza Road, Boston                  | 65332   | 811 409-6734   | 13            | 2012-08-16 11:32:47 |
| 20    | Genting           | Matthew   | 4 Nunnington Place, Wingfield, Boston   | 52365   | (811) 972-1377 | 5             | 2012-08-19 14:55:55 |
| 21    | Mackenzie         | Anna      | 64 Perkington Lane, Reading             | 64577   | (822) 661-2898 | 1             | 2012-08-26 09:32:05 |
| 22    | Coplin            | Joan      | 85 Bard Street, Bloomington, Boston     | 43533   | (822) 499-2232 | 16            | 2012-08-29 08:32:41 |
| 24    | Sarwin            | Ramnaresh | 12 Bullington Lane, Boston              | 65464   | (822) 413-1470 | 15            | 2012-09-01 08:44:42 |
| 26    | Jones             | Douglas   | 976 Gnats Close, Reading                | 11986   | 844 536-8036   | 11            | 2012-09-02 18:43:05 |
| 27    | Rumney            | Henrietta | 3 Burkington Plaza, Boston              | 78533   | (822) 989-8876 | 20            | 2012-09-05 08:42:35 |
| 28    | Farrell           | David     | 437 Granite Farm Road, Westford         | 43532   | (855) 755-9876 |               | 2012-09-15 08:22:05 |
| 29    | Worthington-Smyth | Henry     | 55 Jagbi Way, North Reading             | 97676   | (855) 894-3758 | 2             | 2012-09-17 12:27:15 |
| 30    | Purview           | Millicent | 641 Drudgery Close, Burnington, Boston  | 34232   | (855) 941-9786 | 2             | 2012-09-18 19:04:01 |
| 33    | Tupperware        | Hyacinth  | 33 Cheerful Plaza, Drake Road, Westford | 68666   | (822) 665-5327 |               | 2012-09-18 19:32:05 |
| 35    | Hunt              | John      | 5 Bullington Lane, Boston               | 54333   | (899) 720-6978 | 30            | 2012-09-19 11:32:45 |
| 36    | Crumpet           | Erica     | Crimson Road, North Reading             | 75655   | (811) 732-4816 | 2             | 2012-09-22 08:36:38 |
| 37    | Smith             | Darren    | 3 Funktown, Denzington, Boston          | 66796   | (822) 577-3541 |               | 2012-09-26 18:08:45 |


### Table 2 : Facilities

    CREATE TABLE cd.facilities
    (
       facid integer NOT NULL, 
       name character varying(100) NOT NULL, 
       membercost numeric NOT NULL, 
       guestcost numeric NOT NULL, 
       initialoutlay numeric NOT NULL, 
       monthlymaintenance numeric NOT NULL, 
       CONSTRAINT facilities_pk PRIMARY KEY (facid)
    );
          

The facilities table lists all the bookable facilities that the country club possesses. The club stores id/name information, the cost to book both members and guests, the initial cost to build the facility, and estimated monthly upkeep costs. They hope to use this information to track how financially worthwhile each facility is.

#### Data

| facid | name            | membercost | guestcost | initialoutlay | monthlymaintenance |
|-------|-----------------|------------|-----------|---------------|--------------------|
| 0     | Tennis Court 1  | 5          | 25        | 10000         | 200                |
| 1     | Tennis Court 2  | 5          | 25        | 8000          | 200                |
| 2     | Badminton Court | 0          | 15.5      | 4000          | 50                 |
| 3     | Table Tennis    | 0          | 5         | 320           | 10                 |
| 4     | Massage Room 1  | 35         | 80        | 4000          | 3000               |
| 5     | Massage Room 2  | 35         | 80        | 4000          | 3000               |
| 6     | Squash Court    | 3.5        | 17.5      | 5000          | 80                 |
| 7     | Snooker Table   | 0          | 5         | 450           | 15                 |
| 8     | Pool Table      | 0          | 5         | 400           | 15                 |


### Table 3 : Bookings

    CREATE TABLE cd.bookings
    (
       bookid integer NOT NULL, 
       facid integer NOT NULL, 
       memid integer NOT NULL, 
       starttime timestamp NOT NULL,
       slots integer NOT NULL,
       CONSTRAINT bookings_pk PRIMARY KEY (bookid),
       CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
       CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
    );

Finally, there's a table tracking bookings of facilities. This stores the facility id, the member who made the booking, the start of the booking, and how many half hour 'slots' the booking was made for.

#### Data

Table has more than 4000 rows so I am only displaying first 10 rows here.

| bookid | facid | memid | starttime           | slots |
|--------|-------|-------|---------------------|-------|
| 0      | 3     | 1     | 2012-07-03 11:00:00 | 2     |
| 1      | 4     | 1     | 2012-07-03 08:00:00 | 2     |
| 2      | 6     | 0     | 2012-07-03 18:00:00 | 2     |
| 3      | 7     | 1     | 2012-07-03 19:00:00 | 2     |
| 4      | 8     | 1     | 2012-07-03 10:00:00 | 1     |
| 5      | 8     | 1     | 2012-07-03 15:00:00 | 1     |
| 6      | 0     | 2     | 2012-07-04 09:00:00 | 3     |
| 7      | 0     | 2     | 2012-07-04 15:00:00 | 3     |
| 8      | 4     | 3     | 2012-07-04 13:30:00 | 2     |
| 9      | 4     | 0     | 2012-07-04 15:00:00 | 2     |


## ERD

(I hope you are not using a dark theme for your github)

![Entiry Relation Diagram](images/schema-horizontal.svg)