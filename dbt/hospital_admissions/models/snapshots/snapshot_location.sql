{% snapshot snapshot_location %}
{{ config(target_schema='snapshots', unique_key='location_id', strategy='timestamp', updated_at='updated_at') }}
select * from {{ ref('stg_location') }}
{% endsnapshot %}
