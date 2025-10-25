#!/bin/bash
set -e  # exit on first error

COMPOSE_FILES="-f docker-compose.core.yaml -f docker-compose.sensors.yaml"

PERSISTENT=false

# Parse optional flags (supports -p or --persistent anywhere before the command)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--persistent)
      PERSISTENT=true
      shift
      ;;
    up|down|restart)
      # command found; stop flag parsing
      break
      ;;
    *)
      # unknown token (could be empty or invalid), stop parsing
      break
      ;;
  esac
done

COMMAND="${1:-up}"

case "$COMMAND" in
  ""|"up")
    echo "🚀 Starting River-watch stack (core + sensors)..."
    docker compose $COMPOSE_FILES up -d --remove-orphans
    if $PERSISTENT; then
      echo "🔒 Persistent mode enabled: volumes/data will be preserved."
    fi
    echo "✅ All services are up and running."
    ;;
  "down")
    echo "🛑 Stopping River-watch stack..."
    if $PERSISTENT; then
      docker compose $COMPOSE_FILES down
    else
      docker compose $COMPOSE_FILES down -v
    fi
    echo "✅ All services stopped and removed."
    ;;
  "restart")
    echo "🔄 Restarting River-watch stack..."
    if $PERSISTENT; then
      docker compose $COMPOSE_FILES down
    else
      docker compose $COMPOSE_FILES down -v
    fi
    sleep 3
    docker compose $COMPOSE_FILES up -d --remove-orphans
    echo "✅ Stack restarted successfully."
    ;;
  *)
    echo "Usage: $0 [-p|--persistent] [up|down|restart]"
    exit 1
    ;;
esac