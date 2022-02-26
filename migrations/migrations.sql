DROP TABLE IF EXISTS public.borders;

CREATE TABLE public.borders
(
    country_name text,
    country_iso text NOT NULL,
    geometry geometry
);

CREATE EXTENSION IF NOT EXISTS h3;
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE OR REPLACE FUNCTION h3_to_country_iso (_h3_index text)
returns text AS
    $func$
    SELECT country_iso FROM borders
    WHERE ST_Contains(geometry,
            ST_SetSRID(h3_to_geo(_h3_index::h3index)::geometry, 4326)
    );
    $func$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION h3_to_country_name (_h3_index text)
returns text AS
    $func$
    SELECT country_name FROM borders
    WHERE ST_Contains(geometry,
            ST_SetSRID(h3_to_geo(_h3_index::h3index)::geometry, 4326)
    );
    $func$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION coordinates_to_country_iso (_latitude numeric, _longitude numeric)
returns text AS
    $func$
    SELECT country_iso FROM borders
    WHERE ST_Contains(geometry,
            ST_SetSRID(ST_MakePoint(_longitude, _latitude)::geometry, 4326)
    );
    $func$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION coordinates_to_country_name (_latitude numeric, _longitude numeric)
returns text AS
    $func$
    SELECT country_name FROM borders
    WHERE ST_Contains(geometry,
            ST_SetSRID(ST_MakePoint(_longitude, _latitude)::geometry, 4326)
    );
    $func$ LANGUAGE sql;