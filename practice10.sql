-- Cross tabulations
-- Install the crosstab() function via the tablefunc module
CREATE EXTENSION tablefunc;

-- Listing 13-16: Creating and filling the ice_cream_survey table
CREATE TABLE ice_cream_survey (
    response_id integer PRIMARY KEY,
    office text,
    flavor text
);

COPY ice_cream_survey
FROM '/tmp/ice_cream_survey.csv'
WITH (FORMAT CSV, HEADER);

-- view the data
SELECT * 
FROM ice_cream_survey
ORDER BY response_id
LIMIT 5;

-- Listing 13-17: Generating the ice cream survey crosstab
SELECT *
FROM crosstab('SELECT office,
                      flavor,
                      count(*)
               FROM ice_cream_survey
               GROUP BY office, flavor
               ORDER BY office',

              'SELECT flavor
               FROM ice_cream_survey
               GROUP BY flavor
               ORDER BY flavor')

AS (office text,
    chocolate bigint,
    strawberry bigint,
    vanilla bigint);
	
-- Listing 13-18: Creating and filling a temperature_readings table
CREATE TABLE temperature_readings (
    station_name text,
    observation_date date,
    max_temp integer,
    min_temp integer,
    CONSTRAINT temp_key PRIMARY KEY (station_name, observation_date)
);

COPY temperature_readings
FROM '/tmp/temperature_readings.csv'
WITH (FORMAT CSV, HEADER);

-- Listing 13-19: Generating the temperature readings crosstab
SELECT *
FROM crosstab('SELECT
                  station_name,
                  date_part(''month'', observation_date),
                  percentile_cont(.5)
                      WITHIN GROUP (ORDER BY max_temp)
               FROM temperature_readings
               GROUP BY station_name,
                        date_part(''month'', observation_date)
               ORDER BY station_name',

              'SELECT month
               FROM generate_series(1,12) month')

AS (station text,
    jan numeric(3,0),
    feb numeric(3,0),
    mar numeric(3,0),
    apr numeric(3,0),
    may numeric(3,0),
    jun numeric(3,0),
    jul numeric(3,0),
    aug numeric(3,0),
    sep numeric(3,0),
    oct numeric(3,0),
    nov numeric(3,0),
    dec numeric(3,0)
);
