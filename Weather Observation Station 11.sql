/* Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.

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
WHERE (CITY NOT LIKE 'A%' AND CITY NOT LIKE 'E%' AND CITY NOT LIKE 'I%' AND CITY NOT LIKE 'O%' AND CITY NOT LIKE 'U%') OR (CITY NOT LIKE '%A' AND CITY NOT LIKE '%E' AND CITY NOT LIKE '%I' AND CITY NOT LIKE '%O' AND CITY NOT LIKE '%U');

--2nd way
SELECT DISTINCT CITY
FROM STATION
WHERE NOT (
    -- Starts with a vowel (A AND E AND I AND O AND U, case-insensitive)
    (CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%'
     OR CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%' OR CITY LIKE 'o%' OR CITY LIKE 'u%')
    AND
    -- Ends with a vowel (A AND E AND I AND O AND U, case-insensitive)
    (CITY LIKE '%A' OR CITY LIKE '%E' OR CITY LIKE '%I' OR CITY LIKE '%O' OR CITY LIKE '%U'
     OR CITY LIKE '%a' OR CITY LIKE '%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u')
);

--3rd way
SELECT DISTINCT CITY
FROM STATION
WHERE UPPER(LEFT(CITY, 1)) NOT IN ('A', 'E', 'I', 'O', 'U')
   OR UPPER(RIGHT(CITY, 1)) NOT IN ('A', 'E', 'I', 'O', 'U');

--4th way
SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[^AEIOUaeiou]'
   OR CITY REGEXP '[^AEIOUaeiou]$';
