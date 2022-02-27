import json
import sqlalchemy.exc
from sqlalchemy import create_engine
from sqlalchemy.sql import text
from dotenv import load_dotenv
import os

print("Running migrations...")

load_dotenv()

conn = create_engine(os.getenv("POSTGRES_URL"))

with open("static/countries.geojson") as f:
    countries = json.load(f)

file = open("migrations/migrations.sql")
query = text(file.read())

conn.execute(query)

for country in countries["features"]:
    try:
        if country['properties']['ISO_A2']:
            sql = f"INSERT INTO borders (country_name, country_iso_a3, country_iso_a2, numeric_code, geometry) " \
                  f"VALUES ('{country['properties']['ADMIN']}', '{country['properties']['ISO_A3']}', " \
                  f"'{country['properties']['ISO_A2']}', {country['properties']['numeric_code']}, " \
                  f"st_geomfromgeojson('{json.dumps(country['geometry'])}'));"
            conn.execute(sql)
    except sqlalchemy.exc.IntegrityError:
        pass

print("done.")