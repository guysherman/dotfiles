#! /usr/bin/bash

if [[ -z "$WALLPAPER" ]]; then
  WALLPAPER=/usr/local/share/i3de/ihearti3.jpg
fi

if [[ -z "$WALLPAPER_MODE" ]]; then
  WALLPAPER_MODE="--bg-fill"
fi

feh $WALLPAPER_MODE $WALLPAPER $WALLPAPER_OPTS
