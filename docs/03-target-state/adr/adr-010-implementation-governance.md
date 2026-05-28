# ADR 010: Implementation Governance

## Title
Define the implementation governance pattern for the migration.

## Status
Proposed.

## Context
The architecture decisions for the target state are now mostly defined, so the remaining risk is not concept choice but uncontrolled change during implementation. Without a governance pattern, the team could introduce ad hoc schema changes, metric rewrites, or parity exceptions that slowly drift away from the approved target state.

The hospital’s existing platform already demonstrates the cost of tightly coupled logic and hard-to-audit behavior. The Azure migration must avoid repeating that pattern by keeping design decisions, build artifacts, and cutover exceptions visibly aligned.

## Decision
We will govern the migration with a simple **ADR-first change control model**. Every material design choice must map to an ADR, implementation notes must reference the relevant ADRs, and build work must stay within those approved boundaries unless a documented change is reviewed and accepted.

Schema changes, metric changes, and parity exceptions require explicit approval before implementation. Minor implementation details that do not alter business meaning may be handled in design notes, but any change that affects grain, history, keys, measures, or report behavior must be recorded as an ADR update or a new ADR.

Only the defined project owners and technical reviewers may approve target-state behavior changes. Builders can propose changes, but they cannot silently alter semantics; all changes must be documented in the repo, linked to the governing ADR, and reflected in validation or parity evidence.

To avoid ad hoc drift during build and cutover, the team will treat implementation as a sequence of controlled checkpoints: design approval, build, validation, and cutover review. Any exception discovered during testing must be recorded, explained, and either accepted as an explicit parity variance or corrected before release.

## Alternatives considered
### 1. Informal review in chat or meetings
This would be fast, but it would not create a durable record of decisions and would invite drift during implementation.

### 2. Engineer-driven changes with later documentation
This is too risky because the implementation could diverge before the documentation catches up.

### 3. ADR-first governance with documented approvals
This is the selected approach because it preserves traceability and keeps the build aligned to the approved target state.

### 4. Heavy enterprise change control for every small task
That would be overly burdensome for a small migration project and would slow delivery unnecessarily.

## Consequences
This decision makes the implementation easier to audit. Reviewers can trace each modeled object and each metric back to an approved architectural decision instead of reconstructing intent from code alone.

It also reduces the risk of hidden scope creep. If the team wants to change grain, history, or business logic, the change must be visible and deliberate.

The tradeoff is a small amount of process overhead. That is acceptable because the migration is high risk and the hospital depends on trusted reporting.

## Risks
The main risk is governance fatigue if the team treats the process as paperwork rather than a practical control. That risk is reduced by keeping ADRs concise and decision-focused.

Another risk is unresolved exceptions during cutover, especially if the legacy system contains undocumented behavior. Those cases must be surfaced early so they do not become hidden production differences.

A final risk is over-tight control that slows necessary implementation work. The governance model should therefore separate semantic changes from ordinary implementation tasks.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Prior ADRs establishing target-state behavior for SCD2, FactAdmission, data quality, orchestration, storage zones, Synapse deployment, and privacy.
- Legacy report notes showing that uncontrolled ETL logic and silent issues are already known risks in the current platform.