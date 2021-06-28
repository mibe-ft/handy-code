# Populate bilayer.rfv_weekly into BQ

## Summary
- **Source table**: bilayer.rfv_weekly
- **Target table**: ft-bi-team.BI_Layer_Integration.rfv_weekly
- **Schedule**: 03:00 AM Every Monday
- **Load type**: Incremental

## Overview

The purpose of this DAG is to export data from Redshift `bilayer.rfv_weekly` view to BigQuery `ft-bi-team.BI_Layer_Integration.rfv_weekly` table.
It has 3 parameters in the bilayer.job_date_config table and depending on their values the DAG can have 
different behaviour. A brief description of them follows:
* **first_date_to_process** - first date for which data will be loaded
* **last_date_to_process** - last date for which data will be loaded
* **load_status** - two values are expected: `complete` and `in_progress` 

The first 2 parameters are dates that define the period of time for which visits data will be transferred to BigQuery
and the two options for **load_status** differ in the following manner:
* **`complete`**   
This shows that the previous run of the DAG was successful and that this instance can run.
* **`in_progress`**  
This means that the previous run has not completed successfully. This instance will then
raise an error and not run.

*These parameters are reset to their default values in the last task of the DAG.*

An example query to set DAG parameters prior to execution (export all rows for 1-8 March 2021 and merge them into BQ)
    
    UPDATE bilayer.job_date_config
    SET
    first_date_to_process = '2021-03-01',
    last_date_to_process = '2021-03-08',
    record_modified_date = GETDATE(),
    load_status = 'complete'
    WHERE job_name = 'rs_to_bq_bilayer_rfv_weekly'

## Tasks Overview

1. The task checks that the previous run of this DAG completed successfully andb that the `biteam.rfv_weekly` table has been updated.

2. The task updates the config table in Redshift to mark the dag as in_progress
   
3. The task uses the parameters to create table `bilayer.rfv_weekly_stg` which will be exported.

4. The task unloads the data to S3.

5. The task loads the data into the staging table in bq

6. The task inserts the records in the target table preventing duplicates

7. The task updates the config table in Redshift to mark the dag as complete and set the next date range


## Business Description

The purpose of the rfv_weekly table in BI Layer is to unite in one place all information related to the user engagement (recency, frequency, volume) in a simple and user-friendly way. Information in the table is stored by user, by week, with the RFV values referring to the calculations made for Sundays. 

### FAQ

*To be updated later*
