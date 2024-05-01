#!/usr/bin/env bash

set -xe

images=("nextcloud/all-in-one:latest" "vaultwarden/server:latest" "tombursch/kitchenowl:latest" "tombursch/kitchenowl-web:latest" "lscr.io/linuxserver/transmission:latest" "jellyfin/jellyfin:latest" "ghcr.io/dgtlmoon/changedetection.io:latest" "lscr.io/linuxserver/grocy:latest" "ghcr.io/paperless-ngx/paperless-ngx:latest" "portainer/portainer-ee:latest" "photoprism/photoprism:latest" "caddy:2")

for image in "${images[@]}"; do
    docker image pull "${image}"
done

docker compose down --remove-orphans
docker compose up --detach
docker image prune --all --force
