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

-- ALWAYS CHECK FOR DUPLICATES WHENEVER WORKING WITH DATA SETS!
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
DELETE  -- we cant delete it directly because a delete statement works like a update statement, so basically we need a different approach to delete the duplicate entries!!
FROM duplicate_cte
WHERE row_num > 1;

-- we made a secondary copy of the already made duplicate!, and we added a extra column into it called as row_num
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT -- row_num was added here
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- viweing the empty table
SELECT *
FROM layoffs_staging2;

-- we inserted the data from layoffs_staging into this using the below commands
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- and then we deleted the duplicates from layoffs_staging 2
-- we couldn't directly delete data from layoffs_staging as row_num wasn't actually added into that table, it was just a viewing feature that we added!
-- in layoffs_staging2, we added the row_num as a proper table and in the future we can directly do this into a single table, instead of creating a extra copy
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- with this we have successfully deleted the duplicate entries and can now proceed with standaradizing the data
SELECT *
FROM layoffs_staging2;

-- Standardizing the Data

-- firstly we can already see that the company names has a white spaces, before and after so we removed them
SELECT company, TRIM(company)
FROM layoffs_staging2;

-- updates them into the table
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT company, TRIM(company)
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;
-- by this query we understood that a a few industries are repeated like, crypto and crypto Currency

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';
-- saw the actual data

UPDATE layoffs_staging2
SET industry  = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- updated the table whereever it was cryptocurrency to just crypto

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';
-- saw all of them changed to crypto!

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;
-- checked for industries

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
-- checked for countries
-- found an error where united states was repeated twice, corrected that below

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%';

UPDATE layoffs_staging2
SET country  = 'United States'
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
-- done with countries!

-- changing the date column to actual date data,
-- because we want to do trailing time EDA, we need to change that

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;
-- convert the date from sttring to actual date data type

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- updating the date ka data!

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
-- here we actually changed the date ka data type from text to actual date data type!!

-- WORKING WITH NULL AND BLANK VALUES

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';
-- we had found some industries as blank or null, this query gave us the company names which have the industries as blank and stuff

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';
-- here I am crossreferencing the companies against the DB, to see if we can repopulate the industry field based on the fact whether they had multiple layoffs or not

SELECT *
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
-- this created a self join between the two tables wherever the company names are the same but industries are missing.

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;	
-- this updated the entries, for 3 out of the 4 companies

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';
-- Bally has only a single layoff in the entire csv file

SELECT * 
FROM layoffs_staging2;

-- we can't populate the percentage laid off and total laid off as we don't have the data of company size.

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- we can get rid of these as because, the total laid off and percentage laid off are zero which means that the company didn't have a layoff at all
-- so can we delete this? yes, should we delete this? 75% sure.

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
-- we removed the row number because we don't need it anymore!

SELECT * 
FROM layoffs_staging2;
-- final cleaned data sheet or table!


