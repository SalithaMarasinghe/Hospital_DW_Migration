# Report Mapping

## Purpose
This document defines the report scope that must be validated against the legacy system during parity testing. The report list below represents the business-facing outputs that need to match the trusted legacy experience before production cutover.

## Scope
The hospital admissions analytics platform currently serves executives, operations managers, finance analysts, and department heads. The reports below are the minimum set to validate because they reflect the core business questions already described in the legacy solution and target-state architecture. These reports focus on admissions, discharge trends, doctor performance, regional demand, and throughput metrics.

## Legacy Validation Scope
The following reports must be compared against the legacy system as part of parity testing:

### 1. Admission Volume Trend
Validates total admissions over time by day, month, and year. This report confirms that time-based aggregation, date handling, and trend logic are preserved.

### 2. Admission Volume by Doctor
Validates admission counts by attending doctor. This report confirms that doctor dimension mapping and measure totals match the legacy system.

### 3. Admission Volume by Specialty
Validates admissions grouped by doctor specialty. This report confirms that specialty attribution and rollups are consistent.

### 4. Admission Volume by Location
Validates admissions by province and city. This report confirms that the location hierarchy and location-level reporting are preserved.

### 5. Regional Demand Analysis
Validates patient home-location demand patterns. This report confirms that the geographic analysis used by management remains unchanged.

### 6. Discharge Trend Report
Validates discharge counts and discharge timing over time. This report confirms that discharge-related measures match the legacy outputs.

### 7. Length of Stay Report
Validates length-of-stay metrics for admissions. This report confirms that duration calculations and date logic are correct.

### 8. Doctor Performance Report
Validates performance indicators by doctor, including admission volume and related operational measures. This report confirms that the business logic used to evaluate doctors is preserved.

### 9. Drill-through Admission Detail
Validates record-level drill-through from summary visuals into admission-level detail. This report confirms that the target model supports the same navigation and detail fidelity as the legacy system.

### 10. Executive Summary Dashboard
Validates the top-level KPI view used by leadership. This report confirms that the headline metrics shown to executives remain aligned with trusted historical outputs.

## Parity Rules
Each report must be validated for the following:
- Total row counts where applicable.
- Aggregated metrics and totals.
- Filter behavior and slicer behavior.
- Date hierarchy behavior.
- Dimension-level grouping results.
- Drill-through or detail-level consistency, where applicable.

## Acceptance Criteria
A report is considered parity-approved when:
- The target output matches the legacy output for the agreed comparison period.
- Any differences are documented, explained, and approved.
- Business owners confirm that the report behavior is acceptable.
- The report uses approved business definitions from the target-state ADRs.

## Notes
This mapping intentionally focuses on the reports that matter for cutover and stabilization. If additional reports are introduced later, they must be added here before they are included in parity testing.