-- This collection of sample SQL queries is intented for referrence and recycle code.

-- Selecting all first and last name from a table.
SELECT first_name, last_name
FROM person;

-- Select the number of wins, by country, in descending order, with a limited # of rows, from a table.
SELECT 
    country,
    SUM(wins) AS wins
FROM game_log
GROUP BY country
ORDER BY wins DESC
LIMIT 3;

--

SELECT 
FROM 
GROUP BY ;