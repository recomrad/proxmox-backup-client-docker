# Proxmox Backup Client Docker

This repository builds a Docker image with the Proxmox Backup Server client installed. The container entrypoint validates the required environment variables and then runs the backup script from /do_backup.sh.

## What the image contains

- Debian Bookworm base image
- Proxmox Backup Client package
- Cron package
- Entrypoint that checks required environment variables and executes the backup job

## Required environment variables

The container expects the following variables to be set:

| Variable | Required | Description |
| -------- | :------: | ----------- |
| PBS_PASSWORD | Yes | Password used to authenticate to the Proxmox Backup Server |
| PBS_REPOSITORY | Yes | Backup repository address in the form `user@host:storage` |
| PBS_FINGERPRINT | Yes | Fingerprint of the backup server key |
| STORAGEPATH | Yes | Path inside the container where the data to be backed up is mounted |

## Usage

The default backup script in this repository is only a placeholder. In practice you should mount your own script to /do_backup.sh or replace it before building the image.

Example:

```bash
docker run --name proxmox-backup-job \
  -e PBS_PASSWORD="my-pbs-password" \
  -e PBS_REPOSITORY="me@pbs@192.168.0.1:storage" \
  -e PBS_FINGERPRINT="my:fi:ng:er:pr:in:t1" \
  -e STORAGEPATH="/mnt/mydata" \
  --tmpfs /tmp \
  -v /path/to/host/data:/mnt/mydata:ro \
  -v /path/to/backup/script.sh:/do_backup.sh:ro \
  ghcr.io/recomrad/proxmox-backup-client-docker:latest
```

Example backup script:

```bash
#!/bin/bash

export PRIVATE="private.pxar:$STORAGEPATH/PRIVATE"

proxmox-backup-client backup --all-file-systems true --ns admprivate --backup-id private "$PRIVATE"
```

## Important note about /tmp

The container should be started with a tmpfs mount at /tmp. Without this, incremental backup state files may not be reused correctly and the next backup may not behave as expected.

## Build locally

```bash
docker build -t proxmox-backup-client .
```
