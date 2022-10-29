#!/bin/bash

docker build  --rm -f "mod-docker/Dockerfile" -t mod-docker "mod-docker"
MOD_USER=$(id -u) docker-compose up  --no-build mod-docker
