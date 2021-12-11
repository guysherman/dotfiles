#! /usr/bin/bash

# Thanks to the folks who answered here:
# https://askubuntu.com/questions/1140329/how-to-run-a-script-when-the-lid-is-closed

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
if [ ! -n "$conHdmi" ]; then
  grep -q closed /proc/acpi/button/lid/LID0/state
  if [ $? = 0 ]
  then
      # close action
      runuser -l guy -c 'DISPLAY=:0 betterlockscreen -l blur' &
      sleep 2
      systemctl suspend
  fi
fi
