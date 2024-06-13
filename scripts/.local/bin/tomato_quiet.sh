#!/bin/bash

#printf "\x1b]99;;Quiet Mode!!!\x1b\\"
#touch ~/quiet

dunstctl set-paused true

CURR_WINDOW=`xdotool getactivewindow`
WINDOW=`xdotool search --class slack | tail -n 1` 
xdotool windowactivate $WINDOW
xdotool key 'ctrl+shift+y'
xdotool sleep .5
xdotool key 'shift+Tab' Return
xdotool sleep .5 
xdotool type tomato
xdotool sleep 3
xdotool key Return
xdotool key Tab
xdotool type Deep Work
xdotool key Tab Tab Tab
xdotool type " "
xdotool key Tab Tab
xdotool key Return
xdotool windowactivate $CURR_WINDOW
