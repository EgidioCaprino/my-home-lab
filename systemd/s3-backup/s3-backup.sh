#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID='fill-me'
export AWS_SECRET_ACCESS_KEY='fill-me'
export RESTIC_REPOSITORY='s3:https://fill-me/fill-me'
export RESTIC_PASSWORD='fill-me'

set -xe

/usr/bin/systemctl stop docker.service

FAILED=false
/usr/sbin/restic backup /var/mnt/raid/server --verbose \
  --exclude cache \
  --exclude changedetection/datastore \
  --exclude dns/data \
  --exclude jellyfin/downloads \
  --exclude navidrome/music \
  --exclude nextcloud.bak \
  --exclude transmission/downloads \
  --exclude vaultwarden/data.bak || FAILED=true

/usr/bin/systemctl start docker.service

if "${FAILED}"; then
  exit 1
fi

/usr/sbin/restic forget --keep-within 1y
