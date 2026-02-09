-- sql/duckdb/case_retail_query_sales_aggregate.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Summarize overall checkout activity across ALL branches.
--
-- This query answers:
-- - "What is our total fines?"
-- - "What is the average checkout duration?"
--
-- WHY:
-- - Establishes system-wide activity
-- - Provides a baseline before breaking results down by branch
-- - Helps answer:
--   "Is overall activity up or down?"

SELECT
  COUNT(*) AS checkout_count,
  ROUND(SUM(fine_amount), 2) AS total_fines,
  ROUND(AVG(duration_days), 2) AS avg_checkout_duration
FROM checkout;
