# Legacy DW Model

## Document control

| Field          | Value                                                  |
| -------------- | ------------------------------------------------------ |
| Project name   | Hospital Admissions Analytics Platform Azure Migration |
| Document title | Legacy DW Model                                        |
| Version        | v0.1                                                   |
| Document owner | M S M Marasinghe                                       |
| Last updated   | 2026-05-28                                             |
| Status         | Approved                                               |

## Business purpose

This document records the current-state data warehouse model used by the legacy Hospital Admissions Analytics Platform. Its purpose is to show the business structure being migrated so that future Azure design, dbt modeling, reconciliation, and reporting parity work remain aligned to the warehouse behavior that users currently trust.

The document is intentionally business-first. The legacy warehouse is not treated as a simple collection of tables, but as the current business truth layer that standardizes operational data for downstream SSAS, Excel, and Power BI reporting.

## Warehouse overview

The legacy warehouse is a SQL Server-based snowflake-style analytical model centered on hospital admissions. It is designed to support analysis of admission volumes, discharge trends, doctor performance, regional demand, and throughput-style metrics derived from admission activity.

At the center of the model is `FactAdmission`, which links to `DimPatient`, `DimDoctor`, `DimLocation`, and `DimDate`. This structure gives the organization a consistent reporting layer above heterogeneous operational sources and acts as the trusted analytical foundation feeding SSAS and user-facing reporting.

The model also carries historical business meaning, not just current-state values. The most important example is `DimLocation`, which preserves province and city history through SCD Type 2 handling so that reports remain consistent with the location context valid at the time of admission.

## Fact and dimension inventory table

| Object name     | Object type     | Business role                                                                                               | Confirmed attributes / behavior                                                                                                                                   | Migration relevance                                                                                                 |
| --------------- | --------------- | ----------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `FactAdmission` | Fact table      | Central admissions event fact used for volumes, discharges, elapsed-time analysis, and throughput reporting | One row per hospital admission; references patient, doctor, location, and date dimensions; includes counts, durations, and accumulating transaction-style metrics | Highest priority parity object because changes to grain or measures would alter KPIs and report outputs             |
| `DimPatient`    | Dimension table | Provides patient descriptive context for admission analysis                                                 | Includes demographic and physical attributes such as name, gender, birth date, height, weight, allergy information, and location reference                        | Needed for patient segmentation, demographic reporting, and linking admissions to home geography                    |
| `DimDoctor`     | Dimension table | Provides doctor descriptive context for admissions and performance reporting                                | Includes doctor name, gender, and specialty attributes                                                                                                            | Needed for doctor performance views, specialty analysis, and admissions by attending doctor                         |
| `DimLocation`   | Dimension table | Provides geographical reporting context and province-to-city hierarchy                                      | Includes province and city hierarchy; implemented with SCD Type 2 using effective dates and current-record handling                                               | One of the highest-risk migration objects because incorrect history handling would break regional trend consistency |
| `DimDate`       | Dimension table | Provides calendar attributes for time-series and period-based reporting                                     | Includes day, month, year, and day-name style calendar analysis attributes                                                                                        | Required for trends, period comparison, time slicing, and SSAS / report time navigation                             |

## FactAdmission specification

`FactAdmission` is the central fact table in the warehouse and represents the core business event being analyzed: hospital admission. The legacy documentation confirms that its grain is one row per hospital admission, and this is one of the most important rules that must be preserved during migration.

The fact is described as referencing patient, doctor, location, and date dimensions. It supports measures and analytical outputs such as counts, durations, and accumulating transaction attributes, including elapsed time between admission creation and completion or similar completion-oriented processing metrics.

This object is high risk in the migration because even a small change in grain or metric meaning can break trusted KPIs. If the Azure rebuild reinterprets elapsed-time logic, separates one admission into multiple events, or changes how dates connect to the fact, volumes and throughput outputs may no longer match the legacy reporting baseline.

## DimPatient specification

`DimPatient` provides patient-level descriptive context for admissions analysis. The report confirms patient-oriented attributes such as name, gender, birth date, height, weight, allergy information, and a reference to home location.

From a reporting perspective, this dimension supports demographic segmentation, patient characteristic analysis, and any report logic that needs to join admissions to patient context. The business importance of the dimension is not only descriptive; it also supports downstream regional reporting by linking patients to location context.

Migration work should preserve business attributes and analytical meaning without inventing unconfirmed surrogate-key mechanics or physical modeling details. Additional validation is still required to confirm the exact implemented structure in the legacy warehouse.

## DimDoctor specification

`DimDoctor` provides descriptive doctor context for admissions analysis. Confirmed business attributes include doctor name, gender, and specialty, which are important for performance-oriented reporting and admissions analysis by attending clinician.

This dimension directly affects reports that analyze doctor workload, specialty distribution, and doctor-level admissions trends. Because executive and operational stakeholders use the legacy platform for doctor-related analysis, this dimension must preserve its reporting meaning even if the implementation changes in Azure.

Further legacy inspection is still needed to confirm the exact physical schema, keys, and any additional derived attributes used in the existing warehouse or semantic layer.

## DimLocation specification

`DimLocation` provides geographical context for patient and admission analysis. The confirmed business structure is a province-to-city hierarchy, which supports regional demand analysis and city-level reporting.

This is not a static lookup dimension. The report confirms that `DimLocation` is implemented with Slowly Changing Dimension Type 2 behavior so that location changes over time do not overwrite historical reporting context.

From a migration perspective, `DimLocation` is one of the highest-risk objects in the warehouse. If effective dating, current-record logic, or change capture behavior is rebuilt incorrectly, historical region-based reports can silently drift even when row counts still appear correct.

## DimDate specification

`DimDate` provides the calendar structure used by the warehouse for time-series analysis. Confirmed calendar attributes include day, month, year, and day name, which support reporting by period and standard time slicing in downstream tools.

Although `DimDate` may appear low risk compared with `FactAdmission` or `DimLocation`, it still matters because time intelligence is central to admissions trends, discharge trends, and month-over-month or year-over-year analysis. Poor alignment between the legacy date logic and the target model would affect SSAS and reporting continuity.

More detailed legacy confirmation may still be needed for the exact calendar coverage, date-key pattern, and any extra attributes beyond those explicitly mentioned in the report.

## DimLocation SCD Type 2 behavior analysis

The legacy report confirms that `DimLocation` is implemented as an SCD Type 2 dimension with effective start dates, effective end dates, and a current-record flag. This means the warehouse preserves the location context that was valid when an admission occurred rather than replacing history with the latest province or city state.

This behavior exists to preserve historical reporting truth. If a province or city assignment changes over time, past admissions must still appear under the historical version that was valid at the time of the business event. That makes SCD Type 2 handling in `DimLocation` a business guarantee, not just an implementation detail.

The migration implication is significant. Azure reimplementation must preserve change detection, historical versioning, and current-row semantics in a way that produces the same regional reporting outcomes as the legacy model. This object should be treated as a priority validation target in dbt modeling and parity testing.

## Semantic/reporting implications

The legacy warehouse is not consumed in isolation. It feeds a SSAS multidimensional semantic layer that allows business tools to query trusted analytical structures without interacting directly with warehouse tables.

The report confirms that analysts and managers use Excel pivot tables and Power BI reports on top of the semantic layer. These outputs include admissions by doctor, diagnosis, day, and location, trends over month and year periods, and drill-through views for doctor performance and city-level statistics.

Because of that dependency chain, warehouse objects must be understood in terms of business consumption, not only data structure. A migration can technically rebuild the tables and still fail if the resulting semantics, hierarchies, measures, or drill behavior no longer support the current reporting experience.

## Open questions and gaps

- The report confirms business structure and major attributes, but it does not fully prove physical warehouse column names, key implementation details, or surrogate-key patterns.
- The exact implemented relationship pattern between `FactAdmission` and the date dimension still needs confirmation, especially if multiple date roles exist in practice.
- The detailed logic for accumulating transaction metrics, including column naming and calculation sequence, requires direct review of legacy ETL and warehouse implementation.
- The precise `DimLocation` change-detection rule should be validated from stored procedures or package logic, not only from descriptive documentation.
- It is not yet confirmed whether the semantic layer introduces additional calculated measures or hierarchy behavior beyond what the warehouse model alone suggests.
- The current report inventory and KPI definitions still need to be mapped back to individual warehouse objects for parity planning.

## Evidence references

- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing source formats, warehouse schema, ETL behavior, SCD Type 2 handling, and reporting layer usage.
- Future evidence should include sanitized warehouse screenshots, legacy stored procedure summaries, SSAS metadata extracts, and representative report mappings where available.