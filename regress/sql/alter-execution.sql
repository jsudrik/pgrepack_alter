SET client_min_messages = warning;

--
-- Test ALTER clause execution during repack
--

-- Create test table with data
CREATE TABLE alter_exec_test (
    id INTEGER PRIMARY KEY,
    name VARCHAR(20),
    age INTEGER DEFAULT 25,
    data TEXT
);

INSERT INTO alter_exec_test VALUES (1, 'Alice', 30, 'test data 1');
INSERT INTO alter_exec_test VALUES (2, 'Bob', 35, 'test data 2');
INSERT INTO alter_exec_test VALUES (3, 'Charlie', 40, 'test data 3');

-- Check original table structure
\d alter_exec_test

-- Test ALTER COLUMN SET DATA TYPE - expand varchar size
\! pg_repack --dbname=contrib_regression --table=alter_exec_test --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

-- Verify data is preserved and type changed
SELECT id, name, age, data FROM alter_exec_test ORDER BY id;
\d alter_exec_test

-- Test ADD COLUMN with DEFAULT
\! pg_repack --dbname=contrib_regression --table=alter_exec_test --alter="ADD COLUMN status VARCHAR(10) DEFAULT 'active'"

-- Verify new column added with default values
SELECT id, name, age, status FROM alter_exec_test ORDER BY id;
\d alter_exec_test

-- Test ALTER COLUMN SET DEFAULT
\! pg_repack --dbname=contrib_regression --table=alter_exec_test --alter="ALTER COLUMN age SET DEFAULT 18"

-- Verify default changed (insert new row to test)
INSERT INTO alter_exec_test (id, name) VALUES (4, 'David');
SELECT id, name, age, status FROM alter_exec_test WHERE id = 4;

-- Clean up
DROP TABLE alter_exec_test;