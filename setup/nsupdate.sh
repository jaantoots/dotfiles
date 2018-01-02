#!/bin/bash
set -eu

PROTO="$1"
#PROTO="ipv4"
#HTTPAUTH="user:password"
#PREFIX="/etc/nsupdate"

# Check current IP
ip=$(curl -q -s "https://${PROTO}.nsupdate.info/myip")

# Send GET request to update if changed
if [ "$ip" != "$(cat ${PREFIX}/${PROTO})" ]; then
    status=$(curl -q -s -u "$HTTPAUTH" "https://${PROTO}.nsupdate.info/nic/update")
    echo "$status"
    grep -q -s "good" - <<<"$status"
    echo -n "$ip" > ${PREFIX}/${PROTO}
fi
