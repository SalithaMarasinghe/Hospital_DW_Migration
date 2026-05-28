# Cutover Sign-off

## Purpose
This document records the final approval criteria for moving the hospital admissions analytics platform into production and for confirming that the new Azure-based solution is stable after release.

## Scope
This sign-off applies to the production cutover from the legacy platform to the Azure target state. It covers business approval, technical approval, data validation, report readiness, and stabilization after go-live.

## Final Approval Criteria
Production cutover can proceed only when all of the following are true:
- Core data-quality tests have passed.
- Core parity tests have passed for the agreed scope.
- Any approved exceptions are documented and accepted.
- Target-state ADRs remain satisfied.
- Business owners approve the reporting outputs.
- Operational owners confirm monitoring, access, and support readiness.
- A rollback or fallback approach is documented.

## Required Evidence
The cutover package should include:
- Validation summaries from `docs/05-validation/`.
- Execution evidence from `evidence/04-validation/`.
- Final approval records in `evidence/05-final/`.
- Any open issue log or exception register.
- Confirmation that the implementation matches the approved ADRs.

## Sign-off Checks

### Business sign-off
Confirm that key reports, KPIs, and drill-through views match what the business expects.

### Technical sign-off
Confirm that pipelines, dbt models, warehouse objects, and semantic objects deploy successfully and run without critical failures.

### Data sign-off
Confirm that the required data-quality and parity checks have been completed and reviewed.

### Operational sign-off
Confirm that support procedures, monitoring, and access controls are ready for production use.

## Stabilization Period
The first period after cutover should be treated as stabilization, not as normal steady state. During this window, the team should:
- Monitor pipeline runs and refresh success.
- Review report usage and user feedback.
- Watch for data anomalies, latency issues, or access problems.
- Re-run any agreed post-cutover checks.
- Capture and resolve production defects quickly.

## Stabilization Exit Criteria
Stabilization is complete when:
- Production runs have been successful for the agreed monitoring window.
- No critical defects remain open.
- Key stakeholders confirm the reports are usable.
- The support team has accepted the platform into normal operations.

## Approval Record
- Release name: ____________________
- Cutover date: ____________________
- Business approver: ____________________
- Technical approver: ____________________
- Data/validation approver: ____________________
- Operations approver: ____________________
- Status: Approved / Not approved

## Notes
Any post-cutover change that affects metrics, grain, history, or report semantics must be reviewed against the ADRs before it is released.