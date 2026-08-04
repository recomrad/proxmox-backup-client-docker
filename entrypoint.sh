#!/bin/bash

cleanup() {
	echo "Exiting..."
	exit 1
}

trap cleanup SIGINT
trap cleanup SIGTERM

# Exit if no PBS_PASSWORD is set
if [ -z "$PBS_PASSWORD" ]; then
	echo "PBS_PASSWORD is not set. Exiting."
	exit 1
fi

# Exit if no PBS_REPOSITORY is set
if [ -z "$PBS_REPOSITORY" ]; then
	echo "PBS_REPOSITORY is not set. Exiting."
	exit 1
fi

# Exit if no PBS_FINGERPRINT is set
if [ -z "$PBS_FINGERPRINT" ]; then
	echo "PBS_FINGERPRINT is not set. Exiting."
	exit 1
fi

# Exit if no STORAGEPATH is set
if [ -z "$STORAGEPATH" ]; then
	echo "STORAGEPATH is not set. Exiting."
	exit 1
fi

echo "Starting backup service..."

/do_backup.sh > /proc/1/fd/1 2>&1
exit 0