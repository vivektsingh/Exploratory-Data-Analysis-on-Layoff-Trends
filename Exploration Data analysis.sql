-- Exploration Data analysis

select *
from layoffs_staging_new2;

select MAX(total_laid_off), MAX(percentage_laid_off)
from layoffs_staging_new2;

SELECT *
FROM layoffs_staging_new2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging_new2
group by company
order by 2 desc;

select MIN(date), MAX(DATE)
from layoffs_staging_new2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_new2
group by industry
order by 2 desc;

select *
from layoffs_staging_new2;


SELECT country, SUM(total_laid_off)
FROM layoffs_staging_new2
group by country
order by 2 desc;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging_new2
group by YEAR(date)
order by 1 desc;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging_new2
group by stage
order by 2 desc;

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging_new2
group by company
order by 1 desc;

select *
from layoffs_staging_new2
order by company;


SELECT company, sum(percentage_laid_off)
FROM layoffs_staging_new2
group by company
order by 1 desc;

SELECT 
        LEFT(date, 4) AS `month`, -- Extracts the year and month (e.g., '2023-01')
        SUM(total_laid_off) AS total_off
    FROM layoffs_staging_new2
    WHERE date IS NOT NULL
    GROUP BY LEFT(date, 4)-- Group by the extracted year-month
    ORDER BY LEFT(date, 4) ASC;


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
    `month`,total_off, 
    SUM(total_off) OVER (ORDER BY `month` ASC) AS rolling_total
FROM Rolling_Total;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging_new2
group by company
order by 2 DESC;

SELECT company, date, SUM(total_laid_off)
FROM layoffs_staging_new2
group by company ,date
ORDER BY company asc;

SELECT company, date, SUM(total_laid_off)
FROM layoffs_staging_new2
group by company ,date
ORDER BY 3 desc;

SELECT company, left(date,4), SUM(total_laid_off)
FROM layoffs_staging_new2
group by company , left(date,4)
order by left(date,4) ;

with Company_year (company, years, total_laid_off) as
(
SELECT company, left(date,4), SUM(total_laid_off)
FROM layoffs_staging_new2
group by company , left(date,4)
),
Company_year_Rank AS
(select *, dense_rank() over(partition by years order by total_laid_off DESC ) AS Ranking
from Company_year
WHERE YEARS IS NOT NULL
)
select * from Company_year_Rank
WHERE RANKING <= 5;





