# h3-countries
Simple Postgres dataset and functions for mapping h3 indices or coordinates to country codes.

![example-query](static/example-query.png)

## Getting Started
Setup assumes that you already have write access to a Postgres database.
1. Download the country borders dataset from [here](https://datahub.io/core/geo-countries/r/countries.geojson) [~23MB]. This GeoJSON file contains a list of polygons that define country boundaries.
2. On your Postgres server, install the `postgis` extension and `pgxnclient` extension manager if not already:
   - `sudo apt-get install postgis pgxnclient`
3. Use [`pgxn`](https://pgxn.org/) to install the [Postgres h3 bindings](https://github.com/bytesandbrains/h3-pg):
   - `pgxn install h3`
4. Create a copy of `.env.template`, call it `.env`, and configure the application with your Postgres connection URL and the path to the countries GeoJSON dataset.
5. Install dependencies:
   - `pip install -r requirements.txt`
6. Run the `load_borders.py` bootstrapping script:
   - `python load_borders.py`
   - This creates a table called `borders` with 3 columns:
     - `country_name (text)`: The full country name, e.g. `United States of America`.
     - `country_iso (text)`: The country ISO A3 code, e.g. `USA`.
     - `geometry (geometry)`: The coordinates list defining the country borders as a polygon. This enables a variety of geospatial queries via `postgis`, e.g. `ST_CONTAINS`. 

## Functions
Simple macros leverage `h3` and `postgis` extensions to enable common queries.
- `h3_to_country_iso (_h3_index text) returns text`
  - Description: Given an h3 index, returns the country ISO code that the hex centroid lies in.
  - Example Usage: `SELECT h3_to_country_iso('88a819462bfffff');` -> `BRA`.
- `h3_to_country_name (_h3_index text) returns text`
  - Description: Given an h3 index, returns the country name that the hex centroid lies in.
  - Example Usage: `SELECT h3_to_country_name('88a819462bfffff');` -> `Brazil`.
- `coordinates_to_country_iso (_latitude numeric, _longitude numeric) returns text`
  - Description: Given a coordinate pair, returns the country ISO code that the point lies in.
  - Example Usage: `SELECT coordinates_to_country_iso(24.4539, 54.3773);` -> `ARE`.
- `coordinates_to_country_name (_latitude numeric, _longitude numeric) returns text`
  - Description: Given a coordinate pair, returns the country name that the point lies in.
  - Example Usage: `SELECT coordinates_to_country_name(24.4539, 54.3773);` -> `United Arab Emirates`.
