#!/usr/bin/env bash

set -xe

mount_point=/mnt/usb
mounted="$(df -h "${mount_point}" | grep 1.9T | xargs)"

if [ -z "${mounted}" ]; then
  systemctl stop docker.service
  rm -rf "${mount_point:?}/*"
  mount "${mount_point}"
  systemctl restart docker.service
fi
