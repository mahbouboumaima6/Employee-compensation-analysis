-- ============================================
-- PROJECT: Employee Compensation Fairness & 
--          Talent Risk Analytics
-- Dataset: IBM HR Analytics (1,470 employees)
-- Tools:   MySQL + Power BI
-- ============================================

-- ============================================
-- SECTION 1: DATA OVERVIEW
-- ============================================

USE hr_data;

-- Total employees
SELECT COUNT(*) AS total_employees
FROM hr_data;

-- Salary statistics
SELECT
  MIN(MonthlyIncome)        AS min_salary,
  MAX(MonthlyIncome)        AS max_salary,
  ROUND(AVG(MonthlyIncome),0) AS avg_salary,
  ROUND(STD(MonthlyIncome),0) AS salary_std
FROM hr_data;

-- Missing values check
SELECT
  SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS missing_salary,
  SUM(CASE WHEN Department    IS NULL THEN 1 ELSE 0 END) AS missing_department,
  SUM(CASE WHEN JobRole       IS NULL THEN 1 ELSE 0 END) AS missing_jobrole
FROM hr_data;

-- ============================================
-- SECTION 2: COMPENSATION KPIs
-- ============================================

-- Average salary by department
SELECT
  Department,
  COUNT(*)                    AS headcount,
  ROUND(AVG(MonthlyIncome),0) AS avg_salary
FROM hr_data
GROUP BY Department;

-- Average salary by job role
SELECT
  JobRole,
  COUNT(*)                    AS headcount,
  ROUND(AVG(MonthlyIncome),0) AS avg_salary
FROM hr_data
GROUP BY JobRole
ORDER BY avg_salary DESC;

-- Total monthly payroll
SELECT SUM(MonthlyIncome) AS total_payroll
FROM hr_data;

-- Gender distribution
SELECT
  Gender,
  COUNT(*) AS headcount
FROM hr_data
GROUP BY Gender;

-- ============================================
-- SECTION 3: PAY EQUITY ANALYSIS
-- ============================================

-- Gender pay gap by department
SELECT
  Department,
  Gender,
  COUNT(*)                    AS headcount,
  ROUND(AVG(MonthlyIncome),0) AS avg_salary
FROM hr_data
GROUP BY Department, Gender;

-- Salary percentile within job role (window function)
SELECT
  EmployeeNumber,
  JobRole,
  Department,
  MonthlyIncome,
  ROUND(
    PERCENT_RANK() OVER (
      PARTITION BY JobRole ORDER BY MonthlyIncome
    ) * 100, 1
  ) AS salary_percentile
FROM hr_data;

-- Pay status classification
SELECT
  EmployeeNumber,
  JobRole,
  MonthlyIncome,
  AVG(MonthlyIncome) OVER (PARTITION BY JobRole) AS role_avg_salary,
  CASE
    WHEN MonthlyIncome < AVG(MonthlyIncome) OVER (PARTITION BY JobRole) * 0.8
      THEN 'Underpaid'
    WHEN MonthlyIncome > AVG(MonthlyIncome) OVER (PARTITION BY JobRole) * 1.2
      THEN 'Overpaid'
    ELSE 'Fair'
  END AS pay_status
FROM hr_data;

-- ============================================
-- SECTION 4: TALENT VALUE ANALYSIS
-- ============================================

-- Undervalued high performer flag
SELECT
  EmployeeNumber,
  JobRole,
  MonthlyIncome,
  PerformanceRating,
  AVG(MonthlyIncome) OVER (PARTITION BY JobRole) AS role_avg_salary,
  CASE
    WHEN PerformanceRating >= 3
    AND  MonthlyIncome < AVG(MonthlyIncome) OVER (PARTITION BY JobRole)
      THEN 'Undervalued High Performer'
    ELSE 'Normal'
  END AS talent_value_flag
FROM hr_data;

-- Compensation risk segmentation
SELECT
  EmployeeNumber,
  JobRole,
  MonthlyIncome,
  PERCENT_RANK() OVER (
    PARTITION BY JobRole ORDER BY MonthlyIncome
  ) AS salary_rank,
  CASE
    WHEN PERCENT_RANK() OVER (
      PARTITION BY JobRole ORDER BY MonthlyIncome
    ) < 0.3 THEN 'Low Pay Segment'
    ELSE 'Normal'
  END AS compensation_risk
FROM hr_data;

-- ============================================
-- SECTION 5: MASTER DATASET
-- (exported to CSV for Power BI import)
-- ============================================

SELECT
  EmployeeNumber,
  Age,
  Gender,
  Department,
  JobRole,
  JobLevel,
  MonthlyIncome,
  PerformanceRating,
  YearsAtCompany,
  JobSatisfaction,
  WorkLifeBalance,
  OverTime,
  Attrition,
  ROUND(
    PERCENT_RANK() OVER (
      PARTITION BY JobRole ORDER BY MonthlyIncome
    ) * 100, 1
  )                             AS salary_percentile,
  ROUND(
    AVG(MonthlyIncome) OVER (PARTITION BY JobRole), 0
  )                             AS role_avg_salary,
  MonthlyIncome - ROUND(
    AVG(MonthlyIncome) OVER (PARTITION BY JobRole), 0
  )                             AS diff_from_role_avg,
  CASE
    WHEN MonthlyIncome < AVG(MonthlyIncome)
      OVER (PARTITION BY JobRole) * 0.8 THEN 'Underpaid'
    WHEN MonthlyIncome > AVG(MonthlyIncome)
      OVER (PARTITION BY JobRole) * 1.2 THEN 'Overpaid'
    ELSE 'Fair'
  END                           AS pay_status,
  CASE
    WHEN PerformanceRating >= 3
    AND  MonthlyIncome < AVG(MonthlyIncome)
      OVER (PARTITION BY JobRole)
      THEN 'Undervalued High Performer'
    ELSE 'Normal'
  END                           AS talent_value_flag,
  NTILE(4) OVER (
    PARTITION BY JobRole ORDER BY MonthlyIncome
  )                             AS salary_quartile,
  CASE NTILE(4) OVER (
    PARTITION BY JobRole ORDER BY MonthlyIncome)
    WHEN 1 THEN 'Bottom 25%'
    WHEN 2 THEN 'Lower Mid 25%'
    WHEN 3 THEN 'Upper Mid 25%'
    WHEN 4 THEN 'Top 25%'
  END                           AS salary_quartile_label,
  CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0
  END                           AS attrition_flag
FROM hr_data
ORDER BY Department, JobRole, MonthlyIncome DESC;