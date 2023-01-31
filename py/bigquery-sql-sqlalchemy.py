from google.cloud import bigquery
from connect_connector import connect_with_connector
import sqlalchemy
import os
from datetime import date

def init_connection_pool() -> sqlalchemy.engine.base.Engine:
    # return connect_unix_socket()
    return connect_with_connector()

def create_table(db: sqlalchemy.engine.base.Engine) -> None:
    print('creating table')

    with db.connect() as conn:
        # conn.execute(
        #     "DROP table topfaults;"
        # )
        conn.execute(
            "CREATE TABLE IF NOT EXISTS topfaults(customer varchar(255),"
            "type varchar(255),mfg_unit int,unit_version float,total_fault int,"
            "fault_description varchar(255),ranking int, curdate varchar(255));"
        )

def transfer_data(db: sqlalchemy.engine.base.Engine) -> None:
    project_id = os.environ["PROJECT_ID"]
    # Get the data from the BigQuery table
    bigquery_client = bigquery.Client()
    query = ("with fault_report as (select p.customer,p.type,p.mfg_unit,p.unit_version,"
    " sum(f.total_fault) as total_fault,f.fault_description from `(%d).Manufacturernew.fault_detection` f,"
    "`(%d).Manufacturernew.product_info` p where f.mfg_month=p.mfg_month and f.customer=p.customer "
    "group by customer, type,mfg_unit, unit_version, fault_description)"
    "select *, RANK() OVER (ORDER BY total_fault DESC) AS ranking "
    "from fault_report order by ranking asc limit 3" % project_id)
    query = bigquery_client.query(query)
    query_results = query.result()

    with db.connect() as conn:
        for row in query_results:
            print(row)
            conn.execute("INSERT INTO topfaults(customer,type, mfg_unit, unit_version,"
                         " total_fault,fault_description,ranking,curdate )"
                         " VALUES ({},{},{},{},{},{},{},{})".format(str("'"+row[0]+"'"),
                         str("'"+row[1]+"'"),row[2],row[3],row[4],
                         str("'"+row[5]+"'"),row[6],date.today() ))

if __name__ == "__main__":
    print('main')
    global db;
    db = init_connection_pool()
    create_table(db)
    transfer_data(db)
