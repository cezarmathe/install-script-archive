#!/bin/bash

HOSTNAME="$1"; shift

echo "$HOSTNAME" > /etc/hostname

cat <<EOF > /etc/hosts
127.0.0.1     localhost
::1           localhost
127.0.1.1     $HOSTNAME.localdomain     $HOSTNAME
EOF