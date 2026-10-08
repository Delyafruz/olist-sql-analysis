import os
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

url = URL.create(
    "postgresql+psycopg2",
    username="postgres",
    password=os.environ["PGPASSWORD"],
    host="localhost",
    port=5432,
    database="olist",
)
engine = create_engine(url)

files = {
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "products": "olist_products_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "category_translation": "product_category_name_translation.csv",
}

date_cols = {
    "orders": [
        "order_purchase_timestamp", "order_approved_at",
        "order_delivered_carrier_date", "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ]
}

for table, filename in files.items():
    df = pd.read_csv(f"data/{filename}", parse_dates=date_cols.get(table, []))
    df.to_sql(table, engine, if_exists="replace", index=False)
    print(f"{table}: {len(df)} строк загружено")