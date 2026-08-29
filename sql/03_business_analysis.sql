-- Analysis Part

-- What is: Total accidents and Average accident duration

SELECT COUNT(ID),AVG(accident_duration_minutes) FROM accidents_clean;
-- 500000	40.2577
 
 -- Which hour of the day has the most accidents?
 SELECT accident_hour,COUNT(ID) AS accident_count FROM accidents_clean GROUP BY accident_hour ORDER BY accident_count DESC LIMIT 1 ;
 
 select * FROM accidents_clean;
 SELECT accident_hour,COUNT(id) FROM accidents_clean GROUP BY accident_hour  ORDER BY COUNT(id) DESC;
 
 -- Do more accidents happen during Day or Night?
  SELECT sunrise_sunset,COUNT(ID) AS accident_count FROM accidents_clean GROUP BY sunrise_sunset ORDER BY accident_count DESC  ;
  UPDATE accidents_clean
  
SET Sunrise_Sunset = NULL
WHERE Sunrise_Sunset = '';

-- Which 10 cities have the most accidents?
  SELECT  City,COUNT(ID) AS accident_count FROM accidents_clean GROUP BY City ORDER BY accident_count DESC  LIMIT 10;
  
-- Which 10 states have the most accidents?
  SELECT  State,COUNT(ID) AS accident_count FROM accidents_clean GROUP BY State ORDER BY accident_count DESC  LIMIT 10;

-- Top 10 weather conditions with the most accidents
  SELECT  Weather_condition,COUNT(ID) AS accident_count FROM accidents_clean GROUP BY Weather_condition ORDER BY accident_count DESC  LIMIT 10;

-- Which weather condition has the most severe accidents (Severity = 4)?
  SELECT  Weather_condition,COUNT(ID) FROM accidents_clean WHERE Severity = 4 GROUP BY Weather_condition ORDER BY COUNT(ID) DESC;

-- Average accident duration by severity
  SELECT   Severity,AVG(accident_duration_minutes) FROM accidents_clean  GROUP BY Severity;

-- Which days of the week have the most accidents?
  SELECT  DAYNAME(STart_Time),COUNT(ID) FROM accidents_clean  GROUP BY DAYNAME(STart_TIme) ORDER BY COUNT(ID) DESC;

-- Which months have the most accidents?
  SELECT  accident_month,COUNT(ID) FROM accidents_clean  GROUP BY accident_month ORDER BY COUNT(ID) DESC;


-- Which weather conditions cause the longest table disruption?
SELECT weather_condition,ROUND(AVG(accident_duration_minutes),2) FROM accidents_clean WHERE weather_condition IS NOT NULL
GROUP BY weather_condition
ORDER BY ROUND(AVG(accident_duration_minutes),2) DESC;


-- Accident trend by year
SELECT * FROM accidents_clean;
SELECT accident_year,COUNT(id) FROM accidents_clean GROUP BY accident_year ORDER BY COUNT(id) DESC;

-- Accident severity by time of day
SELECT
    accident_hour,
    Severity,
    COUNT(ID) AS accident_count
FROM accidents_clean
GROUP BY accident_hour, Severity
ORDER BY accident_hour, Severity;

-- Accident distribution by visibility
SELECT
    Visibility,
    COUNT(ID) AS accident_count
FROM accidents_clean
WHERE Visibility IS NOT NULL
GROUP BY Visibility
ORDER BY accident_count DESC;
