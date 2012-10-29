# System Colors
#(exec ~/.xmonad/scripts/dzen_colors.sh | dzen2 -bg '#080808' -x `expr \`$HOME/.xmonad/video_res_width.sh\` - 450` -y 0 -w 450 -h 20 -ta r -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -p) &

(conky | dzen2 -bg '#080808' -x `expr \`$HOME/.xmonad/scripts/video_res_width.sh\` - 450` -y 0 -w 450 -h 20 -ta r -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -p) &
