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







