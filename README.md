# Dockerized Proxmox Backup Client

## Usage

The [official client environment variables](https://pbs.proxmox.com/docs/backup-client.html) are leveraged, along with additional environment variables:

| Variable | Required? | Description | Example |
| -------- | :-------: | ----------- | ------- |
| STORAGEPATH | Yes | Base path to your data in docker container | /mnt/mydata |

### Note
When running your docker container, you need to set [the tmpfs mount](https://docs.docker.com/storage/tmpfs/) to /tmp.  If you don't, [your fidx and didx files from the previous backup will not be readable](https://forum.proxmox.com/threads/proxmox-backup-client-in-docker-subsequential-backups-never-reuse-data.107472/post-462447) and you won't get an accurate incremental backup.

## Example

Run at host:

```
#!/bin/bash

docker run --name my-docker-backup-pbs-job -e PBS_PASSWORD="my-pbs-password" -e PBS_REPOSITORY="me@pbs@192.168.0.1:storage" \
    -e PBS_FINGERPRINT="my:fi:ng:er:pr:in:t1" -e STORAGEPATH="/mnt/mydata" --tmpfs /tmp \
    -v /path/to/host/data:/mnt/mydata:ro -v /path/to/bachup/script.sh:/do_backup.sh --net backup-net --ip 192.168.1.2 -d recomrad/pbs-client-docker:latest

EXIT_CODE=$(docker wait my-docker-backup-pbs-job)

docker logs my-docker-backup-pbs-job >& /path/to/job.log

docker rm my-docker-backup-pbs-job
```

And ``/path/to/bachup/script.sh`` can contain:

```
#!/bin/bash

export PRIVATE="private.pxar:$STORAGEPATH/PRIVATE"

proxmox-backup-client backup --all-file-systems true --ns admprivate --backup-id private $PRIVATE
```
