#!/bin/sh -e

if [ "$(hostname)" = "heatwave" || "$(hostname)" = "arcee" ]; then
    echo "Updating docker services"
    cd ~/services
    docker compose pull
    docker compose restart
fi
