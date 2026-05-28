select *
from {{ source('raw', 'location') }}
