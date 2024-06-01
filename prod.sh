#!/bin/bash

if [[ $1 == 'stop' ]]; then
    docker compose -f compose.prod.yaml down

    echo Weather app stopped
    exit 0
fi

caddy reload -c Caddyfile

echo Caddy config loaded

docker compose -f compose.prod.yaml up -d

echo Docker Compose started

echo Weather app started
