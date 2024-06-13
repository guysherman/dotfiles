#!/bin/bash

#printf "\x1b]99;;Noise Mode!!!\x1b\\"
#touch ~/noise

dunstctl set-paused false
dunstctl set-paused false

# 
CURR_WINDOW=`xdotool getactivewindow`
WINDOW=`xdotool search --class slack | tail -n 1` 
xdotool windowactivate $WINDOW
xdotool key --window $WINDOW 'ctrl+shift+y' 
xdotool sleep .5
xdotool key --window $WINDOW Tab Tab Tab 
xdotool key --window $WINDOW Return
xdotool windowactivate $CURR_WINDOW

