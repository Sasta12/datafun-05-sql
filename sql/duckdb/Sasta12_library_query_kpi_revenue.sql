-- sql/duckdb/case_retail_kpi_revenue.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Calculate a Key Performance Indicator (KPI) for the library domain using DuckDB SQL.
--
-- KPI DRIVES THE WORK:
-- In analytics, we do not start with "write a query."
-- We start with a KPI that supports an actionable decision.
--
-- ACTIONABLE OUTCOME (EXAMPLE):
-- We want to identify which branches are generating the most checkouts so we can:
-- - allocate staffing during high-performing periods,
-- - increase inventory for top categories,
-- - investigate why low-performing stores are underperforming,
-- - target promotions where they will have the biggest impact.
--
-- In this example, our KPI is branch activity (total checkouts) by branch.
--
-- ANALYST RESPONSIBILITY:
-- Analysts are responsible for determining HOW to get the information
-- that informs the KPI and supports action.
-- That means:
-- - identifying the needed tables,
-- - joining them correctly,
-- - selecting the right measures,
-- - aggregating at the correct level (store),
-- - and presenting results in a way that supports decision-making.
--
-- ASSUMPTION:
-- We always run all commands from the project root directory.
--
-- EXPECTED PROJECT PATHS (relative to repo root):
--   SQL:  sql/duckdb/case_retail_kpi_revenue.sql
--   DB:   artifacts/duckdb/retail.duckdb
--
--
-- ============================================================
-- TOPIC DOMAINS + 1:M RELATIONSHIPS
-- ============================================================
-- OUR DOMAIN: LIBRARY
-- Two tables in a 1-to-many relationship (1:M):
-- - branch (1): independent/parent table
-- - checkout (M): dependent/child table
--
-- HOW THIS RELATES TO OUR KPI:
-- - The branch table tells us "which branch" (branch_id, branch_name, location).
-- - The checkout table contains the measurable activity (material_type, duration_days, fine_amount, checkout_date).
-- - To compute activity by branch, we must:
--   1) connect each checkout to its branch (JOIN on branch_id),
--   2) aggregate checkouts at the branch level (GROUP BY branch).
--
--
-- ============================================================
-- KPI DEFINITION
-- ============================================================
-- KPI NAME: Total Checkouts by Branch
--
-- KPI QUESTION:
-- "How many checkouts did each branch process?"
--
-- MEASURE:
-- - checkouts = COUNT(checkout_id)
--
-- GRAIN (LEVEL OF DETAIL):
-- - one row per branch
--
-- OUTPUT (WHAT DECISION-MAKERS NEED):
-- - branch identifier and name
-- - total checkouts
-- - optionally: average checkout duration and total fines
--
--
-- ============================================================
-- EXECUTION: GET THE INFORMATION THAT INFORMS THE KPI
-- ============================================================
-- Strategy:
-- - JOIN branch (1) to checkout (M)
-- - GROUP BY branch
-- - COUNT checkouts to compute activity
-- - ORDER results so we can quickly see top branches
--
SELECT
  b.branch_id,
  b.branch_name,
  b.city,
  b.region,
  COUNT(c.checkout_id) AS checkout_count,
  ROUND(AVG(c.duration_days), 2) AS avg_checkout_duration,
  ROUND(SUM(c.fine_amount), 2) AS total_fines
FROM branch AS b
JOIN checkout AS c
  ON c.branch_id = b.branch_id
GROUP BY
  b.branch_id,
  b.branch_name,
  b.city,
  b.region
ORDER BY checkout_count DESC;
