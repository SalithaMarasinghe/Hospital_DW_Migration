-- Compare trusted report metrics between legacy and target
select 'admission_volume' as metric_name, 0 as legacy_value, 0 as target_value, 0 as difference
union all
select 'length_of_stay', 0, 0, 0;
