FROM debian:bookworm

RUN apt-get update \
        && apt-get install -y --no-install-recommends ca-certificates wget cron \
        && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list \
&& wget -q https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg \
&& apt-get update \
&& apt-get install -y --no-install-recommends proxmox-backup-client \
&& rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh
COPY do_backup.sh /do_backup.sh
RUN chmod +x /entrypoint.sh && chmod +x /do_backup.sh
CMD ["/entrypoint.sh"]
