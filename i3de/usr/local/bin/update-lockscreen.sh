#! /usr/bin/env bash

if [[ -f "$HOME/lockscreen" ]]; then
  LOCKSCREEN=$HOME/lockscreen
elif [[ -z "$LOCKSCREEN" ]]; then
  LOCKSCREEN=/usr/local/share/i3de/ihearti3.jpg
fi

if [[ -z "$LOCKSCREEN_OPTS" ]]; then
  LOCKSCREEN_OPTS="--blur 1 --fx blur"
fi

betterlockscreen -u $LOCKSCREEN $LOCKSCREEN_OPTS
