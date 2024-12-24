FROM alpine:3.21.0

RUN apk add --no-cache --quiet isync envsubst
USER mbsync
COPY .mbsyncrc.template /home/mbsync/.mbsyncrc.template
COPY start.sh /home/mbsync/start.sh
RUN chmod +x /home/mbsync/start.sh
RUN adduser -D mbsync
CMD ["/home/mbsync/start.sh"]
