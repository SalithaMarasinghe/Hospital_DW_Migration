create table if not exists fact_admission (
  admission_key int,
  admission_id int,
  patient_key int,
  doctor_key int,
  location_key int,
  date_key int,
  admission_date date,
  discharge_date date,
  txn_complete_time_hours decimal(10,2)
);
