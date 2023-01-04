#!/usr/bin/env bash

SINKS=`pactl list sinks | grep 'Name:' | cut -b8-`

FIRST_SINK=`echo "$SINKS" | head -n 1`

UNMUTED=`pactl list sinks | grep -A 8 "$FIRST_SINK" | grep "Mute: no" | wc -l`

for SINK in $SINKS
do
    pactl set-sink-mute $SINK $UNMUTED
done
