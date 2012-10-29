#!/bin/bash

LOCKFILE="$HOME/.scripts/video.lock"

while [ -e "$LOCKFILE" ]; do
	sleep 1;
done
trap "rm -f \"$LOCKFILE\"; exit" INT TERM EXIT
touch "$LOCKFILE"

# get active/inactive port
read PORT_ON PORT_OFF <<< $($HOME/.scripts/video_ports.sh)

# filter xrandr output
WIDTH=`xrandr | grep "$PORT_ON connected" | sed "s/$PORT_ON connected \([0-9]*\)x.*/\1/"`
echo $WIDTH

rm "$LOCKFILE"
trap - INT TERM EXIT

