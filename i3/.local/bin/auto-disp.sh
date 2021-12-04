#!/usr/bin/bash

# udev will wait for our script to finish before the monitor is available
# for use, so we will use the `at` command to run our command again as
# another user:
if [ "$1" != "forked" ]; then
  echo "$(dirname $0)/$(basename $0) forked" | at now
  exit
fi

# udev runs as root, so we need to tell it how to connect to the X server:
export DISPLAY=:0
export XAUTHORITY=/run/user/1000/gdm/Xauthority
export XDG_CONFIG_HOME=/home/guy/.config

# Find out the device path to our graphics card:
cardPath=/sys/$(udevadm info -q path -n /dev/dri/card0)

# Detect if the monitor is connected and, if so, the monitor's ID:
conHdmi=$(xrandr | sed -n '/HDMI-1 connected/p')
shaHdmi=$(sha1sum $cardPath/card0-HDMI-A-1/edid | cut -f1 -d " ")

# The useful part: check what the connection status is, and run some other commands
if [ -n "$conHdmi" ]; then
  echo "HDMI connected"
  if [ "$shaHdmi" = "b092b405f8cdfac144a759941fe6b2e28a21af74" ]; then    # Office PC
    #echo "LG Ultrawide"
    autorandr --load home
  else                                            # Probably a projector
    #echo "Some other shit $shaHdmi"
    xrandr --output eDP-1 --auto --output HDMI-1 --auto --same-as eDP-1
  fi
else
  #echo "HDMI not connected"
  autorandr --load laptop
fi
