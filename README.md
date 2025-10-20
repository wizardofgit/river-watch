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

# How to run

## Requirements

- Docker

## Starting the app
To run the app make sure you have Docker installed and run `run.sh` script in the root folder.  
This will build the docker image and start the container.