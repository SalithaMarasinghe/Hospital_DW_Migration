select *
from fact_admission
where patient_key is null
   or doctor_key is null
   or location_key is null
   or date_key is null;
