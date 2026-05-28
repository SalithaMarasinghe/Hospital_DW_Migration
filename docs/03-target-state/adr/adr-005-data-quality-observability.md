# ADR 005: Data Quality and Observability

## Title
Define the target-state data quality and observability approach.

## Status
Proposed.

## Context
The legacy platform has basic logging, but the report explicitly says there is no systematic data quality layer and that silent data issues are hard to detect. That is a serious weakness because the hospital uses this platform for trusted admissions, length-of-stay, doctor performance, and regional demand reporting.

In the Azure target, quality and observability must be built into the pipeline rather than added later. The goal is to prevent bad data from reaching the semantic layer, and to make failures visible enough that the team can act before reports are refreshed.

## Decision
We will use **dbt tests plus pipeline validation checks** as the primary quality mechanism. dbt will enforce structural and business-rule checks on dimensions and facts, while ADF or pipeline-level validations will confirm that source files arrived, extracts completed, row counts are reasonable, and downstream stages loaded successfully.

Mandatory checks for admissions analytics will include uniqueness, non-nullness, referential integrity, accepted values, valid dates, non-negative durations, and SCD consistency for location history. For `FactAdmission`, checks must confirm one row per admission, no duplicate admission keys, and no impossible elapsed-time values.

Failures will be surfaced immediately through failed pipeline runs, failed dbt test results, and status signals that stop downstream refreshes. Reports and semantic outputs must not refresh if upstream quality gates fail, because stale but trusted-looking dashboards are worse than a visible failure.

The design therefore treats quality as a release gate. Only data that passes the checks will move into curated outputs and the reporting layer.

## Alternatives considered
### 1. Rely on manual review after load
This would be too weak for a hospital analytics platform. It still allows silent issues to reach reports and depends on humans to notice problems after the fact.

### 2. Keep only logging without automated tests
Logging alone tells you something failed but does not prevent bad data from being published. That would repeat the current-state weakness described in the report.

### 3. Use dbt tests and pipeline validations as mandatory gates
This is the selected option because it provides repeatable checks, visible failures, and a clear stop/go control before reporting.

### 4. Build a separate enterprise data observability platform
That could add richer monitoring later, but it is too much for the first migration release and would add cost and complexity without solving the immediate trust problem.

## Consequences
This decision makes quality a first-class part of the platform. The hospital gains a clear answer to whether the data is fit for reporting, instead of relying on informal checks or inherited trust from the legacy environment.

It also improves release discipline. If a test fails, the pipeline stops and the issue must be reviewed before Power BI or Excel refreshes.

The tradeoff is that the team must define quality rules carefully and maintain them. If rules are too loose, they miss issues; if they are too strict, they may block legitimate loads and create operational friction.

## Risks
The main risk is false confidence if tests cover only technical constraints and not business meaning. A load can pass structurally while still being wrong from a hospital perspective.

Another risk is alert fatigue. If the checks are noisy or poorly tuned, users may ignore warnings and treat real failures as routine.

A third risk is incomplete coverage of legacy behavior. Some of the old ETL’s assumptions may be undocumented, so parity tests and rule reviews will still be needed during cutover.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing data profiling in SSIS staging tables and the lack of systematic quality controls.
- Target-state architecture notes describing dbt tests, pipeline validation, and quality gates before serving.