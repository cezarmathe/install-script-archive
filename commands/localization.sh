#!/bin/bash

LOCALE="$1"; shift
LOCALE_LANG="$1"; shift

echo "$LOCALE" >> /etc/logale.gen
locale-gen

echo "LANG=$LOCALE_LANG" >> /etc/locale.conf

