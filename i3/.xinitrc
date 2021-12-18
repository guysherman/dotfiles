#!/usr/bin/bash

# Make sure this is before the 'exec' command or it won't be sourced.
export XDG_DATA_DIRS="/usr/share/i3:/home/guy/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/:/var/lib/snapd/desktop:/usr/local/share/:/usr/share/:/usr/share/gdm/:/var/lib/menu-xdg/"
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

export WALLPAPER="$HOME/Pictures/wallpaper"
export LOCKSCREEN="$HOME/Pictures/lockscreen.jpg"


