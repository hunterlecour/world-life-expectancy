# World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy
;


# Analyzing Life Expectancy Trends for the Past 15 Years
# Identifying how each country has progressed in terms of life expectancy.

SELECT 
Country,
MIN(`Life expectancy`),
MAX(`Life expectancy`),
round(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;

# Average Life Expectancy per Year
# Calculating the average life expectancy for each year to observe trends over time.

SELECT
Year,
Round(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY YEAR
ORDER BY Year
;

# Correlation Between GDP and Life Expectancy
# Analyzing the relationship between GDP and life expectancy by country.

SELECT 
Country,
ROUND(AVG(`Life expectancy`),1) AS Life_Exp,
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

# Life Expectancy Based on GDP Levels
# Comparing life expectancy for countries with high GDP (>= 1500) and low GDP (< 1500).

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy
ORDER BY GDP
;

# Average Life Expectancy by Development Status
# Comparing the average life expectancy for "Developed" and "Developing" countries.


SELECT 
Status,
ROUND(AVG(`Life expectancy`),1),
COUNT(DISTINCT Country)
FROM world_life_expectancy
GROUP BY Status
;

# Correlation Between BMI and Life Expectancy
# Examining the relationship between average BMI and life expectancy by country.

SELECT 
Country,
ROUND(AVG(`Life expectancy`),1) AS Life_Exp,
ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI DESC
;

# Adult Mortality Trends Over Time
# Tracking changes in adult mortality over time for each country.

SELECT 
Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) as Rolling_Total
FROM world_life_expectancy
;




