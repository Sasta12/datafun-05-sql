-- sql/duckdb/Sasta12_library_bootstrap.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Creates library tables and loads data from CSV files (DuckDB).
--
-- ASSUMPTION:
-- We always run all commands from the project root directory.
--
-- EXPECTED PROJECT PATHS (relative to repo root):
--   SQL:  sql/duckdb/Sasta12_library_bootstrap.sql
--   CSV:  data/library/branch.csv
--   CSV:  data/library/checkout.csv
--   DB:   artifacts/duckdb/library.duckdb
--
-- ============================================================
-- TOPIC DOMAINS + 1:M RELATIONSHIPS
-- ============================================================
-- OUR DOMAIN: LIBRARY
-- In library, branches have many checkouts.
-- Therefore, we have two tables: branch (1) and checkout (M).
-- - The branch table is the independent/parent table (1).
-- - The checkout table is the dependent/child table (M).
-- - The foreign key in the checkout table references the primary key in the branch table.
--
-- REQ: Tables must be created in order to satisfy foreign key constraints.
-- REQ: Data must be loaded in order to satisfy foreign key constraints.
--
-- ============================================================
-- EXECUTION: ATOMIC BOOTSTRAP (ALL OR NOTHING)
-- ============================================================
BEGIN TRANSACTION;
-- Ensure clean start: drop tables if they exist
DROP TABLE IF EXISTS checkout;
DROP TABLE IF EXISTS branch;
--
-- ============================================================
-- STEP 1: CREATE TABLES (PARENT FIRST, THEN CHILD)
-- ============================================================
CREATE TABLE IF NOT EXISTS branch (
  branch_id TEXT PRIMARY KEY,
  branch_name TEXT NOT NULL,
  city TEXT NOT NULL,
  region TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS checkout (
  checkout_id TEXT PRIMARY KEY,
  branch_id TEXT NOT NULL,
  material_type TEXT NOT NULL,
  duration_days INTEGER NOT NULL,
  fine_amount DOUBLE NOT NULL,
  checkout_date TEXT NOT NULL,
  FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);
--
-- ============================================================
-- STEP 2: LOAD DATA (PARENT FIRST, THEN CHILD)
-- ============================================================
COPY branch
FROM 'data/library/branch.csv'
(HEADER, DELIMITER ',', QUOTE '"', ESCAPE '"');
COPY checkout
FROM 'data/library/checkout.csv'
(HEADER 1, DELIMITER ',', QUOTE '"', ESCAPE '"');
--
-- ============================================================
-- FINISH EXECUTION: ATOMIC BOOTSTRAP (ALL OR NOTHING)
-- ============================================================
COMMIT;
--
-- ============================================================
-- REFERENCE: DUCKDB COPY CSV OPTIONS
-- ============================================================
-- HEADER 1: The first row in the CSV file contains column headers (not data).
-- DELIMITER ',': Columns are separated by commas.
-- QUOTE '"': Text fields are enclosed in double quotes.
-- ESCAPE '"': Double quotes within text fields are escaped by doubling them.
