# ADR 002: Semantic Serving

## Title
Define the semantic and reporting serving pattern for Azure.

## Status
Proposed.

## Context
The legacy platform is trusted not only because the warehouse tables are correct, but because business users consume the data through SSAS, Excel pivot tables, and Power BI reports. The report explicitly states that the cube provides a semantic model for business tools and that users rely on it for admissions by doctor, diagnosis, day, location, month, year, and drill-through analysis.

For the Azure migration, the semantic serving layer must preserve that trust while staying realistic for a first-release target state. We need a pattern that supports ad hoc Excel use, Power BI dashboards, and business-friendly navigation without overbuilding a full SSAS replacement on day one.

## Decision
The first Azure release will use Synapse views and marts as the semantic-serving base, with Power BI built on top of that layer and Excel connected to the same curated semantic outputs. We will not introduce a separate cube in the initial target-state design.

This means the warehouse team will publish a small set of business-facing views or marts that encode the stable reporting grain, dimensions, and measures needed by the current reports. Power BI datasets can then be built over those curated objects, and Excel users can connect to the same layer for pivot-style analysis.

This is a deliberate minimum viable semantic pattern. It preserves trusted reporting behavior by standardizing the business meaning in curated views and marts, while avoiding the extra operational and modeling complexity of rebuilding the old cube immediately.

## Alternatives considered
### 1. Rebuild SSAS in Azure
This would preserve the old consumption style most closely, but it adds another platform layer, more operational overhead, and slower migration delivery. It also postpones the move away from the legacy semantic dependency instead of simplifying it.

### 2. Power BI direct to Synapse tables
This would be simpler technically, but it risks exposing raw warehouse structure directly to report authors and business users. That would make report logic harder to govern and could create inconsistent definitions across datasets.

### 3. Synapse views/marts plus Power BI and Excel on top
This is the selected pattern because it keeps a clear business-facing serving layer without requiring a cube rebuild. It is the best balance of trust, maintainability, and delivery speed for the first release.

### 4. Separate tabular semantic model as a new middle layer
A separate semantic model could eventually make sense, but it would add modeling effort and another artifact to maintain before the Azure warehouse pattern is stabilized. The report does not require that extra layer for the initial migration.

## Consequences
This decision gives the hospital a simpler and more controllable semantic layer. Power BI and Excel can keep using a curated, business-friendly interface while the team validates report parity against the legacy outputs.

The approach also reduces the number of moving parts in the first release. There is no need to manage cube processing, duplicate semantic logic, or synchronize multiple semantic artifacts during cutover.

The main tradeoff is that the first Azure release will not fully reproduce every SSAS-specific feature. That is acceptable because the report prioritizes continuity of trusted reporting over complete technical equivalence on day one.

## Risks
The main risk is that some SSAS behaviors may be harder to replicate exactly with views and marts alone. This includes cube-calculated measures, hierarchy behavior, and any hidden semantics that users have come to expect.

Another risk is semantic sprawl in Power BI if report authors begin creating their own inconsistent definitions on top of the curated layer. To avoid that, the published semantic layer must be treated as the governed source for business reporting.

There is also a user-adoption risk if Excel users expect the same pivot navigation they had in SSAS. That risk must be managed through careful validation and clear communication during the transition.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing SSAS as the trusted semantic model consumed through Excel and Power BI.
- Current-state semantic reporting summary describing admission, trend, and drill-through reporting themes.