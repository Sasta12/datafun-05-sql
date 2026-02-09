-- sql/duckdb/Sasta12_library_query_branch_count.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Answer a simple structural question:
-- "How many branches do we have in our library system?"
--
-- This query does NOT involve the checkout table.
-- It operates only on the independent/parent table.
--
-- WHY:
-- - Establishes the size of the system
-- - Provides context for other KPIs
-- - Helps answer questions like:
--   "Are we growing by adding branches, or just increasing checkouts?"

SELECT
  COUNT(*) AS branch_count
FROM branch;
