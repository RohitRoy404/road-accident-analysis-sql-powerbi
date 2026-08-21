CREATE DATABASE us_accidents;
         USE us_accidents;
         SELECT COUNT(*) FROM accidents_clean;

CREATE TABLE accident_raw (
    ID VARCHAR(20),
    Source VARCHAR(20),
    Severity INT,
    Start_Time DATETIME,
    End_Time DATETIME,
    Start_Lat DECIMAL(10,6),
    Start_Lng DECIMAL(10,6),
    End_Lat DECIMAL(10,6),
    End_Lng DECIMAL(10,6),
    Distance DECIMAL(10,2),
    Description TEXT,
    Street VARCHAR(255),
    City VARCHAR(100),
    County VARCHAR(100),
    State VARCHAR(10),
    Zipcode VARCHAR(20),
    Country VARCHAR(10),
    Timezone VARCHAR(50),
    Airport_Code VARCHAR(10),
    Weather_Timestamp DATETIME,
    Temperature DECIMAL(5,2),
    Wind_Chill DECIMAL(5,2),
    Humidity DECIMAL(5,2),
    Pressure DECIMAL(5,2),
    Visibility DECIMAL(5,2),
    Wind_Direction VARCHAR(20),
    Wind_Speed DECIMAL(5,2),
    Precipitation DECIMAL(5,2),
    Weather_Condition VARCHAR(100),
    Amenity BOOLEAN,
    Bump BOOLEAN,
    Crossing BOOLEAN,
    Give_Way BOOLEAN,
    Junction BOOLEAN,
    No_Exit BOOLEAN,
    Railway BOOLEAN,
    Roundabout BOOLEAN,
    Station BOOLEAN,
    Stop BOOLEAN,
    Traffic_Calming BOOLEAN,
    Traffic_Signal BOOLEAN,
    Turning_Loop BOOLEAN,
    Sunrise_Sunset VARCHAR(10),
    Civil_Twilight VARCHAR(10),
    Nautical_Twilight VARCHAR(10),
    Astronomical_Twilight VARCHAR(10)
);
ALTER TABLE accident_raw MODIFY Temperature DECIMAL(5,2);
ALTER TABLE accident_raw MODIFY Visibility DECIMAL(5,2);
ALTER TABLE accident_raw MODIFY Weather_condition VARCHAR(100);
DESCRIBE accident_raw;

DROP TABLE accident_raw;

LOAD DATA LOCAL INFILE 'E:/US_Accidents_sample.csv'
INTO TABLE accident_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'local_infile'; -- this will show if local infile on or not
SET GLOBAL local_infile=1; -- first we need to on this

SELECT * FROM accident_raw;
SELECT COUNT(*) FROM accident_raw;
