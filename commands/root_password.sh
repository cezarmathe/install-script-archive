#!/bin/bash

PASSWORD="$1"; shift

echo -en "$PASSWORD\n$PASSWORD" | passwd