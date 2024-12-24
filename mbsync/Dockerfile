FROM alpine:3.21.0

RUN apk add --no-cache --quiet isync envsubst python3
RUN adduser -D mbsync
COPY .mbsyncrc.template delete_old_emails.py /home/mbsync/
COPY start.sh /home/mbsync/start.sh
RUN chmod +x /home/mbsync/start.sh /home/mbsync/delete_old_emails.py
USER mbsync
CMD ["/home/mbsync/start.sh"]
