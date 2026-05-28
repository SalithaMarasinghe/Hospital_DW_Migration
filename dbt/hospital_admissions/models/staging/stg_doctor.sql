select *
from {{ source('raw', 'doctor') }}
