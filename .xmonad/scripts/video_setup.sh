#!/bin/bash

LOCKFILE="$HOME/.xmonad/scripts/video.lock"

while [ -e "$LOCKFILE" ]; do
	sleep 1;
done

trap "rm -f \"$LOCKFILE\"; exit" INT TERM EXIT
touch "$LOCKFILE"

# get active/inactive port
read PORT_ON PORT_OFF <<< $($HOME/.xmonad/scripts/video_ports.sh)

# run auto setup
xrandr --output $PORT_OFF --off --output $PORT_ON --auto

rm "$LOCKFILE"
trap - INT TERM EXIT
