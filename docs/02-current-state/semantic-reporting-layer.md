# Semantic Reporting Layer

## Document control

| Field          | Value                                                  |
| -------------- | ------------------------------------------------------ |
| Project name   | Hospital Admissions Analytics Platform Azure Migration |
| Document title | Semantic Reporting Layer                               |
| Version        | v0.1                                                   |
| Document owner | M S M Marasinghe                                       |
| Last updated   | 2026-05-28                                             |
| Status         | Approved                                               |

## Business purpose

This document describes how business users consume the legacy warehouse through SSAS, Excel, and Power BI. Its purpose is to preserve reporting meaning and user trust during migration, because the warehouse tables alone are not enough to guarantee that the business sees the same results after the platform changes.

The semantic layer is where technical warehouse structures become trusted business analytics. In this project, that means the migration must preserve not only the data model, but also the cube-based behavior and reporting patterns that users already rely on.

## Semantic architecture overview

The legacy reporting stack sits on top of the SQL Server data warehouse. The warehouse feeds a SSAS multidimensional semantic model, and that model is then consumed through Excel pivot tables and Power BI reports.

This arrangement matters because business users are not querying the warehouse directly. They rely on the semantic layer to provide trusted measures, hierarchies, drill paths, and report-friendly behavior without having to understand the physical warehouse schema.

The report makes it clear that this is a trusted and established consumption path. That means semantic behavior is a migration dependency, not an optional presentation feature.

## Semantic shape

The report shows that the warehouse supports analysis by doctor, diagnosis, day, location, month, and year. Those analytical shapes are the practical business interface of the semantic layer, even if the detailed cube metadata is not fully documented.

Because of that, migration validation should focus on whether the same slicing and drill patterns still work after the target platform is rebuilt. If those shapes change, the hospital could see a different analytical experience even when the fact and dimension tables look correct.

## SSAS cube role

SSAS provides the multidimensional semantic model that makes the warehouse usable for analysis by business users. The report states that this cube supports complex queries across different perspectives such as time, region, and department.

The cube is important because it abstracts warehouse complexity and gives users a stable analytical interface. If the cube behavior changes during migration, the hospital may lose trust even if the underlying warehouse tables are technically correct.

The report does not fully expose cube internals such as measure definitions, calculated members, named sets, or exact hierarchies. However, it clearly shows that the cube is central to current-state reporting and therefore must be validated as part of the migration.

## Excel usage summary

Excel is used as an ad hoc analysis tool connected to the SSAS cube. The report confirms that analysts and managers use Excel pivot tables and charts for exploration rather than querying the warehouse directly.

This matters because Excel usage often reflects how business users actually inspect data, slice metrics, and trust results. If the migration changes cube behavior, Excel pivot outputs can change even if the warehouse tables match row-for-row.

The report does not provide a detailed Excel workbook inventory or usage frequency, so the exact workbook set and pivot structure still need validation. Even so, Excel remains a significant downstream consumer of the semantic layer.

## Power BI usage summary

Power BI is used as the main reporting and dashboard layer on top of the semantic model. The report confirms that Power BI reports show admission volumes by doctor, diagnosis, day, and location, along with trends over months and years and drill-through views for doctor performance and city-level statistics.

This is important because Power BI reports represent the visible business output of the legacy analytics platform. When users open a dashboard, they are not evaluating warehouse tables; they are evaluating business meaning, trend behavior, and report navigation.

The report does not describe every report page, filter, or visual, so the full report catalog still needs to be validated. Even so, the report themes are clear enough to define the core parity expectations for migration.

## Report catalog and KPI themes

The report explicitly identifies the following themes:

- Admission volumes by doctor.
- Admission volumes by diagnosis.
- Admission volumes by day.
- Admission volumes by location.
- Trends over months and years.
- Drill-through views for doctor performance.
- Drill-through views for city-level statistics.

These themes show that the reporting layer is focused on operational and managerial decision support rather than raw transaction review. The migration must therefore preserve both the data values and the analytical behavior that supports those views.

The KPI themes also imply that time, geography, and doctor dimensions are central to the business story. Any redesign that changes their semantic meaning would affect how the hospital interprets operational performance.

## Semantic dependencies and risks

The semantic layer depends on the warehouse, but the migration risk runs in both directions. A warehouse rebuild that ignores semantic behavior can still fail because the same data may produce different measures, hierarchies, drill paths, or report outputs.

The biggest risk is assuming that table parity automatically equals report parity. In this project, that assumption would be unsafe because the report explicitly shows trusted consumption through SSAS, Excel, and Power BI.

Another risk is overfocusing on Power BI while ignoring SSAS. The report makes it clear that SSAS is part of the trusted consumption path, so semantic validation must include cube behavior, not just report visuals.

## Open questions and gaps

- The report confirms SSAS, Excel, and Power BI usage, but it does not provide cube measure definitions.
- Exact SSAS hierarchies, calculated members, and named set logic are not yet documented.
- The full Excel workbook inventory and pivot structure are not yet known.
- The exact Power BI report catalog, page structure, and filter logic are still unconfirmed.
- It is not yet known whether any reports bypass the cube or use alternate extracts.
- The refresh order between warehouse load, SSAS processing, Excel access, and Power BI refresh still needs validation.
- The report does not confirm whether all business users rely on the same report set or whether there are department-specific variants.

## Evidence references

- Hospital Admissions Analytics Platform legacy architecture and Azure migration proposal.
- Legacy assignment report describing the SSAS semantic layer, Excel pivot table usage, and Power BI reporting themes.
- Future evidence should include sanitized cube metadata, report catalogs, workbook examples, and screenshots or summaries of active dashboards where available.