-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- these are companies which were completely shutdown
-- ordered by money

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, AVG(percentage_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT SUBSTRING(`date`,1,7) AS months, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)  IS NOT NULL
GROUP BY months
ORDER BY 1;

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7) AS months, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)  IS NOT NULL
GROUP BY months
ORDER BY 1
)

SELECT months, total_off, 
SUM(total_off) OVER(ORDER BY months) AS rolling_total
FROM Rolling_Total;

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`) as Years, SUM(total_laid_off) as Total_laid_off
FROM layoffs_staging2
GROUP BY company, Years
ORDER BY 3 DESC;

WITH company_year AS
(
SELECT company, YEAR(`date`) as Years, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company, Years
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE YEARS IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
-- gave me layoffs per year in top 5



