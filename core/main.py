import os
from time import sleep
from flask import Flask
from flask import request
from threading import Thread
from kafka import KafkaConsumer
from pymongo import MongoClient
import json

MONGO_USER = os.environ["MONGO_USER"]
MONGO_PASSWORD = os.environ["MONGO_PASSWORD"]
app = Flask(__name__)
mongo = MongoClient(f"mongodb://{MONGO_USER}:{MONGO_PASSWORD}@mongo:27017/river_watch?authSource=admin")
db = mongo["riverwatch"]
collection = db["data"]

last_readings = []

def consume_messages():
    consumer = KafkaConsumer(
        'data',
        bootstrap_servers='kafka:9092',
        group_id='flask-consumer',
        value_deserializer=lambda v: json.loads(v.decode('utf-8'))
    )

    for message in consumer:
        reading = message.value

        # add server-side timestamp
        reading['server_timestamp'] = json.loads(json.dumps(__import__('datetime').datetime.utcnow(), default=str))

        collection.insert_one(reading)
        last_readings.append(reading)

    while len(last_readings) > 1000:
        last_readings.pop(0)
@app.route('/')
def index():
    return "Riverwatch Core is running."

if __name__ == '__main__':
    print("Waiting for other services to start...(sleep 10s)")
    sleep(10)  # Wait for other services to start
    thread = Thread(target=consume_messages, daemon=True)
    thread.start()
    app.run(host='0.0.0.0', port=5000)