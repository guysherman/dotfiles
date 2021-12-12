#! /usr/bin/env bash

killall polybar

echo "---" | tee -a /tmp/polybar1.log
polybar example 2>&1 | tee -a /tmp/polybar1.log & disown

sleep 3s
