#! /usr/bin/env bash

killall polybar

echo "---" | tee -a /tmp/polybar1.log
#polybar dummy 2>&1 | tee -a /tmp/polybar-dummy1.log & disown
polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
polybar tray 2>&1 | tee -a /tmp/polybar-tray1.log & disown

sleep 3s
