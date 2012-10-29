#!/bin/sh

# kill all programs
killall \
  xcompmgr \
  conky \
  dzen2 \
  dzconky.sh \
  top_panel.sh

# auto set video output
$HOME/.scripts/video_setup.sh

## SETTINGS ##

# X11
$HOME/.scripts/set_dpms.sh

# Composite
xcompmgr -f -r0 -D3 &

# Conky
$HOME/.scripts/dzconky.sh &

# Background
$HOME/.scripts/set_background.sh &
