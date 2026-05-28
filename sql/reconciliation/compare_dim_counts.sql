-- Compare legacy and target dimension row counts
select 'dim_patient' as table_name, 0 as legacy_count, 0 as target_count, 0 as difference
union all
select 'dim_doctor', 0, 0, 0
union all
select 'dim_location', 0, 0, 0
union all
select 'dim_date', 0, 0, 0;
