#!/usr/bin/env sh

envsubst < /home/mbsync/.mbsyncrc.template > /home/mbsync/.mbsyncrc
mbsync --all
