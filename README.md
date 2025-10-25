# river-watch
Ready to deploy app that simulates full infrastructure to monitor river parameters 

## Technology Stack  
The app is shipped as a ready-to-run image that can be initiated in Docker. It consists of:  
- flask server (frontend + backend)
- kafka (for communication between sensors and server)
- docker compose (for simulating adding/dropping sensors)
- sensors simulator (as containerized python script)
- mongo db (for storing older sensor data)

## Functionality  
The system can be managed through a frontend provided by the flask server. The functionalities include:  
- overview of graphs and statistics for monitoring purposes
- sensors overview (how many, recent updates, status)
- upscaling/downscaling number of sensors
- river status watcher (e.g. polluted, high water levels)
- historical data viewer (from mongo db)

## Communication  
The communication is via Kafka topics:
- **data-topic** that provides readings from sensors
- **control-topic** that provides control of pods (sensors) through the frontend

## Routing
The app can be accessed at `http://localhost:5000` after starting the docker container.  
The Kafka broker is accessible at `localhost:9092`.
The MongoDB is accessible at `localhost:27017`. Mongo Express is accessible at `http://localhost:8081`.  
Redpanda is accessible at `http://localhost:8083`.

## Data persistence
All data is deleted when container is stopped as default. To persist data, 
run `./run.sh -p` or `./run.sh --persistent` which will create local folders for MongoDB and Kafka data.

# How to run

## Requirements

- Docker

## Starting the app
To run the app make sure you have Docker installed and run `run.sh` script in the root folder.  
This will build the docker image and start the container.  
To stop the app, run `./run.sh down`.

If using Windows, the script must be run using WSL (Windows Subsystem for Linux).  

It can also be run by `./run.sh restart`, that will stop any running containers and start a new one.  

Running the app with flag `-p` or `--persistent` will start the app with data persistence enabled, e.g.
`./run.sh -p restart`.