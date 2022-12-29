#!/usr/bin/env bash

xrandr --newmode "1912x988_60.00"  156.64  1912 2024 2232 2552  988 989 992 1023  -HSync +Vsync
xrandr --addmode Virtual-1 "1912x988_60.00"
xrandr --output Virtual-1 --mode 1912x988_60.00
feh --bg-fill /etc/wallpaper/wallpaper.jpg
sleep 1
dwmblocks
