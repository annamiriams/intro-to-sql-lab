-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed, so find the least populated country in Southern Europe, and we'll start looking for her there.
 
-- Write SQL query here

SELECT name, population FROM countries WHERE region = 'Southern Europe' ORDER BY population ASC LIMIT 1;

-- returns:
    --              name              | population
    -- -------------------------------+------------
    --  Holy See (Vatican City State) |       1000

------------------------------------------------------------------------------------------------------

-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in this country's officially recognized language. Check our databases and find out what language is spoken in this country, so we can call in a translator to work with you.

-- Write SQL query here

-- started with this:
    -- SELECT code FROM countries WHERE region = 'Southern Europe' ORDER BY population ASC LIMIT 1;
    -- SELECT language FROM countrylanguages WHERE countrycode = 'VAT';

-- refactored so that it could be run without needing the information gathered from the first line above ('VAT'):
    -- SELECT countrylanguages.language FROM countrylanguages JOIN countries ON countrylanguages.countrycode = countries.code WHERE countries.name = 'Holy See (Vatican City State)' AND countrylanguages.isofficial = 't';

-- refactored again to rename the tables so they're shorter and the query is less verbose:
SELECT cl.language FROM countrylanguages cl JOIN countries c ON cl.countrycode = c.code WHERE c.name = 'Holy See (Vatican City State)' AND cl.isofficial = 't';

-- returns: 
    -- language
    -- ----------
    -- Italian
------------------------------------------------------------------------------------------------------

-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on to a different country, a country where people speak only the language she was learning. Find out which nearby country speaks nothing but that language.

-- Write SQL query here

-- join cl.language onto c
-- select country in southern europe where language spoken = italian

SELECT c.name, c.code
FROM countries c
JOIN countrylanguages cl ON c.code = cl.countrycode 
WHERE c.region = 'Southern Europe' AND code != 'VAT'
GROUP BY c.name, c.code
HAVING COUNT(*) = 1 AND MAX(cl.language) = 'Italian';

-- returns:
    --     name
    -- ------------
    --  San Marino

-- Group by country, count how many languages each country has, and make sure that there is only one row for that county (count = 1), and that the language is Italian
-- Max or min could be used--it doesn't matter here because there's still only one count
-- https://www.w3schools.com/sql/sql_min_max.asp
-- https://www.w3schools.com/sql/sql_groupby.asp
-- https://www.freecodecamp.org/news/how-to-remove-duplicate-data-in-sql/#:~:text=One%20of%20the%20easiest%20ways,values%20from%20a%20particular%20column.
-- https://stackoverflow.com/questions/20991729/how-to-avoid-error-aggregate-functions-are-not-allowed-in-where

------------------------------------------------------------------------------------------------------

-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time. There are only two cities she could be flying to in the country. One is named the same as the country – that would be too obvious. We're following our gut on this one; find out what other city in that country she might be flying to.

-- Write SQL query here

-- join code from cities on countries
-- where name != 'San Marino'

SELECT ci.name, ci.countrycode
FROM cities ci
JOIN countries co ON ci.countrycode = co.code
WHERE co.code = 'SMR' AND ci.name != 'San Marino';

-- returns:
    --     name    | countrycode
    -- ------------+-------------
    --  Serravalle | SMR

------------------------------------------------------------------------------------------------------

-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!

-- Write SQL query here

-- join countries region on cities

SELECT ci.name, ci.countrycode 
FROM cities ci 
JOIN countries co ON ci.countrycode = co.code
WHERE ci.name LIKE 'Serra%' AND ci.name != 'SSerravalle' AND co.region = 'South America';

-- returns:
--     name  | countrycode
--     -------+-------------
--     Serra | BRA

-- https://learn.microsoft.com/en-us/sql/t-sql/language-elements/percent-character-wildcard-character-s-to-match-transact-sql?view=sql-server-ver16

------------------------------------------------------------------------------------------------------

-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards
-- the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll
-- follow right behind you!

-- Write SQL query here

------------------------------------------------------------------------------------------------------

-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the landing dock. Lucky for us, she's getting cocky. She left us a note (below), and I'm sure she thinks she's very clever, but if we can crack it, we can finally put her where she belongs – behind bars.


--               Our playdate of late has been unusually fun –
--               As an agent, I'll say, you've been a joy to outrun.
--               And while the food here is great, and the people – so nice!
--               I need a little more sunshine with my slice of life.
--               So I'm off to add one to the population I find
--               In a city of ninety-one thousand and now, eighty five.


-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.