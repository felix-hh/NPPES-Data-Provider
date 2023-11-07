# NPPES Data Provider

A simple DBT job to fetch data from the NPPES Data Dissemination File released by CMS as part of the Freedom of Information Act (FOIA), clean it and output it as a parquet file. 

`example.csv` shows 100 NPIs in this postprocessed format. It is very similar to the original format except for multivalued columns that converted to lists.

## Key Benefits
- Decompresses, parses and converts raw files to a structured parquet format that is easy to load into any database.
- Converts multivalued columns such as "Healthcare Provider Taxonomy Group_idx" into lists of structs.
    - For example, colums that belong together such as License Number 15 and License State 15 is grouped into the same {license: x, state: y} object.
- Single file output of small size (650MB)
- Column names are original, so it is fully compatible with the original CSV documentation.
    - The only exception are Other Provider Identifier List, Healthcare Provider Taxonomy Group List, Healthcare Provider Taxonomy Code List. These correspond to the processed multivalued fields in the original dataset.

## Requirements
Requires using DBT, DuckDB, and an external tool, [csv2parquet](https://github.com/domoritz/arrow-tools/tree/main/crates/csv2parquet#examples). Requires creating a `~/dbt/profiles.yml` file. 

dbt Core Quickstart: https://docs.getdbt.com/quickstarts/manual-install

DuckDB Details:
`dbt-duckdb` setup: https://docs.getdbt.com/docs/core/connect-data-platform/duckdb-setup
More details: https://github.com/duckdb/dbt-duckdb

## Run it
```bash
bash fetch_data.sh
dbt run
```


Here's the result in my `c7i.2xlarge` instance. It takes about 5 minutes to run completely.

```
23:13:45  Running with dbt=1.6.7
23:13:46  Registered adapter: duckdb=1.6.2
23:13:46  [WARNING]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 1 unused configuration paths:
- models.NPPESLoader.example
23:13:46  Found 6 models, 0 sources, 0 exposures, 0 metrics, 352 macros, 0 groups, 0 semantic models
23:13:46  
23:13:46  Concurrency: 1 threads (target='dev')
23:13:46  
23:13:46  1 of 6 START sql view model main.raw_nppes ..................................... [RUN]
23:13:48  1 of 6 OK created sql view model main.raw_nppes ................................ [OK in 2.62s]
23:13:48  2 of 6 START sql view model main.stg_nppes_other_provider_identifier_list ...... [RUN]
23:13:52  2 of 6 OK created sql view model main.stg_nppes_other_provider_identifier_list . [OK in 3.82s]
23:13:52  3 of 6 START sql view model main.stg_nppes_root ................................ [RUN]
23:13:54  3 of 6 OK created sql view model main.stg_nppes_root ........................... [OK in 1.93s]
23:13:54  4 of 6 START sql view model main.stg_nppes_taxonomy_group_list ................. [RUN]
23:13:58  4 of 6 OK created sql view model main.stg_nppes_taxonomy_group_list ............ [OK in 3.82s]
23:13:58  5 of 6 START sql view model main.stg_nppes_taxonomy_list ....................... [RUN]
23:14:02  5 of 6 OK created sql view model main.stg_nppes_taxonomy_list .................. [OK in 3.83s]
23:14:02  6 of 6 START sql external model main.dim_nppes_provider ........................ [RUN]
23:18:51  6 of 6 OK created sql external model main.dim_nppes_provider ................... [OK in 289.38s]
23:18:51  
23:18:51  Finished running 5 view models, 1 external model in 0 hours 5 minutes and 5.48 seconds (305.48s).
23:18:51  
23:18:51  Completed successfully
23:18:51  
23:18:51  Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```