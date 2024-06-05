#!/bin/bash

if [[ ! -f 'owm-appid.txt' ]]; then
    echo 'Warning: remember to save the OpenWeatherMap API key to the file "owm-appid.txt"'
fi

if [[ $1 = 'build' ]]; then
    docker compose -f compose.dev.yaml build --no-cache
fi

docker compose -f compose.dev.yaml up
