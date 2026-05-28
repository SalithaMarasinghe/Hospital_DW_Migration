# Implementation Plan

## Purpose
This plan turns the approved target-state architecture and ADRs into an ordered build sequence for the hospital admissions analytics platform. It defines the delivery phases, dependencies, validation checkpoints, cutover approach, and repository structure.

## Scope
This plan covers the Azure target-state implementation only. It assumes the architecture decisions for storage zones, Synapse deployment, data quality, orchestration, privacy, and governance are already approved. The ADR set under `docs/03-target-state/adr/` is the immutable source of truth for design behavior.

## Build Phases

### Phase 1: Foundation
- Create the repository structure.
- Provision base Azure resources.
- Establish ADLS containers or folders for raw, staged, and curated data.
- Set up naming conventions, environment variables, and deployment conventions.
- Confirm environment separation for local, dev, test, and prod.

### Phase 2: Ingestion
- Build source-to-ADLS ingestion pipelines.
- Land patient, doctor, location, and admission data into raw.
- Add minimal load metadata for traceability.
- Standardize only what is required to move into staged.

### Phase 3: Warehouse Model
- Implement Synapse warehouse objects.
- Build dbt project scaffolding and model folders.
- Create staging models, dimension models, and fact models.
- Apply approved history handling and grain rules.

### Phase 4: Semantic Layer
- Create reporting views and marts.
- Expose stable business-facing objects for Power BI and downstream consumption.
- Keep semantic logic thin and aligned to warehouse definitions.

### Phase 5: Validation
- Run dbt tests and data quality checks.
- Execute row counts, key integrity checks, and business-rule checks.
- Compare warehouse outputs with legacy outputs for parity.
- Keep data-quality tests separate from parity tests.

### Phase 6: Cutover
- Run parallel validation for an agreed period.
- Obtain sign-off on trusted reports.
- Switch consumers to the new Azure reporting path.
- Retire or freeze legacy dependencies according to the cutover plan.

## Delivery Order
1. Repository and environment setup.
2. ADLS storage zones.
3. Ingestion pipelines.
4. Staging models.
5. Dimension models.
6. Fact models.
7. Data quality tests.
8. Reporting views and marts.
9. Power BI validation.
10. Cutover and stabilization.

## Dependency Map
- Data layer depends on storage zones and source connectivity.
- Model layer depends on successful landing and staged data.
- Semantic layer depends on validated warehouse tables.
- Validation depends on stable model definitions and approved business rules.
- Cutover depends on validation success and stakeholder sign-off.

## Validation And Sign-off
The project should use checkpoints at the end of each major phase. Each checkpoint should confirm scope, quality, and ADR alignment before the next phase starts.

Keep general data-quality tests separate from parity tests so the evidence remains easy to interpret. Data-quality checks validate correctness inside the target platform, while parity tests compare target outputs against the legacy system.

Required sign-off points:
- After foundation setup.
- After ingestion completes for the core sources.
- After warehouse model build-out.
- After data-quality test completion.
- After parity testing.
- Before production cutover.

## Cutover Approach
Use a controlled parallel-run approach. The legacy and Azure stacks should run together long enough to validate key reports, core KPIs, and edge cases.

Cutover should happen only after the team confirms that:
- Critical metrics match.
- Exception handling is documented.
- No open ADR conflicts remain.
- Business owners approve the reporting outputs.

## Initial Repo Structure
```text
hospital-analytics-azure-migration/
├── .gitignore
├── LICENSE
├── README.md
├── adf/
│   ├── datasets/
│   ├── linked-services/
│   ├── pipelines/
│   ├── specs/
│   └── triggers/
├── dbt/
│   └── hospital_admissions/
│       ├── analyses/
│       ├── macros/
│       ├── models/
│       │   ├── intermediate/
│       │   ├── marts/
│       │   ├── snapshots/
│       │   └── staging/
│       ├── seeds/
│       └── tests/
├── diagrams/
├── docs/
│   ├── 01-governance/
│   │   ├── assumptions-constraints-log.md
│   │   ├── project-charter.md
│   │   ├── risk-register.md
│   │   └── scope-definition.md
│   ├── 02-current-state/
│   │   ├── legacy-dw-model.md
│   │   ├── semantic-reporting-layer.md
│   │   ├── source-systems-inventory.md
│   │   └── ssis-etl-summary.md
│   ├── 03-target-state/
│   │   ├── architecture/
│   │   │   ├── azure-component-mapping.md
│   │   │   └── target-state-architecture.md
│   │   └── adr/
│   │       ├── adr-001-platform-pattern.md
│   │       ├── adr-002-semantic-serving.md
│   │       ├── adr-003-scd2-location.md
│   │       ├── adr-004-factadmission-model.md
│   │       ├── adr-005-data-quality-observability.md
│   │       ├── adr-006-adf-orchestration.md
│   │       ├── adr-007-security-privacy.md
│   │       ├── adr-008-storage-zones.md
│   │       ├── adr-009-synapse-deployment.md
│   │       └── adr-010-implementation-governance.md
│   ├── 04-delivery-plan/
│   │   └── implementation-plan.md
│   ├── 05-validation/
│   │   └── validation-plan.md
│   └── 06-final/
│       └── cutover-signoff.md
├── evidence/
│   ├── 00-engagement/
│   ├── 01-current-state/
│   ├── 02-target-state/
│   ├── 03-build/
│   ├── 04-validation/
│   └── 05-final/
├── powerbi/
│   ├── mockups/
│   └── report-mapping.md
├── sql/
│   ├── legacy-analysis/
│   ├── reconciliation/
│   └── synapse/
│       ├── ddl/
│       ├── validation/
│       └── views/
├── synapse/
│   ├── artifacts/
│   ├── pipelines/
│   ├── sql-scripts/
│   └── workspace-config/
├── templates/
├── runbooks/
└── config/
    ├── local/
    ├── dev/
    ├── test/
    └── prod/
```

## Governance
Any change that alters schema, grain, metrics, history, or report behavior must be reviewed against the governing ADRs before implementation.

## Open Items
- Final Azure service names and resource group naming.
- Exact deployment mechanism for dbt and Synapse artifacts.
- Detailed report-by-report parity scope.
- Production run frequency and refresh windows.

## Assumptions
- The target-state ADRs remain the source of truth for design behavior.
- The implementation team will not introduce semantic changes without approval.
- Legacy outputs are available for comparison during validation.