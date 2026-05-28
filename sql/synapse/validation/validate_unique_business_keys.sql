select admission_id, count(*) as duplicate_count
from fact_admission
group by admission_id
having count(*) > 1;
