#!/bin/bash

USERNAME="$1"; shift
GROUPS="$2; shift"
PASSWORD="$1"; shift

useradd -G "$GROUPS" -m "$USER_NAME"
echo -en "$PASSWORD\n$PASSWORD" -m "$USERNAME"