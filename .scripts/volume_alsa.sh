#!/bin/bash
volsetting=`amixer sget 'Master' | grep off`
    case "$1" in
    mute)
        amixer sset 'Master' mute > /dev/null
    ;;
    unmute)
        amixer sset 'Master' unmute > /dev/null
    ;;
    toggle)
        if [[ x"$volsetting" = x"" ]]; then
            amixer sset 'Master' mute > /dev/null
        else
            amixer sset 'Master' unmute > /dev/null
        fi
    ;;
    increase)
        amixer sset 'Master' 5%+ > /dev/null
    ;;
    decrease)
        amixer sset 'Master' 5%- > /dev/null
    ;;
    *)
        echo "This is not an acceptable command!";
        echo -e "Use \033[01;33mmute\033[01;00;0m, \033[01;33mincrease\033[01;00;0m or \033[01;33mdecrease\033[01;00;0m as options!";
        echo;
    esac

#notification
#volsetting=`amixer sget 'Master' | grep "Mono: Playback" | sed "s/.*\[\([0-9]*\)%\].*/\1/"`
#( echo "$volsetting 100"; sleep 10 ) | dbar | dzen2 -fg green -bg '#161616' -x "-300" -y "32" -w 300 -h 32 &
