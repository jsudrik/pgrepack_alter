SET client_min_messages = warning;

--
-- Test --alter option validation
--

-- Test valid ALTER clauses (should not error)
\! pg_repack --dbname=contrib_regression --help | grep -A1 "alter="

-- Test invalid ALTER clause - should error
\! pg_repack --dbname=contrib_regression --table=dummy_table --alter="DROP COLUMN old_col"

-- Test invalid ALTER clause - should error  
\! pg_repack --dbname=contrib_regression --table=dummy_table --alter="TRUNCATE TABLE"

-- Test invalid ALTER clause - should error
\! pg_repack --dbname=contrib_regression --table=dummy_table --alter="ALTER COLUMN name DROP DEFAULT"

-- Test invalid ALTER clause - should error
\! pg_repack --dbname=contrib_regression --table=dummy_table --alter="ALTER COLUMN name SET NOT NULL"

-- Test empty ALTER clause - should error
\! pg_repack --dbname=contrib_regression --table=dummy_table --alter=""

-- Create test table for ALTER clause tests
CREATE TABLE alter_test_table (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50),
    age INTEGER,
    data TEXT
);

INSERT INTO alter_test_table VALUES (1, 'Alice', 25, 'test data');
INSERT INTO alter_test_table VALUES (2, 'Bob', 30, 'more data');

-- Test ALTER COLUMN SET DATA TYPE
\! pg_repack --dbname=contrib_regression --table=alter_test_table --alter="ALTER COLUMN name SET DATA TYPE varchar(100)" --dry-run

-- Test ALTER COLUMN SET DEFAULT
\! pg_repack --dbname=contrib_regression --table=alter_test_table --alter="ALTER COLUMN age SET DEFAULT 0" --dry-run

-- Test ALTER COLUMN SET STORAGE
\! pg_repack --dbname=contrib_regression --table=alter_test_table --alter="ALTER COLUMN data SET STORAGE EXTENDED" --dry-run

-- Test ADD COLUMN with DEFAULT
\! pg_repack --dbname=contrib_regression --table=alter_test_table --alter="ADD COLUMN new_col INTEGER DEFAULT 42" --dry-run

-- Test ADD COLUMN without DEFAULT
\! pg_repack --dbname=contrib_regression --table=alter_test_table --alter="ADD COLUMN status VARCHAR(20)" --dry-run

-- Test case insensitive ALTER clause
\! pg_repack --dbname=contrib_regression --table=alter_test_table --alter="alter column name set data type varchar(200)" --dry-run

-- Clean up test table
DROP TABLE alter_test_table;

-- Test that --alter cannot be used with --all
\! pg_repack --dbname=contrib_regression --all --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Test that --alter cannot be used with --schema
\! pg_repack --dbname=contrib_regression --schema=public --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Test that --alter cannot be used with --index
\! pg_repack --dbname=contrib_regression --index=dummy_index --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Test that --alter cannot be used with --only-indexes
\! pg_repack --dbname=contrib_regression --table=dummy_table --only-indexes --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Test that --alter cannot be used with --parent-table
\! pg_repack --dbname=contrib_regression --parent-table=dummy_table --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Test that --alter cannot be used with --tablespace
\! pg_repack --dbname=contrib_regression --table=dummy_table --tablespace=pg_default --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Test that --alter cannot be used with --order-by
\! pg_repack --dbname=contrib_regression --table=dummy_table --order-by="id" --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Test that --alter cannot be used with --jobs
\! pg_repack --dbname=contrib_regression --table=dummy_table --jobs=2 --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Test that --alter works with allowed options (dry-run)
\! pg_repack --dbname=contrib_regression --table=dummy_table --dry-run --wait-timeout=120 --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"