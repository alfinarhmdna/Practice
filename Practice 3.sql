CREATE DATABASE ds;
SELECT * FROM ds_salaries;

-- 1. Apakah ada data yang NULL?
SELECT * 
FROM ds_salaries
WHERE work_year IS NULL
OR experience_level IS NULL
OR employment_type IS NULL
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;

-- 2. Melihat ada job title apa saja
SELECT DISTINCT job_title 
FROM ds_salaries 
ORDER BY job_title;

-- 3. Job title apa saja yang berkaitan dengan data analyst
SELECT DISTINCT job_title 
FROM ds_salaries 
WHERE job_title LIKE '%data analyst%'
ORDER BY job_title;

-- 4. Berapa rata-rata gaji data analyst?
SELECT AVG(salary_in_usd) * 15000 / 12 AS avg_salary_rp_monthly FROM ds_salaries;

-- 4.1 Berapa rata-rata gaji data analyst berdasarkan experience levelnya?
SELECT experience_level, 
	(AVG(salary_in_usd) * 15000 / 12) AS avg_salary_rp_monthly 
FROM ds_salaries 
GROUP BY experience_level;

-- 4.2 Berapa rata-rata gaji data analyst berdasarkan experience level dan
-- jenis employmentnya?
SELECT experience_level, 
	employment_type,
	(AVG(salary_in_usd) * 15000 / 12) AS avg_salary_rp_monthly 
FROM ds_salaries 
GROUP BY experience_level, 
	employment_type
ORDER BY experience_level, employment_type;

-- 5. Negara dengan gaji yg menarik untuk posisi data analyst (>=20000), full-time
-- & experience level = entry dan mid
SELECT company_location, 
	AVG(salary_in_usd) AS avg_sal_in_usd
FROM ds_salaries
WHERE job_title LIKE '%data analyst%'
	AND employment_type = 'FT'
    AND experience_level IN ('EN', 'MI')
GROUP BY company_location
HAVING avg_sal_in_usd >= 20000; -- having = memfilter fungsi agregat

-- 6. Di tahun berapa, kenaikan rerata gaji dari mid ke senior itu memiliki kenaikan tertinggi?
-- (untuk pekerjaan yang berkaitan dengan data analyst yang full time)
WITH ds_1 AS (
	SELECT work_year,
		AVG(salary_in_usd) AS avg_sal_in_usd_ex
	FROM ds_salaries
    WHERE
		employment_type = 'FT'
        AND experience_level = 'EX'
        AND job_title LIKE '%data analyst%'
	GROUP BY work_year
), ds_2 AS (
SELECT work_year,
		AVG(salary_in_usd) AS avg_sal_in_usd_mi
	FROM ds_salaries
    WHERE
		employment_type = 'FT'
        AND experience_level = 'MI'
        AND job_title LIKE '%data analyst%'
	GROUP BY work_year
), t_year AS (
	SELECT DISTINCT work_year
    FROM ds_salaries
) SELECT t_year.work_year,
	ds_1.avg_sal_in_usd_ex,
    ds_2.avg_sal_in_usd_mi,
	ds_1.avg_sal_in_usd_ex - ds_2.avg_sal_in_usd_mi difference
FROM t_year
LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;

-- kalo pake ini kurang akurat (data 2020 gaada)
SELECT ds_2.work_year, 
	ds_1.avg_sal_in_usd_ex,
    ds_2.avg_sal_in_usd_mi,
    ds_1.avg_sal_in_usd_ex - ds_2.avg_sal_in_usd_mi AS difference
FROM ds_1 
LEFT JOIN ds_2 
	ON ds_1.work_year = ds_2.work_year; -- di tahun 2020 dg full time dll itu datanya gaada
