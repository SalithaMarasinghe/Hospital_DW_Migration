# ADR 007: Security and Privacy

## Title
Define the security and privacy posture for the Azure target-state platform.

## Status
Proposed.

## Context
The target architecture treats healthcare privacy as a core design constraint, not a separate operational concern. The report also states that data residence must remain compliant with relevant privacy and security requirements, which is especially important because the platform handles patient demographics, doctor data, location data, and admissions.

The Azure target therefore needs a clear stance on how data is protected in storage, transformation, and serving, and how team members and report consumers are allowed to access it. The design also needs to explain how sample data and evidence artifacts are handled so that the project can be reviewed without exposing sensitive records.

## Decision
We will protect healthcare data with least-privilege role-based access, separation between raw/staged/curated layers, and restricted access to presentation outputs. Raw and staged data will be treated as working zones with access limited to the delivery team, while curated data and report outputs will be limited to approved analysts and report consumers.

The preferred access model is role-based access by function: pipeline operators, model developers, reviewers, and report consumers should each have only the permissions they need. Team members who build or validate the solution may access non-production or masked datasets, but they should not use real patient-identifiable data in shared artifacts unless that is explicitly necessary and authorized.

Sample data, screenshots, diagrams, and validation evidence should be anonymized or masked wherever possible. If a document or artifact must reference a patient-level example, it should be reduced to the minimum needed to explain the point and should not expose unnecessary personal detail.

For the first release, we will not design for broad public sharing, cross-tenant collaboration, or patient-facing self-service access. Those capabilities are out of scope until the core hospital analytics platform and governance model are stabilized.

## Alternatives considered
### 1. Open access to the lake and warehouse for the project team
This would be easy during development, but it would be unsafe for healthcare data and would not align with privacy expectations.

### 2. Restrict everything to a single admin account
This would be secure in a narrow sense, but it would be unworkable for team delivery, review, and controlled report consumption.

### 3. Role-based least-privilege access with masked evidence artifacts
This is the selected approach because it supports development and review while still protecting sensitive hospital data.

### 4. Build a full enterprise security program immediately
That may be appropriate later, but it is too much for the first migration release and would add complexity beyond the project’s current scope.

## Consequences
This decision reduces the chance that sensitive hospital data appears in shared outputs, review notes, or demonstration material. It also makes access expectations clearer for the team and for report consumers.

The platform becomes easier to govern because each layer has a different exposure level. Raw and staged data remain tightly controlled, while curated and serving layers are the only places intended for broad business use.

The tradeoff is that some review and debugging activities will be slightly slower because access is more controlled. That is acceptable because healthcare data protection is a higher priority than convenience.

## Risks
The main risk is accidental exposure through examples, screenshots, or exported files rather than through the platform itself. That is why evidence handling must be treated as part of the security model.

Another risk is over-permissioning during delivery, where shortcuts are taken to speed up development. If that happens, the platform may look secure on paper but still be vulnerable in practice.

A final risk is assuming that report consumption is safe simply because the data is curated. Business-facing views still need access review and governance.

## Evidence / references
- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Target-state architecture notes stating that privacy is a core design constraint.
- Legacy assignment report describing healthcare data sources, admissions, doctor data, and patient location data.