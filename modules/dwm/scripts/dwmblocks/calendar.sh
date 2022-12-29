#!/usr/bin/env bash
ICON=""
printf "$ICON %s" "$(date '+%a, %b %d, %R')"

case $BLOCK_BUTTON in
	1) notify-send "clock 1" ;;
	2) notify-send "clock 2" ;;
	3) notify-send "clock 3" ;;
esac
