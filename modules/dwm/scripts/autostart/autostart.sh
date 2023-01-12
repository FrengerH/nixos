#!/usr/bin/env bash

check=`ps -e | command -v work | wc -l`
echo $check
if [ $check -gt 0 ]; then
    dwm-msg run_command view 128
else
    xrandr --newmode "1912x988_60.00"  156.64  1912 2024 2232 2552  988 989 992 1023  -HSync +Vsync
    xrandr --addmode Virtual-1 "1912x988_60.00"
    xrandr --output Virtual-1 --mode 1912x988_60.00
fi

sleep 1
feh --bg-fill /etc/wallpaper/wallpaper.jpg
dwmblocks

