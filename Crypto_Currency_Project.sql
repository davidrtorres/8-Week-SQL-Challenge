-- Sort all the rows in the table by first_name in alphabetical order and show the top 3 rows
SELECT * FROM trading.members ORDER BY first_name LIMIT 3;

-- Which records from trading.members are from the United States region?
SELECT * FROM trading.members WHERE region = 'United States';

-- Select only the member_id and first_name columns for members who are not from Australia
SELECT 
	member_id,	
	first_name 
FROM trading.members 
WHERE region != 'Australia';

-- Return the unique region values from the trading.members table and sort the output by reverse alphabetical order
SELECT
	DISTINCT region AS distinct_regions
FROM trading.members
ORDER BY distinct_regions DESC;

-- How many memtors are there from Australia or the United States?
-- There are 7 members from U.S. and 4 members from Austrlia
SELECT
	region,
    COUNT(*)
FROM trading.members
WHERE region = 'United States' OR region='Australia'
GROUP BY region;

-- How many mentors are not from Australia or the United States?
-- 3 mentors aren't from US or Australia.
SELECT
	COUNT(*)
FROM trading.members
WHERE region NOT IN ('United States','Australia');

-- How many mentors are there per region? Sort the output by regions with the most mentors to the least?
-- There are 7 mentors in US, 4 in Australia, 1 in India, 1 in Africa and 1 in Asia.
SELECT
	region,
    COUNT(*) AS member_count 
FROM trading.members
GROUP BY region 
ORDER BY member_count DESC;

-- How many US mentors and non US mentors are there?
-- There are 7 mentors from US and 7 not from the US.
SELECT
CASE 	
	WHEN region = 'United States' Then 'US'
    ELSE 'Other' 
    END AS US_or_Non, 
    COUNT(*) 
FROM trading.members
GROUP BY US_or_Non;

-- How many mentors have a first name starting with a letter before 'E'?
SELECT 
	COUNT(*) AS names_start_e
FROM trading.members
WHERE LEFT (first_name,1) < 'E';

-- How many total records do we have in the trading.prices table?
-- There are 3404 records
SELECT 
	COUNT(*) AS record_count
FROM trading.prices 

-- How many records are there per ticker value?
-- There are 1702 records for BTC and 1702 records for ETH.
SELECT 
	ticker,
    COUNT(*) AS row_count
FROM trading.prices
GROUP BY ticker;

-- What is the minimum and maximum market_date values?
-- The min market_date is 2017-01-01T00:00:00.000Z and max market_date is 2021-08-29T00:00:00.000Z.
SELECT
	MIN(market_date) AS min_marketDate,
    MAX(market_date) AS max_marketDate
FROM trading.prices

-- Are there differences in the minimum and maximum market_date values for each ticker?
-- The min, max market_date values for each ticker are the same.
SELECT
	ticker,
	MIN(market_date) AS min_marketDate,
    MAX(market_date) AS max_marketDate
FROM trading.prices
GROUP BY ticker;

-- What is the average of the price column for Bitcoin records during the year 2020?
-- The average price is 11111.631147540982.
SELECT
	AVG(price) As avg_price
FROM trading.prices
WHERE ticker='BTC' AND 
	market_date BETWEEN '2020_01_01' AND '2020_12_31';
    
-- What is the monthly average of the price column for Ethereum in 2020? Sort the output in chronological order and also round the average price value to 2 decimal places
/*
month_start	average_eth_price
2020-01-01T00:00:00.000Z	156.65
2020-02-01T00:00:00.000Z	238.76
2020-03-01T00:00:00.000Z	160.18
2020-04-01T00:00:00.000Z	171.29
2020-05-01T00:00:00.000Z	207.45
2020-06-01T00:00:00.000Z	235.92
2020-07-01T00:00:00.000Z	259.57
2020-08-01T00:00:00.000Z	401.73
2020-09-01T00:00:00.000Z	367.77
2020-10-01T00:00:00.000Z	375.79
2020-11-01T00:00:00.000Z	486.73
2020-12-01T00:00:00.000Z	622.35

*/
SELECT
  DATE_TRUNC('MON', market_date) AS month_start,
  -- need to cast approx. floats to exact numeric types for round!
  ROUND(AVG(price)::NUMERIC, 2) AS average_eth_price
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
  AND ticker = 'ETH'
GROUP BY month_start
ORDER BY month_start;

-- Are there any duplicate market_date values for any ticker value in our table?
/*
ticker	row_count	unique_count
BTC	    1702	    1702
ETH	    1702	    1702


*/
SELECT
	ticker,
    COUNT(*) AS row_count,
    COUNT(DISTINCT market_date) AS unique_count
FROM trading.prices
GROUP BY ticker
















