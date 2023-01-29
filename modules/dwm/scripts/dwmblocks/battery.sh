#!/usr/bin/env bash

proc=`acpi -b | awk '{print $4}'`
ICON=""
printf "$ICON %s" "$proc"
