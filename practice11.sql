-- Case formatting
SELECT upper('Neal7');
SELECT lower('Randy');
SELECT initcap('at the end of the day');
-- Note initcap's imperfect for acronyms
SELECT initcap('Practical SQL');

-- Character Information
SELECT char_length(' Pat ');
SELECT length(' Pat ');
SELECT position(', ' in 'Tan, Bella');

-- Removing characters
SELECT trim('s' from 'socks');
SELECT trim(trailing 's' from 'socks');
SELECT trim(' Pat ');
SELECT char_length(trim(' Pat ')); -- note the length change
SELECT ltrim('socks', 's');
SELECT rtrim('socks', 's');

-- Extracting and replacing characters
SELECT left('703-555-1212', 3);
SELECT right('703-555-1212', 8);
SELECT replace('bat', 'b', 'c');

-- Listing 14-1: Using regular expressions in a WHERE clause
SELECT county_name
FROM us_counties_pop_est_2019
WHERE county_name ~* '(lade|lare)'
ORDER BY county_name;

SELECT county_name
FROM us_counties_pop_est_2019
WHERE county_name ~* 'ash' AND county_name !~ 'Wash'
ORDER BY county_name;

-- Listing 14-2: Regular expression functions to replace and split text
SELECT regexp_replace('05/12/2024', '\d{4}', '2023');

SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');

SELECT regexp_split_to_array('Phil Mike Tony Steve', ' ');

-- Listing 14-3: Finding an array length
SELECT array_length(regexp_split_to_array('Phil Mike Tony Steve', ' '), 1);

-- Listing 14-5: Creating and loading the crime_reports table
-- Data from https://sheriff.loudoun.gov/dailycrime
CREATE TABLE crime_reports (
    crime_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    case_number text,
    date_1 timestamptz,  -- note: this is the PostgreSQL shortcut for timestamp with time zone
    date_2 timestamptz,  -- note: this is the PostgreSQL shortcut for timestamp with time zone
    street text,
    city text,
    crime_type text,
    description text,
    original_text text NOT NULL
);

COPY crime_reports (original_text)
FROM 'C:\YourDirectory\crime_reports.csv'
WITH (FORMAT CSV, HEADER OFF, QUOTE '"');

SELECT original_text FROM crime_reports;

-- Listing 14-6: Using regexp_match() to find the first date
SELECT crime_id,
       regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports
ORDER BY crime_id;

-- Listing 14-7: Using the regexp_matches() function with the 'g' flag
SELECT crime_id,
       regexp_matches(original_text, '\d{1,2}\/\d{1,2}\/\d{2}', 'g')
FROM crime_reports
ORDER BY crime_id;

-- Listing 14-8: Using regexp_match() to find the second date
-- Note that the result includes an unwanted hyphen
SELECT crime_id,
       regexp_match(original_text, '-\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports
ORDER BY crime_id;

-- Listing 14-9: Using a capture group to return only the date
-- Eliminates the hyphen
SELECT crime_id,
       regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})')
FROM crime_reports
ORDER BY crime_id;
