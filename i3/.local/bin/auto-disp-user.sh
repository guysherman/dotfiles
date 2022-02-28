#! /usr/bin/env bash

# Find out the device path to our graphics card:
cardPath=/sys/$(udevadm info -q path -n /dev/dri/card0)

# Detect if the monitor is connected and, if so, the monitor's ID:
conHdmi=$(xrandr | sed -n '/HDMI-1 connected/p')
shaHdmi=$(sha1sum $cardPath/card0-HDMI-A-1/edid | cut -f1 -d " ")

# The useful part: check what the connection status is, and run some other commands
if [ -n "$conHdmi" ]; then
  echo "HDMI connected"
  if [ "$shaHdmi" = "b092b405f8cdfac144a759941fe6b2e28a21af74" ]; then    # Home
    echo "LG Ultrawide"
    autorandr --load home
    update-wallpaper.sh
    update-lockscreen.sh
  elif [ "$shaHdmi" = "28e8d323e82234bb3792ab281d265a7edcbb1658" ]; then # Office
    echo "Dell 4k"
    autorandr --load work
    update-wallpaper.sh
    update-lockscreen.sh
  else                                            # Probably a projector
    echo "Some other shit $shaHdmi"
    xrandr --output eDP-1 --auto --output HDMI-1 --auto --same-as eDP-1
    update-wallpaper.sh
    update-lockscreen.sh
  fi
else
  echo "HDMI not connected"
  autorandr --load laptop
  update-wallpaper.sh
  update-lockscreen.sh
fi
