#!/bin/bash

NAME="$1"; shift
MOUNTPOINT="$1"; shift

if [[ -n "$1" ]]; then
  FORMAT="$1"; shift
fi

mount "$NAME" "$MOUNTPOINT"

if [[ -n "$FORMAT" ]]; then
  exit
fi

case "$FORMAT" in
"ext4")
  mkfs.ext4 "$NAME"
  ;;
"fat") # Does archiso have this package?
  mkfs.vfat "$NAME"
  ;;
esac