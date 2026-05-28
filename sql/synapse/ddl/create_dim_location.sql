create table if not exists dim_location (
  location_key int,
  location_id int,
  province_id varchar(50),
  province_name varchar(100),
  city varchar(100)
);
