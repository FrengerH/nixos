#!/usr/bin/env bash

SINKS=`pactl list sinks | grep 'Name:' | cut -b8-`

FIRST_SINK=`echo "$SINKS" | head -n 1`

VOLUME=`pactl list sinks | grep -A 8 "$FIRST_SINK" | grep "Volume:" | cut -b22- | awk '{print substr($3, 1, length($3)-1)}'`

for SINK in $SINKS
do
    pactl set-sink-volume $SINK $VOLUME%
done
