#! /usr/bin/bash

XDG_CONFIG_HOME=/home/guy/.config
IS_DETECTED=$(autorandr | grep -i detected)
echo "$IS_DETECTED"
if [[ -z $IS_DETECTED ]]
then
  arandr
else
  autorandr -c
fi

