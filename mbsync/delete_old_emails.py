#!/usr/bin/env python

import email
import imaplib
import os
from datetime import datetime, timedelta
from datetime import timezone
from email.utils import parsedate_to_datetime

IMAP_SERVER = os.environ.get("IMAP_HOST")
IMAP_PORT = int(os.environ.get("IMAP_PORT"))
with open("/run/secrets/imap_user", "r") as file:
    USERNAME = file.read()
with open("/run/secrets/imap_password", "r") as file:
    PASSWORD = file.read()
FOLDER = "INBOX"

cutoff_date = datetime.now(tz=timezone.utc) - timedelta(days=float(os.environ.get("DELETE_EMAILS_OLDER_THAN_DAYS")))


def connect_to_imap():
    connection = imaplib.IMAP4_SSL(IMAP_SERVER, IMAP_PORT)
    connection.login(USERNAME, PASSWORD)
    return connection


def delete_old_emails():
    connection = connect_to_imap()

    try:
        connection.select(FOLDER)
        result, data = connection.search(None, "ALL")
        if result != "OK":
            print("Failed to search emails.")
            return

        email_ids = data[0].split()
        print(f"Found {len(email_ids)} emails in {FOLDER}.")

        count = 0
        for email_id in email_ids:
            result, msg_data = connection.fetch(email_id, "(BODY.PEEK[HEADER])")
            if result != "OK":
                raise Exception(f"Failed to fetch email ID {email_id}.")

            msg = email.message_from_bytes(msg_data[0][1])
            date_header = msg["Date"]

            try:
                email_date = parsedate_to_datetime(date_header)
                email_date = email_date.replace(tzinfo=timezone.utc)
            except ValueError as error:
                print(error)
                continue
            if email_date < cutoff_date:
                print(f"Deleting email ID {email_id}, dated {email_date}.")
                connection.store(email_id, "+FLAGS", "\\Deleted")
                count = count + 1

        connection.expunge()
        print(f"Deleted {count} emails.")

    finally:
        connection.close()
        connection.logout()


if __name__ == "__main__":
    delete_old_emails()
