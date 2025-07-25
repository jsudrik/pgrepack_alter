# pgrepack_fork

My experiments with pg_repack extension to add few more bits (not for production use).

This is a PostgreSQL extension and CLI which lets you make schema changes to tables and also use pg_repack functionality.

Obviously, this is forked from the excellent pg_repack project (https://reorg.github.io/pg_repack).

It adds --alter option to pg_repack which allows users to also use it for performing few alter table variations which take table lock for long duration. --alter option works only with few other essential options of pg_repack, otherwise it throws an error.

There are other good alternatives available for this such as

  - https://github.com/phillbaker/pg_migrate
  - https://github.com/shayonj/pg-osc

However, I think with much of the internal working the same, there should be just one extension available for repack as well as just few DDLs which can hold the table lock for long time for really big data sizes.

The supported ALTER TABLE DDL operations with this are

  - ALTER COLUMN [column_name] SET DATA TYPE [data_type]
  - ALTER COLUMN [column_name] SET DEFAULT [value | expression]
  - ADD COLUMN [column_name data_type] DEFAULT [value | expression]
  - ALTER COLUMN [column_name] SET STORAGE [storage_options]

This is just experimental and not ready for production use, which needs exhaustive testing. You are welcome to use it for educational purpose for experiments.
