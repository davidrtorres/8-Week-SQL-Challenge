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
-- No
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

-- How many days from the trading.prices table exist where the high price of Bitcoin is over $30,000?
-- 240 days high prcie over 30000.00
SELECT
	COUNT(high) AS more_than_300000
FROM trading.prices
WHERE ticker='BTC' AND
	high > 30000.0
    
-- How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?
/*
ticker	breakout_days
BTC	    207
ETH	    200
*/
SELECT
	ticker,
    SUM(CASE WHEN price > open THEN 1 ELSE 0 END) AS breakout_days
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
GROUP BY ticker;
-- How many "non_breakout" days were there in 2020 where the price column is less than the open column for each ticker?
/*
ticker	breakout_days
BTC	    159
ETH	    166
*/
SELECT
	ticker,
    SUM(CASE WHEN price < open THEN 1 ELSE 0 END) AS breakout_days
FROM trading.prices
WHERE market_date BETWEEN '2020_01_01' AND '2020_12_31'
GROUP BY ticker;
-- WHERE market_date >= '2020-01-01' AND market_date <= '2020-12-31'
-- WHERE DATE_TRUNC('YEAR', market_date) = '2020-01-01'

-- What percentage of days in 2020 were breakout days vs non-breakout days? Round the percentages to 2 decimal places
-- "breakout" where the price column is greater than the open column
/*
ticker	breakout	non_breakout
BTC	    0.57	    0.43
ETH	    0.55	    0.45

*/
SELECT
	ticker,
    ROUND(SUM(CASE WHEN price > open THEN 1 ELSE 0 END) / COUNT(*)::NUMERIC, 2) AS breakout,
    ROUND(SUM(CASE WHEN price < open THEN 1 ELSE 0 END)/ COUNT(*)::NUMERIC, 2) AS non_breakout
FROM trading.prices
WHERE market_date BETWEEN '2020_01_01' AND '2020_12_31'
GROUP BY ticker;

-- How many records are there in the trading.transactions table?
-- There are 22918 records.
SELECT 
	COUNT(*) AS record_count
FROM trading.transactions;

-- How many unique transactions are there?
-- There are 22918 unique transactions.
SELECT COUNT(DISTINCT txn_id) FROM trading.transactions;

-- How many buy and sell transactions are there for Bitcoin?
/*
txn_type	row_count
BUY	        10440
SELL	    2044
*/
SELECT
	txn_type,
    COUNT(*) AS row_count
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY txn_type;
/*
For each year, calculate the following buy and sell metrics for Bitcoin:
total transaction count
total quantity
average quantity per transaction
Also round the quantity columns to 2 decimal places.
txn_year	txn_type	total_transactions	total_quantity	average_per_transaction
2017	    BUY	        2261	            12069.58	    5.34
2017	SELL	        419	                2160.22	        5.16
2018	BUY	            2204	            11156.06	    5.06
2018	SELL	        433	                2145.05	        4.95
2019	BUY	            2192	            11114.43	    5.07
2019	SELL	        443	                2316.24	        5.23
2020	BUY	            2350	            11748.76	    5.00
2020	SELL	        456	                2301.98	        5.05
2021	BUY	            1433	

*/
SELECT
  EXTRACT(YEAR FROM txn_date) AS txn_year,
  -- need to cast approx. floats to exact numeric types for round!
  txn_type,
  COUNT(txn_id) AS total_transactions,
  ROUND(SUM(quantity):: NUMERIC,2) AS total_quantity,
  ROUND(AVG(quantity)::NUMERIC, 2) AS average_per_transaction
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY txn_year, txn_type
ORDER BY txn_year ASC;

-- What was the monthly total quantity purchased and sold for Ethereum in 2020?
/*
2020-03-01T00:00:00.000Z	SELL	182.19
2020-04-01T00:00:00.000Z	BUY	    761.87
2020-04-01T00:00:00.000Z	SELL	203.17
2020-05-01T00:00:00.000Z	BUY	    787.42
2020-05-01T00:00:00.000Z	SELL	149.08
2020-06-01T00:00:00.000Z	BUY	    787.47
2020-06-01T00:00:00.000Z	SELL	208.34
2020-07-01T00:00:00.000Z	BUY	    890.78
2020-07-01T00:00:00.000Z	SELL	117.02

calendar_month	            buy_quantity	    sell_quantity
2020-01-01T00:00:00.000Z	801.0541163041565	158.1272716986775
2020-02-01T00:00:00.000Z	687.8912804600265	160.06533517839912
2020-03-01T00:00:00.000Z	804.2368342042604	182.1895644691428
2020-04-01T00:00:00.000Z	761.87446914631
*/

SELECT
	DATE_TRUNC('MON', txn_date) AS month_start,
    txn_type,
    ROUND(SUM(quantity)::NUMERIC, 2) AS total_monthly_quantity
FROM trading.transactions
WHERE ticker='ETH' AND EXTRACT(YEAR FROM txn_date) = 2020
GROUP BY month_start, txn_type;

SELECT
  DATE_TRUNC('MON', txn_date)::DATE AS calendar_month,
  SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) AS buy_quantity,
  SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) AS sell_quantity
FROM trading.transactions
WHERE txn_date BETWEEN '2020-01-01' AND '2020-12-31'
  AND ticker = 'ETH'
GROUP BY calendar_month
ORDER BY calendar_month;
/*
Summarise all buy and sell transactions for each member_id by generating 1 row for each member with the following additional columns:
Bitcoin buy quantity
Bitcoin sell quantity
Ethereum buy quantity
Ethereum sell quantity

member_id	btc_buy_quantity	btc_sell_quantity	eth_buy_quantity	eth_sell_quantity
c20ad4	    4975.750641191644	929.659744519077	2187.1154401373137	610.0470610814083
c51ce4	    2580.4064599247727	1028.7200828179675	2394.7300314796344	1076.700582569547
c4ca42	    4380.44293157246	1075.5626055691553	4516.597248410067	1011.5619313973

*/

SELECT
  member_id,
  SUM(CASE WHEN ticker= 'BTC' AND txn_type = 'BUY' THEN quantity ELSE 0 END) AS    			btc_buy_quantity,
  SUM(CASE WHEN ticker= 'BTC' AND txn_type = 'SELL' THEN quantity ELSE 0 END) AS 			btc_sell_quantity,
  SUM(CASE WHEN ticker= 'ETH' AND txn_type = 'BUY' THEN quantity ELSE 0 END) AS 			eth_buy_quantity,
  SUM(CASE WHEN ticker= 'ETH' AND txn_type = 'SELL' THEN quantity ELSE 0 END) AS 			eth_sell_quantity
FROM trading.transactions
GROUP BY member_id;

-- What was the final quantity holding of Bitcoin for each member? Sort the output from the highest BTC holding to lowest
/*
member_id	final_quantity_holding
e4da3b	    2569.0097117919145
45c48c	    3616.1114466881636
6512bd	    3456.9097800695927
c81e72	    1626.8358527114056
*/
WITH final_quantity AS ( 
SELECT
	member_id,
    SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) AS btc_buy_quantity,
    SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) AS btc_sell_quantity
    
FROM trading.transactions
WHERE ticker='BTC'
GROUP BY member_id
)
SELECT
	member_id,
    btc_buy_quantity - btc_sell_quantity AS final_quantity_holding
FROM final_quantity;    
     
-- Which members have sold less than 500 Bitcoin? Sort the output from the most BTC sold to least
/*
member_id	total_sold
8f14e4	    445.7438625475204
eccbc8	    305.3454893552332
45c48c	    198.131022250011

*/
WITH cte_sell_btc AS (
SELECT
	member_id,
    SUM(quantity) AS total_sold
FROM trading.transactions
WHERE txn_type = 'SELL' and ticker='BTC'
GROUP BY member_id
)
SELECT
	*
FROM cte_sell_btc
WHERE total_sold < 500
ORDER BY total_sold DESC;


--  What is the total Bitcoin quantity for each member_id owns after adding all of the BUY and SELL transactions from the transactions table? 
-- Sort the output by descending total quantity
/*
member_id	total_btc_holding
a87ff6	    4160.219869506643
c20ad4	    4046.090896672561
167909	    3945.198083260507
c9f0f8	    3720.5162047540916
45c48c	    3616.1114466881622
d3d944	    3534.985160169097
6512bd	    3456.9097800695936

*/
SELECT
	member_id,
    SUM(
    CASE
      WHEN txn_type = 'BUY' THEN quantity
      WHEN txn_type = 'SELL' THEN -quantity
      ELSE 0
    END
  ) AS total_btc_holding
    
FROM trading.transactions
WHERE ticker='BTC'
GROUP BY member_id
ORDER BY total_btc_holding DESC;

-- Which member_id has the highest buy to sell ratio by quantity?
/*
member_id	buy_to_sell_ratio
45c48c	    19.912698711113308
a87ff6	    7.486010484765202
c9f0f8	    6.249914187095622
8f14e4	    5.300053224554441
eccbc8	    4.928502329467622
c20ad4	    4.652097435222711

*/
SELECT
  member_id,
  SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) /
    SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) AS buy_to_sell_ratio
FROM trading.transactions
GROUP BY member_id
ORDER BY buy_to_sell_ratio DESC;

-- For each member_id - which month had the highest total Ethereum quantity sold`?
/*
member_id	calendar_month	            sold_eth_quantity
c51ce4	    2017-05-01T00:00:00.000Z	66.09244042953502
d3d944	    2020-04-01T00:00:00.000Z	60.41736997398335
6512bd	    2018-05-01T00:00:00.000Z	47.932857149515904
167909	    2020-12-01T00:00:00.000Z	45.92423664055218
c81e72	    2018-08-01T00:00:00.000Z	41.26728177476413
aab323	    2018-09-01T00:00:00.000Z	41.175076337098375
c4ca42	    2021-04-01T00:00:00.000Z.   40.11347472402258

*/
WITH cte_ranked AS (
SELECT
  member_id,
  DATE_TRUNC('MON', txn_date)::DATE AS calendar_month,
  SUM(quantity) AS sold_eth_quantity,
  RANK() OVER (PARTITION BY member_id ORDER BY SUM(quantity) DESC) AS month_rank
FROM trading.transactions
WHERE ticker = 'ETH' AND txn_type = 'SELL'
GROUP BY member_id, calendar_month
)
SELECT
  member_id,
  calendar_month,
  sold_eth_quantity
FROM cte_ranked
WHERE month_rank = 1
ORDER BY sold_eth_quantity DESC;








