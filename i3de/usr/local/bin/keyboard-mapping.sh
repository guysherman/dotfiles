#! /bin/bash

echo "Running keyboard-mapping.sh" | systemd-cat

if [[ $FORKED == 1 ]]; then
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
  echo "Forked keyboard-mapping.sh" | systemd-cat

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


  # Wait a couple of seconds for the keyboard to be fully loaded
  sleep 2

  # Set the keyboard mapping
  echo "Running local keyboard script" | systemd-cat
  #/bin/bash -c '$HOME/.local/bin/local-keyboard-settings.sh'
  runuser -l $user_name -c 'DISPLAY=:0 ~/.local/bin/local-keyboard-settings.sh'
else
  FORKED=1 keyboard-mapping.sh &
fi



