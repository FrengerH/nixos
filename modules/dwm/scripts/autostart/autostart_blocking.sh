#!/usr/bin/env bash

light-locker &
numlockx &
autorandr --change &
xdg-user-dirs-update --force &
pactl list sinks &
xrandr --output Virtual-1 --mode 2560x1401

