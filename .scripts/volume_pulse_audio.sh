#!/bin/bash
PAMIXER="$HOME/bin/pamixer"
VOLUME=`$PAMIXER --get-volume`
case "$1" in
	"up")
		if [ "$VOLUME" -lt 95 ]; then
			$PAMIXER --increase 5
		else
			$PAMIXER --increase `expr 100 - $VOLUME`
		fi
		;;
	"down")
		$PAMIXER --decrease 5
		;;
	"mute")
		$PAMIXER --toggle-mute
		;;
esac

# notification
VOLUME=`$PAMIXER --get-volume`
MUTE=`$PAMIXER --get-mute`
if [ "$MUTE" == "false" ]; then
	volnoti-show $VOLUME
else
	volnoti-show -m $VOLUME
fi
