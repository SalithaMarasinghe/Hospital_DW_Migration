# Validation Plan

## Purpose
This document defines how the Azure target-state platform will be validated before cutover. It separates data-quality tests from parity tests so each type of evidence is easy to interpret and so sign-off is based on both internal correctness and legacy equivalence.

## Scope
This plan applies to the warehouse, transformation, semantic, and reporting layers built for the hospital admissions platform. It covers validation of the data pipeline, model logic, business rules, and report outputs before production release.

## Validation Types

### Data-quality tests
Data-quality tests verify that the target platform is internally correct. They check that the data loaded into ADLS, Synapse, and dbt models follows the expected rules, relationships, and business constraints.

Typical checks include:
- Not-null checks for required fields.
- Uniqueness checks for business and surrogate keys.
- Referential integrity checks between facts and dimensions.
- Accepted-value checks for enumerations and codes.
- Business-rule checks such as valid dates, non-negative durations, and expected row counts.

These tests prove that the target system is trustworthy on its own, even before comparison with the legacy platform.

### Parity tests
Parity tests compare outputs from the Azure target-state platform against outputs from the legacy system. They are used to confirm that the migration has preserved business meaning, report logic, and KPI behavior.

Typical checks include:
- Row-count comparisons for source, staged, and modeled outputs.
- Aggregate comparisons for measures such as admissions, lengths of stay, and transaction timings.
- Dimension-member comparisons for location, doctor, and patient attributes.
- Report-level comparisons for trusted dashboards and key visuals.

Parity tests are not the same as data-quality tests. A model can pass data-quality checks and still fail parity if it does not match the legacy business definition.

## Validation Workflow
1. Validate raw-to-staged loads.
2. Validate staged-to-model transformations.
3. Validate dimension and fact logic.
4. Validate semantic views and marts.
5. Run parity tests against legacy outputs.
6. Document exceptions and re-run checks after fixes.
7. Obtain sign-off for the relevant checkpoint.

## Required Sign-off Checkpoints

### Checkpoint 1: Foundation sign-off
Confirm that the repository structure, environments, and base Azure resources are ready for implementation.

### Checkpoint 2: Ingestion sign-off
Confirm that the core source feeds land correctly in raw and staged zones with traceable load metadata.

### Checkpoint 3: Warehouse model sign-off
Confirm that the warehouse tables, dbt models, and approved grain/history rules are implemented correctly.

### Checkpoint 4: Data-quality sign-off
Confirm that dbt tests and rule checks pass for the target platform without material failures.

### Checkpoint 5: Parity sign-off
Confirm that the Azure outputs match the legacy outputs for the agreed scope of reports, metrics, and dimensions.

### Checkpoint 6: Cutover sign-off
Confirm that business owners approve the target outputs and that any approved variances are documented.

## Evidence Requirements
Validation evidence should be stored separately from build artifacts so it is easy to review.

Recommended evidence folders:
- `docs/05-validation/` for validation plans, results, and summaries.
- `evidence/04-validation/` for execution outputs and result files.
- `evidence/05-final/` for final approval records.

Each checkpoint should produce a short result summary that states:
- What was tested.
- What passed.
- What failed.
- What was fixed.
- Whether the checkpoint is approved.

## Exception Handling
Any validation failure that changes business meaning, metric results, or report outputs must be treated as a formal exception. The exception should be documented, reviewed against the ADRs, and either corrected or explicitly accepted before cutover.

## Exit Criteria
The platform is ready for cutover when:
- Core data-quality tests pass.
- Core parity tests pass.
- Any approved variances are documented.
- Business owners approve the release.
- No open governance issues remain.