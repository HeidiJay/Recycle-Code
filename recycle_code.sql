/* This collection of sample SQL queries is intented for referrence and recycle code. */

-- Display all first and last name from a table.
SELECT first_name, last_name
FROM person;

-- Displying three columns from a given table

SELECT
    mkt_carrier, mkt_carrier_fl_num, origin
FROM performance;

-- Or can be also written as.
SELECT
    mkt_carrier,
    mkt_carrier_fl_num,
    origin
FROM performance;

-- Can be cleaned up even further with.
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

/* LIKE clause is similar to =.  The Wildcard %_ clause with LIKE, % represents zero or more characters, while _ represents exactly one character.
The wildcards can represent characters before a part of a word, after, in the middle, or both before and after a word. */

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

-- ORDER BY ASC or DESC 

SELECT
    name
    state
FROM residency
ORDER BY state DESC, name ASC;

-- Aggregate functions like; COUNT, SUM, MAX, MIN, AVG.

SELECT mkt_carrier
    AVG(delay_time) -- This query would tell us the average delay time between each market carrier/airline
FROM performance
GROUP BY mkt_carrier;

-- Aggregate functions

SELECT p.mkt_carrier,
    c.carrier_desc, -- This would give us the market carrier/airline name
    AVG(p.delay_time) -- This query would tell us the average delay time between each market carrier/airline
FROM performance p
INNER JOIN codes_carrier c
    ON p.mkt_carrier = c.carrier_code
GROUP BY p.mkt_carrier,
    c.carrier_desc
ORDER BY AVG(p.delay_time) DESC; -- This would show the longest delay time first.

-- Display the number of wins, by country, in descending order, with a limited # of rows, from a table.

SELECT 
    country,
    SUM(wins) AS wins
FROM game_log
GROUP BY country
ORDER BY wins DESC
LIMIT 3;

/* Distinct only returns the value of a given character one time
Example:  If cat, cat, dog, cat. Than distinct would return cat, dog. */

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

SELECT 
    customers.first_name
    customers.last_name
    orders.order_date
    orders.order_amount
FROM customers
INNER JOIN orders
    ON customers.customer_id = orders.customer_id
 WHERE customers.last_name = "J%";

-- Join example with Alias to represent a table name

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

-- Left Join or Right Join: Joins tables, but one table dominates. LEFT OUTER JOIN can simply be written as LEFT JOIN, same with RIGHT JOIN.

SELECT 
    c.first_name
    c.last_name
    o.order_date
    o.order_amount
FROM customers c
LEFT JOIN orders o -- This returns the first (left) table and if information matches on the right table to the left table.
    ON c.customer_id = o.customer_id;
    
-- FULL OUTER JOIN returns all rows from two or more tables, regardless of whether a join condition is met.

SELECT 
    c.first_name
    c.last_name
    o.order_date
    o.order_amount
FROM customers c
FULL OUTER JOIN orders o
    ON c.customer_id = o.customer_id;

-- Join: Group age of oldest athlete by region.

SELECT
    region
    MAX(age) AS age_of_oldest_athlete
FROM athletes AS a
JOIN summer_games AS s
ON a.id = s.athlete_id
JOIN countries AS c
ON c.id = s.athlete_id
GROUP BY region;

/* Join: Most Decorated Summer Athletes. */

-- Pull athlete_name and gold_metals for summer_games
SELECT
    a.names AS athlete_name
    SUM(s.gold) AS gold_metals
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY a.name
-- Filter for only athletes with 3 gold metals or more
HAVING COUNT(s.gold) >= 3
-- Sort to show the most gold metals at the top
ORDER BY (gold_metals) DESC;

/* Union: Unique # of events held by each sport, from both tables */
-- Select sport and event for summer sports
SELECT
    sport,
    COUNT(DISTINCT event) AS events
FROM summer_games
GROUP BY sport
UNION 
-- Select sport and events for winter sports
SELECT
    sport
    COUNT(DISTINCT event) AS events
FROM winter_games
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
    (SELECT country, SUM(rev) AS rev
    FROM order AS o
    JOIN countries AS c
    ON o.country_id = c.id
    GROUP BY country);

-- Count all of a given column by rows

SELECT
    bronze,
    COUNT(*) AS rows
FROM summer_games
GROUP BY bronze;

-- Null:  IS NULL or IS NOT NULL clause

SELECT
    mkt_carrier AS airline,
    mkt_carrier_fl_num AS flight,
    origin AS depart_city
    cancellation_code
FROM performance;
WHERE cancellation_code IS NOT NULL

-- Another Null example

SELECT first_name, last_name
FROM person
WHERE last_name IS NULL;

-- Here we can use an AND clause and an OR cause

SELECT 
    first_name,
    age
FROM person
WHERE age >= 20
AND age <= 50
WHERE first_name = 'John'
OR first_name = 'Lorene'
OR first_name = 'Mike';

/* IN checks for equal conditions
We can clean up the above example by replacing our '>=' and '<=' with a BETWEEN cause and replacing our 'OR' with an IN cause. */

SELECT 
    first_name,
    age
FROM person
WHERE age BETWEEN 20 and 50
WHERE first_name IN ("John, Lorene, Mike");

-- Or we can use 'NOT IN' to return values not in the list given.

SELECT 
    first_name,
    age
FROM person
WHERE age BETWEEN 20 and 50
WHERE first_name NOT IN 'John';

/* Operator Precedence are the order of what operator comes first.
AND is a high operator precedence than OR, so AND would be the first condition to apple before the next. */

SELECT 
    first_name,
    age,
    hometown
FROM person
WHERE first_name = "John"
OR first_name = "Mike"  -- Mike may come back from a different hometown, because it is the last operator for the query to search.
AND hometown = "Visalia"; -- AND would be the first condition to apply.

-- We can fix the above query to only return those names from our given hometown by added '()' which has a higher operator precedence value than AND.

SELECT 
    first_name,
    age,
    hometown
FROM person
WHERE (first_name = "John"
OR first_name = "Mike") -- Now the everything inside the '()' will run first, before the hometown condition is applied. 
AND hometown = "Visalia"; 

-- This query will display airlines with the average delay time longer than 30 minutes for Fresno.

SELECT p.mkt_carrier,
    c.carrier_desc, -- This would give us the market carrier/airline name
    AVG(p.delay_time) AS average_delay -- This query would tell us the average delay time between each market carrier/airline
FROM performance p
INNER JOIN codes_carrier c
    ON p.mkt_carrier = c.carrier_code
    WHERE p.orgin = 'FRN' -- This is where the flight originated out of Fresno
    AND p.delay_time <> 0 -- This takes the flights that where ontime out of the equation
GROUP BY p.mkt_carrier,
    c.carrier_desc
HAVING AVG(p.delay_time) > 30  -- HAVING aggregation replaces the WHERE clause in aggregate functions.  Here we want the delay times that are greater than 30 minutes.
ORDER BY AVG(p.delay_time) DESC; -- This would show the longest delay time first.

/* My own queries I am practicing on a database. */

-- Show Customers, Company, Order ID as receipt, and the name of the product they bought, by ascending order.

SELECT
	c.CompanyName AS company,
	c.ContactName AS customer,
	o.OrderID AS receipt,
	p.ProductName AS product
FROM dbo.Customers AS c
JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] AS od
ON o.OrderID = od.OrderID
JOIN dbo.Products AS p
ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Chai'
ORDER BY p.ProductName ASC;
