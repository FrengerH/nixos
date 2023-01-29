#!/usr/bin/env bash

light-locker &
numlockx &
autorandr --change &
xdg-user-dirs-update --force &
pactl list sinks &

