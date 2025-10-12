/* Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.

Input Format
The STATION table is described as follows:
     STATION
-------------------
Field	  Type
-----   ------------
ID	    NUMBER
CITY	  VARCHAR2(21)
STATE	  VARCHAR2(2)
LAT_N	  NUMBER
LONG_W	NUMBER

where LAT_N is the northern latitude and LONG_W is the western longitude. */

--Traditional long but easy to understandable way
SELECT DISTINCT CITY
FROM STATION
WHERE (CITY LIKE 'A%' AND CITY LIKE '%A')
   OR (CITY LIKE 'A%' AND CITY LIKE '%E')
   OR (CITY LIKE 'A%' AND CITY LIKE '%I')
   OR (CITY LIKE 'A%' AND CITY LIKE '%O')
   OR (CITY LIKE 'A%' AND CITY LIKE '%U') 
   OR (CITY LIKE 'E%' AND CITY LIKE '%A')
   OR (CITY LIKE 'E%' AND CITY LIKE '%E')
   OR (CITY LIKE 'E%' AND CITY LIKE '%I')
   OR (CITY LIKE 'E%' AND CITY LIKE '%O')
   OR (CITY LIKE 'E%' AND CITY LIKE '%U')  
   OR (CITY LIKE 'I%' AND CITY LIKE '%A')
   OR (CITY LIKE 'I%' AND CITY LIKE '%E')
   OR (CITY LIKE 'I%' AND CITY LIKE '%I')
   OR (CITY LIKE 'I%' AND CITY LIKE '%O')
   OR (CITY LIKE 'I%' AND CITY LIKE '%U') 
   OR (CITY LIKE 'O%' AND CITY LIKE '%A')
   OR (CITY LIKE 'O%' AND CITY LIKE '%E')
   OR (CITY LIKE 'O%' AND CITY LIKE '%I')
   OR (CITY LIKE 'O%' AND CITY LIKE '%O')
   OR (CITY LIKE 'O%' AND CITY LIKE '%U') 
   OR (CITY LIKE 'U%' AND CITY LIKE '%A')
   OR (CITY LIKE 'U%' AND CITY LIKE '%E')
   OR (CITY LIKE 'U%' AND CITY LIKE '%I')
   OR (CITY LIKE 'U%' AND CITY LIKE '%O')
   OR (CITY LIKE 'U%' AND CITY LIKE '%U');

--concise way
SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY, 1) IN ('A', 'E', 'I', 'O', 'U')
  AND RIGHT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U');

--using regex 
SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[AEIOU].*[aeiou]$';
