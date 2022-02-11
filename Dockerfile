FROM alpine:latest
RUN apk --no-cache add samba-common-tools samba-server

COPY start_samba.sh /bin/start_samba.sh
COPY smb.conf /etc/samba/smb.conf

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

ENTRYPOINT ["/bin/start_samba.sh"]
