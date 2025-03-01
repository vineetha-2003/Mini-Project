###Creation_of_hour_table

create table hour_data(
Year int,
Month int,
Day int,
Hour int,
T2M float,
ALLSKY_SFC_SW_DWN float,
CLRSKY_SFC_SW_DWN float,
RH2M float,
WS10M float,
WD10M float)

select * from hour_data;
select * from hour_data;

###Peak heat analysis

select hour, avg(t2m) as 
avg_temperature
from hour_data
where hour between 12 and 16 
group by hour;

###Solar radiation

select year,month,day,hour,
ALLSKY_SFC_SW_DWN,
CLRSKY_SFC_SW_DWN
from hour_data
where hour between 12 and 16
order by year,month,day,hour;

select year,month, day,
avg(allsky_sfc_sw_dwn) as
avg_solar_radiation
from hour_data
where hour between 12 and 16
group by year,month,day
order by year,month,day;

###Wind speed patterns

select year,month,day,
max(ws10m) as max_wind_speed
from hour_data
group by year,month, day
order by year, month, day;

###Creation_of_daily_data_table

create table daily_data(
year float, month int, day int,
clrsky_sw_sfc_dwn float,
allsky_sw_sfc_dwn float,
t2m_max float, t2m_min float,
rh2m float, qv2m float,
ws10m_max float, ws10m_min float,precipitation float
)
select* from daily_data;
select* from daily_data;

### Daily Max_Min Temperatures

select  year, month, day,
t2m_max, t2m_min,
(t2m_max - t2m_min) as
temperature_range
from daily_data
order by year, month, day;

### Daily precipitation 

select year, month, day,
sum(precipitation) as total_precipitation
from daily_data
group by year, month, day
order by year, month, day;

###Daily Solar radiation diff.

select year, month, day,
clrsky_sw_sfc_dwn as clearsky_radiation,
allsky_sw_sfc_dwn as allsky_radiation,
(clrsky_sw_sfc_dwn - allsky_sw_sfc_dwn) as radiation_difference
from daily_data
order by year, month, day;

select year, month, day,
t2m_max, precipitation
from daily_data
where t2m_max > 35 or
precipitation > 50
order by year, month, day;

###Creation_of_montly_data_table

create table monthly_data(
month varchar,
rh2m float, t2m_max float,
t2m_min float, ws10m_max float,
ws10m_min float, prectotcorr_sum float,
allsky_sw_sfc_dwn float,
clrsky_sw_sfc_dwn float)
select * from monthly_data;

select* from daily_data;

###Monthly avg_temperature

select year, month,
avg((t2m_max + t2m_min)/2) as
avg_temperature
from daily_data
group by year, month
order by year, month;

###Total monthly precipitation

select year, month,
sum(precipitation) as
total_monthly_precipitation
from daily_data
group by year, month
order by year, month;

###Seasonal patterns

select month,avg(t2m_max) as 
avg_max_tempetrature,
avg(allsky_sw_sfc_dwn) as
avg_radiation
from monthly_data
where month in ('MAR', 'APR', 'MAY')
group by month;

 select * from hour_data;
 select* from daily_data;
 select* from monthly_data;

 ###Creation_of_data_view

create view combined_data as
select year, month, day,
'hourly' as source,
 t2m as temperature,
 allsky_sfc_sw_dwn as
 solar_radiation
 from hour_data 
 where hour between 12 and 16

 union all

 select year,month,day,
 'daily' as source,
  null as temperature,
  allsky_sw_sfc_dwn as
  solar_radiation
  from daily_data 

  union all

  select null as month,null as day,
  null as day,
  'monthly' as source,
  t2m_max as temperature,
  allsky_sw_sfc_dwn as
  solar_radiation
  from monthly_data;

  select * from combined_data;