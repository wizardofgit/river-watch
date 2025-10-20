#!/bin/bash
set -e

CORE_FILE="docker-compose.core.yml"
SENSOR_FILE="docker-compose.sensors.yml"
SENSOR_COUNT=${1:-5}

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${YELLOW}Starting core services (Flask, Kafka, MongoDB)...${RESET}"
docker compose -f "$CORE_FILE" up -d

# --- Wait for Kafka ---
echo -e "${YELLOW}Waiting for Kafka to start...${RESET}"
KAFKA_READY=false
for i in {1..30}; do
  if docker exec "$(docker compose -f $CORE_FILE ps -q kafka)" bash -c "nc -z localhost 9092" >/dev/null 2>&1; then
    KAFKA_READY=true
    break
  fi
  echo "Kafka not ready yet... ($i/30)"
  sleep 2
done

if [ "$KAFKA_READY" = false ]; then
  echo -e "${RED}❌ Kafka did not start in time.${RESET}"
  exit 1
fi
echo -e "${GREEN}✅ Kafka is ready.${RESET}"

# --- Wait for Flask ---
echo -e "${YELLOW}Waiting for Flask API to respond...${RESET}"
FLASK_READY=false
for i in {1..30}; do
  if curl -s http://localhost:5000/ >/dev/null; then
    FLASK_READY=true
    break
  fi
  echo "Flask not ready yet... ($i/30)"
  sleep 2
done

if [ "$FLASK_READY" = false ]; then
  echo -e "${RED}❌ Flask API did not respond in time.${RESET}"
  exit 1
fi
echo -e "${GREEN}✅ Flask API is ready.${RESET}"

# --- Start sensors ---
echo -e "${YELLOW}Starting $SENSOR_COUNT sensor containers...${RESET}"
docker compose -f "$SENSOR_FILE" up -d --scale sensor=$SENSOR_COUNT

echo -e "${GREEN}✅ All services are up and running!${RESET}"
echo
echo "Flask API:      http://localhost:5000"
echo "MongoDB:        mongodb://localhost:27017"
echo "Kafka (internal): kafka:9092"
echo
echo -e "${YELLOW}To stop everything:${RESET}"
echo "  ./run.sh down"
echo

# --- Handle shutdown ---
if [ "$1" == "down" ]; then
  echo -e "${YELLOW}Stopping all services...${RESET}"
  docker compose -f "$SENSOR_FILE" down
  docker compose -f "$CORE_FILE" down
  echo -e "${GREEN}✅ All containers stopped and removed.${RESET}"
fi
