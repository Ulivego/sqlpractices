--Create the us_counties_pop_est_2019 table
CREATE TABLE us_counties_pop_est_2019 (
    state_fips text,                         -- State FIPS code
    county_fips text,                        -- County FIPS code
    region smallint,                         -- Region
    state_name text,                         -- State name	
    county_name text,                        -- County name
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                       -- Area (Water) in square meters
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)
    pop_est_2018 integer,                    -- 2018-07-01 resident total population estimate
    pop_est_2019 integer,                    -- 2019-07-01 resident total population estimate
    births_2019 integer,                     -- Births from 2018-07-01 to 2019-06-30
    deaths_2019 integer,                     -- Deaths from 2018-07-01 to 2019-06-30
    international_migr_2019 integer,         -- Net international migration from 2018-07-01 to 2019-06-30
    domestic_migr_2019 integer,              -- Net domestic migration from 2018-07-01 to 2019-06-30
    residual_2019 integer,                   -- Residual for 2018-07-01 to 2019-06-30
    CONSTRAINT counties_2019_key PRIMARY KEY (state_fips, county_fips)	
);

--Copy from the folder we created
COPY us_counties_pop_est_2019
FROM '/tmp/us_counties_pop_est_2019.csv'
WITH (FORMAT CSV, HEADER);

--Select everything
SELECT * FROM us_counties_pop_est_2019;

--Create table supervisor_salaries
CREATE TABLE supervisor_salaries (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    town text,
    county text,
    supervisor text,
    start_date text,
    salary numeric(10,2),
    benefits numeric(10,2)
);

--Copy supervisor_salaries from the folder
COPY supervisor_salaries (town, supervisor, salary)
FROM '/tmp/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;

--Using temporary table to add default value to a column
DELETE FROM supervisor_salaries;

CREATE TEMPORARY TABLE supervisor_salaries_temp 
    (LIKE supervisor_salaries INCLUDING ALL);
	
COPY supervisor_salaries_temp (town, supervisor, salary)
FROM '/tmp/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Mills', supervisor, salary
FROM supervisor_salaries_temp;

DROP TABLE supervisor_salaries_temp;

--Check data
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;

--Exporting a whole table using COPY
COPY us_counties_pop_est_2019
TO '/tmp/us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

--Exporting selected columns from a table using COPY
COPY us_counties_pop_est_2019 
    (county_name, internal_point_lat, internal_point_lon)
TO '/tmp/us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

--Exporting the query results with COPY
COPY (
    SELECT county_name, state_name
    FROM us_counties_pop_est_2019
    WHERE county_name ILIKE '%mill%'
     )
TO '/tmp/us_counties_mill_export.csv'
WITH (FORMAT CSV, HEADER);

--Command to save it in normal path and not in tmp
cp /tmp/us_counties_latlon_export.txt ./
