# SSIS ETL Summary

## Document control

| Field          | Value                                                  |
| -------------- | ------------------------------------------------------ |
| Project name   | Hospital Admissions Analytics Platform Azure Migration |
| Document title | SSIS ETL Summary                                       |
| Version        | v0.1                                                   |
| Document owner | M S M Marasinghe                                       |
| Last updated   | 2026-05-28                                             |
| Status         | Approved                                               |

## Business purpose

This document summarizes how the legacy Hospital Admissions Analytics Platform is loaded and transformed through SSIS and related SQL-based processing. Its purpose is to make the current ETL behavior explicit before Azure redesign begins, because the migration must preserve or consciously replace the operational and business logic embedded in the existing load process.

The ETL layer is not only technical plumbing. In the legacy platform, SSIS packages, staging controls, profiling tasks, stored procedures, and fact enrichment steps together implement part of the business meaning behind the warehouse and its reporting outputs.

## ETL architecture overview

The legacy platform uses SQL Server Integration Services together with T-SQL stored procedures to load the hospital admissions warehouse. Source data arrives from a mixed landscape that includes file-based patient, doctor, and location extracts plus admission data held in an on-premises SQL Server database.

The ETL process can be understood as four linked stages: extraction from source systems, loading into staging tables, transformation of staged data into warehouse dimensions and facts, and downstream refresh into the semantic and reporting layers. This separation matters because each stage will need an equivalent pattern or deliberate redesign in Azure.

The report also shows that the ETL process supports more than straightforward copying. It performs staging-table control, data profiling, dimension updates, SCD Type 2 handling for `DimLocation`, and additional fact enrichment for accumulating transaction metrics related to admissions.

## SSIS orchestration summary

SSIS acts as the orchestration and movement layer for the legacy warehouse loads. The available documentation shows that packages extract data from flat files and from the operational SQL Server source, then load that data into staging tables inside the legacy environment.

The report indicates the use of SSIS control flow and data flow patterns rather than a single monolithic script. This includes source-specific extraction flows, event handling, staging control steps, and object-specific transformation/load processes for dimensions and facts.

From a migration perspective, this means the SSIS layer should be analyzed as an execution framework that coordinates dependencies between extraction, staging refresh, profiling, and warehouse population. In Azure terms, this orchestration behavior will likely map partly to ADF pipeline control flow and partly to downstream SQL/dbt execution order.

## Staging behavior

The report confirms that data from CSV, TXT, spreadsheet-style files, and SQL Server is first loaded into staging tables. OLE DB Source is used for database extraction, Flat File Source is used for file extraction, and OLE DB Destination is used to land the extracted data into staging structures.

Staging is therefore a clear boundary between raw acquisition and warehouse transformation. This is important because it allows the system to standardize inputs before dimension and fact processing begins.

The report also confirms truncate-and-reload behavior in staging. An `Execute SQL Task` is used to truncate staging tables before new data is loaded, which is intended to avoid duplication during batch execution.

## Stored procedure transformation summary

After staging, the warehouse load relies on stored procedures and related SQL logic to populate dimensional and fact tables. The report explicitly names procedures such as `UpdateDimPatient`, `UpdateDimDoctor`, and `UpdateDimLocation` as part of the transformation process.

This means part of the legacy business logic is embedded in procedural SQL rather than solely in SSIS mappings. That distinction matters because Azure migration cannot stop at recreating pipeline movement; it must also recover and reimplement the transformation rules currently encoded in stored procedures.

The documentation confirms dimension-specific load steps and a separate fact load process, but it does not fully expose the detailed SQL logic, change-detection rules, or dependency ordering inside each procedure. Those details still require validation from the real legacy implementation.

## DimLocation SCD Type 2 load behavior

`DimLocation` is loaded using stored procedure-based logic that implements Slowly Changing Dimension Type 2 behavior. The report confirms that this includes effective start date, effective end date, and current-record handling so that historical location context is preserved over time.

This load behavior is especially important because the warehouse supports province-to-city analysis and historical reporting consistency. When location attributes change, the old version must remain available for past admissions while a new current row becomes active for future analytical use.

In migration terms, this is one of the most important ETL behaviors to preserve. The SCD Type 2 logic is not just a technical design choice; it is part of the business guarantee that historical regional reports remain accurate.

## FactAdmission load behavior

The report confirms that `FactAdmission` is populated after staging and dimension processing, using a dedicated transformation/load step. The fact table represents one row per hospital admission and supports analytical measures related to counts, durations, and throughput behavior.

The ETL process does more than basic fact insertion. It also enriches `FactAdmission` with accumulating transaction attributes, including values such as `accm_tnx_create_time`, `accm_tnx_complete_time`, and `txn_complete_time_hours`, based on additional data loading, lookup, conversion, derived-column logic, and update operations.

This is a critical migration point because these metrics may directly influence throughput and elapsed-time KPIs. If Azure reimplementation changes the sequence, interpretation, or calculation logic of these attributes, business users may see different duration-related outputs even if admission counts still reconcile.

## Data profiling and quality checks

The report confirms that data profiling is performed on staging tables before downstream transformation work proceeds. The stated purpose of profiling is to understand structure, quality, completeness, and consistency so the load process can identify issues early and determine the transformations needed before warehouse loading.

This suggests the legacy ETL includes at least a basic quality-control checkpoint between extraction and warehouse population. While the platform does not appear to have a modern programmatic testing framework, the staging profiling step still represents a meaningful control that should be acknowledged in migration planning.

For Azure design, this implies that profiling and validation should not be dropped just because the tooling changes. Instead, those controls should be replaced with explicit, testable quality checks in ingestion pipelines and dbt models.

## Batch characteristics and limitations

The ETL process is batch-oriented and appears to rely on full staging refresh behavior rather than incremental processing. The report explicitly notes truncate-and-reload staging control and describes the current design as stable but limited in its ability to support incremental refresh or larger time horizons.

This batch pattern has practical implications. It can be simple to reason about for a limited data volume, but it creates performance, restart, latency, and scalability constraints as data history and source complexity grow.

These limitations matter directly for Azure design. The migration should preserve business outcomes while reconsidering whether full reload behavior remains appropriate, especially for future growth, improved observability, and more efficient orchestration.

## Open questions and gaps

- The report confirms the existence of SSIS packages, but it does not provide a full package inventory, dependency graph, or run order.
- Exact scheduling, trigger conditions, runtime frequency, and operational SLA details are not yet documented.
- The detailed SQL logic inside `UpdateDimPatient`, `UpdateDimDoctor`, `UpdateDimLocation`, and fact-load procedures is still not confirmed from source code.
- The exact restart and error-handling behavior of the SSIS workflows is not yet known.
- The full staging schema, column mappings, and transformation rules between staged data and warehouse targets still need deeper validation.
- The precise logic used to calculate accumulating transaction metrics in `FactAdmission` needs to be reviewed directly from packages, SQL, or screenshots if parity is required.
- It is not yet confirmed whether all quality checks are profiling-only or whether additional hidden validation logic exists in packages or SQL code.
- The dependency ordering between dimension loads, fact loads, and semantic refresh remains only partially documented.

## Evidence references

- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing SSIS extraction, staging tables, profiling, dimension loads, SCD Type 2 handling, and accumulating transaction metrics.
- Additional evidence should later include sanitized SSIS package screenshots, control-flow diagrams, stored procedure summaries, and any legacy logging or scheduling details that can be captured safely.