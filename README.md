# Hospital Analytics Azure Migration

This repository contains the design, implementation, and validation assets for migrating the hospital admissions analytics platform to Microsoft Azure. The goal is to preserve trusted admissions reporting while modernizing storage, orchestration, warehouse modeling, and delivery practices.

## What is in this repo
- **Target-state design** in `docs/03-target-state/`.
- **Architectural decisions** in `docs/03-target-state/adr/`.
- **Implementation sequencing** in `docs/04-delivery-plan/implementation-plan.md`.
- **Validation and final sign-off** materials in `docs/05-validation/` and `docs/06-final/`.
- **Execution evidence** in `evidence/`.

## Start here
1. Read the target-state architecture in [`docs/03-target-state/architecture/target-state-architecture.md`](docs/03-target-state/architecture/target-state-architecture.md).
2. Review the component mapping in [`docs/03-target-state/architecture/azure-component-mapping.md`](docs/03-target-state/architecture/azure-component-mapping.md).
3. Review the ADRs in [`docs/03-target-state/adr/`](docs/03-target-state/adr/).
4. Read the implementation plan in [`docs/04-delivery-plan/implementation-plan.md`](docs/04-delivery-plan/implementation-plan.md).
5. Use the evidence folders under [`evidence/`](evidence/) as the project progresses.

## ADR index
- [ADR 001: Platform Pattern](docs/03-target-state/adr/adr-001-platform-pattern.md)
- [ADR 002: Semantic Serving](docs/03-target-state/adr/adr-002-semantic-serving.md)
- [ADR 003: SCD2 Location](docs/03-target-state/adr/adr-003-scd2-location.md)
- [ADR 004: FactAdmission Model](docs/03-target-state/adr/adr-004-factadmission-model.md)
- [ADR 005: Data Quality and Observability](docs/03-target-state/adr/adr-005-data-quality-observability.md)
- [ADR 006: ADF Orchestration](docs/03-target-state/adr/adr-006-adf-orchestration.md)
- [ADR 007: Security and Privacy](docs/03-target-state/adr/adr-007-security-privacy.md)
- [ADR 008: Storage Zones](docs/03-target-state/adr/adr-008-storage-zones.md)
- [ADR 009: Synapse Deployment](docs/03-target-state/adr/adr-009-synapse-deployment.md)
- [ADR 010: Implementation Governance](docs/03-target-state/adr/adr-010-implementation-governance.md)

## Evidence folders
- `evidence/00-engagement/`
- `evidence/01-current-state/`
- `evidence/02-target-state/`
- `evidence/03-build/`
- `evidence/04-validation/`
- `evidence/05-final/`

## Working principle
Treat the ADRs as the source of truth for design behavior. Use the implementation plan to sequence work, and store proof of execution and validation in the evidence folders.