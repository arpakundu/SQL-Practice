/* Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.

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

--1st way
SELECT DISTINCT CITY
FROM STATION
WHERE SUBSTR(CITY, 1, 1) IN ('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u');

--2nd way
SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY, 1) IN ('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u');

--3rd way
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE 'A%'
   OR CITY LIKE 'E%'
   OR CITY LIKE 'I%'
   OR CITY LIKE 'O%'
   OR CITY LIKE 'U%'
   OR CITY LIKE 'a%'
   OR CITY LIKE 'e%'
   OR CITY LIKE 'i%'
   OR CITY LIKE 'o%'
   OR CITY LIKE 'u%';

--4th way (using regex)
SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[aeiou]';

--5th way (in case of case-sensitivity)
SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(SUBSTR(CITY, 1, 1)) IN ('a', 'e', 'i', 'o', 'u');
