# Scope Definition

## Document control

| Field          | Value                                                  |
| -------------- | ------------------------------------------------------ |
| Project name   | Hospital Admissions Analytics Platform Azure Migration |
| Document title | Scope Definition                                       |
| Version        | v0.1                                                   |
| Document owner | M S M Marasinghe                                       |
| Last updated   | 2026-05-27                                             |
| Status         | Draft – Pending review                                 |

## Scope purpose

This document defines the delivery boundary for the Hospital Admissions Analytics Platform Azure Migration. Its purpose is to prevent uncontrolled expansion, distinguish the current migration case study from broader enterprise modernization, and provide a clear reference for what is and is not expected in the initial delivery.

## In scope

The following items are in scope for the initial delivery:

- Documentation of the current-state platform, including source systems, warehouse model, ETL behavior, and semantic/reporting usage.
- Analysis of the legacy admissions warehouse centered on `FactAdmission` with supporting dimensions `DimPatient`, `DimDoctor`, `DimLocation`, and `DimDate`.
- Preservation of the existing analytical grain of one row per hospital admission in `FactAdmission`.
- Preservation of historical dimensional behavior for `DimLocation`, including Slowly Changing Dimension Type 2 logic with effective dates and current-record handling.
- Definition of the target Azure architecture using ADLS Gen2, Azure Data Factory, Synapse Analytics, dbt, and Power BI.
- Design of raw, staged, and curated storage patterns in ADLS Gen2.
- Design of ingestion and orchestration patterns for file-based and SQL Server source data using ADF.
- Design of Synapse-based warehouse rebuild and dbt transformation layers for admissions analytics.
- Definition of data quality, observability, reconciliation, and KPI parity validation approaches.
- Rebuild and validate an agreed subset of legacy reporting outputs in the target analytical serving layer to demonstrate reporting continuity.
- Creation of portfolio-grade implementation artifacts, documentation, and evidence packs suitable for technical review and interview discussion.

## Out of scope

The following items are explicitly out of scope for the initial delivery:

- Full production deployment of the Azure solution, including enterprise networking, private endpoints, production IAM hardening, and operational handover.
- Full rebuild of unrelated business domains such as billing, labs, pharmacy, insurance, or broader clinical interoperability workflows.
- Complete retirement or decommissioning of the legacy SSIS, SSAS, and on-prem SQL Server environment in a live production setting.
- Real-time or streaming architecture for admissions processing. The migration is based on batch-oriented legacy behavior and cloud-native batch/ELT modernization.
- Full enterprise data governance operating model, including production stewardship workflows, enterprise MDM, and organization-wide metadata tooling.
- Formal production support SLAs, enterprise user training rollout, and live organizational change management execution beyond documented planning and readiness notes.

## Deferred future scope

The following items are not part of the current delivery, but the target architecture should allow them to be added later without major redesign:

- Addition of new healthcare domains such as billing, laboratories, and pharmacy.
- Expanded semantic models and additional Power BI report portfolios beyond the agreed parity subset.
- Advanced cost optimization, workload separation, and platform tuning after core migration parity is established.
- Expanded data observability, alerting, lineage tooling, and automated deployment pipelines.
- Future extension into broader clinical analytics and enterprise-wide healthcare reporting domains.

## Scope boundaries

The delivery boundary is intentionally defined as a migration case study and portfolio implementation, not a claim of full production rollout. The project must demonstrate enterprise-realistic architecture, warehouse design, transformation logic, validation discipline, and documentation quality, but it stops short of claiming live production cutover readiness in infrastructure, security hardening, or operating model maturity.

The scope boundary also separates business logic preservation from platform modernization mechanics. The admissions fact model, KPI semantics, and historical reporting behavior are treated as fixed business requirements to be preserved, while the ingestion, transformation, orchestration, and storage mechanisms are the parts being modernized.

The project boundary further limits the solution to the admissions analytics platform and its supporting dimensions. Any future data domains must be referenced only as extensibility considerations, not as hidden implementation scope within the current phase plan.

## Change control note

Any requested change that expands scope beyond admissions analytics, introduces new business domains, alters the agreed fact grain, or adds production deployment obligations must be recorded as a scope change and reviewed before acceptance.

All scope changes should include:

- change description,
- reason for change,
- impact on timeline and documentation,
- impact on validation evidence,
- approval decision,
- updated version reference.

Any approved scope change that affects validation expectations must also update the proof checklist, validation plan, and relevant phase review criteria.

No undocumented scope growth should be accepted during delivery, because uncontrolled expansion would weaken parity, evidence quality, and the credibility of the migration case study.
