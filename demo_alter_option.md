# pgrepack_alter --alter Option Demo

This document demonstrates the new `--alter` option added to pgrepack_alter.

## Overview

The `--alter` option allows you to specify ALTER TABLE clauses that will be validated and executed during pgrepack_alter. The ALTER clause is executed on the temporary table after CREATE TABLE but before the data copy phase. Only specific ALTER TABLE operations are allowed for safety.

## Allowed ALTER TABLE Operations

The following operations are supported (case-insensitive):

1. **ALTER COLUMN [colname] SET DATA TYPE [datatype]**
2. **ALTER COLUMN [colname] SET DEFAULT [expression]**  
3. **ALTER COLUMN [colname] SET STORAGE [storage_type]**
4. **ADD COLUMN [colname] [datatype] [DEFAULT value]**

## Usage Examples

### Valid Usage Examples

```bash
# Change column data type (uppercase)
pg_repack --dbname=mydb --table=mytable --alter="ALTER COLUMN name SET DATA TYPE varchar(100)"

# Change column data type (lowercase - case insensitive)
pg_repack --dbname=mydb --table=mytable --alter="alter column name set data type varchar(100)"

# Set column default value
pg_repack --dbname=mydb --table=mytable --alter="ALTER COLUMN age SET DEFAULT 0"

# Change column storage type
pg_repack --dbname=mydb --table=mytable --alter="ALTER COLUMN data SET STORAGE EXTENDED"

# Add new column with default
pg_repack --dbname=mydb --table=mytable --alter="ADD COLUMN new_col INTEGER DEFAULT 42"

# Add new column without default
pg_repack --dbname=mydb --table=mytable --alter="ADD COLUMN new_col INTEGER"
```

### Invalid Usage Examples (Will Error)

```bash
# DROP COLUMN is not allowed
pg_repack --dbname=mydb --table=mytable --alter="DROP COLUMN old_col"
# ERROR: Invalid ALTER clause...

# TRUNCATE is not allowed
pg_repack --dbname=mydb --table=mytable --alter="TRUNCATE TABLE"
# ERROR: Invalid ALTER clause...

# DROP DEFAULT is not allowed
pg_repack --dbname=mydb --table=mytable --alter="ALTER COLUMN name DROP DEFAULT"
# ERROR: Invalid ALTER clause...

# SET NOT NULL is not allowed
pg_repack --dbname=mydb --table=mytable --alter="ALTER COLUMN name SET NOT NULL"
# ERROR: Invalid ALTER clause...
```

### Compatible Options

The `--alter` option can ONLY be used with:
- `--table` (required)
- `--dry-run` (optional)
- `--wait-timeout` (optional)
- Connection options (host, port, username, etc.)
- Generic options (help, version, etc.)

### Incompatible Option Combinations

The `--alter` option cannot be used with most other options:

```bash
# Cannot use with --all, --schema, --index, --only-indexes
# Cannot use with --parent-table, --tablespace, --order-by
# Cannot use with --jobs, --exclude-extension, --no-analyze
# Cannot use with --no-kill-backend, --no-superuser-check
# Cannot use with --apply-count, --switch-threshold
```

## Requirements

- The `--alter` option requires `--table` to be specified (not `--parent-table`)
- The ALTER clause is validated before execution
- Validation is case-insensitive
- Only the specific ALTER TABLE operations listed above are allowed
- The ALTER is executed on the original table after the repack process completes
- Extension `pgrepack_alter` must be installed in the database

## Execution Flow

1. Validation: ALTER clause is validated at startup
2. Table creation: Temporary table is created
3. **ALTER execution: ALTER clause is applied to temporary table**
4. Data copy: Data is copied from original to temporary table
5. Index rebuild: Indexes are rebuilt
6. Table swap: Tables are swapped

## Help Text

```bash
pg_repack --help
```

Will show:
```
      --alter=CLAUSE                 ALTER TABLE clause to apply (only with --table, --dry-run, --wait-timeout)
```

## Testing

The feature includes comprehensive regression tests in `regress/sql/alter-option.sql` that validate:

- Valid ALTER clause formats (case-insensitive)
- Invalid ALTER clause rejection
- Incompatible option combination detection
- Help text display
