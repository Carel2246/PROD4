import psycopg2

def get_connection():
    return psycopg2.connect(
        host="nmiserver.postgres.database.azure.com",
        dbname="jobshopdb",
        user="myadmin",
        password="dXCwCluFm8*PYK",
        port=5432
    )