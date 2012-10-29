#!/bin/bash
dzen2 -e '' -x '0' -y '0' -h '20' \
-w "`expr \`$HOME/.xmonad/scripts/video_res_width.sh\` - 450`" \
-ta 'l' -fg '#FFFFFF' -bg '#080808' \
-fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*'

# -fn '-*-dejavu sans mono-medium-r-normal-*-10-*-*-*-*-*-*-*'
# -fn "-misc-dejavu sans mono-medium-r-normal--10-0-0-0-m-0-iso8859-2"
