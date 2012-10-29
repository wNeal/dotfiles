#!/bin/sh

# kill all programs
killall \
  xcompmgr \
  conky \
  dzen2 \
  dzconky.sh \
  top_panel.sh

# auto set video output
$HOME/.xmonad/scripts/video_setup.sh

## SETTINGS ##

# X11
$HOME/.xmonad/scripts/set_dpms.sh

# Composite
xcompmgr -f -r0 -D3 &

# Conky
$HOME/.xmonad/scripts/dzconky.sh &

# Background
$HOME/.xmonad/scripts/set_background.sh
