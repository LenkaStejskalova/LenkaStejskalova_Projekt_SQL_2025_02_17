
CREATE TABLE t_lenka_stejskalova_project_SQL_primary_final AS
WITH payrolls AS (
	SELECT 
		czechia_payroll.payroll_year AS year,
		czechia_payroll.industry_branch_code,
		czechia_payroll_industry_branch.name AS industry_branch_name,
		round(avg(czechia_payroll.value)) AS industry_branch_payroll
	FROM czechia_payroll
	LEFT JOIN czechia_payroll_industry_branch
		ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code 
	WHERE czechia_payroll.payroll_year BETWEEN 2006 AND 2018
		AND czechia_payroll.value_type_code = 5958
		AND czechia_payroll.calculation_code = 100
	GROUP BY czechia_payroll.payroll_year, czechia_payroll.industry_branch_code, czechia_payroll_industry_branch.name
	ORDER BY czechia_payroll.payroll_year, czechia_payroll.industry_branch_code
),
prices AS (
	SELECT 
		date_part('year', czechia_price.date_from) AS year,
		czechia_price.category_code,
		czechia_price_category.name AS category_name,
		round(avg(czechia_price.value)::numeric,2) AS category_price,
		price_unit AS measure_unit
	FROM czechia_price
	LEFT JOIN czechia_price_category
		ON czechia_price.category_code = czechia_price_category.code 
	WHERE czechia_price.region_code IS NULL
	GROUP BY czechia_price.category_code, date_part('year', czechia_price.date_from), czechia_price_category.name, czechia_price_category.price_unit
	ORDER BY date_part('year', czechia_price.date_from), czechia_price.category_code
),
gdp_data AS (
	SELECT 
		year,
		gdp
	FROM economies
	WHERE 
		year BETWEEN 2006 AND 2018
		AND country LIKE 'Czech Republic'
	ORDER BY YEAR
)
SELECT 
	payrolls.year,
	payrolls.industry_branch_code,
	payrolls.industry_branch_name,
	payrolls.industry_branch_payroll,
	prices.category_code,
	prices.category_name,
	prices.category_price,
	prices.measure_unit,
	gdp_data.gdp
FROM payrolls
LEFT JOIN prices
	ON payrolls.year = prices.year
LEFT JOIN gdp_data
	ON payrolls.year = gdp_data.YEAR
ORDER BY payrolls.year, payrolls.industry_branch_code, prices.category_code;



CREATE TABLE t_lenka_stejskalova_project_SQL_secondary_final AS
SELECT 
	country,
	year,
	gdp,
	gini,
	population 
FROM economies
WHERE 
	country IN ('Austria', 'Poland', 'Germany', 'Slovakia', 'Czech Republic')
	AND year BETWEEN 2006 AND 2018
ORDER BY year, country;



-- Úkol 1

SELECT DISTINCT 
	industry_branch_code,
	industry_branch_name,
	FIRST_VALUE(industry_branch_payroll) OVER (PARTITION BY industry_branch_code ORDER BY year) AS first_value,
	LAST_VALUE(industry_branch_payroll) OVER (PARTITION BY industry_branch_code ORDER BY year RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS last_value,
	LAST_VALUE(industry_branch_payroll) OVER (PARTITION BY industry_branch_code ORDER BY year RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) 
		- FIRST_VALUE(industry_branch_payroll) OVER (PARTITION BY industry_branch_code ORDER BY year) AS difference
FROM t_lenka_stejskalova_project_SQL_primary_final
WHERE industry_branch_code IS NOT NULL
ORDER BY industry_branch_code;



-- Úkol 2

WITH payrolls AS (
	SELECT 
		year,
		industry_branch_payroll
	FROM t_lenka_stejskalova_project_SQL_primary_final
	WHERE industry_branch_code IS NULL
),
prices AS (
	SELECT 
		year,
		category_code,
		category_name,
		category_price,
		measure_unit
	FROM t_lenka_stejskalova_project_SQL_primary_final
	WHERE 
		year IN (2006, 2018)
		AND category_code IN ('111301', '114201')
)
SELECT DISTINCT 
	payrolls.year,
	prices.category_code,
	prices.category_name,
	prices.category_price,
	payrolls.industry_branch_payroll,
	round(payrolls.industry_branch_payroll / prices.category_price) AS purchasable_quantity_goods,
	prices.measure_unit
FROM payrolls
JOIN prices 
	ON payrolls.year = prices.YEAR
ORDER BY payrolls.year, prices.category_code;



-- Úkol 3

WITH prices AS (
	SELECT
		year,
		category_code,
		category_name,
		round((avg(category_price)), 2) AS avg_price
	FROM t_lenka_stejskalova_project_SQL_primary_final
	WHERE 
		category_code != ('212101')
	GROUP BY year, category_code, category_name 
)
SELECT
	prices.year,
	prices.category_code,
	prices.category_name,
	prices.avg_price AS price,
	round((LAG(prices.avg_price) OVER (PARTITION BY prices.category_code ORDER BY prices.year)),2) AS prev_price,
	round(((prices.avg_price - (LAG(prices.avg_price) OVER (PARTITION BY prices.category_code ORDER BY prices.year))) 
		/ (LAG(prices.avg_price) OVER (PARTITION BY prices.category_code ORDER BY prices.year))) * 100) AS percentage_price_change
FROM prices
ORDER BY year, category_code;



-- Úkol 4

WITH payrolls AS (
	SELECT 
		year,
		round(avg(industry_branch_payroll)) AS avg_payroll
	FROM t_lenka_stejskalova_project_SQL_primary_final
	WHERE industry_branch_code IS NULL
	GROUP BY year
),
prices AS (
	SELECT
		year,
		round((avg(category_price)), 2) AS avg_price
	FROM t_lenka_stejskalova_project_SQL_primary_final
	WHERE 
		category_code != ('212101')
	GROUP BY year
)
SELECT
	payrolls.year,
	payrolls.avg_payroll AS payroll,
	round(LAG(payrolls.avg_payroll) OVER (ORDER BY payrolls.year)) AS prev_payroll,
	prices.avg_price AS price,
	round((LAG(prices.avg_price) OVER (ORDER BY prices.year)),2) AS prev_price,
	round(((payrolls.avg_payroll - (LAG(payrolls.avg_payroll) 
		OVER (ORDER BY payrolls.year))) / (LAG(payrolls.avg_payroll) OVER (ORDER BY payrolls.year))) * 100) AS percentage_payroll_change,
	round(((prices.avg_price - (LAG(prices.avg_price) OVER (ORDER BY prices.year))) 
		/ (LAG(prices.avg_price) OVER (ORDER BY prices.year))) * 100) AS percentage_price_change,
	(round(((prices.avg_price - (LAG(prices.avg_price) OVER (ORDER BY prices.year))) 
		/ (LAG(prices.avg_price) OVER (ORDER BY prices.year))) * 100)) 
		- (round(((payrolls.avg_payroll - (LAG(payrolls.avg_payroll) OVER (ORDER BY payrolls.year))) 
		/ (LAG(payrolls.avg_payroll) OVER (ORDER BY payrolls.year))) * 100)) AS difference
FROM payrolls
JOIN prices
	ON payrolls.year = prices.year;



-- Úkol 5

WITH gdp_data AS (
	SELECT 
		year,
		round(avg(gdp)) AS gdp
	FROM t_lenka_stejskalova_project_SQL_primary_final
	GROUP BY year
),
payrolls AS (
	SELECT 
		year,
		round(avg(industry_branch_payroll)) AS avg_payroll
	FROM t_lenka_stejskalova_project_SQL_primary_final
	WHERE industry_branch_code IS NULL
	GROUP BY year
),
prices AS (
	SELECT
		year,
		round((avg(category_price)), 2) AS avg_price
	FROM t_lenka_stejskalova_project_SQL_primary_final
	WHERE 
		category_code != ('212101')
	GROUP BY year
)
SELECT
	payrolls.year,
	gdp_data.gdp,
	LAG(gdp_data.gdp) OVER (ORDER BY gdp_data.year) AS prev_gdp,
	payrolls.avg_payroll AS payroll,
	round(LAG(payrolls.avg_payroll) OVER (ORDER BY payrolls.year)) AS prev_payroll,
	prices.avg_price AS price,
	round((LAG(prices.avg_price) OVER (ORDER BY prices.year)),2) AS prev_price,
	round(((gdp_data.gdp - (LAG(gdp_data.gdp) 
		OVER (ORDER BY gdp_data.year))) / (LAG(gdp_data.gdp) OVER (ORDER BY gdp_data.year))) * 100) AS percentage_gdp_change,
	round(((payrolls.avg_payroll - (LAG(payrolls.avg_payroll) 
		OVER (ORDER BY payrolls.year))) / (LAG(payrolls.avg_payroll) OVER (ORDER BY payrolls.year))) * 100) AS percentage_payroll_change,
	round(((prices.avg_price - (LAG(prices.avg_price) OVER (ORDER BY prices.year))) 
		/ (LAG(prices.avg_price) OVER (ORDER BY prices.year))) * 100) AS percentage_price_change
FROM payrolls
JOIN prices
	ON payrolls.year = prices.year
JOIN gdp_data
	ON payrolls.year = gdp_data.year;




















































