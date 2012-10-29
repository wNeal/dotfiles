#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#xcompmgr -fF &                              # allow transparency
xrdb $HOME/.Xdefaults &                     # load Xdefaults
xset +fp /usr/share/fonts/local
xset fp rehash 

xsetroot -cursor_name left_ptr              # required for xmonad's cursor


# Start the urxvt daemon
urxvtd -q -o -f
screen -dmS default

# Start MPD
mpd

xrandr --output HDMI1 --mode 1920x1080     # On HDMI set the resolution

# set the modmap
xmodmap ~/.Xmodmap

# start the power management tools
# xfce4-power-manager

# start xmonad
exec ck-launch-session dbus-launch xmonad

# start dwm
#exec ck-launch-session dbus-launch dwm

# start openbox
#exec ck-launch-session dbus-launch openbox
