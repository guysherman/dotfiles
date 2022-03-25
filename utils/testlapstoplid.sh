#! /usr/bin/env bash

conHdmi=$(xrandr | sed -n '/HDMI-1 connected/p')
if [ ! -n "$conHdmi" ]; then
  echo "HDMI Not Connected"
fi
