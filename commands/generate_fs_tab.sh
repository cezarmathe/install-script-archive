#!/bin/bash

MOUNTPOINT="$1"; shift

genfstab -U "$MOUNTPOINT" >> "$MOUNTPOINT/etc/fstab"