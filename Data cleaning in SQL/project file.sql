-- Data cleaning

SELECT *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standaardize the Data
-- 3. Null values/ Blank Values
-- 4. Remove any columns or rows that aren't necessary (situation dependent)
	
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- why did we make a duplicate? so that we can have the raw data for reference, just incase we make a mistake!

-- selecting the duplicate entries
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- checking whether the duplicate entry is correct or not
SELECT * 
FROM layoffs_staging
WHERE company = 'Yahoo';

WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE  -- we cant delete it directly because a delete statement works like a update statement
FROM duplicate_cte
WHERE row_num > 1;
