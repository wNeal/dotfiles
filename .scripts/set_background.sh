#!/bin/bash
# Select a random image from the dir and set it as the background
while true 
do 
    files=($HOME/Pictures/Wallpapers/green_patterns/*)
    bg=(${files[RANDOM % ${#files[@]}]})
    feh --bg-tile $bg
    #feh --bg-center $bg
    sleep 1d
done
