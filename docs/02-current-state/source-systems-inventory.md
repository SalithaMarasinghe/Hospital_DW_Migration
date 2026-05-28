# Source Systems Inventory

## Document control

| Field | Value |
|---|---|
| Project name | Hospital Admissions Analytics Platform Azure Migration |
| Document title | Source Systems Inventory |
| Version | v0.2 |
| Document owner | M S M Marasinghe |
| Last updated | 2026-05-28 |
| Status | Approved |

## Business purpose
This document records the current-state source landscape and related dependency layers for the Hospital Admissions Analytics Platform. Its purpose is to preserve business meaning during migration by making the legacy operational inputs, transformation dependencies, semantic interpretation, and reporting consumption paths explicit before target-state Azure design begins.

Although this artifact is titled a source systems inventory, the current-state assessment also needs visibility into processing, semantic, and consumption dependencies. For that reason, each entry is explicitly classified by layer so the document remains analytically precise and does not blur operational sources with downstream platform components.

## Source-by-source inventory

| Source ID | Layer classification | Source name | Source type | Format | Key entities | Representative business fields | Source owner / operational owner | Refresh pattern | Downstream use | Notes / risks |
|---|---|---|---|---|---|---|---|---|---|---|
| SS-01 | Operational source system | Patient master data export | File-based operational feed | CSV | Patient master data | Patient identifier, patient name, gender, birth date, height, weight, allergies, home location reference | Not yet confirmed | Known pattern: batch file export. Unknown detail: exact delivery schedule, trigger, and SLA are not yet confirmed. | Loaded into staging, then used to populate `DimPatient` for demographic and patient-level analytics. | Representative business fields are inferred from the report and still need physical schema confirmation. |
| SS-02 | Operational source system | Doctor master data export | File-based operational feed | TXT | Doctor master data | Doctor identifier, doctor name, gender, specialty | Not yet confirmed | Known pattern: batch file export. Unknown detail: exact delivery schedule, trigger, and SLA are not yet confirmed. | Loaded into staging, then used to populate `DimDoctor` for doctor performance and specialty analysis. | Text parsing rules, delimiters, and physical schema conventions should be validated before migration design. |
| SS-03 | Operational source system | Location reference data export | File-based operational feed | CSV / spreadsheet | Location reference data | Location identifier, province identifier, province name, city | Not yet confirmed | Known pattern: batch file export. Unknown detail: exact delivery schedule, trigger, and SLA are not yet confirmed. | Loaded into staging, then used to populate `DimLocation` for regional analysis and historical location context. | This source is critical because downstream `DimLocation` uses SCD Type 2 behavior that must be preserved. Representative fields remain logical until physical schema is confirmed. |
| SS-04 | Operational source system | Admission events database | Operational transactional source | SQL Server database | Admission events | Admission identifier, patient reference, attending doctor reference, admission date, discharge date | Not yet confirmed | Known pattern: query-based or extract-based database load. Unknown detail: exact extraction schedule, trigger, and SLA are not yet confirmed. | Loaded into staging, then used to populate `FactAdmission` for admissions volume, discharge trends, and throughput analysis. | This is the primary fact source and must preserve the legacy grain of one row per hospital admission. |
| SS-05 | Processing / ETL layer | SSIS staging and processing layer | ETL and orchestration component | SSIS packages, staging tables, SQL tasks, stored procedures | Staging datasets, profiling tasks, dimension loads, fact loads | Staging load steps, truncate-and-reload behavior, profiling outputs, stored procedure-driven transformations | Not yet confirmed | Known pattern: batch ETL processing after source acquisition. Unknown detail: exact operational schedule, dependency order, and restart behavior are not yet confirmed. | Moves source data into staging and warehouse structures, including dimension and fact population. | Business logic is partly embedded here, so incomplete recovery of package and stored procedure behavior could cause KPI drift. |
| SS-06 | Semantic layer | SSAS semantic/reporting layer | Analytical semantic model | Multidimensional cube / semantic model | Measures, hierarchies, drill paths, business-facing analytical structures | Admissions by doctor, diagnosis, date, and location; time trends; drill-through views | Not yet confirmed | Known pattern: semantic refresh follows warehouse processing. Unknown detail: exact processing schedule, dependency timing, and refresh SLA are not yet confirmed. | Supports semantic consumption by Excel and Power BI users without direct warehouse querying. | This layer is not a raw source, but it is part of current-state business meaning and must be analyzed for parity. |
| SS-07 | Consumption layer | Power BI and Excel consumption layer | Reporting and analytical consumption layer | Power BI reports, Excel pivot tables, charts | Dashboards, pivots, user-facing analytical outputs | Admission volumes, time trends, doctor performance, city-level analysis, ad hoc pivots | Not yet confirmed | Known pattern: consumption occurs after warehouse and semantic refresh. Unknown detail: exact report refresh schedule, caching behavior, and user access patterns are not yet confirmed. | Final user-facing reporting layer used by executives, operations, finance, and department stakeholders. | Active report inventory and actual usage patterns still need confirmation for validation planning. |

## Current-state data flow summary
The current platform begins with a mixed source landscape that includes file-based patient, doctor, and location extracts plus admission events held in an on-premises SQL Server database. These operational sources are ingested through SSIS into staging tables, where the platform performs profiling, truncate-and-reload control, and warehouse load orchestration.

After staging, the legacy warehouse populates dimensions such as `DimPatient`, `DimDoctor`, `DimDate`, and `DimLocation`, plus the central `FactAdmission` table. `DimLocation` is implemented with Slowly Changing Dimension Type 2 behavior using effective dating and current-record logic, so historical geographical context must be preserved carefully during migration.

Once warehouse processing completes, SSAS provides the semantic abstraction layer used by business users through Excel and Power BI. This means the migration must preserve not only operational source-to-table transformations, but also the semantic and reporting behavior currently relied on by downstream users.

## Open questions and gaps
- Exact refresh cadence for patient, doctor, location, and admission sources is not yet confirmed.
- File naming standards, delivery paths, and operational ownership for the file-based exports are not yet documented.
- The detailed SSIS package inventory and stored procedure dependencies still need deeper extraction.
- SSAS measure logic, hierarchies, calculated members, and drill behavior require additional analysis.
- The full list of active Power BI and Excel reports still needs to be confirmed so the parity subset can be chosen deliberately.
- The precise business-key and change-detection logic used for `DimLocation` SCD Type 2 handling should be verified directly from legacy implementation artifacts.
- It is not yet confirmed whether all user-facing reports query the semantic layer in the same way or whether some use extracts or alternate paths.
- Source and operational ownership across feeds and analytical layers is not yet confirmed and may become a migration planning blocker.

## Evidence references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing source formats, warehouse schema, ETL flow, and reporting layer.
- Any later screenshots or extracts of SSIS packages, warehouse tables, SSAS metadata, Power BI reports, and Excel pivots should be added as supporting evidence in subsequent current-state documents.