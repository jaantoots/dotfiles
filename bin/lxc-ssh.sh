#!/bin/bash

set -eu

container=$1
user=$2

home=/var/lib/lxc/$container/rootfs/home/$user
ssh=$home/.ssh

mkdir -p -m 700 "$ssh"
cat "$HOME/.ssh/id_ed25519.pub" >> "$ssh/authorized_keys"
chown -R "$(stat -c %u:%g "$home")" "$ssh"
chmod 600 "$ssh/authorized_keys"
