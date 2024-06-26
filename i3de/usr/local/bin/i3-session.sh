#! /usr/bin/env bash

if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_DATA_HOME" ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z "$XDG_STATE_HOME" ]; then
  export XDG_STATE_HOME=$HOME/.local/state
fi

if [ -z "$XDG_CACHE_HOME" ]; then
  export XDG_CACHE_HOME=$HOME/.cache
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
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export TERMINAL='kitty'

# Launch i3 window manager
export XDG_CURRENT_DESKTOP=i3
if [ -n "$DBUS_SESSION_BUS_ADDRESS" ] && \
    [ -x "/usr/bin/dbus-update-activation-environment" ]; then
  # subshell so we can unset environment variables
  (
    # unset login-session-specifics
    unset XDG_SEAT
    unset XDG_SESSION_ID
    unset XDG_VTNR

    # tell dbus-daemon --session (and systemd --user, if running)
    # to put the Xsession's environment in activated services'
    # environments
    dbus-update-activation-environment --verbose --systemd --all
  )
fi

# Ensure that our default i3 config is installed if there is no config file already
if [ ! -f "$XDG_CONFIG_HOME/i3/config" ]; then
  mkdir -p $XDG_CONFIG_HOME/i3
  cp /usr/local/share/i3de/config/i3/config $XDG_CONFIG_HOME/i3/config
fi

if [ -f "$HOME/.xinitrc" ]; then
  source $HOME/.xinitrc
fi

if [ -f "/usr/local/bin/i3-session-autostart.sh" ]; then
  /usr/local/bin/i3-session-autostart.sh
fi


exec i3
