CREATE TABLE natural_key_example (
    license_id text CONSTRAINT license_key PRIMARY KEY,
    first_name text,
    last_name text
);

-- We drop the table
DROP TABLE natural_key_example;

CREATE TABLE natural_key_example (
    license_id text,
    first_name text,
    last_name text,
    CONSTRAINT license_key PRIMARY KEY (license_id)
);

-- Duplicated key values
INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Gem', 'Godfrey');

INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'John', 'Mitchell');

CREATE TABLE natural_key_composite_example (
    student_id text,
    school_day date,
    present boolean,
    CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);

-- Insert Values
INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '2022-01-22', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '2022-01-23', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '2022-01-23', 'N');

CREATE TABLE licenses (
    license_id text,
    first_name text,
    last_name text,
    CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

-- Foreign keys
CREATE TABLE registrations (
    registration_id text,
    registration_date timestamp with time zone,
    license_id text REFERENCES licenses (license_id),
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Steve', 'Rothery');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '2022-03-17', 'T229901');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A75772', '2022-03-17', 'T000001');

-- Create table to check constraints
CREATE TABLE check_constraint_example (
    user_id bigint GENERATED ALWAYS AS IDENTITY,
    user_role text,
    salary numeric(10,2),
    CONSTRAINT user_id_key PRIMARY KEY (user_id),
    CONSTRAINT check_role_in_list CHECK (user_role IN('Admin', 'Staff')),
    CONSTRAINT check_salary_not_below_zero CHECK (salary >= 0)
);

INSERT INTO check_constraint_example (user_role)
VALUES ('admin');

INSERT INTO check_constraint_example (salary)
VALUES (-10000);

-- Create new table to test some more
CREATE TABLE not_null_example (
    student_id bigint GENERATED ALWAYS AS IDENTITY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

-- This wil fail
INSERT INTO not_null_example (first_name, last_name)
VALUES ('Sting', NULL);

-- Drop
ALTER TABLE not_null_example DROP CONSTRAINT student_id_key;
-- Add
ALTER TABLE not_null_example ADD CONSTRAINT student_id_key PRIMARY KEY (student_id);
-- Drop
ALTER TABLE not_null_example ALTER COLUMN first_name DROP NOT NULL;
-- Add
ALTER TABLE not_null_example ALTER COLUMN first_name SET NOT NULL;
