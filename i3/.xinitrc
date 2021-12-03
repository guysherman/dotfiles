#!/usr/bin/bash

export XDG_DATA_DIRS="/usr/local/share/:/usr/share/:/usr/share/gdm/:/var/lib/menu-xdg/"

if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_DATA_HOME" ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi
# $Id:$
# In order to activate the session bus at X session launch
# simply place use-session-dbus into your /etc/X11/Xsession.options file
#

STARTDBUS=
DBUSLAUNCH=/usr/bin/dbus-launch

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && [ -x "$DBUSLAUNCH" ]; then
  STARTDBUS=yes
fi

if [ -n "$STARTDBUS" ]; then
  # Note that anything that is D-Bus-activated between here and
  # 95dbus_update-activation-env will not have the complete environment
  # set up by Xsession.d, unless the Xsession.d snippet that sets the
  # environment variable also calls dbus-update-activation-environment.
  # See <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=815503>
  eval $($DBUSLAUNCH --exit-with-session --sh-syntax)
fi
[[ -f ~/.Xresources ]] && xrdb -merge "${HOME}/.Xresources"

# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID
export OOO_FORCE_DESKTOP=gnome
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export TERMINAL='gnome-terminal'

# Launch i3 window manager
eval $(dbus-launch --sh-syntax)
export XDG_CURRENT_DESKTOP=GNOME

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

exec i3

