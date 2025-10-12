/* Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.

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
WHERE (
    -- Does NOT start with ANY vowel (case-insensitive)
    CITY NOT LIKE 'A%' AND CITY NOT LIKE 'E%' AND CITY NOT LIKE 'I%' AND CITY NOT LIKE 'O%' AND CITY NOT LIKE 'U%'
    AND CITY NOT LIKE 'a%' AND CITY NOT LIKE 'e%' AND CITY NOT LIKE 'i%' AND CITY NOT LIKE 'o%' AND CITY NOT LIKE 'u%'
)
AND (
    -- Does NOT end with ANY vowel (case-insensitive)
    CITY NOT LIKE '%A' AND CITY NOT LIKE '%E' AND CITY NOT LIKE '%I' AND CITY NOT LIKE '%O' AND CITY NOT LIKE '%U'
    AND CITY NOT LIKE '%a' AND CITY NOT LIKE '%e' AND CITY NOT LIKE '%i' AND CITY NOT LIKE '%o' AND CITY NOT LIKE '%u'
);

--2nd way
SELECT DISTINCT CITY
FROM STATION
WHERE UPPER(LEFT(CITY, 1)) NOT IN ('A', 'E', 'I', 'O', 'U') -- First letter is NOT a vowel
  AND UPPER(RIGHT(CITY, 1)) NOT IN ('A', 'E', 'I', 'O', 'U'); -- Last letter is NOT a vowel

--3rd way
SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[^AEIOUaeiou].*[^AEIOUaeiou]$';
