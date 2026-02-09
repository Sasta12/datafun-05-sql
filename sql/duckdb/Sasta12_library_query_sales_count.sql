-- sql/duckdb/case_retail_query_sales_count.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Answer a basic activity question:
-- "How many checkouts have occurred?"
--
-- This query operates on the dependent/child table.
--
-- WHY:
-- - Volume and fines are different signals
-- - A branch may have many short checkouts or few long ones
-- - Analysts often start by understanding event counts
--   before analyzing impact

SELECT
  COUNT(*) AS checkout_count
FROM checkout;
