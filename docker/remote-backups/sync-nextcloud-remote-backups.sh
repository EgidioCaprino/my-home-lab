#!/bin/bash

set -xe

SOURCE_DIRECTORY="/mnt/usb/backups/nextcloud/borg"
DRIVE_MOUNTPOINT="s3://diesophe7k-backups/nextcloud"

if [ "${EUID}" -ne 0 ]; then 
  echo "Please run as root"
  exit 1
fi

if ! [ -d "${SOURCE_DIRECTORY}" ]; then
  echo "The source directory does not exist"
  exit 1
fi

if [ -z "$(ls -A "${SOURCE_DIRECTORY}/")" ]; then
  echo "The source directory is empty which is not allowed"
  exit 1
fi

if [ -f "${SOURCE_DIRECTORY}/lock.roster" ]; then
  echo "Cannot run the script as the backup archive is currently changed. Please try again later"
  exit 1
fi

if [ -f "$SOURCE_DIRECTORY/aio-lockfile" ]; then
  echo "Not continuing because aio-lockfile already exists"
  exit 1
fi

touch "${SOURCE_DIRECTORY}/aio-lockfile"
aws s3 sync "${SOURCE_DIRECTORY}" "${DRIVE_MOUNTPOINT}/" --storage-class DEEP_ARCHIVE --request-payer requester
rm "${SOURCE_DIRECTORY}/aio-lockfile"
aws s3 rm "${DRIVE_MOUNTPOINT}/aio-lockfile"

if docker ps --format "{{.Names}}" | grep "^nextcloud-aio-nextcloud$"; then
  docker exec nextcloud-aio-nextcloud bash /notify.sh "AWS S3 backup successful!" "Synced the backup repository successfully"
else
  echo "Synced the backup repository successfully"
fi
