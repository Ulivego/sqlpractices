CREATE TABLE new_york_addresses (
    longitude numeric(9,6),
    latitude numeric(9,6),
    street_number text,
    street text,
    unit text,
    postcode text,
    id integer CONSTRAINT new_york_key PRIMARY KEY
);

COPY new_york_addresses
FROM '/tmp/city_of_new_york.csv'
WITH (FORMAT CSV, HEADER);

select count(*) from new_york_addresses
where street = 'BROADWAY';

-- Hash, different from normal select
create index street_indx on new_york_addresses (street);

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'BROADWAY';

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = '52 STREET';

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE';

-- Creating a B-tree index on the new_york_addresses table
CREATE INDEX street_idx ON new_york_addresses (street);
