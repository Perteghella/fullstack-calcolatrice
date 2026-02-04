#!/usr/bin/env bash
set -euo pipefail

# Avvia il servizio 2048 in background
# Assicurati che docker sia in esecuzione

docker compose -f 2048-docker-compose.yml up -d

echo "2048 avviato su http://localhost:8080"
