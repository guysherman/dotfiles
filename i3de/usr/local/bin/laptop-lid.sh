#! /usr/bin/env bash

# Work out the correct user name
user_name=guy
grep -q guy:x /etc/passwd
if [[ $? == 1 ]]; then
  user_name=guysnz
fi

home_path=/home
if [[ $user_name == "guysnz" ]]; then
  home_path=/home/ANT.AMAZON.COM
fi

user_id=$(id -u $user_name)

# Thanks to the folks who answered here:
# https://askubuntu.com/questions/1140329/how-to-run-a-script-when-the-lid-is-closed

# udev runs as root, so we need to tell it how to connect to the X server:
export DISPLAY=:0
export XAUTHORITY=/run/user/$user_id/gdm/Xauthority
export XDG_CONFIG_HOME=$home_path/$user_name/.config
export XDG_STATE_HOME=$home_path/$user_name./.local/state
export XDG_DATA_HOME=$home_path/$user_name/.local/share
export XDG_CACHE_HOME=$home_path/$user_name/.cache
export XDG_SEAT=seat0
export XDG_SESSION_TYPE=x11
export XDG_SESSION_CLASS=user
export XDG_RUNTIME_DIR=/run/user/$user_id
export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3
export XDG_CONFIG_DIRS=/etc/xdg/xdg-i3:/etc/xdg
export XDG_DATA_DIRS=/usr/share/i3:$home_path/$user_name/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/:/var/lib/snapd/desktop

# Find out the device path to our graphics card:
#cardPath=/sys/$(udevadm info -q path -n /dev/dri/card0)

# Count how many displays are connected
num_displays=$(runuser -l $user_name -c 'DISPLAY=:0 xrandr' | grep -c ' connected')

# Determine lid state
lid_path=/proc/acpi/button/lid/LID/state
if [[ ! -f $lid_path ]]; then
  lid_path=/proc/acpi/button/lid/LID0/state
fi

grep -q closed $lid_path 
lid=$?

echo "Displays: $num_displays, Lid: $lid; User: $user_name"

# Update displays
runuser -l $user_name -c 'DISPLAY=:0 auto-disp-user.sh'

# If we have only the laptop display, and we closed the lid, suspend
if [[ $num_displays == 1 ]] && [[ $lid = 0 ]]; then
  runuser -l $user_name -c 'echo -ne "\007"'
  runuser -l $user_name -c 'DISPLAY=:0 betterlockscreen -l blur' &
  sleep 2
  systemctl suspend
fi
