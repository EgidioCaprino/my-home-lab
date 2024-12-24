#!/usr/bin/env sh

envsubst < /home/mbsync/.mbsyncrc.template > /home/mbsync/.mbsyncrc
mbsync --all
/home/mbsync/delete_old_emails.py
