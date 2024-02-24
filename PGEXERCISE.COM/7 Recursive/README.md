# Recursive Queries

## Common Table Expressions allow us to, effectively, create our own temporary tables for the duration of a query - they're largely a convenience to help us make more readable SQL. Using the WITH RECURSIVE modifier, however, it's possible for us to create recursive queries. This is enormously advantageous for working with tree and graph-structured data. This section contains following challenges. 


### &#9679; [Find the upward recommendation chain for member ID 27](Recursive.sql)
### &#9679; [Find the downward recommendation chain for member ID 1](Recursive.sql)
### &#9679; [Produce a CTE that can return the upward recommendation chain for any member](Recursive.sql)