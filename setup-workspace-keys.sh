#! /bin/bash

for i in {1..10}
do
   dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-$i "['<Super>$i']"
   # Remove default binding
   dconf write /org/gnome/shell/keybindings/switch-to-application-$i "@as []"
done
# Workspace 10 -> 0
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-10 "['<Super>0']"

for i in {1..10}
do
   dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-$i "['<Super><Shift>$i']"
done
# Workspace 10 -> 0
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-10 "['<Super><Shift>10']"

