#! /usr/bin/env bash

autorandr --skip-options crtc -c --default default
update-wallpaper.sh
update-lockscreen.sh
i3 gaps bottom all set `python3 -Wignore -c 'import math; import gi; gi.require_version("Gdk", "3.0"); from gi.repository import Gdk; screen=Gdk.Screen.get_default(); geo = screen.get_monitor_geometry(screen.get_primary_monitor()); print((math.ceil(geo.height * 0.035)) -5)'`
