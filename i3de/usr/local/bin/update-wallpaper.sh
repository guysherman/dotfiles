#! /usr/bin/env bash

if [[ -f "$HOME/wallpaper" ]]; then
  WALLPAPER=$HOME/wallpaper
elif [[ -z "$WALLPAPER" ]]; then
  WALLPAPER=/usr/local/share/i3de/ihearti3.jpg
fi

if [[ -z "$WALLPAPER_MODE" ]]; then
  WALLPAPER_MODE="--bg-fill"
fi

feh $WALLPAPER_MODE $WALLPAPER $WALLPAPER_OPTS
