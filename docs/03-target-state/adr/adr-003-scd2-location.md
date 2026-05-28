# ADR 003: DimLocation SCD Type 2

## Title
Implement DimLocation as a Slowly Changing Dimension Type 2 in Azure.

## Status
Proposed.

## Context
The legacy warehouse treats `DimLocation` as a Slowly Changing Dimension Type 2 so that historical reports remain consistent with the location valid at the time of admission. The report explicitly describes effective start and end dates, a current-record flag, and historical attributes for province and city. That makes `DimLocation` one of the highest-risk objects in the migration because a small mistake can silently change regional reporting.

In the Azure target, the location dimension must preserve both historical correctness and current-state usability. The implementation must also be testable against the legacy output so that city and province reporting does not drift without detection.

## Decision
We will implement `DimLocation` using **dbt snapshots** as the primary SCD Type 2 mechanism. The snapshot will track changes to the location source attributes and generate the historical records with effective start and end timestamps, while dbt models will expose the business-friendly dimension structure used by Synapse and Power BI.

The target model will preserve `effective_start_date`, `effective_end_date`, and `current_record` behavior explicitly. The snapshot output will feed a curated `DimLocation` model that keeps the same historical semantics as the legacy warehouse, including the ability to join admissions to the location version that was valid when the admission occurred.

Legacy validation will be performed by reconciling the Azure SCD output against the current warehouse behavior for a known historical window. The key checks are row-count parity, version-count parity, effective dating consistency, and spot checks for admissions joined to the expected province/city values.

## Alternatives considered
### 1. Incremental SCD logic in dbt only
This could work, but it would require more custom change-detection logic and more careful handling of effective dating. It is workable, but more error-prone than using a snapshot for a dimension where history matters.

### 2. Recreate the legacy stored procedure approach in Synapse
This would be closest to the current implementation, but it would keep the logic hidden in procedural SQL and make it harder to test and maintain. It would also work against the target-state goal of moving to version-controlled transformation logic.

### 3. Use dbt snapshots plus a curated dimension model
This is the selected approach because snapshots are designed for change tracking and make historical preservation explicit. It is also easier to validate and easier to explain to reviewers than a hand-built SCD mechanism.

## Consequences
This decision gives the hospital a clear and auditable history of location changes. If province or city values change later, the old record remains available for historical reporting, and the new record becomes the current one.

Using dbt snapshots also makes the logic easier to review in source control. That reduces the risk of hidden behavior changes compared with the old SSIS/stored-procedure pattern.

The tradeoff is that snapshot-based SCD handling introduces an additional dbt construct that the team must understand and operate correctly. It also requires disciplined validation so that the snapshot and curated dimension stay aligned with source changes.

## Risks
The main risk is silent drift in regional reporting if source attributes are not tracked correctly or if the snapshot configuration misses a relevant change column. That could produce incorrect historical joins even if the pipeline still appears to succeed.

Another risk is imperfect parity with the legacy SCD implementation if the old logic used undocumented edge cases. For example, the old procedure may have handled reactivation or late-arriving changes in a specific way that must be reproduced carefully.

A final risk is join mistakes in the fact layer. If admissions do not join to the correct location version using the admission date and effective dates, historical reporting will be wrong even when the dimension itself looks correct.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing `DimLocation` as SCD Type 2 with start date, end date, and current flag.
- Legacy ETL notes showing `UpdateDimLocation` stored procedure behavior and the need to preserve historical reporting consistency.