pg_repack_fork -- My experiments to add alter functionality to pg_repack
=========================================================================

This is a PostgreSQL extension and CLI which lets you make schema changes to tables,  while preserving pg_repack functionality.

Obviously, this is forked from the excellent pg_repack project (https://reorg.github.io/pg_repack).

This is just experimental and not ready for production use, which needs much more testing. You are welcome to use it for educational purpose for experiments. 

The approach is minimalist just to get blocking DDLs which can lock the table for long time based on data size working without having to acquire lock on the table for long duration. 

There are good alternatives available for this such as 

	https://github.com/phillbaker/pg_migrate
	https://github.com/shayonj/pg-osc

However, I think with much of the internal working the same, there should be just one extension available for repack as well as just few DDLs which can hold the table lock for long time for really big data sizes.
