#!/bin/bash

REGION="$1"; shift

ln -sf "/usr/share/zoneinfo/$REGION" /etc/localtime

hwclock --systohc