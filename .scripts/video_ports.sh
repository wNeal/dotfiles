#!/bin/bash

# is VGA connected?
if [ -n "`xrandr | grep \"VGA1 connected\"`" ]; then
    PORT_ON="VGA1"
    PORT_OFF="LVDS1"
else
    PORT_ON="LVDS1"
    PORT_OFF="VGA1"
fi

echo $PORT_ON $PORT_OFF
