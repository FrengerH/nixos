#!/usr/bin/env bash

acpi=`ps -e | command -v acpi | wc -l`
if [ $acpi -gt 0 ]; then
    proc=`acpi -b | awk '{print $4}'`
    ICON=""
    printf "$ICON %s" "$proc"
fi

