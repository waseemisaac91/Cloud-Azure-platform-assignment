#!/usr/bin/env bash
# Mount the Azure File Share on the Linux VM with CIFS.
# Usage:  export STORAGE_KEY='<storage-account-key>' && ./mount-fileshare.sh
# The key is read from the environment and is never stored in this repository.
set -euo pipefail

: "${STORAGE_KEY:?Set STORAGE_KEY first: export STORAGE_KEY='<storage-account-key>'}"

STORAGE_ACCOUNT="waseemisaac2026wa"
SHARE="myshare"
MOUNT_POINT="/mnt/myshare"

sudo apt update && sudo apt install -y cifs-utils
sudo mkdir -p "$MOUNT_POINT"
sudo mount -t cifs "//${STORAGE_ACCOUNT}.file.core.windows.net/${SHARE}" "$MOUNT_POINT" \
  -o "username=${STORAGE_ACCOUNT},password=${STORAGE_KEY},dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30"

# Create / read / delete test
df -h | grep "$SHARE"
echo "hello azure" > "$MOUNT_POINT/test.txt"
cat "$MOUNT_POINT/test.txt"
rm "$MOUNT_POINT/test.txt"
