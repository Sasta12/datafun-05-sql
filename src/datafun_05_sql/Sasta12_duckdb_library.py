"""
Sasta12_duckdb_library.py - Starter module for DuckDB library analytics.
"""

from pathlib import Path

import duckdb

SQL_DIR = Path(__file__).parent.parent.parent / 'sql' / 'duckdb'
DB_PATH = (
    Path(__file__).parent.parent.parent / 'artifacts' / 'duckdb' / 'library.duckdb'
)


def run_sql_script(script_name):
    script_path = SQL_DIR / script_name
    with script_path.open() as f:
        sql = f.read()
    print(f"Running {script_name}...")
    duckdb.connect(str(DB_PATH)).execute(sql)


def main():
    scripts = [
        'Sasta12_library_clean.sql',
        'Sasta12_library_bootstrap.sql',
        'Sasta12_library_query_kpi_revenue.sql',
        'Sasta12_library_query_sales_aggregate.sql',
        'Sasta12_library_query_sales_count.sql',
        'Sasta12_library_query_store_count.sql',
    ]
    for script in scripts:
        run_sql_script(script)
    print("Library pipeline complete. Database created at:", DB_PATH)


if __name__ == "__main__":
    main()
