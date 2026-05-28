# ADR 001: Platform Pattern

## Title
Choose the Azure platform pattern for the hospital admissions migration.

## Status
Proposed.

## Context
The legacy hospital analytics platform is a SQL Server-based admissions warehouse built around SSIS, SSAS, and Power BI, with batch file feeds and an on-prem admissions database. It supports admissions, discharge trends, doctor performance, regional demand analysis, and throughput metrics, and it is trusted by business users. The report also states that the current platform is reaching its limits because SSIS logic is rigid, observability is limited, and on-prem infrastructure increases operational overhead.

The migration therefore needs a cloud pattern that preserves the meaning of admissions, patient, doctor, location, and time reporting while reducing maintenance burden. The report already proposes the core Azure direction: ADLS Gen2 for storage, ADF for orchestration, Synapse for the warehouse, dbt for transformations, and Power BI for serving.

## Decision
We will use a batch-oriented Azure analytics platform composed of ADLS Gen2, Azure Data Factory, Azure Synapse Analytics, dbt, and Power BI. ADLS Gen2 will hold raw, staged, and curated data zones; ADF will orchestrate source ingestion from file feeds and the SQL Server admission source; Synapse will host the central warehouse; dbt will implement transformations, dimensional models, tests, and SCD Type 2 handling; and Power BI will serve the business reports.

We will not introduce streaming ingestion in the initial migration. The first release will preserve the legacy batch cadence and focus on trustworthy parity rather than real-time novelty. The platform will stay cost-aware and intentionally lean, using only the services required to maintain business meaning and operational traceability.

## Alternatives considered
### 1. Keep SSIS and SSAS on Azure VMs
This would be the closest technical lift-and-shift, but it would preserve the same operational fragility and maintenance burden. It also fails the modernization goal because it moves servers, not the analytics pattern.

### 2. Use Azure Databricks as the primary platform
Databricks could handle ingestion and transformation, but it would introduce a different operating model and more complexity than the hospital needs for an admissions-focused BI platform. It also does not naturally preserve the existing SQL Server/Synapse-style warehouse semantics as cleanly for a small-to-mid hospital workload.

### 3. Build a near-real-time streaming architecture
Streaming could reduce latency, but the report does not identify a business need for real-time admissions analytics. It would add cost, operational complexity, and more failure modes without improving the current reporting use cases enough to justify the change.

### 4. Replace the cube with a pure Power BI semantic layer only
Power BI is important, but SSAS is part of the trusted consumption path in the legacy platform. Removing semantic structure too early would risk breaking report behavior, hierarchies, and drill-through expectations that users already trust.

## Consequences
The target platform is easier to reason about than the legacy SSIS/SSAS stack because each layer has a clearer role. Batch ingestion keeps the migration aligned to the current operating model, reduces implementation risk, and makes reconciliation against the legacy system simpler.

Using dbt improves maintainability by making transformation logic testable and version-controlled. Using Synapse preserves the warehouse mindset, which is important because the hospital needs a business-truth layer, not a generic data lake with ad hoc reporting on top.

The main tradeoff is that the initial design does not provide real-time data and does not fully replicate every cube behavior one-to-one. That is acceptable because the report prioritizes continuity of trusted metrics and a phased migration over novelty.

## Risks
The biggest risk is semantic drift: the new platform may produce different report meanings even if row counts look correct. This is especially important for `DimLocation` SCD Type 2 behavior, `FactAdmission` accumulating metrics, and any drill-through or hierarchy logic that existed in SSAS.

Another risk is underestimating hidden business logic in the old SSIS packages and stored procedures. Some of that logic may be embedded in procedure code, refresh order, or report definitions and will need careful validation before cutover.

A final risk is overdesign. If the platform is made too large or too modern too quickly, it may increase cost and delay without improving the hospital’s core reporting needs.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing SSIS extraction, staging, SCD Type 2 location handling, accumulating metrics, and SSAS/Power BI usage.
- Current-state summaries for the DW model, ETL flow, and semantic reporting layer.