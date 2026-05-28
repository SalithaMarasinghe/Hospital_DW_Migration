select *
from {{ source('raw', 'admission') }}
