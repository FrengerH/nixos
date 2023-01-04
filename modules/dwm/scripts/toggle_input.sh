#!/usr/bin/env bash

SOURCES=`pactl list sources | grep 'Name:' | grep 'input' | cut -b8-`

FIRST_SOURCE=`echo "$SOURCES" | head -n 1`

UNMUTED=`pactl list sources | grep -A 10 "$FIRST_SOURCE" | grep "Mute: no" | wc -l`

for SOURCE in $SOURCES
do
    pactl set-source-mute $SOURCE $UNMUTED
done
