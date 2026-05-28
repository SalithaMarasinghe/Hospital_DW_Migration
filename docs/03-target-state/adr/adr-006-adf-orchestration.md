# ADR 006: ADF Orchestration

## Title
Define Azure Data Factory orchestration for the target-state ingestion and load process.

## Status
Proposed.

## Context
The legacy platform uses SSIS control flow to coordinate file loads, SQL extraction, truncation, transformation, and downstream warehouse refresh. That orchestration model is important because the hospital’s analytics pipeline is batch-based and must preserve source-to-report order.

In Azure, the migration needs an orchestration backbone that is equally deliberate, but simpler and more maintainable than a direct SSIS clone. ADF is the natural control layer for this because the target design already uses batch sources, ADLS landing zones, Synapse transformations, and dbt-managed model logic.

## Decision
Azure Data Factory will be the orchestration backbone for source ingestion, dependency control, and batch execution. ADF pipelines will coordinate file ingestion from patient, doctor, and location feeds, SQL extraction for admissions, landing into ADLS raw, promotion into staged data, and triggering downstream dbt and Synapse steps in the required order.

ADF will enforce dependency order explicitly: source extraction must complete before staging standardization, staging must complete before dbt transformations, and transformations must complete before semantic refresh or report publication. The orchestration layer will also support scheduled batch windows so the platform loads predictably and does not interfere with operational systems.

Retries will be configured for transient failures such as temporary network issues, file availability problems, or short-lived source connectivity interruptions. Failures that are not transient, such as schema mismatch or validation errors, should stop the pipeline rather than being retried blindly.

ADF will integrate with dbt and Synapse as a coordinator, not as a transformation engine. ADF starts the workflow, dbt performs the modeled transformations and tests, and Synapse stores the warehouse outputs that Power BI and Excel consume.

This ADR intentionally leaves advanced orchestration out of scope for the first release. Complex event-driven orchestration, cross-domain dependency graphs, and near-real-time job management are not required for the hospital’s current admissions workload.

## Alternatives considered
### 1. Keep SSIS for orchestration
This would preserve familiar behavior, but it would not achieve the cloud migration goal and would keep the old maintenance burden. It also would not align cleanly with the target-state Azure storage and warehouse pattern.

### 2. Use ad hoc scripts or manual job scheduling
This would be too fragile for a hospital analytics platform. It would weaken dependency control, visibility, and repeatability.

### 3. Use ADF as the orchestration backbone
This is the selected option because it gives clear scheduling, dependency handling, retries, and Azure-native integration with ADLS, dbt, and Synapse.

### 4. Use a separate enterprise workflow engine
That could be useful in a larger environment, but it is unnecessary for the first migration release and would add cost and complexity.

## Consequences
This decision gives the platform a single visible place for batch workflow management. Operations become easier to understand because every source load and downstream step is part of a controlled pipeline instead of a collection of disconnected jobs.

The design also improves migration safety. Because ADF can sequence extraction, transformations, and refreshes, the team can validate each stage before the next one runs.

The tradeoff is that orchestration logic must be designed carefully and documented well. If pipeline dependencies or schedules are unclear, the workflow can still become hard to manage even with ADF.

## Risks
The main risk is over-reliance on a single orchestration tool without clear pipeline standards. That can create brittle pipelines if naming, error handling, or dependency rules are not disciplined.

Another risk is retry misuse. Retrying a broken schema or validation failure can waste time and obscure the real problem.

A final risk is scope creep. If ADF is asked to do too much orchestration logic beyond the admissions migration, the design may become more complex than intended.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing SSIS control flow, truncation before reload, and batch file/database loads.
- Target-state documents describing ADF, ADLS, Synapse, dbt, and Power BI as the core Azure stack.