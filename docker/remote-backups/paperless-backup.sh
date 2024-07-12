#!/usr/bin/env bash

REPOSITORY=/mnt/usb/backups/paperless
BACKUP_SOURCE=/home/egidio/docker/paperless
export BORG_PASSPHRASE="Wiek7fohthoo5wahm2ud"
ARCHIVE_NAME="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
DRIVE_MOUNTPOINT="s3://diesophe7k-backups/paperless"
LOCKFILE="/tmp/paperless-backup.lock"

if [ -f "${LOCKFILE}" ]; then
  echo "Not continuing because lockfile already exists"
  exit 1
fi

touch "${LOCKFILE}"

borg create --verbose --stats --compression lz4 "${REPOSITORY}::${ARCHIVE_NAME}" "${BACKUP_SOURCE}"
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=6 "${REPOSITORY}"

unset BORG_PASSPHRASE

aws s3 sync "${REPOSITORY}" "${DRIVE_MOUNTPOINT}/" --storage-class DEEP_ARCHIVE --request-payer requester
rm "${LOCKFILE}"

echo "Synced the backup repository successfully"

curl -m 10 --retry 5 https://hc-ping.com/e0299c9e-dc82-428b-8eac-4743c1ac44b1
