#! /usr/bin/env bash

# Thanks to the folks who answered here:
# https://askubuntu.com/questions/1140329/how-to-run-a-script-when-the-lid-is-closed

# udev runs as root, so we need to tell it how to connect to the X server:
export DISPLAY=:0
export XAUTHORITY=/run/user/1000/gdm/Xauthority
export XDG_CONFIG_HOME=/home/ANT.AMAZON.COM/guysnz/.config
export XDG_STATE_HOME=/home/ANT.AMAZON.COM/guysnz./.local/state
export XDG_DATA_HOME=/home/ANT.AMAZON.COM/guysnz/.local/share
export XDG_CACHE_HOME=/home/ANT.AMAZON.COM/guysnz/.cache
export XDG_SEAT=seat0
export XDG_SESSION_TYPE=x11
export XDG_SESSION_CLASS=user
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3
export XDG_CONFIG_DIRS=/etc/xdg/xdg-i3:/etc/xdg
export XDG_DATA_DIRS=/usr/share/i3:/home/ANT.AMAZON.COM/guysnz/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/:/var/lib/snapd/desktop

# Find out the device path to our graphics card:
#cardPath=/sys/$(udevadm info -q path -n /dev/dri/card0)

# Count how many displays are connected
num_displays=$(runuser -l guysnz -c 'DISPLAY=:0 xrandr' | grep -c ' connected')

# Determine lid state
grep -q closed /proc/acpi/button/lid/LID/state
lid=$?

echo "Displays: $num_displays, Lid: $lid"

# Update displays
runuser -l guysnz -c 'DISPLAY=:0 auto-disp-user.sh'

# If we have only the laptop display, and we closed the lid, suspend
if [[ $num_displays == 1 ]] && [[ $lid = 0 ]]; then
  runuser -l guysnz -c 'echo -ne "\007"'
  runuser -l guysnz -c 'DISPLAY=:0 betterlockscreen -l blur' &
  sleep 2
  systemctl suspend
fi
