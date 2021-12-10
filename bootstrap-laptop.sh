#! /usr/bin/bash

source bootstrap.sh

stow laptop
sudo ln -s /home/guy/.config/acpi/events/laptop-lid /etc/acpi/events/laptop-lid
sudo ln -s /home/guy/.config/udev/95-monitors.rules /etc/udev/rules.d/95-monitors.rules

echo "Everything is set up, nothing to do."
