# Exploratory Data Analysis on Layoffs Dataset
# Project Description
    This project uses SQL to perform exploratory data analysis (EDA) on a dataset of company layoffs. The analysis focuses on uncovering trends and insights across 
    various dimensions, including companies, industries, countries, and time period. Key metrics such as total layoffs, percentages, and ranking of top companies 
    are computed to provide a deeper understanding of layoff trends.

Key Features

1. Dataset Overview
    The dataset contains information about layoffs, including:
   
    company:  The company where layoffs occurred.
    date:     The date of the layoffs.
    industry: The industry of the company.
    total_laid_off:        Total number of employees laid off.
    percentage_laid_off:   Percentage of the workforce laid off.
    funds_raised_millions: Funds raised by the company before layoffs.
    country:  Country where the company operates.
    stage:    Company stage (e.g., startup, enterprise).



2. Analysis Performed
    General Exploration
       . View all records in the dataset.
       . Identify the maximum values for total_laid_off and percentage_laid_off.

   
    Specific Queries
        . Companies with the highest layoff percentages, sorted by funds raised.
        . Total layoffs by:
            . Company
            . Industry
            . Country
            . Year
        . Rolling totals of layoffs over time.
   
   
    Insights into Dates
         . Minimum and maximum dates in the dataset.
         . Aggregate layoffs grouped by year or month.

   
    Top Companies by Layoffs
         . Ranking the top 5 companies with the highest layoffs for each year using window functions.


# Key SQL Queries

    1. Total Layoffs by Industry
    
    SELECT industry, SUM(total_laid_off)
    FROM layoffs_staging_new2
    GROUP BY industry
    ORDER BY 2 DESC;
    
    2. Rolling Total of Layoffs
    
    WITH Rolling_Total AS (
        SELECT 
            LEFT(date, 4) AS `month`, -- Extract year and month
            SUM(total_laid_off) AS total_off
        FROM layoffs_staging_new2
        WHERE date IS NOT NULL
        GROUP BY LEFT(date, 4)
        ORDER BY LEFT(date, 4) ASC
    )
    SELECT 
        `month`, total_off, 
        SUM(total_off) OVER (ORDER BY `month` ASC) AS rolling_total
    FROM Rolling_Total;
    
    
    3. Top 5 Companies by Layoffs Each Year
    
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

    
  Technologies Used
    SQL: Query language for data analysis.
    MySQL: Database management system.


  For queries or suggestions, feel free to reach out:

    LinkedIn: https://www.linkedin.com/in/vivek-singh-631213216/
