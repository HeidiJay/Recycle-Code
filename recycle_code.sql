-- This collection of sample SQL queries is intented for referrence and recycle code.

-- Display all first and last name from a table.
SELECT first_name, last_name
FROM person;

-- Displying three columns from a given table

SELECT
    mkt_carrier, mkt_carrier_fl_num, origin
FROM performance;
-- Or can be also written as...
SELECT
    mkt_carrier,
    mkt_carrier_fl_num,
    origin
FROM performance;
-- Can be cleaned up even further with...
SELECT
    mkt_carrier AS airline,
    mkt_carrier_fl_num AS flight,
    origin AS depart_city
FROM performance;

-- The WHERE clause. Criteria to filter matching rows.

SELECT first_name, last_name
FROM person
WHERE first_name = "John";

-- Another example WHERE cause.

SELECT
    city,
    state,
    population
FROM city_population
WHERE city = "Virginia Beach"
AND state = "Virginia";

-- LIKE clause is similar to =.  The Wildcard %_ clause with LIKE, % represents zero or more characters, while _ represents exactly one character.
-- The wildcards can represent characters before a part of a word, after, in the middle, or both before and after a word.

SELECT
    city,
    state,
    population
FROM city_population
WHERE city LIKE '%Beach'  -- Like Virginia Beach
AND state LIKE 'Virgini_';  -- Can look for the character 'a' for Virginia.

-- More examples of how to use a wildcare.

SELECT
    city,
    state,
    population
FROM city_population
WHERE city_name LIKE '___, Beach'  -- Four underscores represent only four characters, Like 'Fort Beach'.
AND state LIKE 'V%';  -- A wildcard after the letter, can represent any state that starts with a 'V'.

SELECT
    city,
    state,
    population
FROM city_population
WHERE city_name LIKE '__, %'  -- Three underscores and a % represents a two word city who first word only has three letters, like 'New York'.
AND state LIKE 'V%';  

-- Display the number of wins, by country, in descending order, with a limited # of rows, from a table.

SELECT 
    country,
    SUM(wins) AS wins
FROM game_log
GROUP BY country
ORDER BY wins DESC
LIMIT 3;

-- Distinct only returns the value of a given character one time
-- Example:  If cat, cat, dog, cat. Than distinct would return cat, dog.

SELECT DISTINCT mkt_carrier,
    origin AS depart_city
FROM performance;

-- Display person id, by sport, in descending order.

SELECT
    sport
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport
ORDER BY athletes DESC
LIMIT 3;

-- Display # of events and # of athletes, by sport, in a table.

SELECT 
    sport,
    COUNT(DISTINCT event) AS events,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport;

-- Join Tables

SELECT *
FROM countries AS c1
JOIN countries AS c2
ON c1.id = c2.country_id;

-- Join: Population by region.

SELECT
    region,
    SUM(pop_in_millions) AS pop_in_millions
FROM countries AS c1
JOIN country_stats AS c2
ON c1.id = c2.country_id
GROUP BY region;

-- Join: Group age of oldest athlete by region.

SELECT
    region
    MAX(age) AS age_of_oldest_athlete
FROM athletes AS a1
JOIN summer_games AS s2
ON a1 = s2.athlete_id
JOIN countries AS c3
ON c3.region = region
GROUP BY region;

-- Union: Unique # of events held by each sport, from both tables

-- Select sport and event for summer sports
SELECT
    sport,
    COUNT(DISTINCT event) AS events
FROM summer_games AS c1
GROUP BY sport
UNION 
-- Select sport and events for winter sports
SELECT
    sport
    COUNT(DISTINCT event) AS events
FROM winter_games AS c2
GROUP BY sport
-- Show the most events at the top of the report
ORDER BY sport DESC;

-- 

SELECT DISTINCT region
FROM countries;

-- 

SELECT region
FROM countries
GROUP BY region;

-- Field-level aggregations

SELECT region, COUNT (*) AS row_num
FROM countries
GROUP BY region
ORDER BY row_num DESC;

-- Field-level aggregations

SELECT revenue_source, SUM(revenue) AS revenue
FROM order
GROUP BY revenue_source
ORDER BY revenue DESC;

-- Table-level aggregations

SELECT COUNT (*)
FROM country_stats;

-- Query Validation

-- Original table that will have missing data
SELECT SUM(rev) AS rev
FROM orders;
-- Query that captures the missing data from the query
SELECT SUM(rev) AS revenue
FROM
    (SELECT country, SUM(rev) AS rev)
FROM order AS o
JOIN countries AS c
ON o.country_id = c.id
GROUP BY country;

-- Count all of a given column by rows

SELECT
    bronze,
    COUNT(*) AS rows
FROM summer_games
GROUP BY bronze;
