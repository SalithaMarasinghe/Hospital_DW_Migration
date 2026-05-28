# ADR 009: Synapse Deployment

## Title
Define the Synapse deployment approach for the target-state warehouse.

## Status
Proposed.

## Context
The target architecture identifies Azure Synapse Analytics as the central analytical warehouse, but the exact deployment model is still open. That choice affects cost, manageability, performance behavior, and how the rest of the stack is implemented.

The hospital workload is a relatively focused admissions analytics domain with a modest historical range, a limited number of dimensions, and a strong need to keep the first migration phase cost-aware. The deployment model should therefore be practical rather than overbuilt.

## Decision
We will use a **serverless-first Synapse deployment pattern** for the initial target state, with curated warehouse tables and views hosted in Synapse-compatible storage/query layers rather than a fully provisioned dedicated pool. This gives the team a lower-cost starting point while still supporting the admissions warehouse, dimensional models, and report-serving views.

The warehouse logic will be hosted as Synapse SQL objects and/or externally managed tables and views depending on the specific implementation step, while marts will be exposed as curated views optimized for reporting. The design keeps the warehouse central in Synapse, but avoids committing to a heavy fixed-capacity deployment before workload and usage patterns are proven.

This pattern fits the hospital’s workload and budget because it supports cloud-first modernization without forcing the project to pay for unused capacity. It also aligns with the phased migration approach: build the model, validate parity, then expand only if usage or performance requires it.

What remains intentionally open is the later tuning path: whether the warehouse stays serverless, moves partially to dedicated capacity, or introduces more specialized performance optimization. Those choices should be made after the first release has measured real report demand and refresh behavior.

## Alternatives considered
### 1. Dedicated SQL pool from day one
This would offer a more traditional warehouse experience, but it would lock the project into fixed cost and more administrative overhead before the workload is fully understood.

### 2. Serverless-first Synapse
This is the selected option because it minimizes upfront cost and keeps the platform flexible during migration.

### 3. Keep the warehouse outside Synapse
That would weaken the target architecture and split the warehouse logic across more systems than necessary.

### 4. Use only views without a warehouse pattern
This would be too thin for a trustworthy admissions model and would make governance and validation harder.

## Consequences
This decision reduces financial risk in the first phase. The hospital can modernize without committing to a larger fixed infrastructure footprint than the admissions workload needs.

It also keeps the platform simpler to operate during migration. The team can focus on model correctness, quality checks, and parity testing instead of tuning a large dedicated warehouse too early.

The tradeoff is that serverless patterns may require later refinement if usage grows or if report concurrency becomes more demanding. That is acceptable because the initial workload is bounded and the architecture is designed to evolve.

## Risks
The main risk is that serverless performance may be insufficient for some reporting patterns if the workload grows faster than expected. In that case, the platform would need a controlled move to more provisioned capacity.

Another risk is implementation ambiguity if the team treats “Synapse” as a single monolithic choice without defining how tables and views are actually hosted. That is why the deployment style must be documented clearly.

A final risk is cost variability if access patterns are poorly managed or if queries are not optimized. That risk can be controlled with careful model design and testing.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Target-state architecture describing Azure Synapse Analytics as the central analytical warehouse.
- Migration scope notes emphasizing limited budget, managed services, and phased implementation.