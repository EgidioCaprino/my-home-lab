#!/bin/bash

set -xe

SOURCE_DIRECTORY="/home/egidio/docker/photoprism"
DRIVE_MOUNTPOINT="s3://diesophe7k-backups/photoprism"

if ! [ -d "${SOURCE_DIRECTORY}" ]; then
  echo "The source directory does not exist"
  exit 1
fi

if [ -z "$(ls -A "${SOURCE_DIRECTORY}/")" ]; then
  echo "The source directory is empty which is not allowed"
  exit 1
fi

if [ -f "$SOURCE_DIRECTORY/lockfile" ]; then
  echo "Not continuing because lockfile already exists"
  exit 1
fi

touch "${SOURCE_DIRECTORY}/lockfile"
aws s3 sync "${SOURCE_DIRECTORY}" "${DRIVE_MOUNTPOINT}/" --storage-class DEEP_ARCHIVE --request-payer requester
rm "${SOURCE_DIRECTORY}/lockfile"
aws s3 rm "${DRIVE_MOUNTPOINT}/lockfile"

echo "Synced the backup repository successfully"

curl -m 10 --retry 5 https://hc-ping.com/fa24df64-4c1a-4aa0-a356-5635ffe88beb
