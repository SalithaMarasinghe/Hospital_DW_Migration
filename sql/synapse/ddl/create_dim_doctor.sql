create table if not exists dim_doctor (
  doctor_key int,
  attending_doctor_id int,
  doctor_first_name varchar(100),
  doctor_last_name varchar(100)
);
