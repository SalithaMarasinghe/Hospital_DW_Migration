# Project Charter

## Document control

| Field                         | Value                                                  |
| ----------------------------- | ------------------------------------------------------ |
| Project name                  | Hospital Admissions Analytics Platform Azure Migration |
| Document title                | Project Charter                                        |
| Version                       | v0.2                                                   |
| Document owner                | M S M Marasinghe                                       |
| Project sponsor               | Project Supervisor / Principal Data Architect          |
| Project owner / delivery lead | M S M Marasinghe                                       |
| Last updated                  | 2026-05-27                                             |
| Approval status               | Approved                                               |

## Business context

The client is a mid-sized private hospital network in Sri Lanka operating multiple facilities and relying on admissions analytics to support executive, operational, financial, and departmental decision-making. The current analytics solution is built on the Microsoft SQL Server BI stack and is used to analyze admissions, discharges, doctor performance, regional demand, and throughput-style measures such as length of stay and elapsed processing time. 

The existing platform is trusted because it centralizes analytical reporting in a structured warehouse model supported by a semantic reporting layer for business consumption. At the same time, the solution is constrained by on-premises scaling limits, tightly coupled SSIS and stored procedure logic, limited programmatic data quality enforcement, and high operational maintenance overhead.

## Problem statement

The hospital’s existing admissions analytics platform continues to deliver trusted reporting, but it is becoming increasingly difficult to scale, maintain, and evolve using its current on-premises architecture. The organization needs a cloud-first analytical platform that preserves established business definitions, trusted KPIs, and historical reporting behavior while reducing dependence on legacy ETL patterns and infrastructure overhead. 

The migration must prioritize reporting continuity over technical novelty. Any loss of KPI fidelity, semantic meaning, or historical dimensional behavior would undermine stakeholder trust, especially because the platform supports executives, operations managers, finance analysts, department heads, and technical support teams. 

## Project objective

Design and document a realistic migration of the Hospital Admissions Analytics Platform from SQL Server, SSIS, SSAS, and Power BI to an Azure-based target architecture using ADLS Gen2, Azure Data Factory, Synapse Analytics, dbt, and Power BI. The migration design must preserve the current fact and dimension model, retain trusted KPI definitions, and maintain historical behavior, especially the SCD Type 2 implementation for `DimLocation`. 

The target-state approach should improve engineering quality through modular ELT patterns, version-controlled transformations, explicit testing, and better observability, while remaining realistic for a budget-sensitive healthcare organization. This project is intended to produce a portfolio-grade migration case study and implementation pack rather than a full production deployment. 

## Scope

The project includes the assessment, design, implementation planning, and portfolio-realistic build artifacts required to demonstrate a defensible migration of the hospital admissions analytics platform from the legacy SQL Server BI stack to Azure. Scope includes current-state analysis, target-state architecture, ingestion and transformation design, dimensional model rebuild planning, validation design, and stakeholder-ready documentation.

In-scope work includes:

- Current-state documentation of source systems, warehouse model, ETL behavior, and semantic/reporting usage. 
- Azure target-state architecture and legacy-to-Azure component mapping.
- ADLS Gen2 landing, staged, and curated zone design.
- Synapse warehouse and dbt transformation design for `FactAdmission`, `DimPatient`, `DimDoctor`, `DimDate`, and SCD Type 2 `DimLocation`. 
- ADF orchestration and ingestion design. 
- Validation and reconciliation planning for core admissions KPIs and selected reports. 
- Portfolio-grade repository structure, design notes, implementation artifacts, and presentation-ready evidence.

## Out of scope

The following items are outside the initial delivery scope:

- Full enterprise rollout into additional domains such as billing, laboratories, and pharmacy, although the design should allow future extensibility into those areas. 
- Broad clinical interoperability redesign across upstream hospital systems.
- Full production networking, enterprise security hardening, secrets management implementation, and live operational cutover execution.
- Formal production support model, live SLA definition, and real-user production training rollout.

This project should therefore be treated as a migration case study and portfolio implementation that demonstrates enterprise-realistic design and build discipline, while stopping short of claiming full production deployment readiness in infrastructure and operational terms.

## Stakeholders

### Business stakeholders

- Hospital executives.
- Operations managers. 
- Finance analysts.
- Department heads.

### Technical stakeholders

- IT and data platform team responsible for legacy analytics operations and future platform support. 
- Data engineering implementation owner for migration build artifacts and documentation. 

### Review and approval stakeholders

- Project Supervisor / Principal Data Architect. 
- Internal reviewer(s) responsible for phase-gate approval of deliverables and evidence completeness.

## Success criteria

The project will be considered successful when all of the following conditions are met:

- The current-state platform is documented with, at minimum, a source inventory, warehouse model specification, ETL behavior summary, and reporting/semantic layer summary. 
- The target-state architecture includes explicit mapping from key legacy components, including SQL Server warehouse objects, SSIS processes, and SSAS/reporting behavior, to justified Azure-based equivalents. 
- The admissions warehouse design preserves one row per hospital admission in `FactAdmission` and retains the required dimensional behavior, including SCD Type 2 history in `DimLocation`.
- Core KPI parity is validated for agreed admissions measures using reconciliation evidence, row-count checks, and comparison outputs between legacy and target designs.
- The repository contains controlled documentation for governance, architecture, implementation planning, validation, and final portfolio packaging. 
- Each project phase produces saved evidence sufficient for technical review, auditability, and interview defense.

## Constraints and assumptions

The project is constrained by the requirement to use Microsoft Azure as the target platform, the need to remain cost-aware through managed or consumption-based service choices, and the need to preserve reporting continuity throughout migration planning and validation. Healthcare data handling must also remain aligned with privacy and security expectations appropriate to the domain. 

The project assumes that existing source extracts remain available during migration, legacy business logic can be recovered from source data, warehouse structures, ETL behavior, and reporting artifacts, and a subset of reports can be rebuilt first to establish parity. It is also assumed that the implementation will use representative or sample data where necessary while preserving enterprise-realistic logic, structure, and documentation standards.

## Delivery approach

The work will be delivered in controlled phases beginning with governance and current-state understanding before moving into target-state architecture, implementation planning, build artifacts, validation, and final packaging. This sequencing reflects consulting-grade migration discipline and reduces the risk of misinterpreting legacy logic before target implementation decisions are made.

The delivery approach favors realistic, minimal, and defensible engineering decisions over oversized enterprise design. The emphasis is on preserving business meaning, ensuring KPI continuity, enabling modular ELT and testing practices, and creating a credible migration case study supported by explicit evidence and review gates.

## Approval status

| Review item                     | Status  | Reviewer                                      | Notes                                                                        |
| ------------------------------- | ------- | --------------------------------------------- | ---------------------------------------------------------------------------- |
| Charter structure               | Draft   | Project Supervisor / Principal Data Architect | Updated to include document control and measurable success criteria          |
| Scope and boundaries            | Draft   | Pending                                       | Explicitly distinguishes portfolio implementation from production deployment |
| Final Phase 0 Step 0.1 approval | Pending | Pending                                       | Subject to review of governance pack consistency                             |