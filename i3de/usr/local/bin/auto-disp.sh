#! /usr/bin/env bash

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
export XDG_STATE_HOME=/home/guy/.local/state
export XDG_DATA_HOME=/home/guy/.local/share
export XDG_CACHE_HOME=/home/guy/.cache
export XDG_SEAT=seat0
export XDG_SESSION_TYPE=x11
export XDG_SESSION_CLASS=user
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3
export XDG_CONFIG_DIRS=/etc/xdg/xdg-i3:/etc/xdg
export XDG_DATA_DIRS=/usr/share/i3:/home/guy/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/:/var/lib/snapd/desktop

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
    runuser -l guy -c 'DISPLAY=:0 feh --bg-fill /home/guy/Pictures/wallpaper --bg-fill /home/guy/Pictures/wallpaper'
    runuser -l guy -c 'DISPLAY=:0 betterlockscreen -u /home/guy/Pictures/wallpaper --blur 1 --fx blur'
  else                                            # Probably a projector
    #echo "Some other shit $shaHdmi"
    xrandr --output eDP-1 --auto --output HDMI-1 --auto --same-as eDP-1
    runuser -l guy -c 'DISPLAY=:0 feh --bg-fill /home/guy/Pictures/wallpaper'
    runuser -l guy -c 'DISPLAY=:0 betterlockscreen -u /home/guy/Pictures/wallpaper --blur 1 --fx blur'
  fi
else
  #echo "HDMI not connected"
  autorandr --load laptop
  runuser -l guy -c 'DISPLAY=:0 feh --bg-fill /home/guy/Pictures/wallpaper'
  runuser -l guy -c 'DISPLAY=:0 betterlockscreen -u /home/guy/Pictures/wallpaper --blur 1 --fx blur'
fi
