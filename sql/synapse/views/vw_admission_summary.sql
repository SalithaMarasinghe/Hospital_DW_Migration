create view vw_admission_summary as
select admission_id, patient_key, doctor_key, location_key, date_key
from fact_admission;
