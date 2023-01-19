#! /usr/bin/env bash
xrandr --newmode "2560x1080" 185.58 2560 2624 2688 2784 1080 1083 1093 1111 -hsync -vsync
xrandr --addmode HDMI1 "2560x1080"

xrandr --newmode "3840x2160" 297.00 3840 4016 4104 4400 2160 2168 2178 2250 +hsync +vsync
xrandr --addmode HDMI1 "3840x2160"

