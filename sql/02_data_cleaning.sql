-- Checking Duplicates

SELECT * FROM (
SELECT *,ROW_NUMBER() OVER(PARTITION BY
        ID ORDER BY City DESC)  AS rn FROM accident_raw)t WHERE rn=2; -- No duplicates Found


-- Null Checking 
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END)AS sum_ids,
    SUM(CASE WHEN Severity IS NULL THEN 1 ELSE 0 END) AS severity_nulls,
    SUM(CASE WHEN Start_Time IS NULL THEN 1 ELSE 0 END) AS start_time_nulls,
    SUM(CASE WHEN End_Time IS NULL THEN 1 ELSE 0 END) AS end_time_nulls,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS state_nulls,
    SUM(CASE WHEN Temperature IS NULL THEN 1 ELSE 0 END) AS temp_nulls,
    SUM(CASE WHEN Visibility IS NULL THEN 1 ELSE 0 END) AS visibility_nulls,
    SUM(CASE WHEN Weather_Condition IS NULL THEN 1 ELSE 0 END) AS weather_nulls
FROM accident_raw;

SET SQL_SAFE_UPDATES=0;
-- UPDATE accident_raw SET Temperature=NULL WHERE Temperature="unknown";
-- UPDATE accident_raw SET Visibility=NULL WHERE Visibility="unknown";
-- UPDATE accident_raw SET Weather_Condition=NULL WHERE Weather_Condition="unknown";




-- Negative Check 
SELECT MAX(Distance),MIN(Distance) FROM accident_raw;
SELECT Distance FROM accident_raw WHERE Distance<0;	

-- Temperature check
SELECT * FROM accident_raw WHERE Temperature> 130 OR Temperature< -50;
UPDATE accident_raw SET Temperature =NULL WHERE  Temperature> 130 OR Temperature< -50;

-- Humidity check 
SELECT MAX(Humidity),MIN(Humidity) FROM accident_raw;
SELECT * FROM accident_raw;

-- Visibility Check 
SELECT MAX(Visibility),MIN(Visibility) FROM accident_raw;
UPDATE accident_raw SET Visibility =NULL WHERE Visibility>50; 

-- wind speed 
SELECT MAX(Wind_speed),MIN(Wind_speed) FROM accident_raw;
SELECT COUNT(Wind_speed) FROM accident_raw WHERE Wind_speed>150;
UPDATE accident_raw SET Wind_speed =NULL WHERE  Wind_speed>150;


-- Atmospheric pressure check table
SELECT MAX(Pressure),MIN(Pressure) FROM accident_raw;
SELECT COUNT(Pressure) FROM accident_raw WHERE Pressure=0.00;
UPDATE accident_raw SET Pressure= NULL WHERE Pressure=0.00;

-- Precipitation Validation
 SELECT MIN(Precipitation), MAX(Precipitation) FROM accident_raw;
 SELECT COUNT(Precipitation) FROM accident_raw WHERE Precipitation>5;
 
 -- Distance Duration
  WITH CTE AS (
 SELECT TIMESTAMPDIFF(MINUTE,Start_Time,End_Time) AS Duration FROM accident_raw )
 SELECT COUNT(Duration) FROM CTE WHERE Duration>1440;
 
 SELECT COUNT(*) FROM accident_raw WHERE Start_Time=End_Time;
 
 -- Geographic Validation
 
 SELECT MAX(Start_Lat),MIN(Start_lat),MAX(Start_Lng),MIN(Start_Lng) FROM accident_raw;
 SELECT MIN(End_Lat),MAX(End_Lat),MIN(End_Lng),MAX(End_Lng) FROM accident_raw;
 UPDATE accident_raw SET End_lat=NULL WHERE End_lat=0;
  UPDATE accident_raw SET End_lng=NULL WHERE End_lng=0;
  
  
-- Boolean Infrastructure Columns Validation (seeing if there other than 0 and 1 )
SELECT
MIN(Amenity) AS min_amenity, MAX(Amenity) AS max_amenity,
MIN(Bump) AS min_bump, MAX(Bump) AS max_bump,
MIN(Crossing) AS min_crossing, MAX(Crossing) AS max_crossing,
MIN(Give_Way) AS min_give_way, MAX(Give_Way) AS max_give_way,
MIN(Junction) AS min_junction, MAX(Junction) AS max_junction,
MIN(No_Exit) AS min_no_exit, MAX(No_Exit) AS max_no_exit,
MIN(Railway) AS min_railway, MAX(Railway) AS max_railway,
MIN(Roundabout) AS min_roundabout, MAX(Roundabout) AS max_roundabout,
MIN(Station) AS min_station, MAX(Station) AS max_station,
MIN(Stop) AS min_stop, MAX(Stop) AS max_stop,
MIN(Traffic_Calming) AS min_traffic_calming, MAX(Traffic_Calming) AS max_traffic_calming,
MIN(Traffic_Signal) AS min_traffic_signal, MAX(Traffic_Signal) AS max_traffic_signal,
MIN(Turning_Loop) AS min_turning_loop, MAX(Turning_Loop) AS max_turning_loop
FROM accident_raw;

SELECT COUNT(*) 
FROM accident_raw 
WHERE Junction = 1;


-- Blank Check(space Check)
-- City
SELECT DISTINCT City FROM accident_raw  WHERE City="";
UPDATE accident_raw SET City=TRIM(City);

-- State
SELECT DISTINCT State FROM accident_raw;

-- weather_condition
SELECT  COUNT(*) FROM accident_raw WHERE Weather_Condition="";
UPDATE accident_raw SET Weather_Condition=NULL WHERE Weather_Condition="";

-- sunrise
SELECT DISTINCT Sunrise_Sunset FROM accident_raw;

-- Timezone
SELECT COUNT( Timezone) FROM accident_raw WHERE Timezone="";
UPDATE accident_raw SET Timezone=NULL WHERE Timezone="";

SELECT COUNT(*)
FROM accident_raw
WHERE Weather_Timestamp <= '1000-01-01';

UPDATE accident_raw
SET Weather_Timestamp = NULL
WHERE Weather_Timestamp <= '1000-01-01';

-- ZIpcode
SELECT DISTINCT Zipcode FROM accident_raw;
SELECT COUNT(zipcode) FROM accident_raw WHERE Zipcode="";
SELECT COUNT(zipcode) FROM accident_raw WHERE Zipcode IS NULL;
SELECT COUNT(zipcode) FROM accident_raw WHERE CHAR_LENGTH(zipcode)>5;


UPDATE accident_raw SET Zipcode=NULL WHERE Zipcode="";


-- Data Understanding / Feature Preparation

SELECT YEAR(Start_Time) FROM accident_raw;
SELECT MONTH(Start_Time) FROM accident_raw;
SELECT HOUR(Start_Time) FROM accident_raw;



CREATE TABLE accidents_clean AS
SELECT 
    *,
    YEAR(Start_Time) AS accident_year,
    MONTH(Start_Time) AS accident_month,
    HOUR(Start_Time) AS accident_hour,
    TIMESTAMPDIFF(MINUTE, Start_Time, End_Time) AS accident_duration_minutes
FROM accident_raw;

SELECT * FROM accidents_clean;

SELECT 
MIN(accident_duration_minutes),
MAX(accident_duration_minutes)
FROM accidents_clean;
