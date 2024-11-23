# World Life Expectancy Project (Data Cleaning)
# Initial exploration of the dataset.


SELECT * 
FROM world_life_expectancy
;

# Finding Duplicates
# Identifying duplicate rows based on a combination of Country and Year.

SELECT * FROM(
	SELECT
	Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
    ) as Row_table
WHERE Row_Num > 1
;

# Removing Duplicates
# Deleting duplicate rows identified in the previous query.

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT
	Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
    ) as Row_table
WHERE Row_Num > 1
)
;

# Finding Null Values in the Status Column
# Checking for empty or missing values in the 'Status' column.


SELECT *
FROM world_life_expectancy
WHERE Status = '';
    
# Identifying Valid Values for the Status Column
# Listing distinct non-empty values in the 'Status' column.

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

# Checking Countries with 'Developing' Status
# Verifying which countries have 'Developing' as their Status value.

SELECT DISTINCT (Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

# Updating Missing Status Values
# Filling in missing values in the 'Status' column based on existing data for the same country.

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> '' 
AND t2.Status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> '' 
AND t2.Status = 'Developed'
;

# Verifying Remaining Null Values in the Status Column
# Ensuring no unaddressed missing values remain in the 'Status' column.

SELECT *
FROM world_life_expectancy
WHERE Status IS NULL
;

# Finding Null Values in the Life Expectancy Column
# Checking for empty or missing values in the 'Life expectancy' column.

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

# Calculating Missing Life Expectancy Values
# Using the average life expectancy of the preceding and succeeding years for the same country to fill missing values.

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`, 
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

# Updating Missing Life Expectancy Values
# Setting missing life expectancy values to the calculated average from the previous query.

UPDATE world_life_expectancy t1
Join world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = ''
;
