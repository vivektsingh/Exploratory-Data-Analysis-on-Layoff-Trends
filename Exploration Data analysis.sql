-- Exploration Data Analysis on Layoffs Dataset

-- Query 1: Fetch all records from the layoffs_staging_new2 table
select *
from layoffs_staging_new2;

-- Query 2: Find the maximum values for total layoffs and percentage layoffs
select MAX(total_laid_off), MAX(percentage_laid_off)
from layoffs_staging_new2;

-- Query 3: Retrieve records where percentage layoffs = 100% and sort by funds raised
SELECT *
FROM layoffs_staging_new2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Query 4: Calculate the total number of layoffs by company and order by the sum
SELECT company, SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY company
ORDER BY 2 DESC;

-- Query 5: Find the minimum and maximum date in the dataset
select MIN(date), MAX(DATE)
from layoffs_staging_new2;

-- Query 6: Calculate total layoffs by industry and order by the sum
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY industry
ORDER BY 2 DESC;

-- Query 7: Display all records from the table (already seen in Query 1)
select *
from layoffs_staging_new2;

-- Query 8: Calculate total layoffs by country and order by the sum
SELECT country, SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY country
ORDER BY 2 DESC;

-- Query 9: Calculate total layoffs by year and order by year in descending order
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

-- Query 10: Calculate total layoffs by company stage and order by the sum
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY stage
ORDER BY 2 DESC;

-- Query 11: Calculate the total percentage layoffs by company and order by the sum
SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging_new2
GROUP BY company
ORDER BY 1 DESC;

-- Query 12: Fetch all records from the table and order by company name
select *
from layoffs_staging_new2
ORDER BY company;

-- Query 13: Calculate the sum of percentage layoffs by company and order by the sum
SELECT company, sum(percentage_laid_off)
FROM layoffs_staging_new2
GROUP BY company
ORDER BY 1 DESC;

-- Query 14: Extract the year and month, and calculate total layoffs by year-month
SELECT 
        LEFT(date, 4) AS `month`, -- Extracts the year and month (e.g., '2023-01')
        SUM(total_laid_off) AS total_off
FROM layoffs_staging_new2
WHERE date IS NOT NULL
GROUP BY LEFT(date, 4) -- Group by the extracted year-month
ORDER BY LEFT(date, 4) ASC;

-- Query 15: Calculate rolling total layoffs over time by year-month
WITH Rolling_Total AS (
    SELECT 
        LEFT(date, 4) AS `month`, -- Extracts the year and month (e.g., '2023-01')
        SUM(total_laid_off) AS total_off
    FROM layoffs_staging_new2
    WHERE date IS NOT NULL
    GROUP BY LEFT(date, 4) -- Group by the extracted year-month
    ORDER BY LEFT(date, 4) ASC
)
SELECT 
    `month`, total_off, 
    SUM(total_off) OVER (ORDER BY `month` ASC) AS rolling_total
FROM Rolling_Total;

-- Query 16: Calculate total layoffs by company, ordered by the sum in descending order
SELECT company, SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY company
ORDER BY 2 DESC;

-- Query 17: Calculate total layoffs by company and date, ordered by company
SELECT company, date, SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY company, date
ORDER BY company ASC;

-- Query 18: Calculate total layoffs by company and date, ordered by the sum in descending order
SELECT company, date, SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY company, date
ORDER BY 3 DESC;

-- Query 19: Calculate total layoffs by company and year (extract year from date)
SELECT company, LEFT(date, 4), SUM(total_laid_off)
FROM layoffs_staging_new2
GROUP BY company, LEFT(date, 4)
ORDER BY LEFT(date, 4);

-- Query 20: Rank companies by total layoffs for each year and show top 5 companies
WITH Company_year (company, years, total_laid_off) AS (
    SELECT company, LEFT(date, 4), SUM(total_laid_off)
    FROM layoffs_staging_new2
    GROUP BY company, LEFT(date, 4)
),
Company_year_Rank AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    FROM Company_year
    WHERE years IS NOT NULL
)
SELECT * 
FROM Company_year_Rank
WHERE Ranking <= 5;
