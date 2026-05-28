# ADR 008: Storage Zones

## Title
Define the Azure storage zone pattern for raw, staged, and curated data.

## Status
Proposed.

## Context
The target architecture uses ADLS Gen2 as the landing and storage backbone, but the behavior of the storage zones needs to be explicit so the implementation stays consistent. The hospital migration must support reprocessing, traceability, and trusted reporting without turning the lake into an undisciplined file dump.

The legacy platform relied on staged loads and repeatable batch processing. The Azure target should preserve that operational discipline while making the data lifecycle clearer from source extract to reporting-ready outputs.

## Decision
We will use three zones: raw, staged, and curated. Raw stores source extracts exactly as received or with only minimal transport metadata, staged stores standardized and validated data that is ready for transformation, and curated stores reporting-ready outputs that reflect the approved warehouse model.

Raw will contain original source files and SQL extracts in their landed form, plus load metadata such as batch time and source system tags. Staged will contain cleaned and conformed files or tables with standardized column names, types, and basic validation outcomes. Curated will contain the final business-facing datasets that support Synapse models and Power BI reporting.

Curated is **physical and intentional**, not merely optional. Even if downstream consumers read from Synapse tables or views, there must be a clearly defined curated layer so the team has a stable checkpoint for reporting trust and for validating whether the warehouse output matches the approved business model.

File formats should stay simple and durable. Raw can preserve original CSV, TXT, or source-specific exports, while staged and curated should prefer columnar or relational-friendly formats such as Parquet or warehouse tables, depending on the implementation step.

Retention should be tiered by zone. Raw should be retained long enough to support replay and audit of loads, staged should be retained for short operational recovery, and curated should be retained as the business-ready history that supports reporting and parity checks.

## Alternatives considered
### 1. Keep only a raw landing zone
This would preserve source evidence but would leave all transformation logic buried in downstream jobs and make recovery harder.

### 2. Use raw and curated only, with no staged zone
This would reduce layering, but it would make standardization and validation harder to isolate and test.

### 3. Use raw, staged, and curated zones
This is the selected approach because it supports replay, traceability, and controlled movement from source to reporting.

### 4. Treat curated as a purely logical concept
This would make the design less explicit and would weaken the handoff between transformation and reporting.

## Consequences
This decision gives the team a clean storage contract. Everyone knows where source evidence lives, where cleansing happens, and where reporting-ready data is published.

It also improves recoverability. If a pipeline fails or a business rule changes, the team can reprocess from raw without needing to re-extract from the source system.

The tradeoff is that the platform now maintains more than one storage stage, which adds some operational overhead. That overhead is justified because it improves auditability and trust.

## Risks
The main risk is zone drift, where users bypass the intended flow and place transformed data in raw or raw-like data in curated. That would make lineage unclear and reduce confidence in the platform.

Another risk is excessive retention, especially in raw, which could create storage cost growth if cleanup rules are not defined.

A third risk is confusing curated with a semantic layer. Curated should remain a governed data product, not a substitute for report design or access control.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Target-state architecture describing ADLS Gen2 with raw, staged, and curated containers/folders.
- Legacy ETL notes showing staged loads, truncation before reload, and repeatable batch processing.