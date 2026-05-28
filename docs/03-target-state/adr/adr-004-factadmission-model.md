# ADR 004: FactAdmission Model

## Title
Implement FactAdmission and accumulating metrics in Azure.

## Status
Proposed.

## Context
The legacy report defines `FactAdmission` as the central event fact with one row per hospital admission. It also states that the table stores counts, durations, and accumulating transaction attributes such as elapsed time between admission creation and completion. This is a high-risk object in the migration because it directly drives the hospital’s KPI trust.

The Azure target must preserve the existing fact grain and the business meaning of the measures. It also must support the reporting model used by Power BI and Excel, including role-playing date behavior for admission and discharge analysis.

## Decision
`FactAdmission` will remain strictly **one row per hospital admission** in the Azure target. The fact will be implemented in Synapse and populated by dbt models that derive measures from curated staging data, while preserving the same admission-level grain used by the legacy warehouse.

Admission date, discharge date, and elapsed-time metrics will be derived as follows: admission and discharge dates are carried from the source admission event, while elapsed-time fields are calculated from the relevant business timestamps using dbt logic and stored in the fact model as trusted measures. If the legacy design uses accumulating transaction timestamps such as create time and complete time, those will be retained in the fact with the same business intent and validated against the old output.

Role-playing date behavior will be handled through a single `DimDate` dimension used by multiple relationships or report views, depending on the final Synapse/Power BI implementation pattern. The important rule is that the admission grain remains stable and that date-based slicing can answer questions by admission date, discharge date, and other approved time perspectives without duplicating fact rows.

To avoid grain drift and measure drift, the fact model will enforce one admission per row, key uniqueness, and strict reconciliation of count and duration measures against the legacy warehouse. Any derived metric that cannot be explained from a source timestamp will be treated as an implementation risk, not silently invented.

## Alternatives considered
### 1. Keep the fact exactly as a direct table copy
This would be simple, but it would not be sufficient on its own because the target still needs curated transformations, validation, and reusable model logic.

### 2. Split admissions into multiple facts by event type
This would reduce the clarity of the current model and would break the legacy grain assumption of one row per admission. It would also complicate KPI parity and report validation.

### 3. Keep one admission fact and derive measures in dbt
This is the selected approach because it preserves the current business grain while making calculations explicit, testable, and version-controlled.

### 4. Move accumulating metrics into a separate process table
That could work for operational processing, but it would hide the metric in a second artifact and increase the chance of mismatch between the process state and the reporting fact.

## Consequences
This decision keeps the hospital’s core reporting object stable and understandable. Business users will still think in terms of admissions, not in terms of fragmented events or technical loading steps.

Using dbt to derive the fact measures makes the model easier to test and easier to review than the old SSIS and stored-procedure pattern. It also gives the team a clearer path to validate parity against the legacy warehouse before cutover.

The tradeoff is that the model depends on high-quality source timestamp logic. If source timestamps are incomplete or ambiguous, the implementation will need a documented rule rather than an automatic assumption.

## Risks
The biggest risk is grain drift: a design change that accidentally adds more than one row per admission or creates duplicate fact records. That would immediately damage counts and lengths-of-stay metrics.

Another risk is measure drift, where elapsed-time calculations differ from the legacy logic because of subtle differences in timestamp interpretation or update sequencing. This is especially relevant for the accumulating transaction fields.

A third risk is incorrect role-playing date behavior. If admission-date and discharge-date reporting are not modeled cleanly, time-based dashboards may still run but produce confusing or inconsistent results.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing `FactAdmission` grain, keys, counts, durations, and accumulating transaction attributes.
- Legacy ETL notes showing accumulated transaction handling with create time, complete time, and elapsed hours.