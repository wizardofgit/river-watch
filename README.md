# river-watch
Ready to deploy app that simulates full infrastructure to monitor river parameters 

# Technology Stack  
The app is shipped as an ready-to-run image that can be initiated in Docker. It consists of:  
- flask server (frontend + backend)
- kafka (for communication between sensors and server)
- kubernetes (for simulating adding/dropping sensors)
- sensors simulator (as containerized python script)

# Functionality  
The system can be managed through a frontend provided by the flask server. The functionalities include:  
- overview of graphs and statistics for montioring purposes
- sensors overview (how many, recent updates, status)
- upscaling/downscaling number of sensors
- river status watcher (e.g. polluted, high water levels)

# Communication  
The communication is via Kafka topics:
- **data-topic** that provides readings from sensors
- **control-topic** that provides control of pods (sensors) through the frontend
