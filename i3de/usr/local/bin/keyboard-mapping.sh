#! /usr/bin/env bash

# udev runs as root, so we need to tell it how to connect to the X server:
export DISPLAY=:0
export XDG_SEAT=seat0
export XDG_SESSION_TYPE=x11
export XDG_SESSION_CLASS=user
export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3

# Work out the correct user name
user_name=guy
grep -q guy:x /etc/passwd
if [[ $? == 1 ]]; then
  user_name=guysnz
fi

# Wait a couple of seconds for the keyboard to be fully loaded
sleep 10

# Set the keyboard mapping
runuser -l $user_name -c 'DISPLAY=:0 setxkbmap -option caps:escape'




