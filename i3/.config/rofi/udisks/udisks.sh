#!/bin/bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# ribbon_top		ribbon_top_round		ribbon_bottom	 	ribbon_bottom_round
# ribbon_left		ribbon_left_round		ribbon_right		ribbon_right_round
# full_bottom		full_top				full_left			full_right

theme="udisks.rasi"

dir="$HOME/.config/rofi/udisks"

# comment this line to disable random colors
#sed -i -e "s/@import .*/@import \"$color\"/g" $dir/styles/colors.rasi

# comment these lines to disable random style
#themes=($(ls -p --hide="launcher.sh" --hide="styles" $dir))
#theme="${themes[$(( $RANDOM % 12 ))]}"

device=$(udiskie-info -a -o "{device_file} {ui_label}" -f "is_partition" | rofi -dmenu -theme $dir/"$theme"  | cut -d' ' -f1)

if [ -n "$device" ] ; then

    if mount | grep "$device" ; then
        echo "mounted"
        udisksctl unmount -b ${device}
    else
        echo "not mounted"
        udisksctl mount -b ${device}
    fi
        
fi

