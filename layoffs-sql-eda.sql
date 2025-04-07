-- ------------------------------------------------------------
-- SETUP
-- ------------------------------------------------------------
select* from world_layoffs.layoffs;
-- Preview the dataset

-- Drop staging2 if it exists
DROP TABLE IF EXISTS world_layoffs.layoffs_staging2;

-- Recreate it with the same structure
CREATE TABLE world_layoffs.layoffs_staging2
LIKE world_layoffs.layoffs;

-- Populate it with data
INSERT INTO world_layoffs.layoffs_staging2
SELECT * FROM world_layoffs.layoffs;


SELECT * 
FROM world_layoffs.layoffs_staging2
LIMIT 100;

-- ------------------------------------------------------------
-- BASIC STATS & EXTREME CASES
-- ------------------------------------------------------------

-- Maximum layoffs in a single record
SELECT MAX(total_laid_off) AS max_layoffs
FROM world_layoffs.layoffs_staging2;

-- Min/Max percentage laid off (ignoring NULLs)
SELECT 
    MAX(percentage_laid_off) AS max_percentage,
    MIN(percentage_laid_off) AS min_percentage
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Companies with 100% of workforce laid off
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- ------------------------------------------------------------
-- AGGREGATIONS & TRENDS
-- ------------------------------------------------------------

-- Top 10 companies by total layoffs
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;

-- Top 10 locations by layoffs
SELECT location, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 10;

-- Layoffs by country
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total_layoffs DESC;

-- Layoffs by year
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL AND date IS NOT NULL
GROUP BY YEAR(date)
ORDER BY year;

-- Layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY total_layoffs DESC;

-- Layoffs by funding stage
SELECT stage, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY stage
ORDER BY total_layoffs DESC;

-- ------------------------------------------------------------
-- TOP COMPANIES BY YEAR (with RANKING)
-- ------------------------------------------------------------

WITH Company_Year AS (
  SELECT 
    company, 
    YEAR(date) AS year, 
    SUM(total_laid_off) AS total_layoffs
  FROM world_layoffs.layoffs_staging2
  WHERE total_laid_off IS NOT NULL AND date IS NOT NULL
  GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
  SELECT *, 
         DENSE_RANK() OVER (PARTITION BY year ORDER BY total_layoffs DESC) AS `rank`
  FROM Company_Year
)
SELECT *
FROM Company_Year_Rank
WHERE `rank` <= 3
ORDER BY year ASC, `rank`;

-- ------------------------------------------------------------
-- ROLLING LAYOFF TREND (Monthly)
-- ------------------------------------------------------------

WITH Monthly_Layoffs AS (
  SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(total_laid_off) AS total_layoffs
  FROM world_layoffs.layoffs_staging2
  WHERE date IS NOT NULL
  GROUP BY DATE_FORMAT(date, '%Y-%m')
)
SELECT 
  month,
  total_layoffs,
  SUM(total_layoffs) OVER (ORDER BY month ASC) AS rolling_total_layoffs
FROM Monthly_Layoffs
ORDER BY month ASC;

-- ------------------------------------------------------------
-- PERCENTAGE OF GLOBAL LAYOFFS BY COUNTRY
-- ------------------------------------------------------------

WITH Global_Total AS (
  SELECT SUM(total_laid_off) AS grand_total
  FROM world_layoffs.layoffs_staging2
  WHERE total_laid_off IS NOT NULL
)
SELECT 
  country,
  SUM(total_laid_off) AS total_layoffs,
  ROUND(SUM(total_laid_off) * 100.0 / grand_total, 2) AS percent_of_total
FROM world_layoffs.layoffs_staging2, Global_Total
WHERE total_laid_off IS NOT NULL
GROUP BY country, grand_total
ORDER BY percent_of_total DESC;

-- ------------------------------------------------------------
-- INDUSTRY LAYOFF TREND OVER YEARS
-- ------------------------------------------------------------

SELECT 
  industry,
  YEAR(date) AS year,
  SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL AND date IS NOT NULL
GROUP BY industry, YEAR(date)
ORDER BY year, total_layoffs DESC;

-- ------------------------------------------------------------
-- END OF EDA SCRIPT
-- ------------------------------------------------------------
