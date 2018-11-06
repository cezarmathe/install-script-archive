#!/bin/bash

LOCATION="$1"; shift

pacstrap -i "$LOCATION" base base-devel