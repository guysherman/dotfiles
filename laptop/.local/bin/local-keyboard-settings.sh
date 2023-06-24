#!/bin/bash
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

echo "DISPLAY=$DISPLAY; XAUTHORITY=$XAUTHORITY; HOME=$HOME;" | systemd-cat
echo "Running keymappings" | systemd-cat

setxkbmap -layout us -variant altgr-intl -option nodeadkeys -option caps:escape
xmodmap -e "keycode  43 = h H h H Left Home Left"
xmodmap -e "keycode  44 = j J j J Down Next Down"
xmodmap -e "keycode  45 = k K k K Up Prior Up"
xmodmap -e "keycode  46 = l L l L Right End Right"
xmodmap -e "keycode 108 = ISO_Level3_Shift NoSymbol ISO_Level3_Shift"

